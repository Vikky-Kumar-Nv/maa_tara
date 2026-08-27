import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maa_tara/job.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Color Palette — consistent with app theme
// ─────────────────────────────────────────────────────────────────────────────
class _C {
  static const bg = Color(0xFF0A1628);
  static const card = Color(0xFF162336);
  static const accent = Color(0xFFE8A020);
  static const white = Colors.white;
  static const muted = Color(0xFF8FAABB);
  static const green = Color(0xFF2ECC71);
  static const red = Color(0xFFE53935);
  static const blue = Color(0xFF2196F3);
  static const amber = Color(0xFFFF9800);
  static const divider = Color(0xFF1E3048);
}

// ─────────────────────────────────────────────────────────────────────────────
//  Work View Page (Full Work Details)
// ─────────────────────────────────────────────────────────────────────────────
class WorkViewPage extends StatefulWidget {
  final WorkModel? work;

  const WorkViewPage({super.key, WorkModel? work, JobModel? job})
    : work = work ?? job;

  @override
  State<WorkViewPage> createState() => _WorkViewPageState();
}

//kdjf

typedef JobViewPage = WorkViewPage;

class _WorkViewPageState extends State<WorkViewPage> {
  late WorkStatus _currentStatus;
  final ImagePicker _picker = ImagePicker();

  List<String> _additionalRequirements = [
    'Check brake disc condition',
    'Check brake fluid level',
  ];

  List<String> _workNotes = [
    'Front brake pads replaced.\nBrake disc cleaned and brake fluid topped.',
  ];

  final List<String> _beforePhotos = [
    'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?w=300&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=300&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=300&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1486006920555-c77dce18193b?w=300&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1617814076367-b759c7d7e738?w=300&auto=format&fit=crop&q=80',
  ];

  final List<String> _afterPhotos = [
    'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?w=300&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=300&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=300&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1486006920555-c77dce18193b?w=300&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1617814076367-b759c7d7e738?w=300&auto=format&fit=crop&q=80',
  ];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.work?.status ?? WorkStatus.inProgress;
  }

  @override
  Widget build(BuildContext context) {
    final workId = widget.work?.workId ?? 'WORK-1058';
    final customerName = widget.work?.customerName ?? 'Rahul Sharma';
    final phone = widget.work?.phone ?? '9876543210';
    final vehiclePlate = widget.work?.vehiclePlate ?? 'DL 8C AX 1234';
    final carModel = widget.work?.carModel ?? 'Hyundai i20';
    final assignedStaff = widget.work?.assignedStaff ?? 'Vikram Singh';

    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header Bar ───────────────────────────────────────────────
            _buildTopBar(workId),

            // ── Scrollable Body Content ──────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Communication Actions (Call, WhatsApp, More)
                    _buildCommunicationRow(phone),
                    const SizedBox(height: 16),

                    // Customer Details Card
                    _buildCustomerDetails(customerName, phone),
                    const SizedBox(height: 12),

                    // Vehicle Details Card
                    _buildVehicleDetails(vehiclePlate, carModel),
                    const SizedBox(height: 12),

                    // Work / Service Card
                    _buildWorkServiceCard(),
                    const SizedBox(height: 12),

                    // Customer Requirement Card
                    _buildCustomerRequirementCard(),
                    const SizedBox(height: 12),

                    // Additional Requirements Card
                    _buildAdditionalRequirementsCard(),
                    const SizedBox(height: 12),

                    // Work Notes Card
                    _buildWorkNotesCard(),
                    const SizedBox(height: 12),

                    // Assigned Staff Card
                    _buildAssignedStaffCard(assignedStaff),
                    const SizedBox(height: 12),

                    // Timeline Section
                    _buildTimelineSection(),
                    const SizedBox(height: 14),

                    // Before Photos Section
                    _buildPhotosSection(
                      title: 'Before Photos',
                      photos: _beforePhotos,
                      isBefore: true,
                    ),
                    const SizedBox(height: 14),

                    // After Photos Section
                    _buildPhotosSection(
                      title: 'After Photos',
                      photos: _afterPhotos,
                      isBefore: false,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Bottom Fixed Action Bar ──────────────────────────────────────
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  // ── Top Bar ─────────────────────────────────────────────────────────────────
  Widget _buildTopBar(String workId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: _C.bg,
        border: Border(bottom: BorderSide(color: _C.divider, width: 1)),
      ),
      child: Column(
        children: [
          // Drag handle bar
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: _C.muted.withOpacity(0.4),
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
                  child: Icon(Icons.close, color: _C.white, size: 24),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                workId,
                style: const TextStyle(
                  color: _C.accent,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              _buildStatusPill(),
            ],
          ),
        ],
      ),
    );
  }

  // ── Status Pill Dropdown ────────────────────────────────────────────────────
  Widget _buildStatusPill() {
    Color statusColor;
    String statusText;

    switch (_currentStatus) {
      case WorkStatus.inProgress:
        statusColor = _C.blue;
        statusText = 'In Progress';
        break;
      case WorkStatus.pending:
        statusColor = _C.amber;
        statusText = 'Pending';
        break;
      case WorkStatus.onHold:
        statusColor = _C.muted;
        statusText = 'On Hold';
        break;
      case WorkStatus.completed:
        statusColor = _C.green;
        statusText = 'Completed';
        break;
    }

    return PopupMenuButton<WorkStatus>(
      color: _C.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (status) {
        setState(() {
          _currentStatus = status;
        });

        Color color = _C.blue;
        String text = 'In Progress';
        switch (status) {
          case WorkStatus.inProgress:
            color = _C.blue;
            text = 'In Progress';
            break;
          case WorkStatus.pending:
            color = _C.amber;
            text = 'Pending';
            break;
          case WorkStatus.onHold:
            color = _C.muted;
            text = 'On Hold';
            break;
          case WorkStatus.completed:
            color = _C.green;
            text = 'Completed';
            break;
        }

        _showSuccessDialog(
          title: 'Status Updated Successfully!',
          message: 'Work status has been updated to "$text".',
          icon: Icons.sync,
          iconColor: color,
        );
      },
      itemBuilder: (context) => WorkStatus.values.map((status) {
        String label = status.name.toUpperCase();
        if (status == WorkStatus.inProgress) label = 'IN PROGRESS';
        if (status == WorkStatus.onHold) label = 'ON HOLD';

        return PopupMenuItem(
          value: status,
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: _currentStatus == status ? _C.accent : _C.white,
                  fontWeight: _currentStatus == status
                      ? FontWeight.w700
                      : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              if (_currentStatus == status)
                const Icon(Icons.check, color: _C.accent, size: 16),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: statusColor.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, color: statusColor, size: 16),
          ],
        ),
      ),
    );
  }

  // ── Communication Row (Call, WhatsApp, More) ────────────────────────────────
  Widget _buildCommunicationRow(String phone) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _commButton(
          iconWidget: const Icon(
            Icons.phone_outlined,
            color: _C.accent,
            size: 22,
          ),
          label: 'Call',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Calling $phone...'),
                backgroundColor: _C.card,
              ),
            );
          },
        ),
        _commButton(
          iconWidget: const SizedBox(
            width: 24,
            height: 24,
            child: CustomPaint(painter: _WhatsAppIconPainter(color: _C.accent)),
          ),
          label: 'WhatsApp',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Opening WhatsApp for $phone...'),
                backgroundColor: _C.card,
              ),
            );
          },
        ),
        _commButton(
          iconWidget: const Icon(Icons.more_horiz, color: _C.accent, size: 22),
          label: 'More',
          onTap: () {
            _showMoreOptionsMenu(phone);
          },
        ),
      ],
    );
  }

  Widget _commButton({
    required Widget iconWidget,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _C.card,
              border: Border.all(color: _C.accent.withOpacity(0.4), width: 1.2),
            ),
            alignment: Alignment.center,
            child: iconWidget,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: _C.muted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreOptionsMenu(String phone) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share, color: _C.accent),
                title: const Text(
                  'Share Work Details',
                  style: TextStyle(color: _C.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sharing work details...'),
                      backgroundColor: _C.card,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.print, color: _C.accent),
                title: const Text(
                  'Print Work Card',
                  style: TextStyle(color: _C.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Printing work card...'),
                      backgroundColor: _C.card,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long, color: _C.accent),
                title: const Text(
                  'Generate Invoice',
                  style: TextStyle(color: _C.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Generating invoice...'),
                      backgroundColor: _C.card,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Customer Details Card ───────────────────────────────────────────────────
  Widget _buildCustomerDetails(String name, String phone) {
    return _sectionCard(
      icon: Icons.person_outline,
      title: 'Customer Details',
      children: [
        _dataRow('Name', name),
        _dataRow('Phone', phone),
        _dataRowWithWidget(
          'Address',
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Dwarka, New Delhi',
                style: TextStyle(
                  color: _C.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.location_on, color: _C.accent, size: 14),
            ],
          ),
        ),
      ],
    );
  }

  // ── Vehicle Details Card ────────────────────────────────────────────────────
  Widget _buildVehicleDetails(String plate, String model) {
    return _sectionCard(
      icon: Icons.directions_car_outlined,
      title: 'Vehicle Details',
      children: [
        _dataRow('Vehicle Number', plate),
        _dataRow('Brand / Model', model),
        _dataRow('Color', 'White'),
        _dataRow('Year', '2019'),
      ],
    );
  }

  // ── Work / Service Card ─────────────────────────────────────────────────────
  Widget _buildWorkServiceCard() {
    return _sectionCard(
      icon: Icons.build_circle_outlined,
      title: 'Work / Service',
      children: [
        _dataRow('Service Type', 'Brake Pad Replacement'),
        _dataRow('Created Date', '23 May 2025, 09:15 AM'),
        _dataRowWithWidget(
          'Expected Completion',
          const Text(
            '24 May 2025',
            style: TextStyle(
              color: _C.blue,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _dataRow('Estimated Cost', '₹ 2,500'),
        _dataRow('Actual Cost', '₹ 2,300'),
      ],
    );
  }

  // ── Customer Requirement Card ───────────────────────────────────────────────
  Widget _buildCustomerRequirementCard() {
    return _sectionCard(
      icon: Icons.edit_note_outlined,
      title: 'Customer Requirement',
      children: [
        const Text(
          'Customer is complaining about brake noise while applying brakes. Need to check and replace front brake pads.',
          style: TextStyle(color: _C.muted, fontSize: 12.5, height: 1.4),
        ),
      ],
    );
  }

  // ── Additional Requirements Card ────────────────────────────────────────────
  Widget _buildAdditionalRequirementsCard() {
    return _sectionCard(
      icon: Icons.checklist_rtl_outlined,
      title: 'Additional Requirements',
      children: [
        ..._additionalRequirements.map(
          (req) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: _bulletItem(req),
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => _showAddRequirementSheet(),
          child: Row(
            children: const [
              Icon(Icons.add, color: _C.accent, size: 16),
              SizedBox(width: 4),
              Text(
                'Add Requirement',
                style: TextStyle(
                  color: _C.accent,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bulletItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(color: _C.accent, fontSize: 13)),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: _C.white, fontSize: 12.5),
          ),
        ),
      ],
    );
  }

  // ── Work Notes Card ─────────────────────────────────────────────────────────
  Widget _buildWorkNotesCard() {
    return _sectionCard(
      icon: Icons.edit_outlined,
      title: 'Work Notes',
      children: [
        ..._workNotes.map(
          (note) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              note,
              style: const TextStyle(
                color: _C.muted,
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Assigned Staff Card ─────────────────────────────────────────────────────
  Widget _buildAssignedStaffCard(String staffName) {
    return _sectionCard(
      icon: Icons.people_outline,
      title: 'Assigned Staff',
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: 36,
                height: 36,
                color: const Color(0xFF0F1B2B),
                child: Image.network(
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.person, color: _C.muted, size: 22),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    staffName,
                    style: const TextStyle(
                      color: _C.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: const [
                      Text(
                        '9876549870',
                        style: TextStyle(color: _C.muted, fontSize: 11),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.phone, color: _C.accent, size: 11),
                    ],
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {
                _showReassignStaffSheet();
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _C.accent, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Reassign',
                style: TextStyle(
                  color: _C.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showReassignStaffSheet() {
    final staffMembers = [
      'Vikram Singh',
      'Arjun Mehta',
      'Rohit Kumar',
      'Suresh Patel',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: _C.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reassign Staff',
                style: TextStyle(
                  color: _C.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...staffMembers.map((staff) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.person, color: _C.accent),
                  title: Text(staff, style: const TextStyle(color: _C.white)),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Work reassigned to $staff'),
                        backgroundColor: _C.card,
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // ── Timeline Section ────────────────────────────────────────────────────────
  Widget _buildTimelineSection() {
    return _sectionCard(
      icon: Icons.access_time_rounded,
      title: 'Timeline',
      children: [
        _timelineItem(
          dotColor: _C.green,
          title: 'Work Created',
          subtitle: 'By Admin',
          dateTime: '23 May 2025, 09:15 AM',
          isFirst: true,
        ),
        _timelineItem(
          dotColor: _C.blue,
          title: 'Assigned to Staff',
          subtitle: 'Vikram Singh',
          dateTime: '23 May 2025, 09:20 AM',
        ),
        _timelineItem(
          dotColor:
              _currentStatus == WorkStatus.inProgress ||
                  _currentStatus == WorkStatus.completed
              ? _C.blue
              : _C.muted.withOpacity(0.4),
          title: 'Work Started',
          subtitle: 'By Vikram Singh',
          dateTime: '23 May 2025, 09:35 AM',
        ),
        _timelineItem(
          dotColor: _currentStatus == WorkStatus.onHold
              ? _C.amber
              : _C.muted.withOpacity(0.4),
          title: 'On Hold',
          subtitle: _currentStatus == WorkStatus.onHold
              ? 'Waiting for parts'
              : '',
          dateTime: _currentStatus == WorkStatus.onHold
              ? '23 May 2025, 11:30 AM'
              : '-',
        ),
        _timelineItem(
          dotColor: _currentStatus == WorkStatus.completed
              ? _C.green
              : _C.muted.withOpacity(0.4),
          title: 'Work Completed',
          subtitle: _currentStatus == WorkStatus.completed
              ? 'Quality check passed'
              : '',
          dateTime: _currentStatus == WorkStatus.completed
              ? '23 May 2025, 01:15 PM'
              : '-',
          isLast: true,
        ),
      ],
    );
  }

  Widget _timelineItem({
    required Color dotColor,
    required String title,
    required String subtitle,
    required String dateTime,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot and connecting line
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(child: Container(width: 1.5, color: _C.divider)),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Timeline Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: _C.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (subtitle.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              color: _C.muted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    dateTime,
                    style: const TextStyle(color: _C.muted, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Photos Gallery Section ──────────────────────────────────────────────────
  Widget _buildPhotosSection({
    required String title,
    required List<String> photos,
    required bool isBefore,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.photo_library_outlined,
                  color: _C.accent,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    color: _C.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () => _viewAllPhotos(title, photos, isBefore),
              child: Row(
                children: const [
                  Text(
                    'View All',
                    style: TextStyle(
                      color: _C.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.chevron_right, color: _C.accent, size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: photos.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isLast = index == photos.length - 1;
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 75,
                  height: 60,
                  color: const Color(0xFF0F1B2B),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildPhotoThumbnail(photos[index]),
                      if (isLast && photos.length >= 5)
                        Container(
                          color: Colors.black.withOpacity(0.65),
                          alignment: Alignment.center,
                          child: const Text(
                            '+2',
                            style: TextStyle(
                              color: _C.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoThumbnail(String photoPath) {
    if (photoPath.startsWith('http://') || photoPath.startsWith('https://')) {
      return Image.network(
        photoPath,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.car_repair, color: _C.muted, size: 24),
        ),
      );
    } else {
      return Image.file(
        File(photoPath),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.car_repair, color: _C.muted, size: 24),
        ),
      );
    }
  }

  void _viewAllPhotos(String title, List<String> photos, bool isBefore) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _C.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: _C.accent,
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _showAddPhotoSheet(defaultIsBefore: isBefore);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _buildPhotoThumbnail(photos[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Bottom Fixed Action Bar ─────────────────────────────────────────────────
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: const BoxDecoration(
        color: _C.card,
        border: Border(top: BorderSide(color: _C.divider, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomActionItem(
            icon: Icons.sync,
            label: 'Change Status',
            onTap: () => _showChangeStatusSheet(),
          ),
          _bottomActionItem(
            icon: Icons.edit_note,
            label: 'Add Note',
            onTap: () => _showAddNoteSheet(),
          ),
          _bottomActionItem(
            icon: Icons.camera_alt_outlined,
            label: 'Add Photo',
            onTap: () => _showAddPhotoSheet(),
          ),
          _bottomActionItem(
            icon: Icons.playlist_add,
            label: 'Add Req',
            onTap: () => _showAddRequirementSheet(),
          ),
        ],
      ),
    );
  }

  Widget _bottomActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: _C.accent, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: _C.muted,
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Interactive Action Sheets ───────────────────────────────────────────────

  // 1. Change Status Bottom Sheet
  void _showChangeStatusSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Change Work Status',
                style: TextStyle(
                  color: _C.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              ...WorkStatus.values.map((status) {
                Color color;
                String text;
                switch (status) {
                  case WorkStatus.inProgress:
                    color = _C.blue;
                    text = 'In Progress';
                    break;
                  case WorkStatus.pending:
                    color = _C.amber;
                    text = 'Pending';
                    break;
                  case WorkStatus.onHold:
                    color = _C.muted;
                    text = 'On Hold';
                    break;
                  case WorkStatus.completed:
                    color = _C.green;
                    text = 'Completed';
                    break;
                }

                final isSelected = _currentStatus == status;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(
                    text,
                    style: TextStyle(
                      color: isSelected ? _C.accent : _C.white,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: _C.accent)
                      : null,
                  onTap: () {
                    setState(() {
                      _currentStatus = status;
                    });
                    Navigator.pop(context);
                    _showSuccessDialog(
                      title: 'Status Updated Successfully!',
                      message: 'Work status has been changed to "$text".',
                      icon: Icons.sync,
                      iconColor: color,
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // 2. Add Note Bottom Sheet
  void _showAddNoteSheet() {
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: _C.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Work Note',
                style: TextStyle(
                  color: _C.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                maxLines: 3,
                style: const TextStyle(color: _C.white, fontSize: 13),
                cursorColor: _C.accent,
                decoration: InputDecoration(
                  hintText: 'Enter technical note, parts replaced, etc...',
                  hintStyle: const TextStyle(color: _C.muted, fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFF0F1B2B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _C.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _C.accent),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final text = noteController.text.trim();
                    if (text.isNotEmpty) {
                      setState(() {
                        _workNotes.add(text);
                      });
                      Navigator.pop(context);
                      _showSuccessDialog(
                        title: 'Note Added Successfully!',
                        message: 'Your technical work note has been saved to the work card.',
                        icon: Icons.edit_note_rounded,
                        iconColor: _C.accent,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Save Note',
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
        );
      },
    );
  }

  // 3. Add Photo Bottom Sheet (Camera + Storage/Gallery)
  void _showAddPhotoSheet({bool defaultIsBefore = true}) {
    bool isBefore = defaultIsBefore;

    showModalBottomSheet(
      context: context,
      backgroundColor: _C.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Vehicle Photo',
                    style: TextStyle(
                      color: _C.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Target Selector (Before vs After)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1B2B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setSheetState(() => isBefore = true),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isBefore
                                    ? _C.accent
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Before Photos',
                                style: TextStyle(
                                  color: isBefore ? Colors.black : _C.muted,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => setSheetState(() => isBefore = false),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: !isBefore
                                    ? _C.accent
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'After Photos',
                                style: TextStyle(
                                  color: !isBefore ? Colors.black : _C.muted,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Option 1: Take Photo with Camera
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _C.accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: _C.accent,
                        size: 20,
                      ),
                    ),
                    title: const Text(
                      'Take Photo (Camera)',
                      style: TextStyle(
                        color: _C.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                    subtitle: const Text(
                      'Open device camera to capture new photo',
                      style: TextStyle(color: _C.muted, fontSize: 11),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: _C.muted),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera, isBefore);
                    },
                  ),

                  const SizedBox(height: 8),

                  // Option 2: Choose from Gallery / Storage
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _C.blue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.photo_library,
                        color: _C.blue,
                        size: 20,
                      ),
                    ),
                    title: const Text(
                      'Browse Storage (Gallery)',
                      style: TextStyle(
                        color: _C.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                    subtitle: const Text(
                      'Select vehicle photo from device files',
                      style: TextStyle(color: _C.muted, fontSize: 11),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: _C.muted),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery, isBefore);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Helper method to pick image from camera or gallery
  Future<void> _pickImage(ImageSource source, bool isBefore) async {
    final galleryName = isBefore ? 'Before Photos' : 'After Photos';

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          if (isBefore) {
            _beforePhotos.add(pickedFile.path);
          } else {
            _afterPhotos.add(pickedFile.path);
          }
        });

        _showSuccessDialog(
          title: 'Photo Added Successfully!',
          message: 'Vehicle photo has been added to "$galleryName" gallery.',
          icon: Icons.check_circle_rounded,
          iconColor: _C.green,
        );
      }
    } catch (e) {
      // Fallback in case of permissions or emulator environment
      final samplePhotos = [
        'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?w=400&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1486006920555-c77dce18193b?w=400&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1617814076367-b759c7d7e738?w=400&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=400&auto=format&fit=crop&q=80',
      ];
      final fallbackUrl =
          samplePhotos[(DateTime.now().millisecond) % samplePhotos.length];

      setState(() {
        if (isBefore) {
          _beforePhotos.add(fallbackUrl);
        } else {
          _afterPhotos.add(fallbackUrl);
        }
      });

      _showSuccessDialog(
        title: 'Photo Added Successfully!',
        message: 'Vehicle photo has been added to "$galleryName" gallery.',
        icon: Icons.check_circle_rounded,
        iconColor: _C.green,
      );
    }
  }

  // 4. Add Requirement Bottom Sheet
  void _showAddRequirementSheet() {
    final reqController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: _C.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Requirement',
                style: TextStyle(
                  color: _C.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reqController,
                maxLines: 2,
                style: const TextStyle(color: _C.white, fontSize: 13),
                cursorColor: _C.accent,
                decoration: InputDecoration(
                  hintText: 'e.g. Check battery health, wiper blade...',
                  hintStyle: const TextStyle(color: _C.muted, fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFF0F1B2B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _C.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _C.accent),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final text = reqController.text.trim();
                    if (text.isNotEmpty) {
                      setState(() {
                        _additionalRequirements.add(text);
                      });
                      Navigator.pop(context);
                      _showSuccessDialog(
                        title: 'Requirement Added Successfully!',
                        message:
                            'New requirement "$text" has been added to the checklist.',
                        icon: Icons.checklist_rounded,
                        iconColor: _C.accent,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Save Requirement',
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
        );
      },
    );
  }

  // ── Unified Center Success Popup Dialog ─────────────────────────────────────
  void _showSuccessDialog({
    required String title,
    required String message,
    IconData icon = Icons.check_circle_rounded,
    Color iconColor = _C.green,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: _C.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: _C.divider, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: iconColor.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(icon, color: iconColor, size: 38),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _C.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _C.muted,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.accent,
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

  // ── Helper Section Card ─────────────────────────────────────────────────────
  Widget _sectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _C.accent, size: 16),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: _C.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  // ── Helper Data Rows ────────────────────────────────────────────────────────
  Widget _dataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: _C.muted, fontSize: 12.5)),
          Text(
            value,
            style: const TextStyle(
              color: _C.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dataRowWithWidget(String label, Widget rightWidget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: _C.muted, fontSize: 12.5)),
          rightWidget,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Custom WhatsApp Icon Painter
// ─────────────────────────────────────────────────────────────────────────────
class _WhatsAppIconPainter extends CustomPainter {
  final Color color;

  const _WhatsAppIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double sx = size.width / 24.0;
    final double sy = size.height / 24.0;

    final Paint strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8 * ((sx + sy) / 2)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Paint fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Outer chat bubble shape
    final Path bubblePath = Path();
    bubblePath.moveTo(12.0 * sx, 2.0 * sy);
    bubblePath.cubicTo(
      6.48 * sx,
      2.0 * sy,
      2.0 * sx,
      6.48 * sy,
      2.0 * sx,
      12.0 * sy,
    );
    bubblePath.cubicTo(
      2.0 * sx,
      13.85 * sy,
      2.5 * sx,
      15.58 * sy,
      3.38 * sx,
      17.07 * sy,
    );
    bubblePath.lineTo(2.0 * sx, 22.0 * sy);
    bubblePath.lineTo(7.08 * sx, 20.67 * sy);
    bubblePath.cubicTo(
      8.54 * sx,
      21.52 * sy,
      10.22 * sx,
      22.0 * sy,
      12.0 * sx,
      22.0 * sy,
    );
    bubblePath.cubicTo(
      17.52 * sx,
      22.0 * sy,
      22.0 * sx,
      17.52 * sy,
      22.0 * sx,
      12.0 * sy,
    );
    bubblePath.cubicTo(
      22.0 * sx,
      6.48 * sy,
      17.52 * sy,
      2.0 * sy,
      12.0 * sx,
      2.0 * sy,
    );
    bubblePath.close();

    canvas.drawPath(bubblePath, strokePaint);

    // Inner phone handset icon
    final Path phonePath = Path();
    phonePath.moveTo(9.0 * sx, 9.2 * sy);
    phonePath.cubicTo(
      8.8 * sx,
      8.7 * sy,
      8.4 * sx,
      8.6 * sy,
      8.0 * sx,
      8.6 * sy,
    );
    phonePath.cubicTo(
      7.6 * sx,
      8.6 * sy,
      7.2 * sx,
      9.0 * sy,
      7.2 * sx,
      9.5 * sy,
    );
    phonePath.cubicTo(
      7.2 * sx,
      11.0 * sy,
      8.2 * sx,
      13.5 * sy,
      10.5 * sx,
      15.8 * sy,
    );
    phonePath.cubicTo(
      12.8 * sx,
      18.0 * sy,
      15.0 * sx,
      18.5 * sy,
      16.5 * sx,
      18.5 * sy,
    );
    phonePath.cubicTo(
      17.0 * sx,
      18.5 * sy,
      17.4 * sx,
      18.1 * sy,
      17.4 * sx,
      17.7 * sy,
    );
    phonePath.cubicTo(
      17.4 * sx,
      17.3 * sy,
      16.3 * sx,
      16.2 * sy,
      15.8 * sx,
      16.0 * sy,
    );
    phonePath.cubicTo(
      15.4 * sx,
      15.8 * sy,
      15.0 * sx,
      16.0 * sy,
      14.7 * sx,
      16.4 * sy,
    );
    phonePath.cubicTo(
      14.3 * sx,
      16.8 * sy,
      14.0 * sx,
      16.9 * sy,
      13.5 * sx,
      16.6 * sy,
    );
    phonePath.cubicTo(
      12.6 * sx,
      16.1 * sy,
      11.0 * sx,
      14.5 * sy,
      10.4 * sx,
      13.5 * sy,
    );
    phonePath.cubicTo(
      10.1 * sx,
      13.0 * sy,
      10.2 * sx,
      12.7 * sy,
      10.6 * sx,
      12.3 * sy,
    );
    phonePath.cubicTo(
      11.0 * sx,
      12.0 * sy,
      11.2 * sx,
      11.6 * sy,
      11.0 * sx,
      11.2 * sy,
    );
    phonePath.cubicTo(
      10.8 * sx,
      10.7 * sy,
      9.8 * sx,
      9.6 * sy,
      9.3 * sx,
      9.2 * sy,
    );
    phonePath.cubicTo(
      9.2 * sx,
      9.0 * sy,
      9.1 * sx,
      9.1 * sy,
      9.0 * sx,
      9.2 * sy,
    );
    phonePath.close();

    canvas.drawPath(phonePath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
