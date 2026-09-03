import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/core/widgets/paginated_list.dart';
import 'package:maa_tara/features/categories/category_model.dart';
import 'package:maa_tara/features/inventory/add_product.dart';
import 'package:maa_tara/features/inventory/inventory_models.dart';
import 'package:maa_tara/features/inventory/products/product_detail.dart';
import 'package:maa_tara/features/suppliers/supplier_detail.dart';
import 'package:maa_tara/features/suppliers/supplier_model.dart';

typedef _C = AppColors;

// ─────────────────────────────────────────────────────────────────────────────
//  MAA TARA AUTOMOBILES — Category Parts Detail & Catalog Page
// ─────────────────────────────────────────────────────────────────────────────
class CategoryDetailPage extends StatefulWidget {
  final CategoryModel category;

  const CategoryDetailPage({super.key, required this.category});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  String _searchQuery = '';
  String _selectedSubCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Pagination state
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  static const int _pageSize = 3;

  // Sub-categories mapped per automotive category
  List<String> get _subCategories {
    switch (widget.category.iconKey.toLowerCase()) {
      case 'engine':
        return [
          'All',
          'Spark Plugs',
          'Pistons & Rings',
          'Timing Belts',
          'Gaskets & Seals',
          'Valves & Lifters',
          'Fuel Injectors',
          'Sensors',
        ];
      case 'brake':
        return [
          'All',
          'Brake Pads',
          'Disc Rotors',
          'Brake Shoes',
          'Brake Calipers',
          'Brake Fluid',
          'Master Cylinder',
        ];
      case 'suspension':
        return [
          'All',
          'Shock Absorbers',
          'Strut Assembly',
          'Control Arms',
          'Bushings & Mounts',
          'Coil Springs',
          'Tie Rod Ends',
        ];
      case 'electrical':
        return [
          'All',
          'Batteries',
          'Alternators',
          'Starter Motors',
          'Wiring & Fuses',
          'Horns & Relays',
          'Headlamp Bulbs',
        ];
      default:
        return [
          'All',
          'Fast Moving',
          'OEM Genuine',
          'Aftermarket',
          'Universal',
        ];
    }
  }

  // Dynamic parts catalog combining live inventory with category defaults
  List<InventoryItemModel> get _categoryItems {
    // 1. Live items added dynamically to Inventory for this category
    final dynamicItems = InventoryRepository.items.where((i) {
      return i.category.toLowerCase() == widget.category.name.toLowerCase() ||
          widget.category.name.toLowerCase().contains(i.category.toLowerCase());
    }).toList();

    // 2. Pre-seeded parts catalog for category demonstration
    List<InventoryItemModel> seedItems = [];
    final key = widget.category.iconKey.toLowerCase();
    if (key == 'engine') {
      seedItems = [
        const InventoryItemModel(
          id: 'ENG-001',
          branchId: 'BR-01',
          name: 'Bosch Double Iridium Spark Plug Set (Pack of 4)',
          description:
              'High performance spark plug with 360 laser welded iridium',
          category: 'Engine Parts',
          brand: 'Bosch',
          partNumber: '0242236571',
          hsnCode: '8511',
          quantity: 24,
          minQuantity: 6,
          purchasePrice: 1200.0,
          sellingPrice: 1650.0,
          discountPercent: 5.0,
          gstRate: 18.0,
          isTaxInclusive: true,
          preGstAmount: 1398.3,
          gstAmount: 251.7,
          postGstAmount: 1650.0,
          unit: 'Set',
          secondaryUnit: 'Box',
          conversionFactor: 10,
          rackLocation: 'Rack E-01, Bin 4',
          supplier: 'Bosch Automotive',
          supplierGstNumber: '29AAACB1876D1ZX',
          lastUpdated: '10 mins ago',
        ),
        const InventoryItemModel(
          id: 'ENG-002',
          branchId: 'BR-01',
          name: 'ContiTech High-Torque Timing Belt (112 Teeth)',
          description:
              'HNBR synthetic rubber reinforced with fiberglass tensile cords',
          category: 'Engine Parts',
          brand: 'Continental',
          partNumber: 'CT-112T-904',
          hsnCode: '4010',
          quantity: 12,
          minQuantity: 3,
          purchasePrice: 850.0,
          sellingPrice: 1250.0,
          discountPercent: 0.0,
          gstRate: 18.0,
          isTaxInclusive: true,
          preGstAmount: 1059.3,
          gstAmount: 190.7,
          postGstAmount: 1250.0,
          unit: 'Pcs',
          secondaryUnit: 'Box',
          conversionFactor: 5,
          rackLocation: 'Rack E-02, Shelf 1',
          supplier: 'Maa Tara Wholesale Parts',
          supplierGstNumber: '20AAAAA0000A1Z5',
          lastUpdated: '1 hr ago',
        ),
        const InventoryItemModel(
          id: 'ENG-003',
          branchId: 'BR-01',
          name: 'Mahle Engine Cylinder Piston & Ring Kit (Standard Size)',
          description:
              'Precision engineered alloy piston with low friction coating',
          category: 'Engine Parts',
          brand: 'Mahle Original',
          partNumber: 'MHL-PST-78MM',
          hsnCode: '8409',
          quantity: 6,
          minQuantity: 2,
          purchasePrice: 3800.0,
          sellingPrice: 4950.0,
          discountPercent: 4.0,
          gstRate: 28.0,
          isTaxInclusive: false,
          preGstAmount: 4752.0,
          gstAmount: 1330.5,
          postGstAmount: 6082.5,
          unit: 'Set',
          secondaryUnit: 'Box',
          conversionFactor: 1,
          rackLocation: 'Rack E-03, Bin 2',
          supplier: 'OEM Genuine Parts Dealer',
          supplierGstNumber: '06AAACM4589K1Z1',
          lastUpdated: 'Yesterday',
        ),
        const InventoryItemModel(
          id: 'ENG-004',
          branchId: 'BR-01',
          name: 'Elring Cylinder Head Gasket (Multi-Layer Steel MLS)',
          description:
              'High temperature multi-layer steel cylinder head gasket',
          category: 'Engine Parts',
          brand: 'Elring',
          partNumber: 'ELR-MLS-4412',
          hsnCode: '8484',
          quantity: 8,
          minQuantity: 2,
          purchasePrice: 1450.0,
          sellingPrice: 1950.0,
          discountPercent: 0.0,
          gstRate: 18.0,
          isTaxInclusive: true,
          preGstAmount: 1652.5,
          gstAmount: 297.5,
          postGstAmount: 1950.0,
          unit: 'Pcs',
          secondaryUnit: 'Pack',
          conversionFactor: 10,
          rackLocation: 'Rack E-04, Shelf 3',
          supplier: 'Authorized Auto Distributor',
          supplierGstNumber: '27AAAAA1234A1Z5',
          lastUpdated: '3 days ago',
        ),
        const InventoryItemModel(
          id: 'ENG-005',
          branchId: 'BR-01',
          name: 'Delphi Common Rail CRDi Fuel Injector Nozzle',
          description: 'Micro-precision high pressure diesel injector nozzle',
          category: 'Engine Parts',
          brand: 'Delphi TVS',
          partNumber: 'DLP-INJ-2823',
          hsnCode: '8409',
          quantity: 4,
          minQuantity: 2,
          purchasePrice: 4200.0,
          sellingPrice: 5600.0,
          discountPercent: 5.0,
          gstRate: 28.0,
          isTaxInclusive: false,
          preGstAmount: 5320.0,
          gstAmount: 1489.6,
          postGstAmount: 6809.6,
          unit: 'Pcs',
          secondaryUnit: 'Box',
          conversionFactor: 4,
          rackLocation: 'Rack E-05, Vault 1',
          supplier: 'Bosch Automotive',
          supplierGstNumber: '29AAACB1876D1ZX',
          lastUpdated: 'Just now',
        ),
      ];
    } else {
      seedItems = [
        InventoryItemModel(
          id: 'PRD-${widget.category.id}-01',
          branchId: 'BR-01',
          name: '${widget.category.name} Premium OEM Component A',
          description: 'Heavy duty direct replacement part',
          category: widget.category.name,
          brand: 'OEM Genuine',
          partNumber:
              'OEM-${widget.category.name.substring(0, widget.category.name.length >= 3 ? 3 : widget.category.name.length).toUpperCase()}-101',
          hsnCode: '8708',
          quantity: 18,
          minQuantity: 4,
          purchasePrice: 950.0,
          sellingPrice: 1400.0,
          gstRate: 18.0,
          unit: 'Pcs',
          rackLocation: 'Rack A-01, Bin 2',
          supplier: 'Authorized Auto Distributor',
          lastUpdated: 'Today',
        ),
        InventoryItemModel(
          id: 'PRD-${widget.category.id}-02',
          branchId: 'BR-01',
          name: '${widget.category.name} High Durability Part B',
          description: 'Standard replacement part for all models',
          category: widget.category.name,
          brand: 'Bosch',
          partNumber:
              'BSH-${widget.category.name.substring(0, widget.category.name.length >= 3 ? 3 : widget.category.name.length).toUpperCase()}-202',
          hsnCode: '8708',
          quantity: 10,
          minQuantity: 3,
          purchasePrice: 1650.0,
          sellingPrice: 2250.0,
          gstRate: 18.0,
          unit: 'Set',
          rackLocation: 'Rack A-02, Bin 1',
          supplier: 'Bosch Automotive',
          lastUpdated: 'Yesterday',
        ),
      ];
    }

    final dynamicIds = dynamicItems.map((e) => e.id).toSet();
    final dynamicNames = dynamicItems.map((e) => e.name.toLowerCase()).toSet();

    return [
      ...dynamicItems,
      ...seedItems.where((s) => !dynamicIds.contains(s.id) && !dynamicNames.contains(s.name.toLowerCase())),
    ];
  }

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

  List<InventoryItemModel> get _allFilteredItems {
    var list = _categoryItems;

    // Sub-category filter
    if (_selectedSubCategory != 'All') {
      final sub = _selectedSubCategory.toLowerCase();
      list = list.where((item) {
        return item.name.toLowerCase().contains(sub) ||
            item.description.toLowerCase().contains(sub);
      }).toList();
    }

    // Search query filter
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((item) {
        return item.name.toLowerCase().contains(q) ||
            item.partNumber.toLowerCase().contains(q) ||
            item.brand.toLowerCase().contains(q) ||
            item.rackLocation.toLowerCase().contains(q);
      }).toList();
    }

    return list;
  }

  List<InventoryItemModel> get _paginatedItems {
    final all = _allFilteredItems;
    final end = (_currentPage * _pageSize).clamp(0, all.length);
    return all.sublist(0, end);
  }

  bool get _hasMore => _paginatedItems.length < _allFilteredItems.length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductPage(
          initialCategory: widget.category.name,
        ),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final allItems = _allFilteredItems;
    final paginatedItems = _paginatedItems;
    final totalUnits = allItems.fold(0, (sum, i) => sum + i.quantity);
    final totalValuation = allItems.fold(
      0.0,
      (sum, i) => sum + i.totalValuation,
    );

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
          widget.category.name,
          style: const TextStyle(
            color: _C.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: _C.accent),
            tooltip: 'Add Part to this Category',
            onPressed: _openAddProduct,
          ),
        ],
      ),
      body: SafeArea(
        child: PaginatedListView<InventoryItemModel>(
          items: paginatedItems,
          isInitialLoading: _isLoading,
          isLoadingMore: _isLoadingMore,
          hasMore: _hasMore,
          onRefresh: _handleRefresh,
          onLoadMore: _handleLoadMore,
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 🏎️ CATEGORY HERO CARD ─────────────────────────────────────────
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
                child: Row(
                  children: [
                    CategoryVisualAvatar(category: widget.category, size: 60),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  widget.category.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: _C.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: widget.category.isActive
                                      ? _C.green.withValues(alpha: 0.15)
                                      : _C.amber.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  widget.category.status,
                                  style: TextStyle(
                                    color: widget.category.isActive
                                        ? _C.green
                                        : _C.amber,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.category.description,
                            maxLines: 2,
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
              ),
              const SizedBox(height: 14),

              // ── 📊 3 KPI SUMMARY METRICS ─────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _kpiMetricCard(
                      'Total Items',
                      '${allItems.length} SKUs',
                      Icons.layers_outlined,
                      _C.accent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _kpiMetricCard(
                      'Stock Qty',
                      '$totalUnits Units',
                      Icons.inventory_2_outlined,
                      _C.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _kpiMetricCard(
                      'Valuation',
                      '₹${(totalValuation / 1000).toStringAsFixed(1)}k',
                      Icons.payments_outlined,
                      _C.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── 🏢 REGISTERED SUPPLIERS FOR THIS CATEGORY ────────────────────
              Builder(
                builder: (context) {
                  final suppliers = SupplierRepository.getSuppliersForCategory(
                    widget.category.name,
                  );
                  if (suppliers.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SUPPLIERS FOR ${widget.category.name.toUpperCase()} (${suppliers.length})',
                        style: const TextStyle(
                          color: _C.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 64,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: suppliers.length,
                          separatorBuilder: (ctx, i) =>
                              const SizedBox(width: 10),
                          itemBuilder: (ctx, i) {
                            final s = suppliers[i];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SupplierDetailPage(supplier: s),
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
                                    SupplierBrandLogo(supplier: s, size: 36),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          s.companyName,
                                          style: const TextStyle(
                                            color: _C.white,
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              color: _C.accent,
                                              size: 12,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              s.rating,
                                              style: const TextStyle(
                                                color: _C.accent,
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '${s.productsCount} items',
                                              style: const TextStyle(
                                                color: _C.muted,
                                                fontSize: 10.5,
                                              ),
                                            ),
                                          ],
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
                      const SizedBox(height: 14),
                    ],
                  );
                },
              ),

              // ── 🔍 SEARCH BAR ────────────────────────────────────────────────
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
                    hintText:
                        'Search ${widget.category.name} (by SKU, Name, Brand)...',
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
                              setState(() {
                                _searchQuery = '';
                                _currentPage = 1;
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (val) => setState(() {
                    _searchQuery = val;
                    _currentPage = 1;
                  }),
                ),
              ),
              const SizedBox(height: 14),

              // ── 🏷️ SUB-CATEGORY CHIPS ────────────────────────────────────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _subCategories.map((sub) {
                    final isSelected = _selectedSubCategory == sub;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => setState(() {
                          _selectedSubCategory = sub;
                          _currentPage = 1;
                        }),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? _C.card : _C.inputFill,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? _C.accent : _C.divider,
                              width: isSelected ? 1.2 : 1,
                            ),
                          ),
                          child: Text(
                            sub,
                            style: TextStyle(
                              color: isSelected ? _C.accent : _C.muted,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // ── 📦 PARTS INVENTORY LIST HEADER ──────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PARTS & SPARES (${allItems.length})',
                    style: const TextStyle(
                      color: _C.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  InkWell(
                    onTap: _openAddProduct,
                    child: Row(
                      children: const [
                        Icon(Icons.add, color: _C.accent, size: 14),
                        SizedBox(width: 2),
                        Text(
                          'Add Part',
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
              const SizedBox(height: 10),
            ],
          ),
          emptyWidget: _buildEmptyPartsState(),
          itemBuilder: (context, item, index) => _buildPartItemCard(item),
        ),
      ),
    );
  }

  Widget _kpiMetricCard(
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
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartItemCard(InventoryItemModel item) {
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
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: item.quantity <= item.minQuantity
                ? _C.amber.withValues(alpha: 0.4)
                : _C.divider,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Part Name & Status Pill
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      const SizedBox(height: 4),
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: item.statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      color: item.statusColor,
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Row 2: Price, Stock & Shelf Rack Position Strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: _C.inputFill,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Buy (Pre-GST)',
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
                          'In Stock',
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
                          'Shelf / Bin',
                          style: TextStyle(color: _C.muted, fontSize: 9.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.rackLocation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _C.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPartsState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: const [
          Icon(Icons.inventory_2_outlined, size: 40, color: _C.muted),
          SizedBox(height: 10),
          Text(
            'No Parts Found',
            style: TextStyle(
              color: _C.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'No parts match your filter query in this category.',
            style: TextStyle(color: _C.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
