import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/features/staff/add_staff.dart';
import 'package:maa_tara/features/staff/staff_attendance_log.dart';
import 'package:maa_tara/features/staff/staff_list.dart';
import 'package:maa_tara/features/staff/staff_work_history.dart';
import 'package:maa_tara/features/work/create_work.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Staff Details Page
// ─────────────────────────────────────────────────────────────────────────────
class StaffDetailsPage extends StatefulWidget {
  final StaffModel staff;

  const StaffDetailsPage({super.key, required this.staff});

  @override
  State<StaffDetailsPage> createState() => _StaffDetailsPageState();
}

class _StaffDetailsPageState extends State<StaffDetailsPage> {
  late StaffModel _s;

  @override
  void initState() {
    super.initState();
    _s = widget.staff;
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

            // ── Scrollable Staff Profile Body ────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header Card
                    _buildProfileHeaderCard(),
                    const SizedBox(height: 14),

                    // Quick Actions Row (Call, WhatsApp, Edit, More)
                    _buildQuickActionButtons(),
                    const SizedBox(height: 18),

                    // 1. Personal Information Section
                    _buildSectionHeader(
                      icon: Icons.person_outline_rounded,
                      title: 'Personal Information',
                    ),
                    const SizedBox(height: 10),
                    _buildInfoCard([
                      _InfoRow('Full Name', _s.name),
                      _InfoRow('Email', _s.email),
                      _InfoRow('Role', _s.role),
                      _InfoRow('Joining Date', _s.joiningDate),
                      _InfoRow('Status', _s.status, isStatus: true),
                    ]),
                    const SizedBox(height: 18),

                    // 2. Today's Summary Section
                    _buildSectionHeader(
                      icon: Icons.pie_chart_outline_rounded,
                      title: "Today's Summary",
                    ),
                    const SizedBox(height: 10),
                    _buildSummaryCard(),
                    const SizedBox(height: 18),

                    // 3. Today's Attendance Section
                    _buildSectionHeader(
                      icon: Icons.calendar_month_outlined,
                      title: "Today's Attendance",
                      trailing: _buildAttendancePill(_s.attendance),
                    ),
                    const SizedBox(height: 10),
                    _buildAttendanceCard(),
                    const SizedBox(height: 18),

                    // 4. Current Work Section
                    _buildSectionHeader(
                      icon: Icons.work_outline_rounded,
                      title: 'Current Work',
                    ),
                    const SizedBox(height: 10),
                    _buildCurrentWorkCard(),
                    const SizedBox(height: 24),

                    // 5. Bottom Action Buttons (Assign Work & Suspend)
                    _buildBottomActionButtons(),
                    const SizedBox(height: 30),
                  ],
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
          // Drag handle
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
                'Staff Details',
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

  // ── Profile Header Card ─────────────────────────────────────────────────────
  Widget _buildProfileHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar Image
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.network(
              _s.avatarUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.inputFill,
                  border: Border.all(color: AppColors.accent, width: 1),
                ),
                alignment: Alignment.center,
                child: Text(
                  _s.initials,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Name, Role, Phone, Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _s.name,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildStatusPill(_s.status),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _s.role,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _s.phone,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.phone, color: AppColors.accent, size: 12),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick Action Buttons (Call, WhatsApp, Edit, More) ───────────────────────
  Widget _buildQuickActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _quickActionButton(
            icon: Icons.phone_outlined,
            label: 'Call',
            onTap: () => _showToast('Calling ${_s.phone}...'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _quickActionButton(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'WhatsApp',
            onTap: () => _showToast('Opening WhatsApp for ${_s.phone}...'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _quickActionButton(
            icon: Icons.edit_outlined,
            label: 'Edit',
            onTap: () async {
              final updated = await Navigator.push<StaffModel>(
                context,
                MaterialPageRoute(
                  builder: (context) => AddStaffPage(staffToEdit: _s),
                ),
              );
              if (updated != null) {
                setState(() => _s = updated);
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _quickActionButton(
            icon: Icons.more_horiz,
            label: 'More',
            onTap: () => _showMoreActions(),
          ),
        ),
      ],
    );
  }

  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: AppColors.accent.withValues(alpha: 0.2),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.divider, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.accent, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Today's Summary Card ────────────────────────────────────────────────────
  Widget _buildSummaryCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StaffWorkHistoryPage(staff: _s),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
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
              children: [
                _buildSummaryItem(
                  "Today's Works",
                  '${_s.todayWorks}',
                  AppColors.blue,
                ),
                _buildSummaryItem(
                  'Completed',
                  '${_s.completedWorks}',
                  AppColors.green,
                ),
                _buildSummaryItem('Pending', '${_s.pendingWorks}', AppColors.red),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.divider, height: 1, thickness: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Work',
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                Row(
                  children: [
                    Text(
                      _s.currentWork,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.accent,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ── Today's Attendance Card ─────────────────────────────────────────────────
  Widget _buildAttendanceCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StaffAttendanceLogPage(staff: _s),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Check In',
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                Text(
                  _s.checkInTime,
                  style: const TextStyle(
                    color: AppColors.green,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Check Out',
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                Text(
                  _s.checkOutTime,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Monthly Log Details',
                  style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.chevron_right, color: AppColors.accent, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Current Work Card ───────────────────────────────────────────────────────
  Widget _buildCurrentWorkCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        children: [
          _buildWorkRow('Work ID', _s.currentWorkId, isHighlighted: true),
          const SizedBox(height: 8),
          _buildWorkRow('Customer', _s.currentCustomer),
          const SizedBox(height: 8),
          _buildWorkRow('Vehicle', _s.currentVehicle),
          const SizedBox(height: 8),
          _buildWorkRow('Work', _s.currentWork),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Status',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              Text(
                'In Progress',
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkRow(
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 12),
        ),
        Text(
          value,
          style: TextStyle(
            color: isHighlighted ? AppColors.accent : AppColors.white,
            fontSize: 12.5,
            fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ── Bottom Action Buttons (Assign Work & Suspend) ───────────────────────────
  Widget _buildBottomActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateWorkPage()),
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.card,
              side: const BorderSide(color: AppColors.divider, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: const Icon(
              Icons.person_add_alt_1_outlined,
              color: AppColors.accent,
              size: 18,
            ),
            label: const Text(
              'Assign Work',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _confirmSuspendStaff(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red.withValues(alpha: 0.25),
              side: BorderSide(
                color: AppColors.red.withValues(alpha: 0.6),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
            ),
            icon: const Icon(Icons.block, color: AppColors.red, size: 18),
            label: const Text(
              'Suspend',
              style: TextStyle(
                color: AppColors.red,
                fontWeight: FontWeight.w800,
                fontSize: 13.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Section Header Helper ───────────────────────────────────────────────────
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
        ),
        ?trailing,
      ],
    );
  }

  // ── Info Card Helper ────────────────────────────────────────────────────────
  Widget _buildInfoCard(List<_InfoRow> rows) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        children: rows.map((r) {
          final isLast = rows.indexOf(r) == rows.length - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  r.label,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (r.isStatus)
                  Text(
                    r.value,
                    style: const TextStyle(
                      color: AppColors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                else
                  Text(
                    r.value,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Status & Attendance Pills ───────────────────────────────────────────────
  Widget _buildStatusPill(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.green.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: AppColors.green,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildAttendancePill(String attendance) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        attendance,
        style: const TextStyle(
          color: AppColors.green,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ── Modals & Action Feedback ────────────────────────────────────────────────
  void _confirmSuspendStaff() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.divider),
        ),
        title: const Text(
          'Suspend Staff',
          style: TextStyle(color: AppColors.white),
        ),
        content: Text(
          'Are you sure you want to suspend ${_s.name}?',
          style: const TextStyle(color: AppColors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.muted),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showToast('${_s.name} suspended');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            child: const Text('Suspend', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showMoreActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.history, color: AppColors.accent),
                title: const Text(
                  'View Work History',
                  style: TextStyle(color: AppColors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StaffWorkHistoryPage(staff: _s),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.calendar_today,
                  color: AppColors.accent,
                ),
                title: const Text(
                  'Monthly Attendance Log',
                  style: TextStyle(color: AppColors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StaffAttendanceLogPage(staff: _s),
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

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.card),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  final bool isStatus;

  _InfoRow(this.label, this.value, {this.isStatus = false});
}
