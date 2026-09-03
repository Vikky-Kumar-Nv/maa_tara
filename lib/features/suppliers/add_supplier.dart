import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/features/categories/category_model.dart';
import 'package:maa_tara/features/suppliers/supplier_model.dart';

typedef _C = AppColors;

// ─────────────────────────────────────────────────────────────────────────────
//  MAA TARA AUTOMOBILES — Add / Edit Supplier Form
// ─────────────────────────────────────────────────────────────────────────────
class AddSupplierBottomSheet extends StatefulWidget {
  final SupplierModel? supplierToEdit;
  final VoidCallback onSaved;

  const AddSupplierBottomSheet({
    super.key,
    this.supplierToEdit,
    required this.onSaved,
  });

  @override
  State<AddSupplierBottomSheet> createState() => _AddSupplierBottomSheetState();
}

class _AddSupplierBottomSheetState extends State<AddSupplierBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _companyController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _gstController;
  late TextEditingController _addressController;
  late TextEditingController _productsController;
  late TextEditingController _paymentTermsController;

  late String _selectedCategory;
  bool _isSubmitting = false;

  List<String> get _categories {
    final list = CategoryRepository.categories.map((c) => c.name).toList();
    if (list.isEmpty) {
      return [
        'Engine Parts',
        'Brake System',
        'Suspension',
        'Electrical',
        'Body Parts',
        'Oils & Fluids',
        'Filters & Belts',
      ];
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    final s = widget.supplierToEdit;
    _nameController = TextEditingController(text: s?.name ?? '');
    _companyController = TextEditingController(text: s?.companyName ?? '');
    _phoneController = TextEditingController(text: s?.phone ?? '');
    _emailController = TextEditingController(text: s?.email ?? '');
    _gstController = TextEditingController(text: s?.gstNumber ?? '');
    _addressController = TextEditingController(text: s?.address ?? '');
    _productsController = TextEditingController(text: s?.suppliedProducts.join(', ') ?? '');
    _paymentTermsController = TextEditingController(text: s?.paymentTerms ?? 'Net 30 Days');

    final cats = _categories;
    if (s != null && cats.contains(s.category)) {
      _selectedCategory = s.category;
    } else {
      _selectedCategory = cats.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _gstController.dispose();
    _addressController.dispose();
    _productsController.dispose();
    _paymentTermsController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 500));

    final isEdit = widget.supplierToEdit != null;
    final products = _productsController.text
        .split(',')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    final supplier = SupplierModel(
      id: widget.supplierToEdit?.id ?? 'SUP-${DateTime.now().millisecondsSinceEpoch % 10000}',
      name: _nameController.text.trim(),
      companyName: _companyController.text.trim(),
      category: _selectedCategory,
      categories: [_selectedCategory],
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      gstNumber: _gstController.text.trim().toUpperCase(),
      address: _addressController.text.trim(),
      productsCount: products.isNotEmpty ? products.length * 15 : (widget.supplierToEdit?.productsCount ?? 25),
      suppliedProducts: products.isNotEmpty ? products : (widget.supplierToEdit?.suppliedProducts ?? ['Standard Spare Parts']),
      logoUrl: widget.supplierToEdit?.logoUrl,
      paymentTerms: _paymentTermsController.text.trim(),
    );

    if (isEdit) {
      SupplierRepository.updateSupplier(supplier);
    } else {
      SupplierRepository.addSupplier(supplier);
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    Navigator.pop(context);
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.supplierToEdit != null;

    return Container(
      decoration: const BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: _C.divider, width: 1.2),
        ),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Drag Handle
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
              const SizedBox(height: 12),

              // Title
              Text(
                isEdit ? 'Edit Supplier' : 'Add Supplier',
                style: const TextStyle(
                  color: _C.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 16),

              // Supplier Name *
              _buildLabel('Supplier Name'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _nameController,
                hintText: 'Enter supplier name',
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter contact person name';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Company Name *
              _buildLabel('Company Name'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _companyController,
                hintText: 'Enter company name',
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter company/trade name';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Category Dropdown
              _buildLabel('Primary Category'),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: _C.inputFill,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _C.divider),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    dropdownColor: _C.card,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _C.muted),
                    style: const TextStyle(color: _C.white, fontSize: 13),
                    items: _categories.map((c) {
                      return DropdownMenuItem<String>(
                        value: c,
                        child: Text(c, maxLines: 1, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Phone Number *
              _buildLabel('Phone Number'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _phoneController,
                hintText: 'Enter phone number',
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter phone number';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Email Address
              _buildLabel('Email Address', isRequired: false),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _emailController,
                hintText: 'Enter email address',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),

              // Supplier GSTIN
              _buildLabel('Supplier GSTIN (15 Digits)', isRequired: false),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _gstController,
                hintText: 'e.g. 27AAAAA1234A1Z5',
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 14),

              // Products (comma separated)
              _buildLabel('Products', isRequired: false),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _productsController,
                hintText: 'Enter products (comma separated)',
                maxLines: 2,
              ),
              const SizedBox(height: 22),

              // Bottom Actions: Cancel & Save Supplier
              Row(
                children: [
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
                          style: TextStyle(color: _C.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _C.accent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  valueColor: AlwaysStoppedAnimation(Colors.black),
                                ),
                              )
                            : Text(
                                isEdit ? 'Save Changes' : 'Save Supplier',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
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

  Widget _buildLabel(String text, {bool isRequired = true}) {
    return Text.rich(
      TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFFD1D5DB),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      style: const TextStyle(color: _C.white, fontSize: 13.5),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 12.5),
        filled: true,
        fillColor: _C.inputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
      ),
      validator: validator,
    );
  }
}
