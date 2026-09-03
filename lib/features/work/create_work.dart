import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/core/utils/image_compressor.dart';
import 'package:maa_tara/features/customers/customer_list.dart';
import 'package:maa_tara/features/staff/staff_list.dart';
import 'package:maa_tara/features/work/job.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Create Work Page
// ─────────────────────────────────────────────────────────────────────────────
class CreateWorkPage extends StatefulWidget {
  final CustomerModel? preselectedCustomer;
  final StaffModel? initialStaff;
  final WorkModel? workToEdit;

  const CreateWorkPage({
    super.key,
    this.preselectedCustomer,
    this.initialStaff,
    this.workToEdit,
  });

  @override
  State<CreateWorkPage> createState() => _CreateWorkPageState();
}

class _CreateWorkPageState extends State<CreateWorkPage> {
  final _formKey = GlobalKey<FormState>();

  // Generated Work ID
  late String _generatedWorkId;

  // Controllers - Customer Info
  final _customerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _altPhoneController = TextEditingController();

  // Controllers - Vehicle Info
  final _vehiclePlateController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _odometerController = TextEditingController();

  // Controllers - Work & Notes
  final _serviceTitleController = TextEditingController();
  final _requirementController = TextEditingController();
  final _notesController = TextEditingController();

  // Dropdown & Selection States
  CustomerModel? _selectedCustomer;
  String? _selectedBrand;
  String _selectedFuelType = 'Petrol';
  String _selectedFuelLevel = 'Half (50%)';
  String _selectedCategory = 'General Service';
  String _selectedPriority = 'Normal';
  String _selectedStaff = 'Vikram Singh';
  WorkStatus _selectedStatus = WorkStatus.inProgress;

  DateTime _promisedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _promisedTime = const TimeOfDay(hour: 17, minute: 0);

  // Photos
  final List<String> _inspectionPhotos = [];
  final List<File> _capturedPhotoFiles = [];

  // Dropdown lists
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

  final List<String> _fuelTypes = [
    'Petrol',
    'Diesel',
    'CNG',
    'Electric (EV)',
    'Hybrid',
  ];

  final List<String> _fuelLevels = [
    'Reserve (<15%)',
    'Quarter (25%)',
    'Half (50%)',
    'Three-Quarter (75%)',
    'Full Tank (100%)',
  ];

  final List<String> _categories = [
    'General Service',
    'Periodic Maintenance',
    'Brake & Suspension',
    'Engine & Transmission',
    'AC & Electricals',
    'Denting & Painting',
    'Car Wash & Detailing',
  ];

  List<String> get _staffList {
    final list = StaffRepository.staffList.map((s) => s.name).toList();
    if (list.isEmpty) {
      return const [
        'Vikram Singh',
        'Arjun Mehta',
        'Rohit Kumar',
        'Suresh Patel',
      ];
    }
    return list;
  }

  final Map<String, String> _staffAvatars = {
    'Vikram Singh': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=80',
    'Arjun Mehta': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&auto=format&fit=crop&q=80',
    'Rohit Kumar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&auto=format&fit=crop&q=80',
    'Suresh Patel': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&auto=format&fit=crop&q=80',
  };

  bool get _isEdit => widget.workToEdit != null;

  @override
  void initState() {
    super.initState();

    if (_isEdit) {
      final w = widget.workToEdit!;
      _generatedWorkId = w.workId;
      _customerNameController.text = w.customerName;
      _phoneController.text = w.phone;
      _vehiclePlateController.text = w.vehiclePlate;
      _vehicleModelController.text = w.carModel;
      _serviceTitleController.text = w.service ?? '';
      _selectedStaff = w.assignedStaff;
      _selectedStatus = w.status;
    } else {
      _generatedWorkId =
          'WORK-${1059 + DateTime.now().millisecondsSinceEpoch % 900}';

      // Dynamic initial staff selection
      if (widget.initialStaff != null) {
        _selectedStaff = widget.initialStaff!.name;
      } else if (StaffRepository.staffList.isNotEmpty) {
        _selectedStaff = StaffRepository.staffList.first.name;
      }

      // If preselected customer is provided (from AddCustomer or CustomerDetails)
      if (widget.preselectedCustomer != null) {
        _applyCustomerData(widget.preselectedCustomer!);
      }
    }
  }

  void _applyCustomerData(CustomerModel c) {
    _selectedCustomer = c;
    _customerNameController.text = c.name;
    _phoneController.text = c.phone;
    _altPhoneController.text = c.altPhone ?? '';
    _vehiclePlateController.text = c.vehiclePlate;
    _selectedBrand = c.vehicleBrand;
    _vehicleModelController.text = c.carModel;
    if (c.requirement != null && c.requirement!.isNotEmpty) {
      _requirementController.text = c.requirement!;
    }
    if (c.notes != null && c.notes!.isNotEmpty) {
      _notesController.text = c.notes!;
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _vehiclePlateController.dispose();
    _vehicleModelController.dispose();
    _odometerController.dispose();
    _serviceTitleController.dispose();
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

            // ── Scrollable Create Work Form ──────────────────────────────────
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
                      // 1. Select Existing Customer or Quick Search
                      _buildCustomerSelectionCard(),
                      const SizedBox(height: 16),

                      // 2. Customer Information Section
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
                              label: 'Customer Name',
                              isRequired: true,
                              hint: 'Enter customer name',
                              controller: _customerNameController,
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
                      _buildInputField(
                        label: 'Alternate Phone',
                        hint: 'Enter alternate phone (optional)',
                        controller: _altPhoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 22),

                      // 3. Vehicle Information Section
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
                              controller: _vehiclePlateController,
                              textCapitalization: TextCapitalization.characters,
                              validator: (val) =>
                                  val == null || val.trim().isEmpty
                                  ? 'Vehicle plate is required'
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
                            child: _buildInputField(
                              label: 'Odometer (KM)',
                              hint: 'e.g. 45,200 km',
                              controller: _odometerController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildDropdownField(
                              label: 'Fuel Type',
                              hint: 'Select fuel',
                              value: _selectedFuelType,
                              items: _fuelTypes,
                              onChanged: (val) => setState(
                                () => _selectedFuelType = val ?? 'Petrol',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDropdownField(
                              label: 'Fuel Level (Tank)',
                              hint: 'Select level',
                              value: _selectedFuelLevel,
                              items: _fuelLevels,
                              onChanged: (val) => setState(
                                () => _selectedFuelLevel = val ?? 'Half (50%)',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),

                      // 4. Work & Service Details Section
                      _buildSectionHeader(
                        icon: Icons.build_outlined,
                        title: 'Work & Service Details',
                      ),
                      const SizedBox(height: 12),
                      _buildInputField(
                        label: 'Primary Work / Service Title',
                        isRequired: true,
                        hint: 'e.g. Brake Pad Replacement & General Inspection',
                        controller: _serviceTitleController,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Service title is required'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildDropdownField(
                              label: 'Service Category',
                              hint: 'Select category',
                              value: _selectedCategory,
                              items: _categories,
                              onChanged: (val) => setState(
                                () => _selectedCategory =
                                    val ?? 'General Service',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: _buildPrioritySelector()),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Promised Delivery Date & Time
                      _buildDeliveryDateTimeRow(),
                      const SizedBox(height: 22),

                      // 5. Staff Assignment & Status Section
                      _buildSectionHeader(
                        icon: Icons.assignment_ind_outlined,
                        title: 'Staff Assignment & Status',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildDropdownField(
                              label: 'Assigned Mechanic',
                              hint: 'Select staff',
                              value: _selectedStaff,
                              items: _staffList,
                              onChanged: (val) => setState(
                                () => _selectedStaff = val ?? 'Vikram Singh',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: _buildStatusDropdownField()),
                        ],
                      ),
                      const SizedBox(height: 22),

                      // 6. Customer Requirement & Notes Section
                      _buildSectionHeader(
                        icon: Icons.assignment_outlined,
                        title: 'Customer Requirements & Issues',
                      ),
                      const SizedBox(height: 8),
                      _buildInputField(
                        label: '',
                        hint: 'Enter customer complaints / requested tasks in detail...',
                        controller: _requirementController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 14),
                      _buildSectionHeader(
                        icon: Icons.edit_note_rounded,
                        title: 'Initial Inspection Notes (Optional)',
                      ),
                      const SizedBox(height: 8),
                      _buildInputField(
                        label: '',
                        hint: 'Enter mechanic preliminary notes or parts observations...',
                        controller: _notesController,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 22),

                      // 7. Pre-Inspection Photos Section
                      _buildPhotosInspectionSection(),
                      const SizedBox(height: 24),

                      // 8. Bottom Action Buttons (Cancel & Create Work Card)
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
                              onPressed: () => _handleCreateWork(),
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
                              child: Text(
                                _isEdit
                                    ? 'Update Work Card'
                                    : 'Create Work Card',
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        color: AppColors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _isEdit ? 'Edit Work' : 'Create Work',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),

              // Work ID Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  _generatedWorkId,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Select Existing Customer Card ───────────────────────────────────────────
  Widget _buildCustomerSelectionCard() {
    final existingCustomers = CustomerRepository.customers;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Auto-Fill From Existing Customer',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.flash_on, color: AppColors.accent, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.divider, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<CustomerModel>(
                value: _selectedCustomer,
                isExpanded: true,
                hint: const Text(
                  'Select customer (or enter new below)',
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.muted,
                  size: 20,
                ),
                dropdownColor: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                items: existingCustomers.map((cust) {
                  return DropdownMenuItem<CustomerModel>(
                    value: cust,
                    child: Text(
                      '${cust.name} • ${cust.vehiclePlate} (${cust.carModel})',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (cust) {
                  if (cust != null) {
                    setState(() {
                      _applyCustomerData(cust);
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Priority Selector Chips ─────────────────────────────────────────────────
  Widget _buildPrioritySelector() {
    final priorities = ['Normal', 'High', 'Urgent'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Priority',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.divider, width: 1),
          ),
          child: Row(
            children: priorities.map((p) {
              final isSelected = _selectedPriority == p;
              Color activeColor = AppColors.accent;
              if (p == 'Urgent') activeColor = AppColors.red;
              if (p == 'High') activeColor = AppColors.amber;

              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedPriority = p),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? activeColor.withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: activeColor, width: 1)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      p,
                      style: TextStyle(
                        color: isSelected ? activeColor : AppColors.muted,
                        fontSize: 11,
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
      ],
    );
  }

  // ── Delivery Date & Time Picker Row ─────────────────────────────────────────
  Widget _buildDeliveryDateTimeRow() {
    final formattedDate =
        '${_promisedDate.day} ${_getMonthName(_promisedDate.month)} ${_promisedDate.year}';
    final formattedTime = _promisedTime.format(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Promised Delivery Time',
          style: TextStyle(
            color: AppColors.muted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _pickDate(),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.divider, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.accent,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          formattedDate,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () => _pickTime(),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.divider, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: AppColors.accent,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          formattedTime,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Status Dropdown ─────────────────────────────────────────────────────────
  Widget _buildStatusDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Initial Status',
          style: TextStyle(
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
            child: DropdownButton<WorkStatus>(
              value: _selectedStatus,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.muted,
                size: 20,
              ),
              dropdownColor: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              items: const [
                DropdownMenuItem(
                  value: WorkStatus.inProgress,
                  child: Text(
                    'In Progress',
                    style: TextStyle(color: AppColors.blue, fontSize: 13),
                  ),
                ),
                DropdownMenuItem(
                  value: WorkStatus.pending,
                  child: Text(
                    'Pending',
                    style: TextStyle(color: AppColors.amber, fontSize: 13),
                  ),
                ),
                DropdownMenuItem(
                  value: WorkStatus.onHold,
                  child: Text(
                    'On Hold',
                    style: TextStyle(color: AppColors.red, fontSize: 13),
                  ),
                ),
                DropdownMenuItem(
                  value: WorkStatus.completed,
                  child: Text(
                    'Completed',
                    style: TextStyle(color: AppColors.green, fontSize: 13),
                  ),
                ),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedStatus = val);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // ── Pre-Inspection Photos Section ───────────────────────────────────────────
  Widget _buildPhotosInspectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader(
              icon: Icons.photo_camera_outlined,
              title: 'Pre-Inspection Photos',
            ),
            Text(
              '${_inspectionPhotos.length + _capturedPhotoFiles.length} Added',
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _pickPhoto(ImageSource.camera),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.card,
                  side: const BorderSide(color: AppColors.divider, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.accent,
                  size: 18,
                ),
                label: const Text(
                  'Take Photo',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _pickPhoto(ImageSource.gallery),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.card,
                  side: const BorderSide(color: AppColors.divider, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                icon: const Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.accent,
                  size: 18,
                ),
                label: const Text(
                  'Browse Gallery',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_inspectionPhotos.isNotEmpty || _capturedPhotoFiles.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ..._capturedPhotoFiles.map((file) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        file,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
                ..._inspectionPhotos.map((url) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        url,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
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

  // ── Dropdown Helper ─────────────────────────────────────────────────────────
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

  // ── Photo Picker Handler ────────────────────────────────────────────────────
  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final compressed = await ImageCompressor.pickAndCompress(
        source: source,
        targetKb: 5,
        maxDimension: 400,
      );

      if (compressed != null) {
        setState(() {
          _capturedPhotoFiles.add(compressed.file);
        });
      }
    } catch (e) {
      // Fallback sample photo for testing if device permissions are pending
      setState(() {
        _inspectionPhotos.add(
          'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?w=300&auto=format&fit=crop&q=80',
        );
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _promisedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accent,
              surface: AppColors.card,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _promisedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _promisedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accent,
              surface: AppColors.card,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _promisedTime = picked);
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  // ── Create Work Handler ─────────────────────────────────────────────────────
  void _handleCreateWork() {
    if (_formKey.currentState?.validate() ?? false) {
      final customerName = _customerNameController.text.trim();
      final phone = _phoneController.text.trim();
      final vehiclePlate = _vehiclePlateController.text.trim().toUpperCase();
      final brand = _selectedBrand ?? 'Hyundai';
      final model = _vehicleModelController.text.trim().isNotEmpty
          ? _vehicleModelController.text.trim()
          : '$brand i20';
      final service = _serviceTitleController.text.trim();

      final matchedStaff = StaffRepository.getStaffByName(_selectedStaff);
      final staffAvatar =
          matchedStaff?.avatarUrl ??
          _staffAvatars[_selectedStaff] ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=80';

      final carImage = _capturedPhotoFiles.isNotEmpty
          ? _capturedPhotoFiles.first.path
          : (_inspectionPhotos.isNotEmpty
              ? _inspectionPhotos.first
              : 'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?w=300&auto=format&fit=crop&q=80');

      if (_isEdit) {
        final updatedWork = widget.workToEdit!.copyWith(
          customerName: customerName,
          phone: phone,
          vehiclePlate: vehiclePlate,
          carModel: model,
          service: service.isNotEmpty ? service : null,
          assignedStaff: _selectedStaff,
          status: _selectedStatus,
          staffAvatarUrl: staffAvatar,
          carImageUrl: _capturedPhotoFiles.isNotEmpty
              ? _capturedPhotoFiles.first.path
              : widget.workToEdit!.carImageUrl,
        );

        WorkRepository.updateWork(updatedWork);

        _showSuccessDialog(
          title: 'Work Card Updated!',
          message:
              'Work "$_generatedWorkId" for $customerName ($vehiclePlate) has been updated successfully.',
          onDismiss: () {
            Navigator.pop(context, updatedWork);
          },
        );
      } else {
        final newWork = WorkModel(
          workId: _generatedWorkId,
          customerName: customerName,
          phone: phone,
          vehiclePlate: vehiclePlate,
          carModel: model,
          service: service.isNotEmpty ? service : null,
          assignedStaff: _selectedStaff,
          date:
              '${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
          time:
              '${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')} ${TimeOfDay.now().period == DayPeriod.am ? 'AM' : 'PM'}',
          status: _selectedStatus,
          carImageUrl: carImage,
          staffAvatarUrl: staffAvatar,
        );

        // Add to dynamic repository
        WorkRepository.addWork(newWork);

        _showSuccessDialog(
          title: 'Work Card Created!',
          message:
              'Work "$_generatedWorkId" for $customerName ($vehiclePlate) has been created successfully.',
          onDismiss: () {
            Navigator.pop(context, newWork);
          },
        );
      }
    }
  }

  // ── Center Success Dialog ───────────────────────────────────────────────────
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
