import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  MAA TARA AUTOMOBILES — Supplier Model & Global Repository
// ─────────────────────────────────────────────────────────────────────────────
class SupplierModel {
  final String id;
  final String name; // Contact Person Name
  final String companyName; // Business / Trade Name
  final String category; // Primary domain e.g. 'Brake Parts & Accessories'
  final List<String> categories; // Linked categories e.g. ['Brake System', 'Engine Parts']
  final String phone;
  final String email;
  final String gstNumber; // 15-digit GSTIN
  final String address;
  final int productsCount;
  final List<String> suppliedProducts;
  final String? logoUrl;
  final String rating;
  final String paymentTerms;
  final double totalSpend;
  final String lastOrderDate;

  const SupplierModel({
    required this.id,
    required this.name,
    required this.companyName,
    required this.category,
    this.categories = const [],
    required this.phone,
    required this.email,
    this.gstNumber = '',
    this.address = '',
    this.productsCount = 0,
    this.suppliedProducts = const [],
    this.logoUrl,
    this.rating = '4.8',
    this.paymentTerms = 'Net 30 Days',
    this.totalSpend = 45000.0,
    this.lastOrderDate = '2 days ago',
  });

  String get initials {
    final clean = companyName.trim();
    if (clean.isEmpty) return 'S';
    final parts = clean.split(' ');
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  SupplierModel copyWith({
    String? id,
    String? name,
    String? companyName,
    String? category,
    List<String>? categories,
    String? phone,
    String? email,
    String? gstNumber,
    String? address,
    int? productsCount,
    List<String>? suppliedProducts,
    String? logoUrl,
    String? rating,
    String? paymentTerms,
    double? totalSpend,
    String? lastOrderDate,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      name: name ?? this.name,
      companyName: companyName ?? this.companyName,
      category: category ?? this.category,
      categories: categories ?? this.categories,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gstNumber: gstNumber ?? this.gstNumber,
      address: address ?? this.address,
      productsCount: productsCount ?? this.productsCount,
      suppliedProducts: suppliedProducts ?? this.suppliedProducts,
      logoUrl: logoUrl ?? this.logoUrl,
      rating: rating ?? this.rating,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      totalSpend: totalSpend ?? this.totalSpend,
      lastOrderDate: lastOrderDate ?? this.lastOrderDate,
    );
  }
}

class SupplierRepository {
  static final List<SupplierModel> _suppliers = [
    const SupplierModel(
      id: 'SUP-001',
      name: 'Prakash Sharma',
      companyName: 'Brembo India Pvt. Ltd.',
      category: 'Brake Parts & Accessories',
      categories: ['Brake System'],
      phone: '9876543210',
      email: 'info@bremboindia.com',
      gstNumber: '27AAAAA1234A1Z5',
      address: 'Plot 45, MIDC Industrial Area, Pune, Maharashtra - 411018',
      productsCount: 120,
      logoUrl: 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=150&auto=format&fit=crop&q=80',
      rating: '4.9',
      paymentTerms: 'Credit (30 Days)',
      totalSpend: 185000.0,
      suppliedProducts: [
        'Ceramic Front Brake Pads',
        'Ventilated Disc Rotors',
        'Rear Brake Shoes',
        'Brake Fluid DOT 4',
        'Brake Master Cylinder Kit',
      ],
    ),
    const SupplierModel(
      id: 'SUP-002',
      name: 'Anil Deshmukh',
      companyName: 'Bosch Automotive',
      category: 'Engine & Electrical Parts',
      categories: ['Engine Parts', 'Brake System', 'Electrical', 'Filters & Belts'],
      phone: '9876501110',
      email: 'contact@boschauto.com',
      gstNumber: '29AAACB1876D1ZX',
      address: 'Hosur Road, Adugodi, Bengaluru, Karnataka - 560030',
      productsCount: 95,
      logoUrl: 'https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=150&auto=format&fit=crop&q=80',
      rating: '4.8',
      paymentTerms: 'Immediate / UPI',
      totalSpend: 240000.0,
      suppliedProducts: [
        'Iridium Spark Plugs',
        'High Output Alternator',
        'Common Rail Injectors',
        'ClearAdvantage Wiper Blades',
        'Horn & Relay Kits',
      ],
    ),
    const SupplierModel(
      id: 'SUP-003',
      name: 'Sunil Aggarwal',
      companyName: 'Motherson Sumi Systems',
      category: 'Body Parts & Electrical',
      categories: ['Body Parts', 'Electrical'],
      phone: '9876522220',
      email: 'sales@motherson.com',
      gstNumber: '07AAACM1234F1Z8',
      address: 'Sector 62, Noida, Uttar Pradesh - 201301',
      productsCount: 80,
      logoUrl: 'https://images.unsplash.com/photo-1563720223185-11003d516935?w=150&auto=format&fit=crop&q=80',
      rating: '4.7',
      paymentTerms: 'Credit (15 Days)',
      totalSpend: 135000.0,
      suppliedProducts: [
        'Rear View Mirror Assemblies',
        'LED Headlight Units',
        'Wiring Harness Loom 12V',
        'Front Bumper Grilles',
      ],
    ),
    const SupplierModel(
      id: 'SUP-004',
      name: 'Vikram Singhania',
      companyName: 'Shell Lubricants Official',
      category: 'Oils & Lubricants',
      categories: ['Oils & Fluids'],
      phone: '9876533330',
      email: 'orders@shell.in',
      gstNumber: '27AAACS1122D1ZP',
      address: 'Bandra Kurla Complex, Mumbai, Maharashtra - 400051',
      productsCount: 45,
      logoUrl: 'https://images.unsplash.com/photo-1545454675-3531b543be5d?w=150&auto=format&fit=crop&q=80',
      rating: '4.9',
      paymentTerms: 'Credit (45 Days)',
      totalSpend: 310000.0,
      suppliedProducts: [
        'Shell Helix Ultra 5W-40 Synthetic',
        'Shell Rimula R4 Heavy Duty',
        'Shell Spirax S2 Gear Oil',
        'Long-Life Radiator Coolant',
      ],
    ),
    const SupplierModel(
      id: 'SUP-005',
      name: 'Rajesh Gupta',
      companyName: 'Exide Industries Ltd.',
      category: 'Batteries & Power',
      categories: ['Electrical'],
      phone: '9876544440',
      email: 'dealers@exide.co.in',
      gstNumber: '19AAACE1001A1Z2',
      address: '59E Chowringhee Road, Kolkata, West Bengal - 700020',
      productsCount: 30,
      logoUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=150&auto=format&fit=crop&q=80',
      rating: '4.8',
      paymentTerms: 'Immediate / RTGS',
      totalSpend: 160000.0,
      suppliedProducts: [
        'Exide Matrix 35Ah Maintenance Free',
        'Exide Mileage 45Ah ISS Ready',
        'Exide Epiq 65Ah Heavy Duty',
        'Brass Battery Terminals & Clamps',
      ],
    ),
    const SupplierModel(
      id: 'SUP-006',
      name: 'Karan Mehra',
      companyName: 'Castrol India Official',
      category: 'Oils & Fluids',
      categories: ['Oils & Fluids'],
      phone: '9876555550',
      email: 'distribution@castrol.in',
      gstNumber: '27AAACC2211A1Z9',
      address: 'Technopolis Knowledge Park, Andheri East, Mumbai, MH - 400093',
      productsCount: 52,
      logoUrl: 'https://images.unsplash.com/photo-1486006920555-c77dce18193b?w=150&auto=format&fit=crop&q=80',
      rating: '4.9',
      paymentTerms: 'Credit (15 Days)',
      totalSpend: 290000.0,
      suppliedProducts: [
        'Castrol GTX 20W-50 Engine Oil',
        'Castrol Magnatec Stop-Start 5W-30',
        'Castrol EDGE Titanium Fully Synthetic',
        'Castrol Brake Fluid DOT 4',
      ],
    ),
  ];

  static List<SupplierModel> get suppliers => List.unmodifiable(_suppliers);

  static List<SupplierModel> getSuppliersForCategory(String categoryName) {
    final cat = categoryName.toLowerCase();
    return _suppliers.where((s) {
      return s.categories.any((c) => c.toLowerCase().contains(cat) || cat.contains(c.toLowerCase())) ||
             s.category.toLowerCase().contains(cat);
    }).toList();
  }

  static void addSupplier(SupplierModel s) {
    _suppliers.insert(0, s);
  }

  static void updateSupplier(SupplierModel s) {
    final idx = _suppliers.indexWhere((x) => x.id == s.id);
    if (idx != -1) {
      _suppliers[idx] = s;
    }
  }

  static void deleteSupplier(String id) {
    _suppliers.removeWhere((x) => x.id == id);
  }

  static void linkProductToSupplier(
    String supplierName,
    String productName,
    String categoryName,
  ) {
    if (supplierName.trim().isEmpty) return;
    final idx = _suppliers.indexWhere(
      (s) =>
          s.companyName.toLowerCase() == supplierName.toLowerCase() ||
          supplierName.toLowerCase().contains(s.companyName.toLowerCase()) ||
          s.companyName.toLowerCase().contains(supplierName.toLowerCase()),
    );
    if (idx != -1) {
      final s = _suppliers[idx];
      final updatedProducts = List<String>.from(s.suppliedProducts);
      if (productName.isNotEmpty && !updatedProducts.contains(productName)) {
        updatedProducts.add(productName);
      }
      final updatedCats = List<String>.from(s.categories);
      if (categoryName.isNotEmpty &&
          !updatedCats.any(
            (c) => c.toLowerCase() == categoryName.toLowerCase(),
          )) {
        updatedCats.add(categoryName);
      }
      _suppliers[idx] = s.copyWith(
        productsCount: s.productsCount + 1,
        suppliedProducts: updatedProducts,
        categories: updatedCats,
      );
    } else {
      // Auto-register supplier so relation is truly dynamic!
      final newSup = SupplierModel(
        id: 'SUP-${DateTime.now().millisecondsSinceEpoch % 10000}',
        name: supplierName.trim(),
        companyName: supplierName.trim(),
        category: categoryName.isNotEmpty ? categoryName : 'Automotive Parts',
        categories: categoryName.isNotEmpty ? [categoryName] : [],
        phone: '',
        email: '',
        productsCount: 1,
        suppliedProducts: productName.isNotEmpty ? [productName] : [],
      );
      _suppliers.insert(0, newSup);
    }
  }

  static void unlinkProductFromSupplier(
    String supplierName,
    String productName,
  ) {
    if (supplierName.trim().isEmpty) return;
    final idx = _suppliers.indexWhere(
      (s) =>
          s.companyName.toLowerCase() == supplierName.toLowerCase() ||
          supplierName.toLowerCase().contains(s.companyName.toLowerCase()),
    );
    if (idx != -1) {
      final s = _suppliers[idx];
      final updatedProducts = List<String>.from(s.suppliedProducts)
        ..removeWhere((p) => p.toLowerCase() == productName.toLowerCase());
      _suppliers[idx] = s.copyWith(
        productsCount: (s.productsCount - 1).clamp(0, 999999),
        suppliedProducts: updatedProducts,
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Supplier Brand Logo Widget (Matches Exact Screenshot Brand Logos)
// ─────────────────────────────────────────────────────────────────────────────
class SupplierBrandLogo extends StatelessWidget {
  final SupplierModel supplier;
  final double size;

  const SupplierBrandLogo({
    super.key,
    required this.supplier,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: _buildLogoContent(supplier.companyName.toLowerCase()),
        ),
      ),
    );
  }

  Widget _buildLogoContent(String name) {
    if (name.contains('brembo')) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size * 0.25,
            height: size * 0.25,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE51A24),
            ),
            alignment: Alignment.center,
            child: Container(
              width: size * 0.1,
              height: size * 0.1,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 2),
          Text(
            'brembo',
            style: TextStyle(
              color: const Color(0xFFE51A24),
              fontSize: size * 0.22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ],
      );
    } else if (name.contains('bosch')) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.trip_origin, color: const Color(0xFFE2001A), size: size * 0.28),
          const SizedBox(width: 2),
          Text(
            'BOSCH',
            style: TextStyle(
              color: const Color(0xFFE2001A),
              fontSize: size * 0.22,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
            ),
          ),
        ],
      );
    } else if (name.contains('motherson')) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(width: 3, height: size * 0.2, color: const Color(0xFFED1C24)),
          const SizedBox(width: 2),
          Container(width: 3, height: size * 0.28, color: const Color(0xFFED1C24)),
          const SizedBox(width: 2),
          Container(width: 3, height: size * 0.36, color: const Color(0xFFED1C24)),
          const SizedBox(width: 2),
          Container(width: 3, height: size * 0.44, color: const Color(0xFFED1C24)),
        ],
      );
    } else if (name.contains('shell')) {
      return Icon(Icons.wb_sunny_rounded, color: const Color(0xFFDD1D21), size: size * 0.65);
    } else if (name.contains('exide')) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFED1C24),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          'EXIDE',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.22,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      );
    } else if (name.contains('castrol')) {
      return Text(
        'Castrol',
        style: TextStyle(
          color: const Color(0xFF007A3D),
          fontSize: size * 0.24,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    // Default Fallback
    return Text(
      supplier.initials,
      style: TextStyle(
        color: Colors.black87,
        fontSize: size * 0.32,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
