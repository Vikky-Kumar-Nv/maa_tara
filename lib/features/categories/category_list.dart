import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/core/widgets/paginated_list.dart';
import 'package:maa_tara/features/categories/add_category.dart';
import 'package:maa_tara/features/categories/category_detail.dart';
import 'package:maa_tara/features/categories/category_model.dart';
import 'package:maa_tara/features/categories/category_options_sheet.dart';

typedef _C = AppColors;

// ─────────────────────────────────────────────────────────────────────────────
//  MAA TARA AUTOMOBILES — Categories List Page (Matches Screenshot 1 Design)
// ─────────────────────────────────────────────────────────────────────────────
class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedFilter = 'All'; // 'All', 'Active', 'Inactive'
  final TextEditingController _searchController = TextEditingController();

  // Pagination state
  int _currentPage = 1;
  static const int _pageSize = 8;
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

  List<CategoryModel> get _allFilteredCategories {
    var list = CategoryRepository.categories;

    // Filter by tab
    if (_selectedFilter == 'Active') {
      list = list.where((c) => c.isActive).toList();
    } else if (_selectedFilter == 'Inactive') {
      list = list.where((c) => !c.isActive).toList();
    }

    // Search filter
    if (_searchQuery.isEmpty) return list;
    final q = _searchQuery.toLowerCase();
    return list.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q);
    }).toList();
  }

  List<CategoryModel> get _paginatedCategories {
    final all = _allFilteredCategories;
    final end = (_currentPage * _pageSize).clamp(0, all.length);
    return all.sublist(0, end);
  }

  bool get _hasMore => _paginatedCategories.length < _allFilteredCategories.length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddCategoryModal({CategoryModel? categoryToEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddCategoryBottomSheet(
        categoryToEdit: categoryToEdit,
        onSaved: () => setState(() {}),
      ),
    );
  }

  void _openCategoryOptions(CategoryModel category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CategoryOptionsBottomSheet(
        category: category,
        onViewProducts: () {
          Navigator.pop(ctx);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryDetailPage(category: category),
            ),
          );
        },
        onEdit: () {
          Navigator.pop(ctx);
          _openAddCategoryModal(categoryToEdit: category);
        },
        onToggleStatus: () {
          Navigator.pop(ctx);
          CategoryRepository.toggleStatus(category.id);
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: _C.card,
              content: Text(
                '${category.name} status updated.',
                style: const TextStyle(color: _C.white),
              ),
            ),
          );
        },
        onDelete: () {
          Navigator.pop(ctx);
          _confirmDeleteCategory(category);
        },
      ),
    );
  }

  void _confirmDeleteCategory(CategoryModel category) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _C.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _C.red, width: 1.2),
        ),
        title: const Text(
          'Delete Category?',
          style: TextStyle(color: _C.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to remove "${category.name}"?',
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
              CategoryRepository.deleteCategory(category.id);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: _C.card,
                  content: Text(
                    '${category.name} deleted.',
                    style: const TextStyle(color: _C.white),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: _C.red),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = _paginatedCategories;

    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: PaginatedListView<CategoryModel>(
          items: categories,
          isInitialLoading: _isLoading,
          isLoadingMore: _isLoadingMore,
          hasMore: _hasMore,
          onRefresh: _handleRefresh,
          onLoadMore: _handleLoadMore,
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Row: Back, Title & + Add Category Button ───────────
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
                        'Categories',
                        style: TextStyle(
                          color: _C.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),

                  // + Add Category Button
                  InkWell(
                    onTap: () => _openAddCategoryModal(),
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
                            'Add Category',
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
                    hintText: 'Search categories...',
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
              const SizedBox(height: 14),

              // ── 📊 Top 2 KPI Summary Cards ─────────────────────────────────
              Row(
                children: [
                  // Total Categories Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _C.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _C.divider),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Categories',
                                style: TextStyle(color: _C.muted, fontSize: 11.5),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${CategoryRepository.totalCategories}',
                                style: const TextStyle(
                                  color: _C.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _C.accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.layers_outlined,
                              color: _C.accent,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Total Products Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _C.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _C.divider),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Products',
                                style: TextStyle(color: _C.muted, fontSize: 11.5),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${CategoryRepository.totalProducts}',
                                style: const TextStyle(
                                  color: _C.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.all_inbox_outlined,
                              color: Colors.blue,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── Filter Segment Tabs: All / Active / Inactive ───────────────
              Row(
                children: [
                  _buildFilterTab('All'),
                  const SizedBox(width: 8),
                  _buildFilterTab('Active'),
                  const SizedBox(width: 8),
                  _buildFilterTab('Inactive'),
                ],
              ),
              const SizedBox(height: 14),
            ],
          ),
          emptyWidget: _buildEmptyState(),
          itemBuilder: (context, category, index) => _buildCategoryCard(category),
        ),
      ),
    );
  }

  Widget _buildFilterTab(String label) {
    final isSelected = _selectedFilter == label;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = label;
          _currentPage = 1;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? _C.card : _C.inputFill,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? _C.accent : _C.divider,
            width: isSelected ? 1.2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? _C.accent : _C.muted,
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(CategoryModel category) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailPage(category: category),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.divider),
        ),
        child: Row(
        children: [
          // Category 3D Visual Avatar (Realistic Part Visuals)
          CategoryVisualAvatar(category: category, size: 48),
          const SizedBox(width: 12),

          // Name & Products Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
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
                  'Products: ${category.productsCount}',
                  style: const TextStyle(
                    color: _C.muted,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),

          // Status Badge (Active / Inactive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: category.isActive
                  ? const Color(0xFF132B1E)
                  : const Color(0xFF2C1F15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: category.isActive
                    ? _C.green.withValues(alpha: 0.3)
                    : _C.amber.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              category.status,
              style: TextStyle(
                color: category.isActive ? _C.green : _C.amber,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 6),

          // 3-Dots Menu Action
          InkWell(
            onTap: () => _openCategoryOptions(category),
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
          Icon(Icons.grid_view_rounded, size: 48, color: _C.muted),
          SizedBox(height: 12),
          Text(
            'No Categories Found',
            style: TextStyle(
              color: _C.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Add your first automotive category.',
            style: TextStyle(color: _C.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
