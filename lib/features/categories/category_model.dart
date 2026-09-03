import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  MAA TARA AUTOMOBILES — Category Model & Global Repository
// ─────────────────────────────────────────────────────────────────────────────
class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String status; // 'Active' or 'Inactive'
  final int productsCount;
  final String iconKey; // 'engine', 'brake', 'suspension', 'electrical', 'body', 'oil', 'filters', 'tyres'
  final String iconUrl;
  final String createdAt;

  const CategoryModel({
    required this.id,
    required this.name,
    this.description = '',
    this.status = 'Active',
    this.productsCount = 0,
    required this.iconKey,
    this.iconUrl = '',
    this.createdAt = 'Just now',
  });

  bool get isActive => status.toLowerCase() == 'active';

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? status,
    int? productsCount,
    String? iconKey,
    String? iconUrl,
    String? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      productsCount: productsCount ?? this.productsCount,
      iconKey: iconKey ?? this.iconKey,
      iconUrl: iconUrl ?? this.iconUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CategoryRepository {
  static final List<CategoryModel> _categories = [
    const CategoryModel(
      id: 'CAT-001',
      name: 'Engine Parts',
      description: 'Pistons, Spark Plugs, Gaskets, Belts & Engine internals',
      status: 'Active',
      productsCount: 42,
      iconKey: 'engine',
      iconUrl: 'https://cdn-icons-png.flaticon.com/512/3202/3202926.png',
    ),
    const CategoryModel(
      id: 'CAT-002',
      name: 'Brake System',
      description: 'Disc pads, Rotors, Calipers, Drums, Shoes & Brake oil',
      status: 'Active',
      productsCount: 28,
      iconKey: 'brake',
      iconUrl: 'https://cdn-icons-png.flaticon.com/512/3089/3089803.png',
    ),
    const CategoryModel(
      id: 'CAT-003',
      name: 'Suspension',
      description: 'Shock absorbers, Struts, Control arms, Bushings & Springs',
      status: 'Active',
      productsCount: 18,
      iconKey: 'suspension',
      iconUrl: 'https://cdn-icons-png.flaticon.com/512/2061/2061986.png',
    ),
    const CategoryModel(
      id: 'CAT-004',
      name: 'Electrical',
      description: 'Batteries, Alternators, Starters, Relays, Horns & Bulbs',
      status: 'Active',
      productsCount: 24,
      iconKey: 'electrical',
      iconUrl: 'https://cdn-icons-png.flaticon.com/512/1505/1505494.png',
    ),
    const CategoryModel(
      id: 'CAT-005',
      name: 'Body Parts',
      description: 'Bumpers, Mirrors, Headlights, Tail lamps & Grilles',
      status: 'Inactive',
      productsCount: 20,
      iconKey: 'body',
      iconUrl: 'https://cdn-icons-png.flaticon.com/512/3202/3202940.png',
    ),
    const CategoryModel(
      id: 'CAT-006',
      name: 'Oils & Fluids',
      description: 'Engine oil, Gear oil, Coolant, Brake fluid & Greases',
      status: 'Active',
      productsCount: 15,
      iconKey: 'oil',
      iconUrl: 'https://cdn-icons-png.flaticon.com/512/3089/3089851.png',
    ),
    const CategoryModel(
      id: 'CAT-007',
      name: 'Filters & Belts',
      description: 'Oil filters, Air filters, AC cabin filters & Timing belts',
      status: 'Active',
      productsCount: 9,
      iconKey: 'filters',
      iconUrl: 'https://cdn-icons-png.flaticon.com/512/2061/2061962.png',
    ),
    const CategoryModel(
      id: 'CAT-008',
      name: 'Tyres & Wheels',
      description: 'Tubeless tyres, Alloy wheels, Rims & Valve caps',
      status: 'Active',
      productsCount: 32,
      iconKey: 'tyres',
      iconUrl: 'https://cdn-icons-png.flaticon.com/512/2061/2061980.png',
    ),
  ];

  static List<CategoryModel> get categories => List.unmodifiable(_categories);

  static int get totalCategories => _categories.length;
  static int get totalProducts =>
      _categories.fold(0, (sum, item) => sum + item.productsCount);

  static void addCategory(CategoryModel cat) {
    _categories.insert(0, cat);
  }

  static void updateCategory(CategoryModel cat) {
    final idx = _categories.indexWhere((c) => c.id == cat.id);
    if (idx != -1) {
      _categories[idx] = cat;
    }
  }

  static void deleteCategory(String id) {
    _categories.removeWhere((c) => c.id == id);
  }

  static void toggleStatus(String id) {
    final idx = _categories.indexWhere((c) => c.id == id);
    if (idx != -1) {
      final cur = _categories[idx];
      _categories[idx] = cur.copyWith(
        status: cur.isActive ? 'Inactive' : 'Active',
      );
    }
  }

  static void incrementProductCount(String categoryName) {
    if (categoryName.trim().isEmpty) return;
    final idx = _categories.indexWhere(
      (c) => c.name.toLowerCase() == categoryName.toLowerCase(),
    );
    if (idx != -1) {
      final cur = _categories[idx];
      _categories[idx] = cur.copyWith(productsCount: cur.productsCount + 1);
    } else {
      // Auto-register category if not present
      _categories.add(
        CategoryModel(
          id: 'CAT-${DateTime.now().millisecondsSinceEpoch % 10000}',
          name: categoryName.trim(),
          description: '$categoryName automotive parts',
          status: 'Active',
          productsCount: 1,
          iconKey: 'engine',
        ),
      );
    }
  }

  static void decrementProductCount(String categoryName) {
    if (categoryName.trim().isEmpty) return;
    final idx = _categories.indexWhere(
      (c) => c.name.toLowerCase() == categoryName.toLowerCase(),
    );
    if (idx != -1) {
      final cur = _categories[idx];
      _categories[idx] = cur.copyWith(
        productsCount: (cur.productsCount - 1).clamp(0, 999999),
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Automotive Category 3D Visual Avatar Widget (Screenshot-Accurate Parts)
// ─────────────────────────────────────────────────────────────────────────────
class CategoryVisualAvatar extends StatelessWidget {
  final CategoryModel category;
  final double size;

  const CategoryVisualAvatar({
    super.key,
    required this.category,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF131822),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E2738), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildPartVisual(category.iconKey.toLowerCase()),
    );
  }

  Widget _buildPartVisual(String key) {
    switch (key) {
      case 'engine':
        return _renderEngineVisual();
      case 'brake':
        return _renderBrakeVisual();
      case 'suspension':
        return _renderSuspensionVisual();
      case 'electrical':
        return _renderBatteryVisual();
      case 'body':
        return _renderBodyVisual();
      case 'oil':
        return _renderOilVisual();
      case 'filters':
        return _renderFilterVisual();
      case 'tyres':
        return _renderTyreVisual();
      default:
        return _renderEngineVisual();
    }
  }

  // 1. Engine Parts Visual (Metallic Engine Block with Piston Header)
  Widget _renderEngineVisual() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [Color(0xFF2E384D), Color(0xFF131822)],
          center: Alignment(0, -0.2),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.precision_manufacturing, color: Colors.grey.shade400, size: size * 0.58),
          Positioned(
            bottom: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: const Color(0xFFEAB308).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                'V6 ENGINE',
                style: TextStyle(
                  color: const Color(0xFFEAB308),
                  fontSize: size * 0.15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Brake System Visual (Ventilated Rotor with Red Sport Caliper)
  Widget _renderBrakeVisual() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [Color(0xFF2C3240), Color(0xFF131822)],
          center: Alignment(0, 0),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rotor Disc
          Container(
            width: size * 0.72,
            height: size * 0.72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 2.2),
              color: Colors.grey.shade800,
            ),
            child: Icon(Icons.album_outlined, color: Colors.grey.shade400, size: size * 0.45),
          ),
          // Red Caliper on the edge
          Positioned(
            top: size * 0.1,
            right: size * 0.1,
            child: Container(
              width: size * 0.32,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 0.8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.4),
                    blurRadius: 4,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                'BRE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Suspension Visual (Gold/Yellow Heavy Duty Coilover Shock Absorber)
  Widget _renderSuspensionVisual() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E2430), Color(0xFF10141C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.waves_rounded, color: const Color(0xFFEAB308), size: size * 0.65),
          Positioned(
            top: 5,
            child: Container(
              width: size * 0.22,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            child: Container(
              width: size * 0.22,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 4. Electrical Visual (Heavy-Duty Battery with Gold/Red Terminals)
  Widget _renderBatteryVisual() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [Color(0xFF263044), Color(0xFF121620)],
          center: Alignment(0, -0.1),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.battery_charging_full_rounded, color: const Color(0xFF38BDF8), size: size * 0.62),
          Positioned(
            top: 5,
            left: size * 0.22,
            child: Container(
              width: 5,
              height: 4,
              decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
            ),
          ),
          Positioned(
            top: 5,
            right: size * 0.22,
            child: Container(
              width: 5,
              height: 4,
              decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }

  // 5. Body Parts Visual (Aerodynamic Car Chassis / Panel)
  Widget _renderBodyVisual() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [Color(0xFF2A3448), Color(0xFF131822)],
          center: Alignment(0, 0),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.directions_car_filled_rounded,
          color: Colors.grey.shade300,
          size: size * 0.65,
        ),
      ),
    );
  }

  // 6. Oils & Fluids Visual (Synthetic Fluid Droplet & Golden Bottle)
  Widget _renderOilVisual() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [Color(0xFF382C17), Color(0xFF131822)],
          center: Alignment(0, 0),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.opacity_rounded,
          color: const Color(0xFFEAB308),
          size: size * 0.65,
        ),
      ),
    );
  }

  // 7. Filters Visual (Air/Oil Cylindrical Filter)
  Widget _renderFilterVisual() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [Color(0xFF283446), Color(0xFF131822)],
          center: Alignment(0, 0),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.filter_alt_outlined,
          color: const Color(0xFF38BDF8),
          size: size * 0.62,
        ),
      ),
    );
  }

  // 8. Tyres Visual (Sport Alloy Rim & Rubber Tread)
  Widget _renderTyreVisual() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [Color(0xFF262D3B), Color(0xFF131822)],
          center: Alignment(0, 0),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.donut_large_rounded,
          color: Colors.grey.shade300,
          size: size * 0.65,
        ),
      ),
    );
  }
}
