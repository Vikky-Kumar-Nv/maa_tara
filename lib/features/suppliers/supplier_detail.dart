import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/features/categories/category_detail.dart';
import 'package:maa_tara/features/categories/category_model.dart';
import 'package:maa_tara/features/inventory/add_product.dart';
import 'package:maa_tara/features/inventory/inventory_models.dart';
import 'package:maa_tara/features/inventory/products/product_detail.dart';
import 'package:maa_tara/features/suppliers/add_supplier.dart';
import 'package:maa_tara/features/suppliers/supplier_model.dart';

typedef _C = AppColors;

// ─────────────────────────────────────────────────────────────────────────────
//  MAA TARA AUTOMOBILES — Ultra-Attractive Supplier Detail & Catalog Page
// ─────────────────────────────────────────────────────────────────────────────
class SupplierDetailPage extends StatefulWidget {
  final SupplierModel supplier;

  const SupplierDetailPage({super.key, required this.supplier});

  @override
  State<SupplierDetailPage> createState() => _SupplierDetailPageState();
}

class _SupplierDetailPageState extends State<SupplierDetailPage>
    with SingleTickerProviderStateMixin {
  late SupplierModel _supplier;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _supplier = widget.supplier;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _C.card,
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: _C.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              '$label copied to clipboard!',
              style: const TextStyle(color: _C.white),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openEditSupplier() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddSupplierBottomSheet(
        supplierToEdit: _supplier,
        onSaved: () {
          final updated = SupplierRepository.suppliers.firstWhere(
            (s) => s.id == _supplier.id,
            orElse: () => _supplier,
          );
          setState(() => _supplier = updated);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          _supplier.companyName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _C.white,
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: _C.accent),
            tooltip: 'Edit Supplier',
            onPressed: _openEditSupplier,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 🏢 HERO SUPPLIER PROFILE CARD ────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF161F36), Color(0xFF101726)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _C.accent.withValues(alpha: 0.3),
                  width: 1.2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Supplier Brand Logo
                      SupplierBrandLogo(supplier: _supplier, size: 64),
                      const SizedBox(width: 14),

                      // Company Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    _supplier.companyName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: _C.white,
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.verified,
                                  color: _C.accent,
                                  size: 16,
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _supplier.category,
                              style: const TextStyle(
                                color: _C.muted,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _C.accent.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        color: _C.accent,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        _supplier.rating,
                                        style: const TextStyle(
                                          color: _C.accent,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _C.inputFill,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${_supplier.productsCount} Products',
                                    style: const TextStyle(
                                      color: _C.white,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── QUICK ACTION BUTTONS (Call, WhatsApp, Email, GST) ──────
                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          icon: Icons.phone_forwarded,
                          label: 'Call',
                          color: _C.green,
                          onTap: () =>
                              _copyToClipboard(_supplier.phone, 'Phone number'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _actionButton(
                          icon: Icons.chat_bubble_outline,
                          label: 'WhatsApp',
                          color: const Color(0xFF25D366),
                          onTap: () => _copyToClipboard(
                            _supplier.phone,
                            'WhatsApp contact',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _actionButton(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          color: _C.accent,
                          onTap: () => _copyToClipboard(
                            _supplier.email,
                            'Email address',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── 📊 KPI STATS GRID ────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    'Supplied Items',
                    '${_supplier.productsCount} SKUs',
                    Icons.inventory_2_outlined,
                    _C.accent,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _statCard(
                    'Total Purchase',
                    '₹${(_supplier.totalSpend / 1000).toStringAsFixed(1)}k',
                    Icons.payments_outlined,
                    _C.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    'Payment Terms',
                    _supplier.paymentTerms,
                    Icons.account_balance_wallet_outlined,
                    _C.amber,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _statCard(
                    'Last Order',
                    _supplier.lastOrderDate,
                    Icons.local_shipping_outlined,
                    _C.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // ── 🗂️ LINKED AUTOMOTIVE CATEGORIES ──────────────────────────────
            Builder(
              builder: (context) {
                final matchedCategories = CategoryRepository.categories.where((
                  c,
                ) {
                  return _supplier.categories.any(
                        (sc) =>
                            sc.toLowerCase() == c.name.toLowerCase() ||
                            c.name.toLowerCase().contains(sc.toLowerCase()),
                      ) ||
                      _supplier.category.toLowerCase().contains(
                        c.name.toLowerCase(),
                      );
                }).toList();
                if (matchedCategories.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SUPPLIED CATEGORIES (${matchedCategories.length})',
                      style: const TextStyle(
                        color: _C.muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 62,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: matchedCategories.length,
                        separatorBuilder: (ctx, i) => const SizedBox(width: 10),
                        itemBuilder: (ctx, i) {
                          final cat = matchedCategories[i];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CategoryDetailPage(category: cat),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: _C.card,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _C.divider),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CategoryVisualAvatar(category: cat, size: 38),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        cat.name,
                                        style: const TextStyle(
                                          color: _C.white,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${cat.productsCount} items in stock',
                                        style: const TextStyle(
                                          color: _C.muted,
                                          fontSize: 10.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: _C.muted,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                );
              },
            ),

            // ── 📞 CONTACT & BUSINESS DETAILS CARD ───────────────────────────
            const Text(
              'BUSINESS & TAX INFORMATION',
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
                  _infoRow(
                    icon: Icons.person_outline,
                    title: 'Contact Person',
                    value: _supplier.name,
                  ),
                  const Divider(color: _C.divider, height: 16),
                  _infoRow(
                    icon: Icons.phone_outlined,
                    title: 'Phone Number',
                    value: _supplier.phone,
                    onCopy: () =>
                        _copyToClipboard(_supplier.phone, 'Phone number'),
                  ),
                  const Divider(color: _C.divider, height: 16),
                  _infoRow(
                    icon: Icons.email_outlined,
                    title: 'Email Address',
                    value: _supplier.email,
                    onCopy: () =>
                        _copyToClipboard(_supplier.email, 'Email address'),
                  ),
                  const Divider(color: _C.divider, height: 16),
                  _infoRow(
                    icon: Icons.receipt_long_outlined,
                    title: 'GSTIN / Tax ID',
                    value: _supplier.gstNumber.isNotEmpty
                        ? _supplier.gstNumber
                        : 'Unregistered / Not Added',
                    isAccentValue: _supplier.gstNumber.isNotEmpty,
                    onCopy: _supplier.gstNumber.isNotEmpty
                        ? () => _copyToClipboard(
                            _supplier.gstNumber,
                            'GST Number',
                          )
                        : null,
                  ),
                  const Divider(color: _C.divider, height: 16),
                  _infoRow(
                    icon: Icons.location_on_outlined,
                    title: 'Warehouse / Office',
                    value: _supplier.address.isNotEmpty
                        ? _supplier.address
                        : 'Main Workshop Store',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // ── 📦 SUPPLIED PRODUCTS CATALOG ─────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'SUPPLIED PRODUCTS CATALOG',
                  style: TextStyle(
                    color: _C.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddProductPage(initialSupplier: _supplier),
                      ),
                    ).then((_) {
                      if (mounted) {
                        final updated = SupplierRepository.suppliers.firstWhere(
                          (s) => s.id == _supplier.id,
                          orElse: () => _supplier,
                        );
                        setState(() => _supplier = updated);
                      }
                    });
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.add, color: _C.accent, size: 14),
                      SizedBox(width: 2),
                      Text(
                        'Add Product',
                        style: TextStyle(
                          color: _C.accent,
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _C.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _C.divider),
              ),
              child: _buildSuppliedProductsContent(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: _C.inputFill,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _C.divider),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 15),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: _C.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(12),
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
                style: const TextStyle(color: _C.muted, fontSize: 11),
              ),
              Icon(icon, color: iconColor, size: 15),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _C.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
    bool isAccentValue = false,
    VoidCallback? onCopy,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: _C.accent, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: _C.muted, fontSize: 10.5),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isAccentValue ? _C.accent : _C.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (onCopy != null) ...[
          const SizedBox(width: 8),
          InkWell(
            onTap: onCopy,
            borderRadius: BorderRadius.circular(6),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.copy_rounded, color: _C.muted, size: 15),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSuppliedProductsContent() {
    final allProducts = List<String>.from(_supplier.suppliedProducts);
    final dynamicItems = InventoryRepository.items
        .where((i) {
          return i.supplier.toLowerCase() ==
                  _supplier.companyName.toLowerCase() ||
              _supplier.companyName.toLowerCase().contains(
                i.supplier.toLowerCase(),
              ) ||
              i.supplier.toLowerCase().contains(
                _supplier.companyName.toLowerCase(),
              );
        })
        .map((i) => i.name);

    for (final p in dynamicItems) {
      if (!allProducts.any((x) => x.toLowerCase() == p.toLowerCase())) {
        allProducts.add(p);
      }
    }

    if (allProducts.isEmpty) {
      return const Text(
        'No specific product lines added.',
        style: TextStyle(color: _C.muted, fontSize: 12),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allProducts.map((p) {
            final matchedItem = InventoryRepository.items
                .where(
                  (item) =>
                      item.name.toLowerCase().contains(p.toLowerCase()) ||
                      p.toLowerCase().contains(item.name.toLowerCase()),
                )
                .firstOrNull;

            return InkWell(
              onTap: () {
                if (matchedItem != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailPage(product: matchedItem),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Product line: $p'),
                      backgroundColor: _C.card,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _C.inputFill,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: matchedItem != null
                        ? _C.accent.withValues(alpha: 0.5)
                        : _C.divider,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      matchedItem != null
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      color: _C.accent,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      p,
                      style: const TextStyle(
                        color: _C.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (matchedItem != null) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: _C.accent,
                        size: 10,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
