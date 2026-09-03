import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/features/categories/category_model.dart';

typedef _C = AppColors;

// ─────────────────────────────────────────────────────────────────────────────
//  MAA TARA AUTOMOBILES — Add / Edit Category Bottom Sheet (Screenshot 2)
// ─────────────────────────────────────────────────────────────────────────────
class AddCategoryBottomSheet extends StatefulWidget {
  final CategoryModel? categoryToEdit;
  final VoidCallback onSaved;

  const AddCategoryBottomSheet({
    super.key,
    this.categoryToEdit,
    required this.onSaved,
  });

  @override
  State<AddCategoryBottomSheet> createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String _selectedStatus = 'Active';
  bool _isSubmitting = false;

  final List<String> _statusOptions = ['Active', 'Inactive'];

  @override
  void initState() {
    super.initState();
    final cat = widget.categoryToEdit;
    _nameController = TextEditingController(text: cat?.name ?? '');
    _descriptionController = TextEditingController(text: cat?.description ?? '');
    _selectedStatus = cat?.status ?? 'Active';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 500));

    final isEdit = widget.categoryToEdit != null;
    final category = CategoryModel(
      id: widget.categoryToEdit?.id ??
          'CAT-${DateTime.now().millisecondsSinceEpoch % 10000}',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      status: _selectedStatus,
      productsCount: widget.categoryToEdit?.productsCount ?? 0,
      iconKey: widget.categoryToEdit?.iconKey ?? 'engine',
      iconUrl: widget.categoryToEdit?.iconUrl ?? '',
    );

    if (isEdit) {
      CategoryRepository.updateCategory(category);
    } else {
      CategoryRepository.addCategory(category);
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    Navigator.pop(context);
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.categoryToEdit != null;

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
              const SizedBox(height: 14),

              // Title
              Text(
                isEdit ? 'Edit Category' : 'Add Category',
                style: const TextStyle(
                  color: _C.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 16),

              // Category Name *
              _buildLabel('Category Name'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: _C.white, fontSize: 13.5),
                decoration: _inputDecoration(hintText: 'Enter category name'),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter category name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Status * (Dropdown)
              _buildLabel('Status'),
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
                    value: _selectedStatus,
                    isExpanded: true,
                    dropdownColor: _C.card,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _C.muted,
                    ),
                    style: const TextStyle(color: _C.white, fontSize: 13.5),
                    items: _statusOptions.map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: status == 'Active' ? _C.green : _C.amber,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(status),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedStatus = val);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Description (Optional)
              _buildLabel('Description (Optional)', isRequired: false),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                style: const TextStyle(color: _C.white, fontSize: 13.5),
                decoration: _inputDecoration(hintText: 'Enter description'),
              ),
              const SizedBox(height: 22),

              // Bottom Actions: Cancel & Save Category
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
                            side: const BorderSide(
                              color: _C.divider,
                              width: 1,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: _C.white,
                            fontWeight: FontWeight.w600,
                          ),
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
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.black,
                                  ),
                                ),
                              )
                            : Text(
                                isEdit ? 'Save Changes' : 'Save Category',
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

  InputDecoration _inputDecoration({required String hintText}) {
    return InputDecoration(
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
    );
  }
}
