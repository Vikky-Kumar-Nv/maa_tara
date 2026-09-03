import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  MAA TARA AUTOMOBILES — Inventory & Branch Models
// ─────────────────────────────────────────────────────────────────────────────

/// Represents a Workshop / Store Branch
class InventoryBranchModel {
  final String id;
  final String name;
  final String code; // e.g. 'MT-MAIN', 'MT-OUTLET2'
  final String location;
  final String phone;
  final String managerName;
  final bool isPrimary;
  final String createdAt;

  const InventoryBranchModel({
    required this.id,
    required this.name,
    required this.code,
    required this.location,
    required this.phone,
    required this.managerName,
    this.isPrimary = false,
    required this.createdAt,
  });

  InventoryBranchModel copyWith({
    String? id,
    String? name,
    String? code,
    String? location,
    String? phone,
    String? managerName,
    bool? isPrimary,
    String? createdAt,
  }) {
    return InventoryBranchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      managerName: managerName ?? this.managerName,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Product Category Enum / Constants
class ProductCategory {
  static const String engineOil = 'Engine Oil & Fluids';
  static const String brakes = 'Brakes & Pads';
  static const String filters = 'Filters & Belts';
  static const String suspension = 'Suspension & Steering';
  static const String electrical = 'Electrical & Battery';
  static const String tyres = 'Tyres & Wheels';
  static const String bodyParts = 'Body & Exterior';
  static const String accessories = 'Accessories & Misc';

  static const List<String> all = [
    engineOil,
    brakes,
    filters,
    suspension,
    electrical,
    tyres,
    bodyParts,
    accessories,
  ];
}

/// Represents an Individual Product / Spare Part in a specific Branch
class InventoryItemModel {
  final String id;
  final String branchId;
  final String name;
  final String description;
  final String category;
  final String brand;
  final String partNumber; // SKU / Particular OEM code
  final String hsnCode; // HSN / SAC Code
  final int quantity;
  final int minQuantity; // Alert threshold

  // Pricing & GST
  final double purchasePrice; // Base or input cost
  final double sellingPrice; // Base or final selling price
  final double discountPercent; // Discount % (e.g. 5%)
  final double gstRate; // GST Slab % (0, 5, 8, 12, 18, 28)
  final bool isTaxInclusive; // Price is inclusive vs exclusive of GST
  final double preGstAmount; // Amount without tax
  final double gstAmount; // Total GST tax amount (₹)
  final double postGstAmount; // Total amount with tax (₹)

  // Units & Packaging Conversion
  final String unit; // Primary Base Unit ('Pcs', 'Nos', 'Ltr', 'Bottle')
  final String? secondaryUnit; // Bulk Packaging ('Box', 'Pair', 'Bundle', 'Set')
  final int conversionFactor; // 1 secondaryUnit = X primary units (e.g. 1 Box = 10 Pcs)

  // Location & Supplier Details
  final String rackLocation; // Storage Position (e.g. 'Rack A-3, Shelf 2')
  final String supplier; // Supplier Name / Company
  final String supplierGstNumber; // Supplier 15-digit GSTIN
  final String supplierPhone; // Supplier contact
  final String lastUpdated;

  const InventoryItemModel({
    required this.id,
    required this.branchId,
    required this.name,
    this.description = '',
    required this.category,
    this.brand = 'OEM / Generic',
    required this.partNumber,
    this.hsnCode = '8708',
    required this.quantity,
    required this.minQuantity,
    required this.purchasePrice,
    required this.sellingPrice,
    this.discountPercent = 0.0,
    this.gstRate = 18.0,
    this.isTaxInclusive = false,
    this.preGstAmount = 0.0,
    this.gstAmount = 0.0,
    this.postGstAmount = 0.0,
    this.unit = 'Pcs',
    this.secondaryUnit,
    this.conversionFactor = 1,
    this.rackLocation = 'Main Storage',
    required this.supplier,
    this.supplierGstNumber = '',
    this.supplierPhone = '',
    required this.lastUpdated,
  });

  /// Stock status calculation
  String get status {
    if (quantity <= 0) return 'Out of Stock';
    if (quantity <= minQuantity) return 'Low Stock';
    return 'In Stock';
  }

  Color get statusColor {
    if (quantity <= 0) return const Color(0xFFE53935); // Red
    if (quantity <= minQuantity) return const Color(0xFFFF9800); // Amber
    return const Color(0xFF2ECC71); // Green
  }

  double get totalValuation => quantity * (preGstAmount > 0 ? preGstAmount : purchasePrice);
  double get profitMargin => (postGstAmount > 0 ? postGstAmount : sellingPrice) - (preGstAmount > 0 ? preGstAmount : purchasePrice);

  InventoryItemModel copyWith({
    String? id,
    String? branchId,
    String? name,
    String? description,
    String? category,
    String? brand,
    String? partNumber,
    String? hsnCode,
    int? quantity,
    int? minQuantity,
    double? purchasePrice,
    double? sellingPrice,
    double? discountPercent,
    double? gstRate,
    bool? isTaxInclusive,
    double? preGstAmount,
    double? gstAmount,
    double? postGstAmount,
    String? unit,
    String? secondaryUnit,
    int? conversionFactor,
    String? rackLocation,
    String? supplier,
    String? supplierGstNumber,
    String? supplierPhone,
    String? lastUpdated,
  }) {
    return InventoryItemModel(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      partNumber: partNumber ?? this.partNumber,
      hsnCode: hsnCode ?? this.hsnCode,
      quantity: quantity ?? this.quantity,
      minQuantity: minQuantity ?? this.minQuantity,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      gstRate: gstRate ?? this.gstRate,
      isTaxInclusive: isTaxInclusive ?? this.isTaxInclusive,
      preGstAmount: preGstAmount ?? this.preGstAmount,
      gstAmount: gstAmount ?? this.gstAmount,
      postGstAmount: postGstAmount ?? this.postGstAmount,
      unit: unit ?? this.unit,
      secondaryUnit: secondaryUnit ?? this.secondaryUnit,
      conversionFactor: conversionFactor ?? this.conversionFactor,
      rackLocation: rackLocation ?? this.rackLocation,
      supplier: supplier ?? this.supplier,
      supplierGstNumber: supplierGstNumber ?? this.supplierGstNumber,
      supplierPhone: supplierPhone ?? this.supplierPhone,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Represents a Stock Adjustment / Audit Log
class StockTransactionModel {
  final String id;
  final String branchId;
  final String productId;
  final String productName;
  final String type; // 'Stock In', 'Stock Out', 'Transfer'
  final int quantity;
  final String reason;
  final String date;
  final String performedBy;

  const StockTransactionModel({
    required this.id,
    required this.branchId,
    required this.productId,
    required this.productName,
    required this.type,
    required this.quantity,
    required this.reason,
    required this.date,
    required this.performedBy,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
//  Global In-Memory Inventory Repository (Multi-Branch State)
// ─────────────────────────────────────────────────────────────────────────────
class InventoryRepository {
  /// Maximum number of branches allowed (Business Rule: Max 2 Shops)
  static const int maxBranchLimit = 2;

  // Active Branches List (Empty by default - Client creates their own branches)
  static final List<InventoryBranchModel> _branches = [];

  // Active Products List (Populated when client adds products to their branches)
  static final List<InventoryItemModel> _items = [];

  // Stock Transaction Logs
  static final List<StockTransactionModel> _transactions = [];

  // ── Branch Getters & Operations ─────────────────────────────────────────────
  static List<InventoryBranchModel> get branches =>
      List.unmodifiable(_branches);

  static bool get canCreateBranch => _branches.length < maxBranchLimit;

  static bool addBranch(InventoryBranchModel branch) {
    if (_branches.length >= maxBranchLimit) {
      return false; // Limit reached
    }
    _branches.add(branch);
    return true;
  }

  static void updateBranch(InventoryBranchModel updated) {
    final idx = _branches.indexWhere((b) => b.id == updated.id);
    if (idx != -1) {
      _branches[idx] = updated;
    }
  }

  static void deleteBranch(String branchId) {
    _branches.removeWhere((b) => b.id == branchId);
    _items.removeWhere((item) => item.branchId == branchId);
  }

  // ── Product Getters & Operations ────────────────────────────────────────────
  static List<InventoryItemModel> get items => List.unmodifiable(_items);

  static List<InventoryItemModel> getItemsForBranch(String branchId) {
    return _items.where((item) => item.branchId == branchId).toList();
  }

  static List<InventoryItemModel> getAllItems() {
    return List.unmodifiable(_items);
  }

  static void addItem(InventoryItemModel item) {
    _items.insert(0, item);
    _transactions.insert(
      0,
      StockTransactionModel(
        id: 'TXN-${DateTime.now().millisecondsSinceEpoch % 10000}',
        branchId: item.branchId,
        productId: item.id,
        productName: item.name,
        type: 'Stock In',
        quantity: item.quantity,
        reason: 'New product added to inventory',
        date: 'Just now',
        performedBy: 'Admin',
      ),
    );
  }

  static void updateItem(InventoryItemModel updated) {
    final idx = _items.indexWhere((i) => i.id == updated.id);
    if (idx != -1) {
      _items[idx] = updated;
    }
  }

  static void deleteItem(String itemId) {
    _items.removeWhere((i) => i.id == itemId);
  }

  static void adjustStock({
    required String itemId,
    required int deltaQuantity, // positive for Stock In, negative for Stock Out
    required String reason,
    required String performedBy,
  }) {
    final idx = _items.indexWhere((i) => i.id == itemId);
    if (idx != -1) {
      final old = _items[idx];
      final newQty = (old.quantity + deltaQuantity).clamp(0, 99999);
      final isStockIn = deltaQuantity > 0;

      _items[idx] = old.copyWith(quantity: newQty, lastUpdated: 'Just now');

      _transactions.insert(
        0,
        StockTransactionModel(
          id: 'TXN-${DateTime.now().millisecondsSinceEpoch % 10000}',
          branchId: old.branchId,
          productId: old.id,
          productName: old.name,
          type: isStockIn ? 'Stock In' : 'Stock Out',
          quantity: deltaQuantity.abs(),
          reason: reason.isNotEmpty
              ? reason
              : (isStockIn
                    ? 'Manual stock addition'
                    : 'Part consumption / sale'),
          date: 'Just now',
          performedBy: performedBy,
        ),
      );
    }
  }

  // ── Metrics & Summaries ─────────────────────────────────────────────────────
  static double getBranchTotalValuation(String branchId) {
    final items = getItemsForBranch(branchId);
    return items.fold(0.0, (sum, i) => sum + i.totalValuation);
  }

  static int getBranchTotalItemsCount(String branchId) {
    final items = getItemsForBranch(branchId);
    return items.fold(0, (sum, i) => sum + i.quantity);
  }

  static int getBranchLowStockCount(String branchId) {
    final items = getItemsForBranch(branchId);
    return items
        .where((i) => i.quantity > 0 && i.quantity <= i.minQuantity)
        .length;
  }

  static int getBranchOutOfStockCount(String branchId) {
    final items = getItemsForBranch(branchId);
    return items.where((i) => i.quantity <= 0).length;
  }

  static List<StockTransactionModel> getTransactionsForBranch(String branchId) {
    return _transactions.where((t) => t.branchId == branchId).toList();
  }
}
