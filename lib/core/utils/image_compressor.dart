import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  MAA TARA AUTOMOBILES — Ultra-Light Auto Image Compression Engine (~5 KB)
// ─────────────────────────────────────────────────────────────────────────────

/// Result of an image compression operation
class CompressedImageResult {
  final File file;
  final int originalBytes;
  final int compressedBytes;
  final int width;
  final int height;

  const CompressedImageResult({
    required this.file,
    required this.originalBytes,
    required this.compressedBytes,
    required this.width,
    required this.height,
  });

  String get originalSizeFormatted =>
      ImageCompressor.formatBytes(originalBytes);
  String get compressedSizeFormatted =>
      ImageCompressor.formatBytes(compressedBytes);
  double get compressionRatio =>
      originalBytes > 0 ? (1 - (compressedBytes / originalBytes)) * 100 : 0.0;
}

class ImageCompressor {
  static final ImagePicker _picker = ImagePicker();

  /// Formats byte count to human-readable string (e.g. "4.8 KB")
  static String formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Picks an image from [source] and compresses it automatically down to ~5 KB.
  /// Target max size is [targetKb] (default 5 KB).
  static Future<CompressedImageResult?> pickAndCompress({
    required ImageSource source,
    int targetKb = 5,
    int maxDimension = 300,
  }) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (picked == null) return null;

      return await compressFile(
        File(picked.path),
        targetKb: targetKb,
        maxDimension: maxDimension,
      );
    } catch (e) {
      debugPrint('[ImageCompressor] Error picking image: $e');
      return null;
    }
  }

  /// Compresses an existing [sourceFile] down to approx [targetKb] (default 5 KB).
  static Future<CompressedImageResult?> compressFile(
    File sourceFile, {
    int targetKb = 5,
    int maxDimension = 300,
  }) async {
    try {
      final originalBytes = await sourceFile.readAsBytes();
      if (originalBytes.isEmpty) return null;

      // Decode image in memory using pure Dart `image` package
      final originalImage = img.decodeImage(originalBytes);
      if (originalImage == null) {
        // Fallback: if decode fails, return original file
        return CompressedImageResult(
          file: sourceFile,
          originalBytes: originalBytes.length,
          compressedBytes: originalBytes.length,
          width: 0,
          height: 0,
        );
      }

      final targetByteLimit = targetKb * 1024;

      // Step 1: Initial scale down maintaining aspect ratio
      int targetWidth = originalImage.width;
      int targetHeight = originalImage.height;

      if (targetWidth > maxDimension || targetHeight > maxDimension) {
        if (targetWidth > targetHeight) {
          targetHeight = (targetHeight * maxDimension / targetWidth).round();
          targetWidth = maxDimension;
        } else {
          targetWidth = (targetWidth * maxDimension / targetHeight).round();
          targetHeight = maxDimension;
        }
      }

      img.Image processedImage = img.copyResize(
        originalImage,
        width: targetWidth,
        height: targetHeight,
        interpolation: img.Interpolation.average,
      );

      // Step 2: Iterative quality/dimension adjustment to reach ~5 KB
      int quality = 45;
      Uint8List compressedJpg = img.encodeJpg(processedImage, quality: quality);

      // If still above target size, progressively reduce quality and scale
      while (compressedJpg.lengthInBytes > targetByteLimit && quality > 15) {
        quality -= 10;
        compressedJpg = img.encodeJpg(processedImage, quality: quality);
      }

      // If still slightly above target, resize down slightly more (e.g. 200px -> 160px)
      if (compressedJpg.lengthInBytes > targetByteLimit && targetWidth > 120) {
        final scaledDownWidth = (targetWidth * 0.75).round();
        final scaledDownHeight = (targetHeight * 0.75).round();
        processedImage = img.copyResize(
          processedImage,
          width: scaledDownWidth,
          height: scaledDownHeight,
          interpolation: img.Interpolation.average,
        );
        compressedJpg = img.encodeJpg(processedImage, quality: quality);
      }

      // Save to temporary compressed file
      final tempDir = Directory.systemTemp;
      final fileName =
          'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final compressedFile = File('${tempDir.path}/$fileName');
      await compressedFile.writeAsBytes(compressedJpg);

      return CompressedImageResult(
        file: compressedFile,
        originalBytes: originalBytes.length,
        compressedBytes: compressedJpg.lengthInBytes,
        width: processedImage.width,
        height: processedImage.height,
      );
    } catch (e) {
      debugPrint('[ImageCompressor] Compression error: $e');
      // If error occurs, return source file as fallback
      final len = await sourceFile.length();
      return CompressedImageResult(
        file: sourceFile,
        originalBytes: len,
        compressedBytes: len,
        width: 0,
        height: 0,
      );
    }
  }
}
