import 'package:flutter/material.dart';
import 'package:maa_tara/colors.dart';
import 'package:maa_tara/customer_list.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Add Customer Page
// ─────────────────────────────────────────────────────────────────────────────
class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({super.key});

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers - Customer Info
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _altPhoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  // Controllers - Vehicle Info
  final _vehicleNumberController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehicleColorController = TextEditingController();

  // Controllers - Requirements & Notes
  final _requirementController = TextEditingController();
  final _notesController = TextEditingController();

  // Dropdown Selections
  String? _selectedBrand;
  String? _selectedType;

  final List<String> _brands = [
    'Maruti Suzuki',
    'Hyundai',
    'Tata Motors',
    'Mahindra',
    'Honda',
    'Toyota',
    'Kia',
    'Volkswagen',
    'Skoda',
    'MG Motor',
    'Renault',
    'Nissan',
    'Other',
  ];

  final List<String> _vehicleTypes = [
    'Hatchback',
    'Sedan',
    'SUV / Compact SUV',
    'MUV / MPV',
    'Electric (EV)',
    'Commercial Vehicle',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _vehicleNumberController.dispose();
    _vehicleModelController.dispose();
    _vehicleColorController.dispose();
    _requirementController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header Bar ───────────────────────────────────────────────
            _buildTopHeader(),

            // ── Scrollable Form Body ─────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Customer Information Section
                      _buildSectionHeader(
                        icon: Icons.person_outline_rounded,
                        title: 'Customer Information',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Full Name',
                              isRequired: true,
                              hint: 'Enter full name',
                              controller: _nameController,
                              validator: (val) =>
                                  val == null || val.trim().isEmpty
                                  ? 'Name is required'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInputField(
                              label: 'Phone Number',
                              isRequired: true,
                              hint: 'Enter phone number',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              validator: (val) =>
                                  val == null || val.trim().isEmpty
                                  ? 'Phone is required'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Alternate Phone',
                              hint: 'Enter alternate phone',
                              controller: _altPhoneController,
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInputField(
                              label: 'Email Address',
                              hint: 'Enter email (optional)',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        label: 'Address',
                        hint: 'Enter address',
                        controller: _addressController,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 22),

                      // 2. Vehicle Information Section
                      _buildSectionHeader(
                        icon: Icons.directions_car_outlined,
                        title: 'Vehicle Information',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Vehicle Number',
                              isRequired: true,
                              hint: 'e.g. DL 8C AX 1234',
                              controller: _vehicleNumberController,
                              textCapitalization: TextCapitalization.characters,
                              validator: (val) =>
                                  val == null || val.trim().isEmpty
                                  ? 'Number is required'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDropdownField(
                              label: 'Vehicle Brand',
                              hint: 'Select brand',
                              value: _selectedBrand,
                              items: _brands,
                              onChanged: (val) =>
                                  setState(() => _selectedBrand = val),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Vehicle Model',
                              hint: 'e.g. Swift Dzire, i20',
                              controller: _vehicleModelController,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDropdownField(
                              label: 'Vehicle Type',
                              hint: 'Select type',
                              value: _selectedType,
                              items: _vehicleTypes,
                              onChanged: (val) =>
                                  setState(() => _selectedType = val),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        label: 'Vehicle Color',
                        hint: 'e.g. White, Silver, Black',
                        controller: _vehicleColorController,
                      ),
                      const SizedBox(height: 22),

                      // 3. Customer Requirement Section
                      _buildSectionHeader(
                        icon: Icons.assignment_outlined,
                        title: 'Customer Requirement',
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'What does the customer want?',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInputField(
                        label: '',
                        hint: 'Enter customer requirement / complaints...',
                        controller: _requirementController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 22),

                      // 4. Additional Notes Section
                      _buildSectionHeader(
                        icon: Icons.edit_note_rounded,
                        title: 'Additional Notes',
                      ),
                      const SizedBox(height: 8),
                      _buildInputField(
                        label: '',
                        hint: 'Enter additional notes (optional)',
                        controller: _notesController,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 24),

                      // 5. Action Buttons (Cancel & Save Customer)
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.card,
                                side: const BorderSide(
                                  color: AppColors.divider,
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
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
                              onPressed: () =>
                                  _handleSaveCustomer(createWork: false),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Save Customer',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 6. Full Width "Save & Create Work" Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              _handleSaveCustomer(createWork: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Save & Create Work',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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
  Widget _buildTopHeader() {
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
              const Text(
                'Add Customer',
                style: TextStyle(
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
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
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
        ],
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
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
            errorStyle: const TextStyle(fontSize: 11, height: 1.1),
          ),
        ),
      ],
    );
  }

  // ── Dropdown Field Helper ───────────────────────────────────────────────────
  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
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

  // ── Save Handler with Center Success Popup ──────────────────────────────────
  void _handleSaveCustomer({required bool createWork}) {
    if (_formKey.currentState?.validate() ?? false) {
      final customerName = _nameController.text.trim();
      final vehicleNo = _vehicleNumberController.text.trim().toUpperCase();
      final brand = _selectedBrand ?? 'Hyundai';
      final model = _vehicleModelController.text.trim().isNotEmpty
          ? _vehicleModelController.text.trim()
          : '$brand i20';

      final newCustomer = CustomerModel(
        id: 'CUST-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        name: customerName,
        phone: _phoneController.text.trim(),
        altPhone: _altPhoneController.text.trim().isNotEmpty
            ? _altPhoneController.text.trim()
            : null,
        email: _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim()
            : null,
        address: _addressController.text.trim().isNotEmpty
            ? _addressController.text.trim()
            : 'Dwarka, New Delhi',
        vehiclePlate: vehicleNo,
        vehicleBrand: brand,
        carModel: model,
        vehicleType: _selectedType ?? 'Hatchback',
        vehicleColor: _vehicleColorController.text.trim().isNotEmpty
            ? _vehicleColorController.text.trim()
            : 'White',
        vehicleYear: '2024',
        customerSince: 'Today',
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        requirement: _requirementController.text.trim().isNotEmpty
            ? _requirementController.text.trim()
            : null,
        totalWorks: 1,
        lastVisit: 'Today',
        status: 'Active',
        workHistory: [
          WorkHistoryItem(
            workId:
                'WORK-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
            service: _requirementController.text.trim().isNotEmpty
                ? _requirementController.text.trim()
                : 'General Service & Inspection',
            status: 'In Progress',
          ),
        ],
      );

      // Add to shared dynamic repository
      CustomerRepository.addCustomer(newCustomer);

      _showSuccessDialog(
        title: 'Customer Added Successfully!',
        message: createWork
            ? 'Customer "$customerName" ($vehicleNo) saved! Proceeding to create work job card.'
            : 'Customer "$customerName" ($vehicleNo) has been saved to the database.',
        onDismiss: () {
          Navigator.pop(context, newCustomer);
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
