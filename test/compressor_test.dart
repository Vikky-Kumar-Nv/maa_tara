import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:maa_tara/core/utils/image_compressor.dart';

void main() {
  test('ImageCompressor compresses high-res image down to ~5 KB', () async {
    // 1. Create a dummy test image (800x600)
    final testImage = img.Image(width: 800, height: 600);
    // Draw some colored pixels
    for (int y = 0; y < 600; y++) {
      for (int x = 0; x < 800; x++) {
        testImage.setPixelRgb(x, y, (x % 255), (y % 255), ((x + y) % 255));
      }
    }
    final rawJpg = img.encodeJpg(testImage, quality: 90);
    final tempFile = File('${Directory.systemTemp.path}/test_raw_image.jpg');
    await tempFile.writeAsBytes(rawJpg);

    expect(tempFile.lengthSync() > 20000, isTrue); // Should be > 20KB initially

    // 2. Run ImageCompressor
    final result = await ImageCompressor.compressFile(tempFile, targetKb: 5);

    expect(result, isNotNull);
    expect(result!.compressedBytes, lessThanOrEqualTo(12000)); // Compressed tightly around target
    expect(result.file.existsSync(), isTrue);

    // Clean up
    if (tempFile.existsSync()) tempFile.deleteSync();
    if (result.file.existsSync()) result.file.deleteSync();
  });
}
