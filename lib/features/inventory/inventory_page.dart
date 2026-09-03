import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/core/widgets/paginated_list.dart';
import 'package:maa_tara/core/widgets/skeleton_loader.dart';
import 'package:maa_tara/features/categories/category_model.dart';
import 'package:maa_tara/features/inventory/add_product.dart';
import 'package:maa_tara/features/inventory/create_branch.dart';
import 'package:maa_tara/features/inventory/inventory_models.dart';
import 'package:maa_tara/features/inventory/products/product_detail.dart';
import 'package:maa_tara/features/suppliers/supplier_model.dart';

typedef _C = AppColors;

// ─────────────────────────────────────────────────────────────────────────────
//  Inventory Page (Multi-Branch ERP with 2-Shop Limit)
// ─────────────────────────────────────────────────────────────────────────────
class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  bool _isLoading = false;
  late String _selectedBranchId;
  String _selectedCategory = 'All';
  String _selectedStatus = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Pagination state
  int _currentPage = 1;
  static const int _pageSize = 8;
  bool _isLoadingMore = false;

  final List<String> _statusFilters = [
    'All',
    'In Stock',
    'Low Stock',
    'Out of Stock',
  ];

  @override
  void initState() {
    super.initState();
    _selectedBranchId = InventoryRepository.branches.isNotEmpty
        ? InventoryRepository.branches.first.id
        : 'BR-01';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Cached branch items to prevent repeated iterations
  List<InventoryItemModel>? _cachedBranchItems;
  String? _cachedBranchId;

  List<InventoryItemModel> _getBranchItems() {
    if (_cachedBranchId != _selectedBranchId || _cachedBranchItems == null) {
      _cachedBranchItems = InventoryRepository.getItemsForBranch(_selectedBranchId);
      _cachedBranchId = _selectedBranchId;
    }
    return _cachedBranchItems!;
  }

  void _invalidateCache() {
    _cachedBranchItems = null;
    _cachedBranchId = null;
  }

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      _invalidateCache();
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

  InventoryBranchModel? get _currentBranch {
    final branches = InventoryRepository.branches;
    final idx = branches.indexWhere((b) => b.id == _selectedBranchId);
    return idx != -1
        ? branches[idx]
        : (branches.isNotEmpty ? branches.first : null);
  }

  List<InventoryItemModel> get _filteredItems {
    final branchItems = _getBranchItems();

    return branchItems.where((item) {
      // Category filter
      final matchesCat =
          _selectedCategory == 'All' || item.category == _selectedCategory;

      // Status filter
      bool matchesStatus = true;
      if (_selectedStatus == 'In Stock') {
        matchesStatus = item.quantity > item.minQuantity;
      } else if (_selectedStatus == 'Low Stock') {
        matchesStatus = item.quantity > 0 && item.quantity <= item.minQuantity;
      } else if (_selectedStatus == 'Out of Stock') {
        matchesStatus = item.quantity <= 0;
      }

      // Search query
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        matchesSearch =
            item.name.toLowerCase().contains(q) ||
            item.partNumber.toLowerCase().contains(q) ||
            item.category.toLowerCase().contains(q) ||
            item.supplier.toLowerCase().contains(q) ||
            item.rackLocation.toLowerCase().contains(q);
      }

      return matchesCat && matchesStatus && matchesSearch;
    }).toList();
  }

  List<InventoryItemModel> get _paginatedItems {
    final all = _filteredItems;
    final end = (_currentPage * _pageSize).clamp(0, all.length);
    return all.sublist(0, end);
  }

  bool get _hasMore => _paginatedItems.length < _filteredItems.length;

  void _openCreateBranchPage({InventoryBranchModel? branchToEdit}) async {
    if (branchToEdit == null && !InventoryRepository.canCreateBranch) {
      _showBranchLimitLockedDialog();
      return;
    }

    final result = await Navigator.push<InventoryBranchModel>(
      context,
      MaterialPageRoute(
        builder: (ctx) => CreateBranchPage(initialBranch: branchToEdit),
      ),
    );

    if (result != null) {
      _invalidateCache();
      setState(() {
        _selectedBranchId = result.id;
      });
      _showStatusDialog(
        title: branchToEdit != null ? 'Shop Updated' : 'Shop Branch Created',
        message: '${result.name} is now ready for inventory management.',
        isSuccess: true,
      );
    }
  }

  void _openAddProductPage({InventoryItemModel? itemToEdit}) async {
    final result = await Navigator.push<InventoryItemModel>(
      context,
      MaterialPageRoute(
        builder: (ctx) => AddProductPage(
          initialBranchId: _selectedBranchId,
          initialItem: itemToEdit,
        ),
      ),
    );

    if (result != null && mounted) {
      // Defer rebuild to after the navigation transition completes
      // This prevents ANR caused by heavy rebuild during animation
      _invalidateCache();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
          _showStatusDialog(
            title: itemToEdit != null ? 'Product Updated' : 'Product Added',
            message: '${result.name} added to inventory.',
            isSuccess: true,
          );
        }
      });
    }
  }

  void _showBranchLimitLockedDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _C.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _C.amber, width: 1.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _C.amber.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.storefront, color: _C.amber, size: 30),
              ),
              const SizedBox(height: 16),
              const Text(
                'Branch Limit Reached (2/2)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _C.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Aapke account mein max 2 shop branches manage karne ka rule set hai. Agar kisi branch ka name ya details badalna ho toh usko Edit kar sakte hain.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _C.muted, fontSize: 12.5, height: 1.4),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Got It',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStockAdjustDialog(
    InventoryItemModel item, {
    required bool isStockIn,
  }) {
    final qtyController = TextEditingController(text: '5');
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: _C.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: isStockIn ? _C.green : _C.amber, width: 1.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: (isStockIn ? _C.green : _C.amber).withValues(
                        alpha: 0.15,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isStockIn
                          ? Icons.add_circle_outline
                          : Icons.remove_circle_outline,
                      color: isStockIn ? _C.green : _C.amber,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isStockIn ? 'Stock In (+)' : 'Stock Out (-)',
                          style: TextStyle(
                            color: isStockIn ? _C.green : _C.amber,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _C.muted,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Current Stock:',
                    style: TextStyle(color: _C.muted, fontSize: 12.5),
                  ),
                  Text(
                    '${item.quantity} ${item.unit}',
                    style: const TextStyle(
                      color: _C.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Quantity to Adjust',
                style: TextStyle(
                  color: _C.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: const TextStyle(color: _C.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'e.g. 5',
                  hintStyle: TextStyle(
                    color: _C.muted.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                  filled: true,
                  fillColor: _C.inputFill,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: _C.divider),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Reason / Reference Note',
                style: TextStyle(
                  color: _C.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: reasonController,
                style: const TextStyle(color: _C.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: isStockIn
                      ? 'e.g. Supplier Shipment Recvd'
                      : 'e.g. Used in Job Card / Sale',
                  hintStyle: TextStyle(
                    color: _C.muted.withValues(alpha: 0.5),
                    fontSize: 11.5,
                  ),
                  filled: true,
                  fillColor: _C.inputFill,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: _C.divider),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _C.divider),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: _C.muted),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final qty =
                            int.tryParse(qtyController.text.trim()) ?? 0;
                        if (qty <= 0) return;

                        InventoryRepository.adjustStock(
                          itemId: item.id,
                          deltaQuantity: isStockIn ? qty : -qty,
                          reason: reasonController.text.trim(),
                          performedBy: 'Admin',
                        );

                        Navigator.pop(ctx);
                        _invalidateCache();
                        setState(() {});

                        _showStatusDialog(
                          title: isStockIn ? 'Stock Added' : 'Stock Deducted',
                          message:
                              '${isStockIn ? "+" : "-"}$qty ${item.unit} updated for ${item.name}',
                          isSuccess: true,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isStockIn ? _C.green : _C.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                      ),
                      child: Text(
                        isStockIn ? 'Add Stock' : 'Deduct Stock',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStatusDialog({
    required String title,
    required String message,
    required bool isSuccess,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: _C.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: isSuccess ? _C.green : _C.accent, width: 1.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: (isSuccess ? _C.green : _C.accent).withValues(
                    alpha: 0.15,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSuccess ? Icons.check_circle_rounded : Icons.info_outline,
                  color: isSuccess ? _C.green : _C.accent,
                  size: 28,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _C.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: _C.muted, fontSize: 12.5),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final branches = InventoryRepository.branches;

    // ── If No Branch Created Yet: Show Setup Onboarding ───────────────────────
    if (branches.isEmpty) {
      return Scaffold(
        backgroundColor: _C.bg,
        body: _buildNoBranchOnboardingView(),
      );
    }

    // Auto-select first branch if selected branch is invalid or empty
    if (_selectedBranchId.isEmpty ||
        !branches.any((b) => b.id == _selectedBranchId)) {
      _selectedBranchId = branches.first.id;
    }

    final branch = _currentBranch;

    // Use cached branch items for all metric calculations (single iteration)
    final branchItems = _getBranchItems();
    final totalValuation = branchItems.fold(0.0, (sum, i) => sum + i.totalValuation);
    final totalItemsCount = branchItems.fold(0, (sum, i) => sum + i.quantity);
    final lowStockCount = branchItems.where((i) => i.quantity > 0 && i.quantity <= i.minQuantity).length;
    final outOfStockCount = branchItems.where((i) => i.quantity <= 0).length;

    // Compute filtered/paginated items ONCE per build (not via repeated getters)
    final filteredItems = _filteredItems;
    final endIdx = (_currentPage * _pageSize).clamp(0, filteredItems.length);
    final paginatedItems = filteredItems.sublist(0, endIdx);
    final hasMore = paginatedItems.length < filteredItems.length;

    return PaginatedListView<InventoryItemModel>(
      items: paginatedItems,
      isInitialLoading: _isLoading,
      isLoadingMore: _isLoadingMore,
      hasMore: hasMore,
      onRefresh: _handleRefresh,
      onLoadMore: _handleLoadMore,
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Header: Title & + Add Product Button ─────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Inventory',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _C.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Multi-Shop stock & parts ERP',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _C.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _openAddProductPage(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C.card,
                  side: const BorderSide(color: _C.accent, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.add, color: _C.accent, size: 15),
                label: const Text(
                  'Add Product',
                  style: TextStyle(
                    color: _C.accent,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── 🏬 Multi-Shop / Branch Switcher Card ──────────────────────────
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _C.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _C.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.storefront,
                            color: _C.accent,
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'SELECT WORKSHOP SHOP',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _C.muted,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // + Create Branch Button (Max 2 rule)
                    InkWell(
                      onTap: () => _openCreateBranchPage(),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: branches.length >= 2
                              ? _C.inputFill
                              : _C.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: branches.length >= 2
                                ? _C.divider
                                : _C.accent,
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              branches.length >= 2
                                  ? Icons.lock_outline
                                  : Icons.add_business_outlined,
                              color: branches.length >= 2
                                  ? _C.muted
                                  : _C.accent,
                              size: 12.5,
                            ),
                            const SizedBox(width: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                branches.length >= 2
                                    ? 'Branches (2/2 Max)'
                                    : '+ New Shop',
                                maxLines: 1,
                                style: TextStyle(
                                  color: branches.length >= 2
                                      ? _C.muted
                                      : _C.accent,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Branch Toggle Buttons Row
                Row(
                  children: branches.map((b) {
                    final isSelected = b.id == _selectedBranchId;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: InkWell(
                          onTap: () {
                            _invalidateCache();
                            setState(() {
                              _selectedBranchId = b.id;
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? _C.accent.withValues(alpha: 0.18)
                                  : _C.inputFill,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? _C.accent : _C.divider,
                                width: isSelected ? 1.2 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      size: 13,
                                      color: isSelected ? _C.accent : _C.muted,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        b.code,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: isSelected
                                              ? _C.accent
                                              : _C.muted,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  b.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isSelected ? _C.white : _C.muted,
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // Branch Info Footer
                if (branch != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: _C.muted,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          branch.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: _C.muted, fontSize: 11),
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            _openCreateBranchPage(branchToEdit: branch),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'Edit Shop',
                            style: TextStyle(
                              color: _C.accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── 📊 KPI Summary Row (Valuation, Items, Low, Out) ───────────────
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'TOTAL VALUE',
                  value:
                      '₹${totalValuation >= 100000 ? "${(totalValuation / 1000).toStringAsFixed(1)}k" : totalValuation.toStringAsFixed(0)}',
                  subtitle: 'Stock Valuation',
                  icon: Icons.currency_rupee,
                  color: _C.accent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  title: 'TOTAL ITEMS',
                  value: '$totalItemsCount',
                  subtitle: 'Units in Shop',
                  icon: Icons.inventory_2_outlined,
                  color: _C.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  title: 'LOW STOCK',
                  value: '$lowStockCount',
                  subtitle: 'Need Reorder',
                  icon: Icons.warning_amber_rounded,
                  color: _C.amber,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  title: 'OUT OF STOCK',
                  value: '$outOfStockCount',
                  subtitle: '0 Qty Left',
                  icon: Icons.remove_circle_outline,
                  color: _C.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Search & Filter Input ─────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: _C.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _C.divider),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: _C.white, fontSize: 13),
                    cursorColor: _C.accent,
                    decoration: InputDecoration(
                      hintText: 'Search product by name, SKU, shelf...',
                      hintStyle: TextStyle(
                        color: _C.muted.withValues(alpha: 0.5),
                        fontSize: 12.5,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: _C.muted,
                        size: 18,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: _C.muted,
                                size: 16,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 11,
                      ),
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Stock Status Filter Tabs ──────────────────────────────────────
          SizedBox(
            height: 34,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _statusFilters.length,
              itemBuilder: (context, index) {
                final status = _statusFilters[index];
                final isSelected = _selectedStatus == status;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => setState(() => _selectedStatus = status),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _C.accent.withValues(alpha: 0.15)
                            : _C.card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? _C.accent : _C.divider,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          if (status == 'Low Stock') ...[
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: _C.amber,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                          ] else if (status == 'Out of Stock') ...[
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: _C.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            status,
                            style: TextStyle(
                              color: isSelected ? _C.accent : _C.muted,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // ── Category Filter Pills ─────────────────────────────────────────
          SizedBox(
            height: 30,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                'All',
                ...CategoryRepository.categories.map((c) => c.name),
              ].map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    onTap: () => setState(() => _selectedCategory = cat),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _C.accent.withValues(alpha: 0.2)
                            : _C.inputFill,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? _C.accent : _C.divider,
                          width: 0.8,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? _C.accent : _C.muted,
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
      initialLoadingWidget: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => const AppShimmer(
          child: SkeletonCard(
            child: Column(
              children: [
                SkeletonLine(width: 180, height: 16),
                SizedBox(height: 8),
                SkeletonLine(width: 120, height: 12),
                SizedBox(height: 12),
                SkeletonBox(height: 36, borderRadius: 8),
              ],
            ),
          ),
        ),
      ),
      emptyWidget: _buildEmptyState(),
      itemBuilder: (context, item, index) => _buildProductCard(item),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    maxLines: 1,
                    style: const TextStyle(
                      color: _C.muted,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
              Icon(icon, color: color, size: 13),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              subtitle,
              maxLines: 1,
              style: const TextStyle(color: _C.muted, fontSize: 8.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(InventoryItemModel item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: item),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: item.quantity <= 0
                ? _C.red.withValues(alpha: 0.4)
                : (item.quantity <= item.minQuantity
                      ? _C.amber.withValues(alpha: 0.4)
                      : _C.divider),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Row: Name, SKU, Status Pill ────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _C.inputFill,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _C.divider),
                  ),
                  child: const Icon(
                    Icons.build_circle_outlined,
                    color: _C.accent,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          color: _C.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
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
                              item.partNumber,
                              style: const TextStyle(
                                color: _C.accent,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${item.brand} • HSN: ${item.hsnCode}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _C.muted,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusPill(item),
              ],
            ),
            const SizedBox(height: 10),

            // ── Middle Row: 4 Metric Badges ────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: _C.inputFill,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Buy Price',
                          style: TextStyle(color: _C.muted, fontSize: 9.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '₹${item.purchasePrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: _C.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sell (With Tax)',
                          style: TextStyle(color: _C.muted, fontSize: 9.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '₹${(item.postGstAmount > 0 ? item.postGstAmount : item.sellingPrice).toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: _C.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Stock Level',
                          style: TextStyle(color: _C.muted, fontSize: 9.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.quantity} ${item.unit}',
                          style: TextStyle(
                            color: item.statusColor,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Shelf / Rack',
                          style: TextStyle(color: _C.muted, fontSize: 9.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.rackLocation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _C.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(color: _C.divider, height: 1, thickness: 1),
            const SizedBox(height: 8),

            // ── Bottom Action Buttons Row (+ Stock In / - Stock Out / Edit) ─────
            Row(
              children: [
                Expanded(
                  child: _cardActionButton(
                    icon: Icons.add_circle_outline,
                    iconColor: _C.green,
                    label: '+ Stock In',
                    onTap: () => _showStockAdjustDialog(item, isStockIn: true),
                  ),
                ),
                Container(width: 1, height: 16, color: _C.divider),
                Expanded(
                  child: _cardActionButton(
                    icon: Icons.remove_circle_outline,
                    iconColor: _C.amber,
                    label: '- Stock Out',
                    onTap: () => _showStockAdjustDialog(item, isStockIn: false),
                  ),
                ),
                Container(width: 1, height: 16, color: _C.divider),
                Expanded(
                  child: _cardActionButton(
                    icon: Icons.edit_outlined,
                    iconColor: _C.accent,
                    label: 'Edit',
                    onTap: () => _openAddProductPage(itemToEdit: item),
                  ),
                ),
                Container(width: 1, height: 16, color: _C.divider),
                InkWell(
                  onTap: () => _showProductOptions(item),
                  borderRadius: BorderRadius.circular(6),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Icon(Icons.more_vert, color: _C.muted, size: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(InventoryItemModel item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: item.statusColor.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: item.statusColor.withValues(alpha: 0.4)),
      ),
      child: Text(
        item.status,
        style: TextStyle(
          color: item.statusColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _cardActionButton({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13.5, color: iconColor),
            const SizedBox(width: 3.5),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: const TextStyle(
                    color: _C.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductOptions(InventoryItemModel item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: _C.accent),
              title: const Text(
                'Edit Product Details',
                style: TextStyle(color: _C.white),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _openAddProductPage(itemToEdit: item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: _C.red),
              title: const Text(
                'Delete Product',
                style: TextStyle(color: _C.red),
              ),
              onTap: () {
                Navigator.pop(ctx);
                CategoryRepository.decrementProductCount(item.category);
                SupplierRepository.unlinkProductFromSupplier(item.supplier, item.name);
                InventoryRepository.deleteItem(item.id);
                _invalidateCache();
                setState(() {});
                _showStatusDialog(
                  title: 'Product Deleted',
                  message: '${item.name} removed from inventory.',
                  isSuccess: false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.divider),
      ),
      child: Column(
        children: [
          const Icon(Icons.inventory_2_outlined, color: _C.muted, size: 48),
          const SizedBox(height: 12),
          const Text(
            'No Products Found',
            style: TextStyle(
              color: _C.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Is category ya search query ke liye koi product available nahi hai.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _C.muted, fontSize: 12),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _openAddProductPage(),
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.add, color: Colors.black, size: 16),
            label: const Text(
              'Add First Product',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoBranchOnboardingView() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: _C.accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _C.accent.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.storefront_rounded,
                color: _C.accent,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Shop Branch Created Yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _C.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Inventory manage karne ke liye pehle apni Shop Branch create karein.\nAap apne account mein max 2 shop branches manage kar sakte hain.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _C.muted, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Features Overview Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _C.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _C.divider),
              ),
              child: Column(
                children: [
                  _onboardingFeatureRow(
                    Icons.store_mall_directory_outlined,
                    'Multi-Shop Management',
                    '2 Workshop Branches (e.g. Main Workshop & Outlet)',
                  ),
                  const SizedBox(height: 12),
                  _onboardingFeatureRow(
                    Icons.inventory_2_outlined,
                    'Isolated Stock Tracking',
                    'Dono shops ka alag stock aur spare parts records',
                  ),
                  const SizedBox(height: 12),
                  _onboardingFeatureRow(
                    Icons.currency_rupee,
                    'Live Stock Valuation',
                    'Har branch ka real-time financial stock valuation (₹)',
                  ),
                  const SizedBox(height: 12),
                  _onboardingFeatureRow(
                    Icons.warning_amber_rounded,
                    'Automated Stock Alerts',
                    'Low Stock aur Out of Stock instant warnings',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),

            // Big CTA Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openCreateBranchPage(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                icon: const Icon(
                  Icons.add_business_rounded,
                  color: Colors.black,
                  size: 20,
                ),
                label: const Text(
                  'Create First Shop Branch',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _onboardingFeatureRow(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _C.accent.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: _C.accent, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _C.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(color: _C.muted, fontSize: 11.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
