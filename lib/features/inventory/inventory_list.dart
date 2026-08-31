import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';

typedef _C = AppColors;

// ─────────────────────────────────────────────────────────────────────────────
//  Branch Model & Repository (Max 2 Allowed Architecture)
// ─────────────────────────────────────────────────────────────────────────────
class BranchModel {
  final String id;
  final String name;
  final String code; // e.g. BR-01, BR-02
  final String location;
  final String address;
  final String managerName;
  final String phone;
  final bool isMainBranch;
  final DateTime createdAt;

  BranchModel({
    required this.id,
    required this.name,
    required this.code,
    required this.location,
    required this.address,
    required this.managerName,
    required this.phone,
    this.isMainBranch = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class BranchRepository {
  // 🔒 Client Plan Limit: Only 2 branches allowed currently
  static const int maxAllowedBranches = 2;

  static final List<BranchModel> _branches = [
    BranchModel(
      id: 'BR_01',
      name: 'Main Workshop',
      code: 'BR-01',
      location: 'Kankarbagh, Patna',
      address: 'Plot 42, Main Bypass Road, Kankarbagh, Patna - 800020',
      managerName: 'Vikash Kumar (Admin)',
      phone: '+91 98765 43210',
      isMainBranch: true,
    ),
    BranchModel(
      id: 'BR_02',
      name: 'Express Service Branch',
      code: 'BR-02',
      location: 'Boring Road, Patna',
      address: 'Shop 12, Commercial Complex, Boring Road, Patna - 800001',
      managerName: 'Rohit Kumar (Manager)',
      phone: '+91 98765 11223',
      isMainBranch: false,
    ),
  ];

  static List<BranchModel> get branches => List.unmodifiable(_branches);

  static int get totalBranches => _branches.length;
  static bool get canAddMoreBranches => _branches.length < maxAllowedBranches;
  static int get remainingSlots => maxAllowedBranches - _branches.length;

  static bool addBranch(BranchModel branch) {
    if (!canAddMoreBranches) return false;
    _branches.add(branch);
    return true;
  }

  static void deleteBranch(String id) {
    _branches.removeWhere((b) => b.id == id && !b.isMainBranch);
  }

  static BranchModel? getBranchById(String id) {
    try {
      return _branches.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Inventory Item Model & Repository
// ─────────────────────────────────────────────────────────────────────────────
enum StockStatus { inStock, lowStock, outOfStock }

class InventoryItemModel {
  final String id;
  final String partNumber;
  final String name;
  final String category;
  final String unit; // 'Litre', 'Piece', 'Set', 'Bottle', 'Kg'
  final double costPrice;
  final double sellingPrice;
  final int minAlertThreshold;
  final String imageUrl;

  // Branch-Wise Stock Allocation
  int shop1Quantity; // Main Workshop (BR-01)
  int shop2Quantity; // Express Branch (BR-02)

  InventoryItemModel({
    required this.id,
    required this.partNumber,
    required this.name,
    required this.category,
    required this.unit,
    required this.costPrice,
    required this.sellingPrice,
    required this.minAlertThreshold,
    required this.imageUrl,
    this.shop1Quantity = 0,
    this.shop2Quantity = 0,
  });

  // Total Quantity across all active branches
  int get totalQuantity => shop1Quantity + shop2Quantity;

  // Get quantity for specific branch filter
  int getQuantityForBranch(String? branchId) {
    if (branchId == 'BR_01') return shop1Quantity;
    if (branchId == 'BR_02') return shop2Quantity;
    return totalQuantity;
  }

  StockStatus getStockStatus(String? branchId) {
    final qty = getQuantityForBranch(branchId);
    if (qty <= 0) return StockStatus.outOfStock;
    if (qty <= minAlertThreshold) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  double getTotalValuation(String? branchId) {
    return getQuantityForBranch(branchId) * sellingPrice;
  }
}

// Inter-Branch Stock Transfer Log
class StockTransferLog {
  final String id;
  final String itemId;
  final String itemName;
  final String fromBranchId;
  final String fromBranchName;
  final String toBranchId;
  final String toBranchName;
  final int quantity;
  final String unit;
  final String transferReason;
  final DateTime timestamp;

  StockTransferLog({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.fromBranchId,
    required this.fromBranchName,
    required this.toBranchId,
    required this.toBranchName,
    required this.quantity,
    required this.unit,
    required this.transferReason,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class InventoryRepository {
  static final List<InventoryItemModel> _items = [
    InventoryItemModel(
      id: 'INV_001',
      partNumber: 'LUB-ENG-5W30',
      name: 'Castrol MAGNATEC 5W-30 Full Synthetic Engine Oil',
      category: 'Lubricants & Oils',
      unit: 'Litre',
      costPrice: 1250.0,
      sellingPrice: 1650.0,
      minAlertThreshold: 10,
      shop1Quantity: 28,
      shop2Quantity: 8,
      imageUrl: 'https://images.unsplash.com/photo-1596742578443-7682ef5251cd?w=200&auto=format&fit=crop&q=80',
    ),
    InventoryItemModel(
      id: 'INV_002',
      partNumber: 'BRK-FRT-SWFT',
      name: 'Brembo Premium Front Ceramic Brake Pads (Swift/Dzire)',
      category: 'Brakes & Suspension',
      unit: 'Set',
      costPrice: 1400.0,
      sellingPrice: 2200.0,
      minAlertThreshold: 5,
      shop1Quantity: 14,
      shop2Quantity: 3,
      imageUrl: 'https://images.unsplash.com/photo-1600705722908-bab1e61c0b4d?w=200&auto=format&fit=crop&q=80',
    ),
    InventoryItemModel(
      id: 'INV_003',
      partNumber: 'FLT-OIL-HYN',
      name: 'Bosch Spin-on Engine Oil Filter (Hyundai Creta/i20)',
      category: 'Filters & Belts',
      unit: 'Piece',
      costPrice: 220.0,
      sellingPrice: 450.0,
      minAlertThreshold: 8,
      shop1Quantity: 35,
      shop2Quantity: 6,
      imageUrl: 'https://images.unsplash.com/photo-1486006920555-c77dce18193b?w=200&auto=format&fit=crop&q=80',
    ),
    InventoryItemModel(
      id: 'INV_004',
      partNumber: 'BAT-EXD-45AH',
      name: 'Exide Mileage Red 45Ah Maintenance-Free Car Battery',
      category: 'Batteries & Electrical',
      unit: 'Piece',
      costPrice: 4200.0,
      sellingPrice: 5800.0,
      minAlertThreshold: 4,
      shop1Quantity: 7,
      shop2Quantity: 1, // Low stock in Shop 2
      imageUrl: 'https://images.unsplash.com/photo-1588854337236-6889d631faa8?w=200&auto=format&fit=crop&q=80',
    ),
    InventoryItemModel(
      id: 'INV_005',
      partNumber: 'SPK-IRID-NGK',
      name: 'NGK Laser Iridium Spark Plugs Set of 4',
      category: 'Engine Parts',
      unit: 'Set',
      costPrice: 1800.0,
      sellingPrice: 2800.0,
      minAlertThreshold: 6,
      shop1Quantity: 12,
      shop2Quantity: 0, // Out of stock in Shop 2
      imageUrl: 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=200&auto=format&fit=crop&q=80',
    ),
    InventoryItemModel(
      id: 'INV_006',
      partNumber: 'CLT-RED-MOTL',
      name: 'Motul Inugel Long Life Radiator Coolant Red 5L',
      category: 'Lubricants & Oils',
      unit: 'Bottle',
      costPrice: 750.0,
      sellingPrice: 1150.0,
      minAlertThreshold: 8,
      shop1Quantity: 18,
      shop2Quantity: 9,
      imageUrl: 'https://images.unsplash.com/photo-1563720223185-11003d516935?w=200&auto=format&fit=crop&q=80',
    ),
    InventoryItemModel(
      id: 'INV_007',
      partNumber: 'WPR-BLD-BOS24',
      name: 'Bosch Clear Advantage Frameless Wiper Blade 24"',
      category: 'Body & Accessories',
      unit: 'Piece',
      costPrice: 380.0,
      sellingPrice: 650.0,
      minAlertThreshold: 10,
      shop1Quantity: 22,
      shop2Quantity: 4,
      imageUrl: 'https://images.unsplash.com/photo-1617814076367-b759c7d7e738?w=200&auto=format&fit=crop&q=80',
    ),
    InventoryItemModel(
      id: 'INV_008',
      partNumber: 'FLT-CAB-MAH',
      name: 'Mahle PM 2.5 Activated Carbon Cabin AC Filter',
      category: 'Filters & Belts',
      unit: 'Piece',
      costPrice: 420.0,
      sellingPrice: 850.0,
      minAlertThreshold: 5,
      shop1Quantity: 2, // Low stock in Shop 1
      shop2Quantity: 5,
      imageUrl: 'https://images.unsplash.com/photo-1517524008697-84bbe3c3fd98?w=200&auto=format&fit=crop&q=80',
    ),
  ];

  static final List<StockTransferLog> _transferLogs = [];

  static List<InventoryItemModel> get items => List.unmodifiable(_items);
  static List<StockTransferLog> get transferLogs =>
      List.unmodifiable(_transferLogs);

  static void addItem(InventoryItemModel item) {
    _items.insert(0, item);
  }

  static void updateItem(InventoryItemModel updated) {
    final index = _items.indexWhere((i) => i.id == updated.id);
    if (index != -1) {
      _items[index] = updated;
    }
  }

  static void deleteItem(String id) {
    _items.removeWhere((i) => i.id == id);
  }

  // Inter-Branch Transfer Logic
  static bool transferStock({
    required String itemId,
    required String fromBranchId,
    required String toBranchId,
    required int quantity,
    required String reason,
  }) {
    final index = _items.indexWhere((i) => i.id == itemId);
    if (index == -1 || quantity <= 0) return false;

    final item = _items[index];

    // Check availability in source branch
    if (fromBranchId == 'BR_01') {
      if (item.shop1Quantity < quantity) return false;
      item.shop1Quantity -= quantity;
      item.shop2Quantity += quantity;
    } else if (fromBranchId == 'BR_02') {
      if (item.shop2Quantity < quantity) return false;
      item.shop2Quantity -= quantity;
      item.shop1Quantity += quantity;
    }

    final fromBranch = BranchRepository.getBranchById(fromBranchId);
    final toBranch = BranchRepository.getBranchById(toBranchId);

    _transferLogs.insert(
      0,
      StockTransferLog(
        id: 'TRF_${DateTime.now().millisecondsSinceEpoch}',
        itemId: item.id,
        itemName: item.name,
        fromBranchId: fromBranchId,
        fromBranchName: fromBranch?.name ?? fromBranchId,
        toBranchId: toBranchId,
        toBranchName: toBranch?.name ?? toBranchId,
        quantity: quantity,
        unit: item.unit,
        transferReason: reason,
      ),
    );

    return true;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Inventory List Screen
// ─────────────────────────────────────────────────────────────────────────────
class InventoryListPage extends StatefulWidget {
  const InventoryListPage({super.key});

  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  String? _selectedBranchId; // null = All Branches Combined, 'BR_01', 'BR_02'
  String _selectedCategory = 'All';
  String _selectedStatusFilter = 'All'; // 'All', 'Low Stock', 'Out of Stock'
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Lubricants & Oils',
    'Brakes & Suspension',
    'Filters & Belts',
    'Batteries & Electrical',
    'Engine Parts',
    'Body & Accessories',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<InventoryItemModel> get _filteredItems {
    return InventoryRepository.items.where((item) {
      // Category filter
      if (_selectedCategory != 'All' && item.category != _selectedCategory) {
        return false;
      }

      // Status filter
      final status = item.getStockStatus(_selectedBranchId);
      if (_selectedStatusFilter == 'Low Stock' &&
          status != StockStatus.lowStock) {
        return false;
      }
      if (_selectedStatusFilter == 'Out of Stock' &&
          status != StockStatus.outOfStock) {
        return false;
      }
      if (_selectedStatusFilter == 'In Stock' &&
          status != StockStatus.inStock) {
        return false;
      }

      // Search Query
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchName = item.name.toLowerCase().contains(q);
        final matchPart = item.partNumber.toLowerCase().contains(q);
        final matchCat = item.category.toLowerCase().contains(q);
        if (!matchName && !matchPart && !matchCat) return false;
      }

      return true;
    }).toList();
  }

  // Summary Metrics calculations
  double get _totalStockValuation {
    double total = 0;
    for (var item in InventoryRepository.items) {
      total += item.getTotalValuation(_selectedBranchId);
    }
    return total;
  }

  int get _totalSkuCount => InventoryRepository.items.length;

  int get _lowStockCount {
    return InventoryRepository.items
        .where(
          (i) => i.getStockStatus(_selectedBranchId) == StockStatus.lowStock,
        )
        .length;
  }

  int get _outOfStockCount {
    return InventoryRepository.items
        .where(
          (i) => i.getStockStatus(_selectedBranchId) == StockStatus.outOfStock,
        )
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final branches = BranchRepository.branches;
    final items = _filteredItems;

    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Header with Multi-Branch Badge ─────────────────────────
              _buildHeader(),
              const SizedBox(height: 14),

              // ── 2. Multi-Branch Switcher Tabs + Add Branch ─────────────────
              _buildBranchSwitcher(branches),
              const SizedBox(height: 16),

              // ── 3. Inventory Overview Cards ───────────────────────────────
              _buildMetricsRow(),
              const SizedBox(height: 14),

              // ── 4. Quick Action Buttons Row ───────────────────────────────
              _buildQuickActionsRow(),
              const SizedBox(height: 16),

              // ── 5. Search & Filter Bar ────────────────────────────────────
              _buildSearchBar(),
              const SizedBox(height: 12),

              // ── 6. Category Filter Chips ──────────────────────────────────
              _buildCategoryChips(),
              const SizedBox(height: 12),

              // ── 7. Stock Status Tabs ──────────────────────────────────────
              _buildStatusTabs(),
              const SizedBox(height: 16),

              // ── 8. Products List Header ───────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'INVENTORY ITEMS (${items.length})',
                    style: const TextStyle(
                      color: _C.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    _selectedBranchId == null
                        ? 'Combined Total Stock'
                        : BranchRepository.getBranchById(_selectedBranchId!)
                                  ?.name ??
                              'Selected Branch',
                    style: const TextStyle(
                      color: _C.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ── 9. Products List ──────────────────────────────────────────
              if (items.isEmpty)
                _buildEmptyState()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildProductCard(items[index]);
                  },
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ── 1. Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    final activeBranches = BranchRepository.totalBranches;
    final maxBranches = BranchRepository.maxAllowedBranches;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Inventory & Stock',
                  style: TextStyle(
                    color: _C.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _C.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _C.accent.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '$activeBranches/$maxBranches Branches',
                    style: const TextStyle(
                      color: _C.accent,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            const Text(
              'Multi-Branch Workshop Inventory Hub',
              style: TextStyle(color: _C.muted, fontSize: 11.5),
            ),
          ],
        ),

        // Add Branch Button
        InkWell(
          onTap: () => _handleBranchCreationFlow(),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: BranchRepository.canAddMoreBranches
                  ? _C.accent.withValues(alpha: 0.2)
                  : _C.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: BranchRepository.canAddMoreBranches
                    ? _C.accent
                    : _C.divider,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  BranchRepository.canAddMoreBranches
                      ? Icons.add_business_outlined
                      : Icons.lock_outline,
                  size: 15,
                  color: BranchRepository.canAddMoreBranches
                      ? _C.accent
                      : _C.muted,
                ),
                const SizedBox(width: 5),
                Text(
                  BranchRepository.canAddMoreBranches
                      ? '+ Branch'
                      : 'Limit (2/2)',
                  style: TextStyle(
                    color: BranchRepository.canAddMoreBranches
                        ? _C.accent
                        : _C.muted,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── 2. Multi-Branch Switcher Bar ───────────────────────────────────────────
  Widget _buildBranchSwitcher(List<BranchModel> branches) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // All Branches Chip
          _branchFilterChip(
            title: '🌟 All Branches (${branches.length})',
            subtitle: 'Consolidated Stock',
            isSelected: _selectedBranchId == null,
            onTap: () => setState(() => _selectedBranchId = null),
          ),
          const SizedBox(width: 8),

          // Individual Branches
          ...branches.map((b) {
            final isSelected = _selectedBranchId == b.id;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _branchFilterChip(
                title: b.name,
                subtitle: b.location,
                isMain: b.isMainBranch,
                isSelected: isSelected,
                onTap: () => setState(() => _selectedBranchId = b.id),
              ),
            );
          }),

          // + Add / Locked Branch Chip
          InkWell(
            onTap: () => _handleBranchCreationFlow(),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _C.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: BranchRepository.canAddMoreBranches
                      ? _C.accent.withValues(alpha: 0.5)
                      : _C.divider,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    BranchRepository.canAddMoreBranches
                        ? Icons.add_circle_outline
                        : Icons.lock,
                    size: 14,
                    color: BranchRepository.canAddMoreBranches
                        ? _C.accent
                        : _C.amber,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    BranchRepository.canAddMoreBranches
                        ? 'Add Branch 2'
                        : 'Branch 3 (Locked)',
                    style: TextStyle(
                      color: BranchRepository.canAddMoreBranches
                          ? _C.accent
                          : _C.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _branchFilterChip({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    bool isMain = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _C.accent.withValues(alpha: 0.15) : _C.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? _C.accent : _C.divider,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? _C.white : _C.muted,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
                if (isMain) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: _C.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'HQ',
                      style: TextStyle(
                        color: _C.green,
                        fontSize: 8.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: isSelected
                    ? _C.accent.withValues(alpha: 0.9)
                    : _C.navMuted,
                fontSize: 9.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 3. Metrics Row ─────────────────────────────────────────────────────────
  Widget _buildMetricsRow() {
    return Row(
      children: [
        // Total Stock Value
        Expanded(
          flex: 4,
          child: _metricCard(
            title: 'TOTAL VALUE',
            value:
                '₹ ${_totalStockValuation.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
            icon: Icons.account_balance_wallet_outlined,
            iconColor: _C.accent,
            accentColor: _C.accent,
          ),
        ),
        const SizedBox(width: 6),

        // Total SKUs
        Expanded(
          flex: 3,
          child: _metricCard(
            title: 'SKUs',
            value: '$_totalSkuCount Items',
            icon: Icons.inventory_2_outlined,
            iconColor: _C.blue,
            accentColor: _C.blue,
          ),
        ),
        const SizedBox(width: 6),

        // Low Stock
        Expanded(
          flex: 3,
          child: _metricCard(
            title: 'LOW STOCK',
            value: '$_lowStockCount Alert',
            icon: Icons.warning_amber_rounded,
            iconColor: _C.amber,
            accentColor: _lowStockCount > 0 ? _C.amber : _C.green,
            isWarning: _lowStockCount > 0,
          ),
        ),
        const SizedBox(width: 6),

        // Out of Stock
        Expanded(
          flex: 3,
          child: _metricCard(
            title: 'OUT OF STOCK',
            value: '$_outOfStockCount Empty',
            icon: Icons.highlight_off_rounded,
            iconColor: _C.red,
            accentColor: _outOfStockCount > 0 ? _C.red : _C.muted,
            isWarning: _outOfStockCount > 0,
          ),
        ),
      ],
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color accentColor,
    bool isWarning = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isWarning ? _C.amber.withValues(alpha: 0.5) : _C.divider,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _C.muted,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(icon, color: iconColor, size: 14),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: _C.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ── 4. Quick Actions Row ───────────────────────────────────────────────────
  Widget _buildQuickActionsRow() {
    return Row(
      children: [
        // Add Product Button
        Expanded(
          child: _quickActionButton(
            icon: Icons.add_circle,
            label: 'Add Product',
            color: _C.accent,
            onTap: () => _showAddProductModal(),
          ),
        ),
        const SizedBox(width: 8),

        // Inter-Branch Transfer Button
        Expanded(
          child: _quickActionButton(
            icon: Icons.swap_horiz_rounded,
            label: 'Branch Transfer',
            color: _C.blue,
            onTap: () => _showStockTransferModal(),
          ),
        ),
        const SizedBox(width: 8),

        // Manage Branches Button
        Expanded(
          child: _quickActionButton(
            icon: Icons.storefront_outlined,
            label: 'Branches (${BranchRepository.totalBranches}/2)',
            color: _C.green,
            onTap: () => _showManageBranchesModal(),
          ),
        ),
      ],
    );
  }

  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 5. Search Bar ──────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: _C.inputFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _C.divider, width: 1),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: _C.white, fontSize: 13),
        onChanged: (val) => setState(() => _searchQuery = val.trim()),
        decoration: InputDecoration(
          hintText: 'Search by part name, SKU, or category...',
          hintStyle: const TextStyle(color: _C.muted, fontSize: 12),
          prefixIcon: const Icon(Icons.search, color: _C.muted, size: 18),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: _C.muted, size: 16),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  // ── 6. Category Filter Chips ───────────────────────────────────────────────
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat;

          return InkWell(
            onTap: () => setState(() => _selectedCategory = cat),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? _C.accent.withValues(alpha: 0.15) : _C.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? _C.accent : _C.divider,
                  width: 1,
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isSelected ? _C.accent : _C.muted,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── 7. Stock Status Tabs ───────────────────────────────────────────────────
  Widget _buildStatusTabs() {
    const tabs = ['All', 'In Stock', 'Low Stock', 'Out of Stock'];

    return Row(
      children: tabs.map((t) {
        final isSelected = _selectedStatusFilter == t;
        Color activeColor = _C.accent;
        if (t == 'Low Stock') activeColor = _C.amber;
        if (t == 'Out of Stock') activeColor = _C.red;
        if (t == 'In Stock') activeColor = _C.green;

        return Expanded(
          child: InkWell(
            onTap: () => setState(() => _selectedStatusFilter = t),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? activeColor : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  t,
                  style: TextStyle(
                    color: isSelected ? activeColor : _C.muted,
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── 8. Product Card ────────────────────────────────────────────────────────
  Widget _buildProductCard(InventoryItemModel item) {
    final status = item.getStockStatus(_selectedBranchId);
    final displayedQty = item.getQuantityForBranch(_selectedBranchId);

    Color statusColor = _C.green;
    String statusLabel = 'In Stock';
    if (status == StockStatus.lowStock) {
      statusColor = _C.amber;
      statusLabel = 'Low Stock';
    } else if (status == StockStatus.outOfStock) {
      statusColor = _C.red;
      statusLabel = 'Out of Stock';
    }

    final branches = BranchRepository.branches;

    return Container(
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.divider, width: 1),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Image, Details & Status Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 52,
                  height: 52,
                  color: _C.inputFill,
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.inventory_2,
                      color: _C.muted,
                      size: 26,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Title, Part No & Category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        color: _C.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: _C.inputFill,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.partNumber,
                            style: const TextStyle(
                              color: _C.accent,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.category,
                            style: const TextStyle(
                              color: _C.muted,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Status Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(color: _C.divider, height: 1),
          const SizedBox(height: 10),

          // ── Multi-Branch Stock Breakdown Box ──────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: _C.inputFill,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Branch 1 (Main Workshop)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🏬 Shop 1 (Main)',
                        style: TextStyle(color: _C.muted, fontSize: 10),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '${item.shop1Quantity} ${item.unit}',
                        style: TextStyle(
                          color: item.shop1Quantity <= item.minAlertThreshold
                              ? (item.shop1Quantity == 0 ? _C.red : _C.amber)
                              : _C.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 26, color: _C.divider),
                const SizedBox(width: 10),

                // Branch 2 (Express Branch) - if active
                if (branches.length >= 2) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🏪 Shop 2 (Boring Rd)',
                          style: TextStyle(color: _C.muted, fontSize: 10),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          '${item.shop2Quantity} ${item.unit}',
                          style: TextStyle(
                            color: item.shop2Quantity <= item.minAlertThreshold
                                ? (item.shop2Quantity == 0 ? _C.red : _C.amber)
                                : _C.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 26, color: _C.divider),
                  const SizedBox(width: 10),
                ],

                // Total Stock & Price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        '📊 Total Stock',
                        style: TextStyle(color: _C.muted, fontSize: 10),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '$displayedQty ${item.unit}',
                        style: const TextStyle(
                          color: _C.accent,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Price & Actions Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹ ${item.sellingPrice.toStringAsFixed(0)} / ${item.unit}',
                    style: const TextStyle(
                      color: _C.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Cost: ₹${item.costPrice.toStringAsFixed(0)}',
                    style: const TextStyle(color: _C.muted, fontSize: 10),
                  ),
                ],
              ),

              // Action Buttons
              Row(
                children: [
                  // Quick Adjust Button
                  _smallCardAction(
                    icon: Icons.edit_note,
                    label: 'Adjust',
                    onTap: () => _showStockAdjustModal(item),
                  ),
                  const SizedBox(width: 6),

                  // Quick Transfer Button
                  _smallCardAction(
                    icon: Icons.sync_alt,
                    label: 'Transfer',
                    onTap: () => _showStockTransferModal(preselectedItem: item),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallCardAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: _C.divider,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: _C.accent),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: _C.white,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 9. Empty State ──────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.divider),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: _C.muted.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 12),
          const Text(
            'No Inventory Items Found',
            style: TextStyle(
              color: _C.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try changing the branch or category filter',
            style: TextStyle(color: _C.muted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  //  MODALS & DIALOGS
  // ───────────────────────────────────────────────────────────────────────────

  // 🏢 1. Branch Creation & Limit Lock Flow
  void _handleBranchCreationFlow() {
    if (BranchRepository.canAddMoreBranches) {
      _showAddBranchModal();
    } else {
      _showBranchLimitLockedDialog();
    }
  }

  // 🔒 2. Locked Plan Dialog (When 2/2 branches already created)
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
              // Glowing Lock Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _C.amber.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _C.amber.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.lock_rounded,
                  color: _C.amber,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Branch Limit Reached (2/2)',
                style: TextStyle(
                  color: _C.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              const Text(
                'Aapke current workshop plan mein sirf 2 branches allowed hain.\n\nBranch 3, 4 ya 5 add karne ke liye plan upgrade karein ya Administrator se contact karein.',
                style: TextStyle(color: _C.muted, fontSize: 12, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Feature Badges
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _C.inputFill,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _C.divider),
                ),
                child: Column(
                  children: [
                    _lockFeatureRow('✅ Branch 1: Main Workshop (Active)'),
                    const SizedBox(height: 4),
                    _lockFeatureRow('✅ Branch 2: Express Branch (Active)'),
                    const SizedBox(height: 4),
                    _lockFeatureRow(
                      '🔒 Multi-Branch Enterprise (Upgrade Required)',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _C.divider),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: _C.muted),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _C.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Upgrade request sent to Administrator!',
                            ),
                            backgroundColor: _C.green,
                          ),
                        );
                      },
                      child: const Text(
                        'Upgrade Plan',
                        style: TextStyle(
                          color: _C.darkText,
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

  Widget _lockFeatureRow(String text) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            color: _C.white,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // 🏬 3. Add New Branch Modal (If Slot Available)
  void _showAddBranchModal() {
    final nameCtrl = TextEditingController();
    final locCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final managerCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _C.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Create Branch 2 (Max 2 Limit)',
                  style: TextStyle(
                    color: _C.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: _C.muted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _inputField(
              controller: nameCtrl,
              label: 'Branch Name (e.g. Express Outlet)',
            ),
            const SizedBox(height: 10),
            _inputField(
              controller: locCtrl,
              label: 'Location / City Area (e.g. Boring Road, Patna)',
            ),
            const SizedBox(height: 10),
            _inputField(controller: addressCtrl, label: 'Full Address'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _inputField(
                    controller: managerCtrl,
                    label: 'Branch Manager',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _inputField(
                    controller: phoneCtrl,
                    label: 'Contact Phone',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty) return;

                  final newBranch = BranchModel(
                    id: 'BR_02',
                    name: nameCtrl.text.trim(),
                    code: 'BR-02',
                    location: locCtrl.text.trim(),
                    address: addressCtrl.text.trim(),
                    managerName: managerCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                  );

                  BranchRepository.addBranch(newBranch);
                  setState(() {});
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Branch "${newBranch.name}" created successfully!',
                      ),
                      backgroundColor: _C.green,
                    ),
                  );
                },
                child: const Text(
                  'Create Branch',
                  style: TextStyle(
                    color: _C.darkText,
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

  // 🏢 4. Manage Branches Modal
  void _showManageBranchesModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final branches = BranchRepository.branches;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Active Workshop Branches',
                    style: TextStyle(
                      color: _C.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _C.accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${branches.length}/2 Active',
                      style: const TextStyle(
                        color: _C.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              ...branches.map(
                (b) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _C.inputFill,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: b.isMainBranch
                          ? _C.accent.withValues(alpha: 0.5)
                          : _C.divider,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: b.isMainBranch
                              ? _C.accent.withValues(alpha: 0.2)
                              : _C.blue.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          b.isMainBranch
                              ? Icons.business
                              : Icons.store_outlined,
                          color: b.isMainBranch ? _C.accent : _C.blue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  b.name,
                                  style: const TextStyle(
                                    color: _C.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (b.isMainBranch) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _C.green.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'HQ / Main',
                                      style: TextStyle(
                                        color: _C.green,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${b.location} • Mgr: ${b.managerName}',
                              style: const TextStyle(
                                color: _C.muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: BranchRepository.canAddMoreBranches
                          ? _C.accent
                          : _C.amber,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: Icon(
                    BranchRepository.canAddMoreBranches
                        ? Icons.add
                        : Icons.lock,
                    color: BranchRepository.canAddMoreBranches
                        ? _C.accent
                        : _C.amber,
                    size: 16,
                  ),
                  label: Text(
                    BranchRepository.canAddMoreBranches
                        ? 'Add Branch 2'
                        : 'Unlock Branch 3+ (Upgrade Plan)',
                    style: TextStyle(
                      color: BranchRepository.canAddMoreBranches
                          ? _C.accent
                          : _C.amber,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _handleBranchCreationFlow();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 🔄 5. Inter-Branch Stock Transfer Modal
  void _showStockTransferModal({InventoryItemModel? preselectedItem}) {
    InventoryItemModel? selectedItem =
        preselectedItem ?? InventoryRepository.items.first;
    String fromBranch = 'BR_01';
    String toBranch = 'BR_02';
    final qtyCtrl = TextEditingController(text: '1');
    final reasonCtrl = TextEditingController(text: 'Branch Stock Balancing');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _C.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final maxQty = fromBranch == 'BR_01'
              ? (selectedItem?.shop1Quantity ?? 0)
              : (selectedItem?.shop2Quantity ?? 0);

          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '🔄 Inter-Branch Stock Transfer',
                      style: TextStyle(
                        color: _C.white,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: _C.muted),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Select Item Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: _C.inputFill,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _C.divider),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<InventoryItemModel>(
                      isExpanded: true,
                      dropdownColor: _C.card,
                      value: selectedItem,
                      items: InventoryRepository.items.map((i) {
                        return DropdownMenuItem(
                          value: i,
                          child: Text(
                            '${i.name} (${i.totalQuantity} ${i.unit})',
                            style: const TextStyle(
                              color: _C.white,
                              fontSize: 12.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setModalState(() => selectedItem = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // From Branch -> To Branch Selector
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _C.inputFill,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _C.divider),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'FROM',
                              style: TextStyle(color: _C.muted, fontSize: 10),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              fromBranch == 'BR_01'
                                  ? 'Shop 1 (Main)'
                                  : 'Shop 2 (Express)',
                              style: const TextStyle(
                                color: _C.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Available: $maxQty ${selectedItem?.unit}',
                              style: const TextStyle(
                                color: _C.accent,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.swap_horiz, color: _C.accent),
                      onPressed: () {
                        setModalState(() {
                          final tmp = fromBranch;
                          fromBranch = toBranch;
                          toBranch = tmp;
                        });
                      },
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _C.inputFill,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _C.divider),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TO',
                              style: TextStyle(color: _C.muted, fontSize: 10),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              toBranch == 'BR_01'
                                  ? 'Shop 1 (Main)'
                                  : 'Shop 2 (Express)',
                              style: const TextStyle(
                                color: _C.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const Text(
                              'Receiving Branch',
                              style: TextStyle(color: _C.green, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Transfer Quantity
                _inputField(
                  controller: qtyCtrl,
                  label:
                      'Transfer Quantity (Max $maxQty ${selectedItem?.unit})',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),

                // Reason
                _inputField(
                  controller: reasonCtrl,
                  label: 'Reason / Challan Note',
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      final q = int.tryParse(qtyCtrl.text.trim()) ?? 0;
                      if (q <= 0 || q > maxQty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Invalid quantity! Enter between 1 and $maxQty.',
                            ),
                            backgroundColor: _C.red,
                          ),
                        );
                        return;
                      }

                      final ok = InventoryRepository.transferStock(
                        itemId: selectedItem!.id,
                        fromBranchId: fromBranch,
                        toBranchId: toBranch,
                        quantity: q,
                        reason: reasonCtrl.text.trim(),
                      );

                      if (ok) {
                        setState(() {});
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Transferred $q ${selectedItem?.unit} of "${selectedItem?.name}" successfully!',
                            ),
                            backgroundColor: _C.green,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Confirm Stock Transfer',
                      style: TextStyle(
                        color: _C.white,
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

  // ➕ 6. Add Product Modal
  void _showAddProductModal() {
    final nameCtrl = TextEditingController();
    final partCtrl = TextEditingController();
    final unitCtrl = TextEditingController(text: 'Piece');
    final costCtrl = TextEditingController();
    final sellCtrl = TextEditingController();
    final shop1QtyCtrl = TextEditingController(text: '10');
    final shop2QtyCtrl = TextEditingController(text: '5');
    final alertCtrl = TextEditingController(text: '5');
    String category = _categories[1];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _C.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '➕ Add New Inventory Product',
                      style: TextStyle(
                        color: _C.white,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: _C.muted),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                _inputField(
                  controller: nameCtrl,
                  label: 'Product Name (e.g. Shell Helix 5W-40)',
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _inputField(
                        controller: partCtrl,
                        label: 'SKU / Part Number',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _inputField(
                        controller: unitCtrl,
                        label: 'Unit (Litre, Piece, Set)',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _inputField(
                        controller: costCtrl,
                        label: 'Cost Price (₹)',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _inputField(
                        controller: sellCtrl,
                        label: 'Selling Price (₹)',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Initial Branch Allocation Row
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _C.inputFill,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _C.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🏬 Multi-Branch Initial Stock Allocation',
                        style: TextStyle(
                          color: _C.accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _inputField(
                              controller: shop1QtyCtrl,
                              label: 'Shop 1 (Main) Qty',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _inputField(
                              controller: shop2QtyCtrl,
                              label: 'Shop 2 (Express) Qty',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                _inputField(
                  controller: alertCtrl,
                  label: 'Min Stock Low Alert Threshold (e.g. 5)',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (nameCtrl.text.trim().isEmpty) return;

                      final newItem = InventoryItemModel(
                        id: 'INV_${DateTime.now().millisecondsSinceEpoch}',
                        name: nameCtrl.text.trim(),
                        partNumber: partCtrl.text.trim().isEmpty
                            ? 'AUTO-${DateTime.now().millisecond}'
                            : partCtrl.text.trim(),
                        category: category,
                        unit: unitCtrl.text.trim().isEmpty
                            ? 'Piece'
                            : unitCtrl.text.trim(),
                        costPrice: double.tryParse(costCtrl.text.trim()) ?? 0,
                        sellingPrice:
                            double.tryParse(sellCtrl.text.trim()) ?? 0,
                        shop1Quantity:
                            int.tryParse(shop1QtyCtrl.text.trim()) ?? 0,
                        shop2Quantity:
                            int.tryParse(shop2QtyCtrl.text.trim()) ?? 0,
                        minAlertThreshold:
                            int.tryParse(alertCtrl.text.trim()) ?? 5,
                        imageUrl: 'https://images.unsplash.com/photo-1596742578443-7682ef5251cd?w=200&auto=format&fit=crop&q=80',
                      );

                      InventoryRepository.addItem(newItem);
                      setState(() {});
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Product "${newItem.name}" added to both branches!',
                          ),
                          backgroundColor: _C.green,
                        ),
                      );
                    },
                    child: const Text(
                      'Save Product',
                      style: TextStyle(
                        color: _C.darkText,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✏️ 7. Quick Adjust Stock Modal
  void _showStockAdjustModal(InventoryItemModel item) {
    int s1 = item.shop1Quantity;
    int s2 = item.shop2Quantity;

    showModalBottomSheet(
      context: context,
      backgroundColor: _C.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Adjust Stock: ${item.name}',
                style: const TextStyle(
                  color: _C.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 14),

              // Shop 1 Stepper
              _stepperRow(
                branchName: '🏬 Shop 1 (Main Workshop)',
                qty: s1,
                unit: item.unit,
                onMinus: () => setModalState(() {
                  if (s1 > 0) s1--;
                }),
                onPlus: () => setModalState(() => s1++),
              ),
              const SizedBox(height: 10),

              // Shop 2 Stepper
              _stepperRow(
                branchName: '🏪 Shop 2 (Express Branch)',
                qty: s2,
                unit: item.unit,
                onMinus: () => setModalState(() {
                  if (s2 > 0) s2--;
                }),
                onPlus: () => setModalState(() => s2++),
              ),
              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    item.shop1Quantity = s1;
                    item.shop2Quantity = s2;
                    setState(() {});
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Stock levels updated successfully!'),
                        backgroundColor: _C.green,
                      ),
                    );
                  },
                  child: const Text(
                    'Save Adjustments',
                    style: TextStyle(
                      color: _C.darkText,
                      fontWeight: FontWeight.w800,
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

  Widget _stepperRow({
    required String branchName,
    required int qty,
    required String unit,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _C.inputFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _C.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                branchName,
                style: const TextStyle(
                  color: _C.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$qty $unit in stock',
                style: const TextStyle(color: _C.muted, fontSize: 10.5),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: _C.red),
                onPressed: onMinus,
              ),
              Text(
                '$qty',
                style: const TextStyle(
                  color: _C.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: _C.green),
                onPressed: onPlus,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 📝 Helper Input Field
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: _C.white, fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _C.muted, fontSize: 11.5),
        filled: true,
        fillColor: _C.inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _C.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _C.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _C.accent),
        ),
      ),
    );
  }
}
