import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/features/inventory/inventory_models.dart';

typedef _C = AppColors;

// ─────────────────────────────────────────────────────────────────────────────
//  Create / Add Branch Page (Max 2 Limit Protected)
// ─────────────────────────────────────────────────────────────────────────────
class CreateBranchPage extends StatefulWidget {
  final InventoryBranchModel? initialBranch; // Pass if editing

  const CreateBranchPage({super.key, this.initialBranch});

  @override
  State<CreateBranchPage> createState() => _CreateBranchPageState();
}

class _CreateBranchPageState extends State<CreateBranchPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;
  late TextEditingController _managerController;
  bool _isPrimary = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final b = widget.initialBranch;
    _nameController = TextEditingController(text: b?.name ?? '');
    _codeController = TextEditingController(
      text: b?.code ?? 'MT-BR${InventoryRepository.branches.length + 1}',
    );
    _locationController = TextEditingController(text: b?.location ?? '');
    _phoneController = TextEditingController(text: b?.phone ?? '');
    _managerController = TextEditingController(text: b?.managerName ?? '');
    _isPrimary = b?.isPrimary ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _managerController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final isEdit = widget.initialBranch != null;
    if (!isEdit && !InventoryRepository.canCreateBranch) {
      _showLimitReachedDialog();
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final branchId =
        widget.initialBranch?.id ??
        'BR-${DateTime.now().millisecondsSinceEpoch % 1000}';

    final managerText = _managerController.text.trim();

    final newBranch = InventoryBranchModel(
      id: branchId,
      name: _nameController.text.trim(),
      code: _codeController.text.trim().toUpperCase(),
      location: _locationController.text.trim(),
      phone: _phoneController.text.trim(),
      managerName: managerText.isNotEmpty ? managerText : 'Owner / In-Charge',
      isPrimary: _isPrimary,
      createdAt: widget.initialBranch?.createdAt ?? 'Today',
    );

    if (isEdit) {
      InventoryRepository.updateBranch(newBranch);
    } else {
      InventoryRepository.addBranch(newBranch);
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    Navigator.pop(context, newBranch);
  }

  void _showLimitReachedDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
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
                child: const Icon(Icons.store, color: _C.amber, size: 30),
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
                'Aapke account mein max 2 shops manage karne ka option enabled hai. Nayi shop create karne ke liye aap existing shop ko rename ya edit kar sakte hain.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _C.muted, fontSize: 12.5, height: 1.4),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Understood',
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
    final isEdit = widget.initialBranch != null;
    final currentBranchCount = InventoryRepository.branches.length;

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
          isEdit ? 'Edit Shop / Branch' : 'Create New Shop Branch',
          style: const TextStyle(
            color: _C.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 2-Branch Limit Info Banner ──────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _C.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _C.divider),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _C.accent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.store_mall_directory_rounded,
                        color: _C.accent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Workshop Shop Limit: ',
                                style: TextStyle(
                                  color: _C.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: currentBranchCount >= 2
                                      ? _C.amber.withValues(alpha: 0.2)
                                      : _C.green.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '$currentBranchCount / 2 Active',
                                  style: TextStyle(
                                    color: currentBranchCount >= 2
                                        ? _C.amber
                                        : _C.green,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Client ke dono shops ko alag inventory ke sath manage karein.',
                            style: TextStyle(color: _C.muted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Shop / Branch Name ───────────────────────────────────────────
              _buildFieldLabel('Shop / Branch Name', isRequired: true),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: _C.white, fontSize: 14),
                decoration: _inputDecoration(
                  hintText: 'e.g. Maa Tara Automobiles (Branch 2)',
                  prefixIcon: Icons.storefront_outlined,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter shop/branch name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Branch Code & Phone Row ─────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Branch Code', isRequired: true),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _codeController,
                          textCapitalization: TextCapitalization.characters,
                          style: const TextStyle(color: _C.white, fontSize: 14),
                          decoration: _inputDecoration(
                            hintText: 'e.g. MT-OUTLET2',
                            prefixIcon: Icons.qr_code_2_rounded,
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Enter code';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Contact Phone', isRequired: true),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: _C.white, fontSize: 14),
                          decoration: _inputDecoration(
                            hintText: 'e.g. 9812345678',
                            prefixIcon: Icons.phone_outlined,
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Enter phone';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Location / Address ──────────────────────────────────────────
              _buildFieldLabel('Shop Address / Location', isRequired: true),
              const SizedBox(height: 6),
              TextFormField(
                controller: _locationController,
                maxLines: 2,
                style: const TextStyle(color: _C.white, fontSize: 14),
                decoration: _inputDecoration(
                  hintText: 'e.g. Main Market, Bada Chowk, Giridih, Jharkhand',
                  prefixIcon: Icons.location_on_outlined,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter branch location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Branch Manager / In-Charge (Manual Text Input) ─────────────
              _buildFieldLabel('Branch Manager / In-Charge Name'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _managerController,
                style: const TextStyle(color: _C.white, fontSize: 14),
                decoration: _inputDecoration(
                  hintText: 'e.g. Vikram Singh / Self (Owner)',
                  prefixIcon: Icons.person_outline_rounded,
                ),
              ),
              const SizedBox(height: 18),

              // ── Primary Branch Switch ───────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _C.card,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _C.divider),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_outline_rounded,
                      color: _C.accent,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Set as Main Workshop (Primary)',
                            style: TextStyle(
                              color: _C.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Default selected branch on app open',
                            style: TextStyle(color: _C.muted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isPrimary,
                      activeTrackColor: _C.accent.withValues(alpha: 0.5),
                      thumbColor: WidgetStateProperty.all(_C.accent),
                      onChanged: (v) => setState(() => _isPrimary = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // ── Submit Button ───────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
                          isEdit ? 'Save Changes' : 'Create Shop Branch',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _C.white,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isRequired)
          const Text(
            ' *',
            style: TextStyle(color: _C.red, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: _C.muted.withValues(alpha: 0.5),
        fontSize: 12.5,
      ),
      prefixIcon: Icon(prefixIcon, color: _C.accent, size: 18),
      filled: true,
      fillColor: _C.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _C.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _C.accent, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _C.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _C.red, width: 1.2),
      ),
    );
  }
}
