import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/core/widgets/paginated_list.dart';
import 'package:maa_tara/features/suppliers/add_supplier.dart';
import 'package:maa_tara/features/suppliers/supplier_detail.dart';
import 'package:maa_tara/features/suppliers/supplier_model.dart';
import 'package:maa_tara/features/suppliers/supplier_options_sheet.dart';

typedef _C = AppColors;

// ─────────────────────────────────────────────────────────────────────────────
//  MAA TARA AUTOMOBILES — Suppliers List Page (Matches Screenshot 1 Design)
// ─────────────────────────────────────────────────────────────────────────────
class SupplierListPage extends StatefulWidget {
  const SupplierListPage({super.key});

  @override
  State<SupplierListPage> createState() => _SupplierListPageState();
}

class _SupplierListPageState extends State<SupplierListPage> {
  bool _isLoading = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Pagination state
  int _currentPage = 1;
  static const int _pageSize = 6;
  bool _isLoadingMore = false;

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _currentPage = 1;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLoadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _currentPage++;
        _isLoadingMore = false;
      });
    }
  }

  List<SupplierModel> get _allFilteredSuppliers {
    final list = SupplierRepository.suppliers;
    if (_searchQuery.isEmpty) return list;

    final q = _searchQuery.toLowerCase();
    return list.where((s) {
      return s.companyName.toLowerCase().contains(q) ||
          s.name.toLowerCase().contains(q) ||
          s.category.toLowerCase().contains(q) ||
          s.phone.toLowerCase().contains(q) ||
          s.email.toLowerCase().contains(q) ||
          s.gstNumber.toLowerCase().contains(q);
    }).toList();
  }

  List<SupplierModel> get _paginatedSuppliers {
    final all = _allFilteredSuppliers;
    final end = (_currentPage * _pageSize).clamp(0, all.length);
    return all.sublist(0, end);
  }

  bool get _hasMore => _paginatedSuppliers.length < _allFilteredSuppliers.length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddSupplierModal({SupplierModel? supplierToEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddSupplierBottomSheet(
        supplierToEdit: supplierToEdit,
        onSaved: () => setState(() {}),
      ),
    );
  }

  void _openSupplierOptions(SupplierModel supplier) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SupplierOptionsBottomSheet(
        supplier: supplier,
        onEdit: () {
          Navigator.pop(ctx);
          _openAddSupplierModal(supplierToEdit: supplier);
        },
        onViewProducts: () {
          Navigator.pop(ctx);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SupplierDetailPage(supplier: supplier),
            ),
          );
        },
        onDelete: () {
          Navigator.pop(ctx);
          _confirmDeleteSupplier(supplier);
        },
      ),
    );
  }

  void _confirmDeleteSupplier(SupplierModel supplier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _C.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _C.red, width: 1.2),
        ),
        title: const Text('Delete Supplier?', style: TextStyle(color: _C.white, fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to remove "${supplier.companyName}" from your suppliers list?',
          style: const TextStyle(color: _C.muted, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: _C.muted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              SupplierRepository.deleteSupplier(supplier.id);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: _C.card,
                  content: Text('${supplier.companyName} removed.', style: const TextStyle(color: _C.white)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: _C.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final suppliers = _paginatedSuppliers;

    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: PaginatedListView<SupplierModel>(
          items: suppliers,
          isInitialLoading: _isLoading,
          isLoadingMore: _isLoadingMore,
          hasMore: _hasMore,
          onRefresh: _handleRefresh,
          onLoadMore: _handleLoadMore,
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Row: Back, Title & + Add Supplier Button ────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.arrow_back, color: _C.white, size: 22),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Suppliers',
                        style: TextStyle(
                          color: _C.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),

                  // + Add Supplier Button
                  InkWell(
                    onTap: () => _openAddSupplierModal(),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: _C.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _C.accent, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add, color: _C.accent, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Add Supplier',
                            style: TextStyle(
                              color: _C.accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── Search Input Field ─────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: _C.inputFill,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _C.divider),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: _C.white, fontSize: 13.5),
                  decoration: InputDecoration(
                    hintText: 'Search suppliers...',
                    hintStyle: TextStyle(
                      color: _C.muted.withValues(alpha: 0.5),
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(Icons.search, color: _C.muted, size: 18),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, color: _C.muted, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
          emptyWidget: _buildEmptyState(),
          itemBuilder: (context, supplier, index) => _buildSupplierCard(supplier),
        ),
      ),
    );
  }

  Widget _buildSupplierCard(SupplierModel s) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SupplierDetailPage(supplier: s)),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.divider),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Supplier Brand Avatar / Screenshot-Accurate Logo
            SupplierBrandLogo(supplier: s, size: 52),
            const SizedBox(width: 12),

            // Middle Details: Company, Category, Phone, Email, Products
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.companyName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _C.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    s.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _C.muted,
                      fontSize: 11.5,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Phone Row
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, color: _C.muted, size: 13),
                      const SizedBox(width: 5),
                      Text(
                        s.phone,
                        style: const TextStyle(color: _C.white, fontSize: 11.5, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),

                  // Email Row
                  Row(
                    children: [
                      const Icon(Icons.email_outlined, color: _C.muted, size: 13),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          s.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: _C.muted, fontSize: 11.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Products Count
                  Text(
                    'Products: ${s.productsCount}',
                    style: const TextStyle(
                      color: _C.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // 3-Dots Menu Button
            InkWell(
              onTap: () => _openSupplierOptions(s),
              borderRadius: BorderRadius.circular(16),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.more_vert, color: _C.muted, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: const [
          Icon(Icons.storefront_outlined, size: 48, color: _C.muted),
          SizedBox(height: 12),
          Text(
            'No Suppliers Found',
            style: TextStyle(color: _C.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4),
          Text(
            'Add your first automotive parts supplier.',
            style: TextStyle(color: _C.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
