import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/features/suppliers/supplier_model.dart';

typedef _C = AppColors;

// ─────────────────────────────────────────────────────────────────────────────
//  Supplier Options Bottom Sheet (Matches Screenshot 3 Design)
// ─────────────────────────────────────────────────────────────────────────────
class SupplierOptionsBottomSheet extends StatelessWidget {
  final SupplierModel supplier;
  final VoidCallback onEdit;
  final VoidCallback onViewProducts;
  final VoidCallback onDelete;

  const SupplierOptionsBottomSheet({
    super.key,
    required this.supplier,
    required this.onEdit,
    required this.onViewProducts,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: _C.divider, width: 1.2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Handle Pill
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: _C.muted.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Header with Logo, Company Name, Category
          Row(
            children: [
              SupplierBrandLogo(supplier: supplier, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supplier.companyName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _C.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      supplier.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _C.muted, fontSize: 11.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Options Container Card
          Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: _C.inputFill,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _C.divider),
              ),
              child: Column(
                children: [
                  ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    leading: const Icon(Icons.edit_outlined, color: _C.accent, size: 20),
                    title: const Text('Edit Supplier', style: TextStyle(color: _C.white, fontSize: 13.5)),
                    onTap: onEdit,
                  ),
                  const Divider(color: _C.divider, height: 1),
                  ListTile(
                    leading: const Icon(Icons.inventory_2_outlined, color: _C.amber, size: 20),
                    title: Text(
                      'View Products (${supplier.productsCount})',
                      style: const TextStyle(color: _C.white, fontSize: 13.5),
                    ),
                    onTap: onViewProducts,
                  ),
                  const Divider(color: _C.divider, height: 1),
                  ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                    ),
                    leading: const Icon(Icons.delete_outline, color: _C.red, size: 20),
                    title: const Text('Delete Supplier', style: TextStyle(color: _C.red, fontSize: 13.5)),
                    onTap: onDelete,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Cancel Button
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.inputFill,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: _C.divider),
                ),
              ),
              child: const Text('Cancel', style: TextStyle(color: _C.white, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
