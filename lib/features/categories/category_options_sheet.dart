import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/features/categories/category_model.dart';

typedef _C = AppColors;

// ─────────────────────────────────────────────────────────────────────────────
//  Category Options Bottom Sheet (Edit, Toggle Status, Delete)
// ─────────────────────────────────────────────────────────────────────────────
class CategoryOptionsBottomSheet extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onViewProducts;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;

  const CategoryOptionsBottomSheet({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onViewProducts,
    required this.onToggleStatus,
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

          // Header with Icon & Category Name
          Row(
            children: [
              CategoryVisualAvatar(category: category, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        color: _C.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${category.productsCount} Products',
                      style: const TextStyle(color: _C.muted, fontSize: 11.5),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: category.isActive
                      ? _C.green.withValues(alpha: 0.15)
                      : _C.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  category.status,
                  style: TextStyle(
                    color: category.isActive ? _C.green : _C.amber,
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Options Container
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
                    leading: const Icon(Icons.inventory_2_outlined, color: _C.accent, size: 20),
                    title: Text(
                      'View Spares & Parts (${category.productsCount})',
                      style: const TextStyle(color: _C.white, fontSize: 13.5),
                    ),
                    onTap: onViewProducts,
                  ),
                  const Divider(color: _C.divider, height: 1),
                  ListTile(
                    leading: const Icon(Icons.edit_outlined, color: _C.white, size: 20),
                    title: const Text('Edit Category', style: TextStyle(color: _C.white, fontSize: 13.5)),
                    onTap: onEdit,
                  ),
                  const Divider(color: _C.divider, height: 1),
                  ListTile(
                    leading: Icon(
                      category.isActive ? Icons.block_outlined : Icons.check_circle_outline,
                      color: category.isActive ? _C.amber : _C.green,
                      size: 20,
                    ),
                    title: Text(
                      category.isActive ? 'Mark as Inactive' : 'Mark as Active',
                      style: const TextStyle(color: _C.white, fontSize: 13.5),
                    ),
                    onTap: onToggleStatus,
                  ),
                  const Divider(color: _C.divider, height: 1),
                  ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                    ),
                    leading: const Icon(Icons.delete_outline, color: _C.red, size: 20),
                    title: const Text('Delete Category', style: TextStyle(color: _C.red, fontSize: 13.5)),
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
