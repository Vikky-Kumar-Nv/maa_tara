import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/core/utils/image_compressor.dart';
import 'package:maa_tara/features/categories/add_category.dart';
import 'package:maa_tara/features/categories/category_model.dart';
import 'package:maa_tara/features/inventory/inventory_models.dart';
import 'package:maa_tara/features/suppliers/add_supplier.dart';
import 'package:maa_tara/features/suppliers/supplier_model.dart';

typedef _C = AppColors;

// ─────────────────────────────────────────────────────────────────────────────
//  MAA TARA AUTOMOBILES — Complete Automotive ERP & GST Add Product Page
// ─────────────────────────────────────────────────────────────────────────────
class AddProductPage extends StatefulWidget {
  final String? initialBranchId;
  final InventoryItemModel? initialItem; // Pass if editing
  final String? initialCategory;
  final SupplierModel? initialSupplier;

  const AddProductPage({
    super.key,
    this.initialBranchId,
    this.initialItem,
    this.initialCategory,
    this.initialSupplier,
  });

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late String _selectedBranchId;
  late TextEditingController _nameController;
  late TextEditingController _partNumberController;
  late TextEditingController _hsnController;
  late TextEditingController _descriptionController;
  late TextEditingController _rackController;

  // Pricing & Tax Controllers
  late TextEditingController _purchasePriceController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _discountController;

  // Inventory & Stock Controllers
  late TextEditingController _openingStockController;
  late TextEditingController _minStockController;
  late TextEditingController _conversionFactorController;

  // Supplier Controllers
  late TextEditingController _supplierNameController;
  late TextEditingController _supplierGstController;
  late TextEditingController _supplierPhoneController;

  // Dropdown States
  String _selectedCategory = 'Engine Parts';
  String _selectedBrand = 'Bosch';
  String _selectedBaseUnit = 'Pcs';
  String? _selectedSecondaryUnit = 'Box';
  double _selectedGstRate = 18.0;
  bool _isTaxInclusive =
      false; // False = Price + GST (Exclusive), True = MRP (Inclusive)
  bool _isSubmitting = false;

  // Image & Auto-Compression State (~5 KB)
  File? _productImageFile;
  String _productImagePath = '';
  String? _compressionInfo;
  bool _isCompressingImage = false;

  final List<String> _brands = [
    'Bosch',
    'Castrol',
    'Mobil 1',
    'Motul',
    'Brembo',
    'Shell',
    'Exide',
    'Amaron',
    'Tata Genuine Parts',
    'Maruti Suzuki Genuine (MGP)',
    'Hyundai Mobis',
    'Mahindra Genuine',
    'Lucas TVS',
    'Minda',
    'Valeo',
    'OEM / Generic',
  ];

  final List<String> _baseUnits = [
    'Pcs',
    'Nos',
    'Ltr',
    'Bottle',
    'Can',
    'Meter',
    'Kg',
  ];
  final List<String> _secondaryUnits = [
    'Box',
    'Pair',
    'Bundle',
    'Set',
    'Pack',
    'Drum',
    'Carton',
  ];
  final List<double> _gstSlabs = [0.0, 5.0, 8.0, 12.0, 18.0, 28.0];

  List<double> get _gstSlabOptions {
    if (_gstSlabs.contains(_selectedGstRate)) return _gstSlabs;
    final list = [..._gstSlabs, _selectedGstRate]..sort();
    return list;
  }

  List<String> get _categoryOptions {
    final list = CategoryRepository.categories.map((c) => c.name).toList();
    if (_selectedCategory.isNotEmpty && !list.contains(_selectedCategory)) {
      list.add(_selectedCategory);
    }
    return list.isNotEmpty
        ? list
        : [
            'Engine Parts',
            'Brake System',
            'Suspension',
            'Electrical',
            'Body Parts',
            'Oils & Fluids',
            'Filters & Belts',
            'Tyres & Wheels',
          ];
  }

  List<String> get _brandOptions {
    final set = <String>{..._brands};
    for (final s in SupplierRepository.suppliers) {
      final name = s.companyName.split(' ').first;
      if (name.isNotEmpty) set.add(name);
    }
    if (_selectedBrand.isNotEmpty) {
      set.add(_selectedBrand);
    }
    return set.toList();
  }

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    final sup = widget.initialSupplier;

    _selectedBranchId =
        widget.initialBranchId ??
        item?.branchId ??
        (InventoryRepository.branches.isNotEmpty
            ? InventoryRepository.branches.first.id
            : 'BR-01');

    _nameController = TextEditingController(text: item?.name ?? '');
    _partNumberController = TextEditingController(
      text:
          item?.partNumber ??
          'MT-PART-${DateTime.now().millisecondsSinceEpoch % 10000}',
    );
    _hsnController = TextEditingController(text: item?.hsnCode ?? '8708');
    _descriptionController = TextEditingController(
      text: item?.description ?? '',
    );
    _rackController = TextEditingController(
      text: item?.rackLocation ?? 'Rack A-01, Bin 1',
    );

    _purchasePriceController = TextEditingController(
      text: item != null ? item.purchasePrice.toStringAsFixed(0) : '500',
    );
    _sellingPriceController = TextEditingController(
      text: item != null ? item.sellingPrice.toStringAsFixed(0) : '750',
    );
    _discountController = TextEditingController(
      text: item != null ? item.discountPercent.toStringAsFixed(1) : '0.0',
    );

    _openingStockController = TextEditingController(
      text: item != null ? '${item.quantity}' : '10',
    );
    _minStockController = TextEditingController(
      text: item != null ? '${item.minQuantity}' : '3',
    );
    _conversionFactorController = TextEditingController(
      text: item != null ? '${item.conversionFactor}' : '10',
    );

    _supplierNameController = TextEditingController(
      text:
          sup?.companyName ?? (item?.supplier ?? 'Authorized Auto Distributor'),
    );
    _supplierGstController = TextEditingController(
      text: sup?.gstNumber ?? (item?.supplierGstNumber ?? '20AAAAA0000A1Z5'),
    );
    _supplierPhoneController = TextEditingController(
      text: sup?.phone ?? (item?.supplierPhone ?? '9876543210'),
    );

    _selectedCategory =
        widget.initialCategory ??
        (sup != null && sup.categories.isNotEmpty
            ? sup.categories.first
            : null) ??
        item?.category ??
        (CategoryRepository.categories.isNotEmpty
            ? CategoryRepository.categories.first.name
            : 'Engine Parts');
    _selectedBrand = item?.brand ?? 'Bosch';
    _selectedBaseUnit = item?.unit ?? 'Pcs';
    _selectedSecondaryUnit = item?.secondaryUnit ?? 'Box';
    _selectedGstRate = item?.gstRate ?? 18.0;
    _isTaxInclusive = item?.isTaxInclusive ?? false;

    if (item != null && item.imagePath.isNotEmpty) {
      _productImagePath = item.imagePath;
      final f = File(item.imagePath);
      if (f.existsSync()) {
        _productImageFile = f;
        _compressionInfo = ImageCompressor.formatBytes(f.lengthSync());
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _partNumberController.dispose();
    _hsnController.dispose();
    _descriptionController.dispose();
    _rackController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _discountController.dispose();
    _openingStockController.dispose();
    _minStockController.dispose();
    _conversionFactorController.dispose();
    _supplierNameController.dispose();
    _supplierGstController.dispose();
    _supplierPhoneController.dispose();
    super.dispose();
  }

  // ── Dynamic Live GST Calculations ──────────────────────────────────────────
  double get _baseSellingPrice =>
      double.tryParse(_sellingPriceController.text.trim()) ?? 0.0;
  double get _basePurchasePrice =>
      double.tryParse(_purchasePriceController.text.trim()) ?? 0.0;
  double get _discountPercent =>
      double.tryParse(_discountController.text.trim()) ?? 0.0;

  /// Discounted Base Selling Price (Pre-GST)
  double get _preGstSellingAmount {
    final raw = _baseSellingPrice;
    final discounted = raw - (raw * (_discountPercent / 100.0));
    if (_isTaxInclusive) {
      // Reverse calculate base price from inclusive MRP: Base = MRP / (1 + GST%)
      return discounted / (1.0 + (_selectedGstRate / 100.0));
    }
    return discounted;
  }

  /// GST Tax Amount per unit
  double get _gstSellingAmount {
    return _preGstSellingAmount * (_selectedGstRate / 100.0);
  }

  /// Final Selling Price with Tax (Post-GST)
  double get _postGstSellingAmount {
    if (_isTaxInclusive) {
      final raw = _baseSellingPrice;
      return raw - (raw * (_discountPercent / 100.0));
    }
    return _preGstSellingAmount + _gstSellingAmount;
  }

  /// Estimated Profit Margin per unit
  double get _estimatedProfit => _postGstSellingAmount - _basePurchasePrice;

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final isEdit = widget.initialItem != null;
    final itemId =
        widget.initialItem?.id ??
        'PRD-${DateTime.now().millisecondsSinceEpoch % 10000}';

    final newItem = InventoryItemModel(
      id: itemId,
      branchId: _selectedBranchId,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      brand: _selectedBrand,
      partNumber: _partNumberController.text.trim().toUpperCase(),
      hsnCode: _hsnController.text.trim(),
      quantity: int.tryParse(_openingStockController.text.trim()) ?? 0,
      minQuantity: int.tryParse(_minStockController.text.trim()) ?? 1,
      purchasePrice: _basePurchasePrice,
      sellingPrice: _baseSellingPrice,
      discountPercent: _discountPercent,
      gstRate: _selectedGstRate,
      isTaxInclusive: _isTaxInclusive,
      preGstAmount: _preGstSellingAmount,
      gstAmount: _gstSellingAmount,
      postGstAmount: _postGstSellingAmount,
      unit: _selectedBaseUnit,
      secondaryUnit: _selectedSecondaryUnit,
      conversionFactor:
          int.tryParse(_conversionFactorController.text.trim()) ?? 1,
      rackLocation: _rackController.text.trim(),
      supplier: _supplierNameController.text.trim(),
      supplierGstNumber: _supplierGstController.text.trim().toUpperCase(),
      supplierPhone: _supplierPhoneController.text.trim(),
      imagePath: _productImagePath,
      lastUpdated: 'Just now',
    );

    if (isEdit) {
      InventoryRepository.updateItem(newItem);
    } else {
      InventoryRepository.addItem(newItem);
      CategoryRepository.incrementProductCount(_selectedCategory);
      SupplierRepository.linkProductToSupplier(
        _supplierNameController.text.trim(),
        _nameController.text.trim(),
        _selectedCategory,
      );
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    Navigator.pop(context, newItem);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialItem != null;
    final branches = InventoryRepository.branches;

    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.card,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: _C.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? 'Edit Product & GST' : 'Add Product & GST Details',
          style: const TextStyle(
            color: _C.white,
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 🏢 SECTION 1: Storage & Workshop Branch ────────────────
              _buildSectionHeader(
                icon: Icons.storefront_outlined,
                title: 'Workshop Branch & Location',
              ),
              const SizedBox(height: 10),

              if (branches.length > 1) ...[
                _buildLabel('Assign to Workshop Shop / Branch'),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: _boxDecoration(),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: branches.any((b) => b.id == _selectedBranchId)
                          ? _selectedBranchId
                          : (branches.isNotEmpty ? branches.first.id : null),
                      isExpanded: true,
                      dropdownColor: _C.card,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: _C.muted,
                      ),
                      style: const TextStyle(color: _C.white, fontSize: 13.5),
                      items: branches.map((b) {
                        return DropdownMenuItem<String>(
                          value: b.id,
                          child: Text(
                            '${b.name} (${b.code})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedBranchId = val);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Rack / Shelf Location ("Kahan rakha hua hai")
              _buildLabel('Storage Rack / Shelf / Bin Position'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _rackController,
                style: const TextStyle(color: _C.white, fontSize: 13.5),
                decoration: _inputDecoration(
                  hintText: 'e.g. Rack A-12, Shelf 3, Bin 4',
                  prefixIcon: Icons.grid_view_rounded,
                ),
              ),
              const SizedBox(height: 20),

              // ── 💼 SECTION 2: Basic & Part Information ─────────────────
              _buildSectionHeader(
                icon: Icons.business_center_outlined,
                title: 'Basic & Part Information',
              ),
              const SizedBox(height: 12),

              // Product Photo Card (~5 KB Auto Compression)
              _buildProductPhotoPicker(),
              const SizedBox(height: 14),

              // Product Name *
              _buildLabel('Product / Spare Part Name'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: _C.white, fontSize: 13.5),
                decoration: _inputDecoration(
                  hintText: 'e.g. Bosch Front Disc Brake Pads - Ceramic',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Particular Part Number / OEM SKU & HSN Code Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Part Number / SKU *
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Part No / OEM SKU'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _partNumberController,
                          textCapitalization: TextCapitalization.characters,
                          style: const TextStyle(
                            color: _C.white,
                            fontSize: 13.5,
                          ),
                          decoration: _inputDecoration(
                            hintText: 'e.g. 0986AB1234',
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // HSN / SAC Code
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('HSN Code'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _hsnController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: _C.white,
                            fontSize: 13.5,
                          ),
                          decoration: _inputDecoration(hintText: 'e.g. 8708'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Category * & Brand * Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category *
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLabel('Category'),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (ctx) => AddCategoryBottomSheet(
                                    onSaved: () {
                                      setState(() {
                                        if (CategoryRepository
                                            .categories
                                            .isNotEmpty) {
                                          _selectedCategory = CategoryRepository
                                              .categories
                                              .first
                                              .name;
                                        }
                                      });
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                '+ New',
                                style: TextStyle(
                                  color: _C.accent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: _boxDecoration(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value:
                                  _categoryOptions.contains(_selectedCategory)
                                  ? _selectedCategory
                                  : (_categoryOptions.isNotEmpty
                                        ? _categoryOptions.first
                                        : null),
                              isExpanded: true,
                              dropdownColor: _C.card,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: _C.muted,
                                size: 18,
                              ),
                              style: const TextStyle(
                                color: _C.white,
                                fontSize: 12.5,
                              ),
                              items: _categoryOptions.map((c) {
                                return DropdownMenuItem<String>(
                                  value: c,
                                  child: Text(
                                    c,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedCategory = val);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Brand *
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Brand Details'),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: _boxDecoration(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _brandOptions.contains(_selectedBrand)
                                  ? _selectedBrand
                                  : (_brandOptions.isNotEmpty
                                        ? _brandOptions.first
                                        : null),
                              isExpanded: true,
                              dropdownColor: _C.card,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: _C.muted,
                                size: 18,
                              ),
                              style: const TextStyle(
                                color: _C.white,
                                fontSize: 12.5,
                              ),
                              items: _brandOptions.map((b) {
                                return DropdownMenuItem<String>(
                                  value: b,
                                  child: Text(
                                    b,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedBrand = val);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Product Description / Note
              _buildLabel(
                'Product Description / Specifications',
                isRequired: false,
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                style: const TextStyle(color: _C.white, fontSize: 13),
                decoration: _inputDecoration(
                  hintText: 'e.g. OE standard friction material, low dust, fits 2018+ models',
                ),
              ),
              const SizedBox(height: 20),

              // ── 📦 SECTION 3: Units, Packaging & Conversion ───────────
              _buildSectionHeader(
                icon: Icons.inventory_2_outlined,
                title: 'Units, Packaging & Conversion',
              ),
              const SizedBox(height: 12),

              // Base Unit & Secondary Packaging Unit (Row)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Base Primary Unit
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Primary Base Unit'),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: _boxDecoration(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _baseUnits.contains(_selectedBaseUnit)
                                  ? _selectedBaseUnit
                                  : _baseUnits.first,
                              isExpanded: true,
                              dropdownColor: _C.card,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: _C.muted,
                                size: 18,
                              ),
                              style: const TextStyle(
                                color: _C.white,
                                fontSize: 12.5,
                              ),
                              items: _baseUnits.map((u) {
                                return DropdownMenuItem<String>(
                                  value: u,
                                  child: Text(u),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedBaseUnit = val);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Secondary Bulk Packaging
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Packaging (Box / Set)'),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: _boxDecoration(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value:
                                  _selectedSecondaryUnit != null &&
                                      _secondaryUnits.contains(
                                        _selectedSecondaryUnit,
                                      )
                                  ? _selectedSecondaryUnit
                                  : null,
                              isExpanded: true,
                              dropdownColor: _C.card,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: _C.muted,
                                size: 18,
                              ),
                              style: const TextStyle(
                                color: _C.white,
                                fontSize: 12.5,
                              ),
                              items: _secondaryUnits.map((u) {
                                return DropdownMenuItem<String>(
                                  value: u,
                                  child: Text(u),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() => _selectedSecondaryUnit = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Unit Conversion Card (e.g. 1 Box = 10 Pcs)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _C.card,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _C.divider),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.sync_alt_rounded,
                      color: _C.accent,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '1 ${_selectedSecondaryUnit ?? "Box"} = ',
                      style: const TextStyle(
                        color: _C.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 32,
                      child: TextFormField(
                        controller: _conversionFactorController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: _C.accent,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: _C.inputFill,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(color: _C.divider),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _selectedBaseUnit,
                      style: const TextStyle(color: _C.muted, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Opening Stock * & Minimum Stock Limit (Row)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Opening Stock ($_selectedBaseUnit)'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _openingStockController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: _C.white,
                            fontSize: 13.5,
                          ),
                          decoration: _inputDecoration(
                            hintText: 'e.g. 20',
                            prefixIcon: Icons.inventory_2_outlined,
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Min Stock Alert ($_selectedBaseUnit)'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _minStockController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: _C.white,
                            fontSize: 13.5,
                          ),
                          decoration: _inputDecoration(
                            hintText: 'e.g. 5',
                            prefixIcon: Icons.warning_amber_rounded,
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── 💵 SECTION 4: Pricing, Discount & GST Engine ───────────
              _buildSectionHeader(
                icon: Icons.paid_outlined,
                title: 'Pricing, Discount & GST Engine',
              ),
              const SizedBox(height: 12),

              // Purchase Cost & Selling Base Price Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Purchase Cost
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Cost / Buy Price (₹)'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _purchasePriceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: const TextStyle(
                            color: _C.white,
                            fontSize: 13.5,
                          ),
                          decoration: _inputDecoration(
                            hintText: 'e.g. 1000',
                            prefixIcon: Icons.currency_rupee,
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Selling Price
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Selling Price (₹)'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _sellingPriceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: const TextStyle(
                            color: _C.white,
                            fontSize: 13.5,
                          ),
                          decoration: _inputDecoration(
                            hintText: 'e.g. 1500',
                            prefixIcon: Icons.sell_outlined,
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Discount % & GST Slab Selection (Row)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Discount %
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Discount (%)', isRequired: false),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _discountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: const TextStyle(
                            color: _C.white,
                            fontSize: 13.5,
                          ),
                          decoration: _inputDecoration(
                            hintText: 'e.g. 5.0%',
                            prefixIcon: Icons.discount_outlined,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // GST Slab Selector
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('GST Slab (%)'),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: _boxDecoration(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<double>(
                              value: _selectedGstRate,
                              isExpanded: true,
                              dropdownColor: _C.card,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: _C.muted,
                                size: 18,
                              ),
                              style: const TextStyle(
                                color: _C.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              items: _gstSlabOptions.map((rate) {
                                return DropdownMenuItem<double>(
                                  value: rate,
                                  child: Text('${rate.toInt()}% GST'),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedGstRate = val);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Tax Mode Toggle (Exclusive vs Inclusive)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _C.card,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _C.divider),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isTaxInclusive
                                ? 'Price is GST INCLUSIVE (MRP)'
                                : 'Price is GST EXCLUSIVE (+Tax)',
                            style: const TextStyle(
                              color: _C.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isTaxInclusive
                                ? 'GST ${_selectedGstRate.toInt()}% is already included inside price'
                                : 'GST ${_selectedGstRate.toInt()}% will be added on top of base price',
                            style: const TextStyle(
                              color: _C.muted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: _isTaxInclusive,
                      activeThumbColor: _C.accent,
                      onChanged: (val) => setState(() => _isTaxInclusive = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── 📊 LIVE GST & PROFIT BREAKDOWN CARD ────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _C.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _C.accent.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'LIVE GST BREAKDOWN (PER UNIT)',
                          style: TextStyle(
                            color: _C.accent,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Icon(
                          Icons.receipt_long_rounded,
                          color: _C.accent,
                          size: 16,
                        ),
                      ],
                    ),
                    const Divider(color: _C.divider, height: 16),
                    _buildBreakdownRow(
                      'Pre-GST Taxable Base:',
                      '₹${_preGstSellingAmount.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 6),
                    _buildBreakdownRow(
                      'GST Tax (${_selectedGstRate.toInt()}% CGST+SGST):',
                      '+ ₹${_gstSellingAmount.toStringAsFixed(2)}',
                      valueColor: _C.amber,
                    ),
                    const SizedBox(height: 6),
                    _buildBreakdownRow(
                      'Post-GST Amount (With Tax):',
                      '₹${_postGstSellingAmount.toStringAsFixed(2)}',
                      isBold: true,
                      valueColor: _C.white,
                    ),
                    const Divider(color: _C.divider, height: 16),
                    _buildBreakdownRow(
                      'Estimated Profit Margin:',
                      '₹${_estimatedProfit >= 0 ? _estimatedProfit.toStringAsFixed(2) : "0.00"} / $_selectedBaseUnit',
                      isBold: true,
                      valueColor: _estimatedProfit >= 0 ? _C.green : _C.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── 🏢 SECTION 5: Supplier & Purchase GST Details ───────────
              _buildSectionHeader(
                icon: Icons.local_shipping_outlined,
                title: 'Supplier & Purchase GST Details',
              ),
              const SizedBox(height: 12),

              // Quick Select from Registered Suppliers
              if (SupplierRepository.suppliers.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabel(
                      'Select Registered Supplier',
                      isRequired: false,
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) => AddSupplierBottomSheet(
                            onSaved: () {
                              setState(() {
                                if (SupplierRepository.suppliers.isNotEmpty) {
                                  final s = SupplierRepository.suppliers.first;
                                  _supplierNameController.text = s.companyName;
                                  if (s.gstNumber.isNotEmpty) {
                                    _supplierGstController.text = s.gstNumber;
                                  }
                                  if (s.phone.isNotEmpty) {
                                    _supplierPhoneController.text = s.phone;
                                  }
                                  if (s.categories.isNotEmpty) {
                                    _selectedCategory = s.categories.first;
                                  }
                                }
                              });
                            },
                          ),
                        );
                      },
                      child: const Text(
                        '+ Add New Supplier',
                        style: TextStyle(
                          color: _C.accent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: _boxDecoration(),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: Text(
                        'Pick from saved suppliers (Auto-fills GST & phone)',
                        style: TextStyle(
                          color: _C.muted.withValues(alpha: 0.5),
                          fontSize: 12.5,
                        ),
                      ),
                      isExpanded: true,
                      dropdownColor: _C.card,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: _C.muted,
                        size: 18,
                      ),
                      style: const TextStyle(color: _C.white, fontSize: 12.5),
                      items: SupplierRepository.suppliers.map((s) {
                        return DropdownMenuItem<String>(
                          value: s.id,
                          child: Text(
                            '${s.companyName} (${s.name})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          final s = SupplierRepository.suppliers.firstWhere(
                            (x) => x.id == val,
                          );
                          setState(() {
                            _supplierNameController.text = s.companyName;
                            if (s.gstNumber.isNotEmpty) {
                              _supplierGstController.text = s.gstNumber;
                            }
                            if (s.phone.isNotEmpty) {
                              _supplierPhoneController.text = s.phone;
                            }
                            if (s.categories.isNotEmpty) {
                              _selectedCategory = s.categories.first;
                            }
                            final brandMatch = _brandOptions
                                .where(
                                  (b) =>
                                      s.companyName.toLowerCase().contains(
                                        b.toLowerCase(),
                                      ) ||
                                      b.toLowerCase().contains(
                                        s.companyName.toLowerCase(),
                                      ),
                                )
                                .firstOrNull;
                            if (brandMatch != null) {
                              _selectedBrand = brandMatch;
                            }
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Supplier Name
              _buildLabel('Supplier / Distributor Name'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _supplierNameController,
                style: const TextStyle(color: _C.white, fontSize: 13.5),
                decoration: _inputDecoration(
                  hintText: 'e.g. Bosch India Auto Distributorship',
                  prefixIcon: Icons.store_mall_directory_outlined,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Enter supplier name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Supplier GSTIN & Phone Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GSTIN (15 Digits)
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Supplier GSTIN (15 Digits)'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _supplierGstController,
                          textCapitalization: TextCapitalization.characters,
                          style: const TextStyle(color: _C.white, fontSize: 13),
                          decoration: _inputDecoration(
                            hintText: 'e.g. 20AAAAA0000A1Z5',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Phone
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Contact Phone', isRequired: false),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _supplierPhoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: _C.white, fontSize: 13),
                          decoration: _inputDecoration(hintText: '9876543210'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: _C.card,
          border: Border(top: BorderSide(color: _C.divider, width: 0.8)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Cancel Button
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.inputFill,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: _C.divider, width: 1),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: _C.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Save Product Button
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.accent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black,
                              ),
                            ),
                          )
                        : Text(
                            isEdit ? 'Save Changes' : 'Save Product & GST',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
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

  // ── 📸 Product Photo & Auto-Compression (~5 KB) ──────────────────────────

  void _showPhotoPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _C.muted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Upload Product Photo',
                style: TextStyle(
                  color: _C.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Photo is auto-compressed to ~5 KB for instant syncing',
                style: TextStyle(color: _C.muted, fontSize: 12),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickAndCompressProductImage(ImageSource.camera);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _C.inputFill,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _C.divider),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.camera_alt_rounded, color: _C.accent, size: 28),
                            SizedBox(height: 8),
                            Text(
                              'Camera',
                              style: TextStyle(color: _C.white, fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickAndCompressProductImage(ImageSource.gallery);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _C.inputFill,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _C.divider),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.photo_library_rounded, color: _C.accent, size: 28),
                            SizedBox(height: 8),
                            Text(
                              'Gallery',
                              style: TextStyle(color: _C.white, fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndCompressProductImage(ImageSource source) async {
    setState(() => _isCompressingImage = true);
    try {
      final result = await ImageCompressor.pickAndCompress(
        source: source,
        targetKb: 5,
        maxDimension: 300,
      );
      if (result != null && mounted) {
        setState(() {
          _productImageFile = result.file;
          _productImagePath = result.file.path;
          _compressionInfo =
              '${result.compressedSizeFormatted} (~5 KB, saved ${result.compressionRatio.toStringAsFixed(0)}%)';
        });
      }
    } catch (e) {
      debugPrint('[AddProduct] Error picking/compressing photo: $e');
    } finally {
      if (mounted) {
        setState(() => _isCompressingImage = false);
      }
    }
  }

  Widget _buildProductPhotoPicker() {
    if (_isCompressingImage) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _C.inputFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _C.accent.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: _C.accent),
            ),
            SizedBox(width: 12),
            Text(
              'Compressing photo to ~5 KB...',
              style: TextStyle(color: _C.white, fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    if (_productImageFile != null || (_productImagePath.isNotEmpty && File(_productImagePath).existsSync())) {
      final file = _productImageFile ?? File(_productImagePath);
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _C.accent.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                file,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _C.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.check_circle_rounded, color: _C.green, size: 12),
                            SizedBox(width: 4),
                            Text(
                              'Auto-Compressed',
                              style: TextStyle(color: _C.green, fontSize: 10.5, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _compressionInfo ?? ImageCompressor.formatBytes(file.lengthSync()),
                    style: const TextStyle(color: _C.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Stored at ultra-light ~5 KB size',
                    style: TextStyle(color: _C.muted, fontSize: 10.5),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Change Photo',
              icon: const Icon(Icons.edit_outlined, color: _C.accent, size: 20),
              onPressed: _showPhotoPickerOptions,
            ),
            IconButton(
              tooltip: 'Remove Photo',
              icon: const Icon(Icons.delete_outline, color: _C.red, size: 20),
              onPressed: () {
                setState(() {
                  _productImageFile = null;
                  _productImagePath = '';
                  _compressionInfo = null;
                });
              },
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: _showPhotoPickerOptions,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: _C.inputFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _C.divider),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _C.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add_a_photo_outlined, color: _C.accent, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Add Product / Spare Part Photo',
                    style: TextStyle(color: _C.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Auto-compressed to ~5 KB for instant syncing',
                    style: TextStyle(color: _C.muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: _C.muted, size: 20),
          ],
        ),
      ),
    );
  }

  // ── Helper Widgets ─────────────────────────────────────────────────────────

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, color: _C.accent, size: 17),
        const SizedBox(width: 7),
        Text(
          title,
          style: const TextStyle(
            color: _C.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, {bool isRequired = true}) {
    return Text.rich(
      TextSpan(
        text: text,
        style: const TextStyle(
          color: _C.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        children: [
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                color: _C.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildBreakdownRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? _C.white : _C.muted,
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? (isBold ? _C.white : _C.muted),
            fontSize: isBold ? 13 : 12,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: _C.inputFill,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: _C.divider, width: 1),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: _C.muted.withValues(alpha: 0.5),
        fontSize: 12.5,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: _C.accent, size: 17)
          : null,
      filled: true,
      fillColor: _C.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _C.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _C.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _C.accent, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _C.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _C.red, width: 1.2),
      ),
    );
  }
}
