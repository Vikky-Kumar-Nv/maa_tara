import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/features/categories/category_detail.dart';
import 'package:maa_tara/features/categories/category_model.dart';
import 'package:maa_tara/features/inventory/add_product.dart';
import 'package:maa_tara/features/inventory/inventory_models.dart';
import 'package:maa_tara/features/suppliers/supplier_detail.dart';
import 'package:maa_tara/features/suppliers/supplier_model.dart';

typedef _C = AppColors;

// ─────────────────────────────────────────────────────────────────────────────
//  MAA TARA AUTOMOBILES — Ultra-Attractive Product / Part Detail Screen
// ─────────────────────────────────────────────────────────────────────────────
class ProductDetailPage extends StatefulWidget {
  final InventoryItemModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late InventoryItemModel _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        backgroundColor: _C.card,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openEditProduct() async {
    final updated = await Navigator.push<InventoryItemModel>(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductPage(initialItem: _product),
      ),
    );
    if (updated != null && mounted) {
      setState(() => _product = updated);
    }
  }

  void _showStockAdjustSheet() {
    int delta = 1;
    bool isAdding = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _C.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final newQty = isAdding
              ? _product.quantity + delta
              : (_product.quantity - delta).clamp(0, 999999);
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Adjust Stock Qty',
                      style: TextStyle(
                        color: _C.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: _C.muted, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setSheetState(() => isAdding = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isAdding
                                ? _C.green.withValues(alpha: 0.15)
                                : _C.inputFill,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isAdding ? _C.green : _C.divider,
                              width: isAdding ? 1.5 : 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '+ Stock In (Receive)',
                            style: TextStyle(
                              color: isAdding ? _C.green : _C.muted,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () => setSheetState(() => isAdding = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !isAdding
                                ? _C.red.withValues(alpha: 0.15)
                                : _C.inputFill,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: !isAdding ? _C.red : _C.divider,
                              width: !isAdding ? 1.5 : 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '- Stock Out (Issue/Damage)',
                            style: TextStyle(
                              color: !isAdding ? _C.red : _C.muted,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: _C.muted,
                        size: 28,
                      ),
                      onPressed: delta > 1
                          ? () => setSheetState(() => delta--)
                          : null,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _C.inputFill,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _C.divider),
                      ),
                      child: Text(
                        '$delta ${_product.unit}',
                        style: const TextStyle(
                          color: _C.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: _C.accent,
                        size: 28,
                      ),
                      onPressed: () => setSheetState(() => delta++),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Resulting Stock: ${_product.quantity} -> $newQty ${_product.unit}',
                    style: const TextStyle(
                      color: _C.muted,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      final updatedItem = InventoryItemModel(
                        id: _product.id,
                        branchId: _product.branchId,
                        name: _product.name,
                        description: _product.description,
                        category: _product.category,
                        brand: _product.brand,
                        partNumber: _product.partNumber,
                        hsnCode: _product.hsnCode,
                        quantity: newQty,
                        minQuantity: _product.minQuantity,
                        purchasePrice: _product.purchasePrice,
                        sellingPrice: _product.sellingPrice,
                        discountPercent: _product.discountPercent,
                        gstRate: _product.gstRate,
                        isTaxInclusive: _product.isTaxInclusive,
                        preGstAmount: _product.preGstAmount,
                        gstAmount: _product.gstAmount,
                        postGstAmount: _product.postGstAmount,
                        unit: _product.unit,
                        secondaryUnit: _product.secondaryUnit,
                        conversionFactor: _product.conversionFactor,
                        rackLocation: _product.rackLocation,
                        supplier: _product.supplier,
                        supplierGstNumber: _product.supplierGstNumber,
                        supplierPhone: _product.supplierPhone,
                        lastUpdated: 'Just now',
                      );
                      InventoryRepository.updateItem(updatedItem);
                      setState(() => _product = updatedItem);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Stock updated to $newQty ${_product.unit}',
                          ),
                          backgroundColor: _C.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Confirm Stock Adjustment',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculated financial metrics
    final double marginAmount = _product.postGstAmount - _product.purchasePrice;
    final double marginPercent = _product.purchasePrice > 0
        ? ((marginAmount / _product.purchasePrice) * 100)
        : 0.0;

    // Matched Category object for 3D visual
    final matchedCat = CategoryRepository.categories.firstWhere(
      (c) =>
          c.name.toLowerCase() == _product.category.toLowerCase() ||
          _product.category.toLowerCase().contains(c.name.toLowerCase()),
      orElse: () => CategoryModel(
        id: 'cat-gen',
        name: _product.category,
        iconKey: 'engine',
        description: _product.description,
        productsCount: 1,
      ),
    );

    // Matched Supplier
    final matchedSupplier = SupplierRepository.suppliers.where((s) {
      return s.companyName.toLowerCase() == _product.supplier.toLowerCase() ||
          _product.supplier.toLowerCase().contains(s.companyName.toLowerCase()) ||
          s.companyName.toLowerCase().contains(_product.supplier.toLowerCase());
    }).firstOrNull ??
        (_product.supplier.isNotEmpty
            ? SupplierModel(
                id: 'SUP-AUTO',
                name: _product.supplier,
                companyName: _product.supplier,
                category: _product.category,
                phone: _product.supplierPhone,
                email: '',
                gstNumber: _product.supplierGstNumber,
                suppliedProducts: [_product.name],
              )
            : null);

    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.card,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _C.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _product.name,
          style: const TextStyle(
            color: _C.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: _C.accent),
            tooltip: 'Adjust Stock',
            onPressed: _showStockAdjustSheet,
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: _C.white),
            tooltip: 'Edit Part',
            onPressed: _openEditProduct,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 🏎️ PRODUCT HERO BANNER CARD ───────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF162336), Color(0xFF0F1B2B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _C.accent.withValues(alpha: 0.35),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_product.imagePath.isNotEmpty &&
                          File(_product.imagePath).existsSync())
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(_product.imagePath),
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoryDetailPage(category: matchedCat),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Tooltip(
                            message: 'View ${matchedCat.name} Category Catalog',
                            child: CategoryVisualAvatar(category: matchedCat, size: 64),
                          ),
                        ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _C.accent.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.qr_code_rounded,
                                        color: _C.accent,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _product.partNumber,
                                        style: const TextStyle(
                                          color: _C.accent,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _product.statusColor.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    _product.status,
                                    style: TextStyle(
                                      color: _product.statusColor,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _product.name,
                              style: const TextStyle(
                                color: _C.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_product.brand} • HSN: ${_product.hsnCode}',
                              style: const TextStyle(
                                color: _C.muted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_product.description.isNotEmpty) ...[
                    const Divider(color: _C.divider, height: 20),
                    Text(
                      _product.description,
                      style: TextStyle(
                        color: _C.muted.withValues(alpha: 0.9),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── 📊 3 FINANCIAL KPI SUMMARY TILES ─────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    'Post-GST Sell',
                    '₹${_product.postGstAmount.toStringAsFixed(0)}',
                    Icons.sell_outlined,
                    _C.accent,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    'Purchase Cost',
                    '₹${_product.purchasePrice.toStringAsFixed(0)}',
                    Icons.shopping_bag_outlined,
                    _C.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    'Est. Margin',
                    '${marginPercent >= 0 ? '+' : ''}${marginPercent.toStringAsFixed(1)}%',
                    Icons.trending_up_rounded,
                    marginPercent >= 0 ? _C.green : _C.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── 💰 PRICING & GST COMPLETE BREAKDOWN CARD ──────────────────────
            const Text(
              'TAX & PRICING BREAKDOWN',
              style: TextStyle(
                color: _C.muted,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _C.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _C.divider),
              ),
              child: Column(
                children: [
                  _detailRow(
                    'Pre-GST Base Amount',
                    '₹${_product.preGstAmount.toStringAsFixed(2)}',
                  ),
                  const Divider(color: _C.divider, height: 16),
                  _detailRow(
                    'GST Slab Rate',
                    '${_product.gstRate.toStringAsFixed(0)}% (${_product.isTaxInclusive ? "Included" : "Added"})',
                    badgeColor: _C.accent,
                  ),
                  const Divider(color: _C.divider, height: 16),
                  _detailRow(
                    'GST Tax Amount',
                    '₹${_product.gstAmount.toStringAsFixed(2)}',
                  ),
                  if (_product.discountPercent > 0) ...[
                    const Divider(color: _C.divider, height: 16),
                    _detailRow(
                      'Trade Discount',
                      '${_product.discountPercent.toStringAsFixed(1)}%',
                      badgeColor: _C.green,
                    ),
                  ],
                  const Divider(color: _C.divider, height: 16),
                  _detailRow(
                    'Final Selling Price (Post-GST)',
                    '₹${_product.postGstAmount.toStringAsFixed(2)} / ${_product.unit}',
                    isBold: true,
                    valueColor: _C.accent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── 📦 STOCK, UNITS & WAREHOUSE LOCATION ─────────────────────────
            const Text(
              'STOCK & PACKAGING CONVERSION',
              style: TextStyle(
                color: _C.muted,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _C.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _C.divider),
              ),
              child: Column(
                children: [
                  _detailRow(
                    'Current Available Quantity',
                    '${_product.quantity} ${_product.unit}',
                    isBold: true,
                    valueColor: _product.statusColor,
                  ),
                  const Divider(color: _C.divider, height: 16),
                  _detailRow(
                    'Low Stock Alert Level',
                    'Alert when ≤ ${_product.minQuantity} ${_product.unit}',
                    badgeColor: _product.quantity <= _product.minQuantity
                        ? _C.amber
                        : null,
                  ),
                  if (_product.secondaryUnit != null &&
                      _product.conversionFactor > 1) ...[
                    const Divider(color: _C.divider, height: 16),
                    _detailRow(
                      'Unit Packaging Conversion',
                      '1 ${_product.secondaryUnit} = ${_product.conversionFactor} ${_product.unit}',
                      badgeColor: _C.accent,
                    ),
                    const Divider(color: _C.divider, height: 16),
                    _detailRow(
                      'Equivalent Bulk Stock',
                      '${(_product.quantity / _product.conversionFactor).toStringAsFixed(1)} ${_product.secondaryUnit}',
                    ),
                  ],
                  const Divider(color: _C.divider, height: 16),
                  _detailRow(
                    'Shelf / Rack Location',
                    _product.rackLocation,
                    icon: Icons.place_outlined,
                  ),
                  const Divider(color: _C.divider, height: 16),
                  _detailRow('Last Stock Audit', _product.lastUpdated),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── 🏢 SUPPLIER & SOURCING DETAILS CARD ──────────────────────────
            const Text(
              'SUPPLIER & SOURCING INFO',
              style: TextStyle(
                color: _C.muted,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _C.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _C.divider),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (matchedSupplier != null)
                        SupplierBrandLogo(supplier: matchedSupplier, size: 40)
                      else
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _C.inputFill,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _C.divider),
                          ),
                          child: const Icon(
                            Icons.business_outlined,
                            color: _C.accent,
                            size: 20,
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _product.supplier,
                              style: const TextStyle(
                                color: _C.white,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _product.supplierGstNumber.isNotEmpty
                                  ? 'GST: ${_product.supplierGstNumber}'
                                  : 'Vendor Partner',
                              style: const TextStyle(
                                color: _C.muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (matchedSupplier != null)
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: _C.accent,
                            size: 15,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SupplierDetailPage(
                                  supplier: matchedSupplier,
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                  if (_product.supplierGstNumber.isNotEmpty) ...[
                    const Divider(color: _C.divider, height: 16),
                    _detailRow(
                      'Supplier GSTIN',
                      _product.supplierGstNumber,
                      onCopy: () => _copyToClipboard(
                        _product.supplierGstNumber,
                        'Supplier GST',
                      ),
                    ),
                  ],
                  if (_product.supplierPhone.isNotEmpty) ...[
                    const Divider(color: _C.divider, height: 16),
                    _detailRow(
                      'Supplier Phone',
                      _product.supplierPhone,
                      onCopy: () => _copyToClipboard(
                        _product.supplierPhone,
                        'Supplier Phone',
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── 🔘 BOTTOM ACTION BUTTONS ─────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: _showStockAdjustSheet,
                      icon: const Icon(
                        Icons.tune_rounded,
                        color: _C.white,
                        size: 16,
                      ),
                      label: const Text(
                        'Adjust Stock',
                        style: TextStyle(
                          color: _C.white,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _C.divider),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: _C.inputFill,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _openEditProduct,
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.black,
                        size: 16,
                      ),
                      label: const Text(
                        'Edit Product',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _C.accent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ── Helper Widgets ─────────────────────────────────────────────────────────

  Widget _buildMetricTile(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _C.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(color: _C.muted, fontSize: 10),
              ),
              Icon(icon, color: color, size: 13),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
    Color? badgeColor,
    IconData? icon,
    VoidCallback? onCopy,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: _C.muted, size: 13),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: isBold ? _C.white : _C.muted,
                fontSize: 12,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        valueColor ??
                        (badgeColor ?? (isBold ? _C.white : _C.muted)),
                    fontSize: isBold ? 13 : 12,
                    fontWeight: isBold || badgeColor != null
                        ? FontWeight.w800
                        : FontWeight.w600,
                  ),
                ),
              ),
              if (onCopy != null) ...[
                const SizedBox(width: 4),
                InkWell(
                  onTap: onCopy,
                  child: const Icon(
                    Icons.copy_rounded,
                    color: _C.muted,
                    size: 13,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
