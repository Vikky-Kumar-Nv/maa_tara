import 'package:flutter/material.dart';
import 'package:maa_tara/colors.dart';
import 'package:maa_tara/staff_list.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Add / Edit Staff Page
// ─────────────────────────────────────────────────────────────────────────────
class AddStaffPage extends StatefulWidget {
  final StaffModel? staffToEdit;

  const AddStaffPage({super.key, this.staffToEdit});

  @override
  State<AddStaffPage> createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String _selectedRole = 'Technician';
  String _selectedStatus = 'Active';

  final List<String> _roles = [
    'Technician',
    'Mechanic',
    'Electrician',
    'Painter / Denter',
    'Service Advisor',
    'Helper',
    'Manager',
  ];

  final List<String> _statuses = [
    'Active',
    'On Leave',
    'Suspended',
    'Inactive',
  ];

  final Map<String, String> _roleAvatars = {
    'Technician':
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80',
    'Mechanic':
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80',
    'Electrician':
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&auto=format&fit=crop&q=80',
    'Painter / Denter':
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80',
    'Service Advisor':
        'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150&auto=format&fit=crop&q=80',
    'Helper':
        'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150&auto=format&fit=crop&q=80',
    'Manager':
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80',
  };

  @override
  void initState() {
    super.initState();
    if (widget.staffToEdit != null) {
      final s = widget.staffToEdit!;
      _nameController.text = s.name;
      _phoneController.text = s.phone;
      _emailController.text = s.email;
      _selectedRole = s.role;
      _selectedStatus = s.status;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.staffToEdit != null;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header Bar ───────────────────────────────────────────────
            _buildTopHeader(isEditing ? 'Edit Staff' : 'Add / Edit Staff'),

            // ── Scrollable Form Body ─────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Personal Information Section
                      _buildSectionHeader(
                        icon: Icons.person_outline_rounded,
                        title: 'Personal Information',
                      ),
                      const SizedBox(height: 14),

                      // Full Name
                      _buildInputField(
                        label: 'Full Name',
                        isRequired: true,
                        hint: 'Enter full name',
                        controller: _nameController,
                        validator: (val) =>
                            val == null || val.trim().isEmpty ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 14),

                      // Phone Number
                      _buildInputField(
                        label: 'Phone Number',
                        isRequired: true,
                        hint: 'Enter phone number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (val) =>
                            val == null || val.trim().isEmpty ? 'Phone is required' : null,
                      ),
                      const SizedBox(height: 14),

                      // Email
                      _buildInputField(
                        label: 'Email',
                        hint: 'Enter email address',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),

                      // Role Dropdown
                      _buildDropdownField(
                        label: 'Role',
                        isRequired: true,
                        hint: 'Select role',
                        value: _selectedRole,
                        items: _roles,
                        onChanged: (val) => setState(() => _selectedRole = val ?? 'Technician'),
                      ),
                      const SizedBox(height: 14),

                      // Password Field
                      _buildPasswordField(
                        label: 'Password',
                        hint: isEditing ? 'Enter new password (optional)' : 'Enter password',
                        controller: _passwordController,
                        isObscured: _obscurePassword,
                        onToggleVisibility: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      const SizedBox(height: 14),

                      // Confirm Password Field
                      _buildPasswordField(
                        label: 'Confirm Password',
                        hint: isEditing ? 'Confirm new password' : 'Confirm password',
                        controller: _confirmPasswordController,
                        isObscured: _obscureConfirmPassword,
                        onToggleVisibility: () => setState(
                          () => _obscureConfirmPassword = !_obscureConfirmPassword,
                        ),
                        validator: (val) {
                          if (_passwordController.text.isNotEmpty &&
                              val != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Status Dropdown
                      _buildDropdownField(
                        label: 'Status',
                        isRequired: true,
                        hint: 'Select status',
                        value: _selectedStatus,
                        items: _statuses,
                        onChanged: (val) => setState(() => _selectedStatus = val ?? 'Active'),
                      ),
                      const SizedBox(height: 28),

                      // Action Buttons (Cancel & Save Staff)
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.card,
                                side: const BorderSide(color: AppColors.divider, width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _handleSaveStaff(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                elevation: 0,
                              ),
                              child: Text(
                                isEditing ? 'Update Staff' : 'Save Staff',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top Header Bar ──────────────────────────────────────────────────────────
  Widget _buildTopHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Column(
        children: [
          // Drag handle bar
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.muted.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close, color: AppColors.white, size: 22),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Section Header ──────────────────────────────────────────────────────────
  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent, size: 18),
        const SizedBox(width: 7),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  // ── Input Field Helper ──────────────────────────────────────────────────────
  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(color: AppColors.white, fontSize: 13),
          cursorColor: AppColors.accent,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.muted.withValues(alpha: 0.5),
              fontSize: 12,
            ),
            filled: true,
            fillColor: AppColors.inputFill,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.divider, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.red, width: 1.2),
            ),
            errorStyle: const TextStyle(fontSize: 11, height: 1.1),
          ),
        ),
      ],
    );
  }

  // ── Password Field Helper ───────────────────────────────────────────────────
  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isObscured,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: isObscured,
          validator: validator,
          style: const TextStyle(color: AppColors.white, fontSize: 13),
          cursorColor: AppColors.accent,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.muted.withValues(alpha: 0.5),
              fontSize: 12,
            ),
            filled: true,
            fillColor: AppColors.inputFill,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            suffixIcon: IconButton(
              icon: Icon(
                isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.muted,
                size: 18,
              ),
              onPressed: onToggleVisibility,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.divider, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.red, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }

  // ── Dropdown Helper ─────────────────────────────────────────────────────────
  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.divider, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text(
                hint,
                style: TextStyle(
                  color: AppColors.muted.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.muted,
                size: 20,
              ),
              dropdownColor: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 13,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // ── Save Handler ────────────────────────────────────────────────────────────
  void _handleSaveStaff() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final email = _emailController.text.trim().isNotEmpty
          ? _emailController.text.trim()
          : '${name.toLowerCase().replaceAll(" ", ".")}@maara.com';

      final avatar = _roleAvatars[_selectedRole] ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80';

      final isEditing = widget.staffToEdit != null;

      final savedStaff = StaffModel(
        id: isEditing
            ? widget.staffToEdit!.id
            : 'STF-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        name: name,
        role: _selectedRole,
        phone: phone,
        email: email,
        avatarUrl: isEditing ? widget.staffToEdit!.avatarUrl : avatar,
        status: _selectedStatus,
        activityStatus: _selectedStatus == 'Active' ? 'Working' : 'Offline',
        todayWorks: isEditing ? widget.staffToEdit!.todayWorks : 0,
        completedWorks: isEditing ? widget.staffToEdit!.completedWorks : 0,
        pendingWorks: isEditing ? widget.staffToEdit!.pendingWorks : 0,
        currentWork: isEditing ? widget.staffToEdit!.currentWork : '-',
        attendance: _selectedStatus == 'Active' ? 'Present' : 'Absent',
        joiningDate: isEditing ? widget.staffToEdit!.joiningDate : 'Today',
      );

      if (isEditing) {
        StaffRepository.updateStaff(savedStaff);
      } else {
        StaffRepository.addStaff(savedStaff);
      }

      _showSuccessDialog(
        title: isEditing ? 'Staff Updated Successfully!' : 'Staff Added Successfully!',
        message: 'Staff member "$name" ($_selectedRole) has been saved successfully.',
        onDismiss: () {
          Navigator.pop(context, savedStaff);
        },
      );
    }
  }

  // ── Unified Center Success Dialog ───────────────────────────────────────────
  void _showSuccessDialog({
    required String title,
    required String message,
    required VoidCallback onDismiss,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.divider, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success glowing checkmark icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.green.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.green.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.green,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onDismiss();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
