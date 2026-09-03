import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/features/staff/add_staff.dart';
import 'package:maa_tara/features/staff/staff_attendance_log.dart';
import 'package:maa_tara/features/staff/staff_list.dart';
import 'package:maa_tara/features/staff/staff_work_history.dart';
import 'package:maa_tara/features/work/create_work.dart';
import 'package:maa_tara/features/work/job.dart';
import 'package:maa_tara/features/work/job_view.dart';

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

  // Live dynamic works from WorkRepository for this staff
  List<WorkModel> get _staffWorks {
    final clean = _s.name.trim().toLowerCase();
    return WorkRepository.works.where((w) {
      final assigned = w.assignedStaff.trim().toLowerCase();
      return assigned == clean ||
          assigned.contains(clean) ||
          clean.contains(assigned);
    }).toList();
  }

  int get _todayWorksCount {
    final live = _staffWorks.length;
    return live > 0 ? live : _s.todayWorks;
  }

  int get _completedWorksCount {
    final live =
        _staffWorks.where((w) => w.status == WorkStatus.completed).length;
    return live > 0 ? live : _s.completedWorks;
  }

  int get _pendingWorksCount {
    final live =
        _staffWorks.where((w) => w.status != WorkStatus.completed).length;
    return live > 0 ? live : _s.pendingWorks;
  }

  WorkModel? get _currentWorkModel {
    final inProgress = _staffWorks
        .where((w) => w.status == WorkStatus.inProgress)
        .firstOrNull;
    if (inProgress != null) return inProgress;
    final pending = _staffWorks
        .where(
          (w) =>
              w.status == WorkStatus.pending || w.status == WorkStatus.onHold,
        )
        .firstOrNull;
    return pending ?? _staffWorks.firstOrNull;
  }

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
    final isSuspended = _s.status == 'Suspended';

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSuspended
                  ? AppColors.red.withValues(alpha: 0.5)
                  : AppColors.divider,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        const SizedBox(width: 8),
                        _buildStatusPill(_s.status),
                      ],
                    ),
                    const SizedBox(height: 3),
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
        ),
        if (isSuspended) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.red.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.red.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: AppColors.red, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Staff is currently suspended from duty and work allocation.',
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
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
                  '$_todayWorksCount',
                  AppColors.blue,
                ),
                _buildSummaryItem(
                  'Completed',
                  '$_completedWorksCount',
                  AppColors.green,
                ),
                _buildSummaryItem(
                  'Pending',
                  '$_pendingWorksCount',
                  AppColors.red,
                ),
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
                      _currentWorkModel != null
                          ? (_currentWorkModel!.service ?? _currentWorkModel!.carModel)
                          : _s.currentWork,
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
    final cur = _currentWorkModel;

    if (cur == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Column(
          children: [
            const Icon(Icons.assignment_outlined, color: AppColors.muted, size: 28),
            const SizedBox(height: 8),
            const Text(
              'No Active Work Assigned',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Assign a work card to get started',
              style: TextStyle(color: AppColors.muted, fontSize: 11),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobViewPage(work: cur),
          ),
        ).then((_) {
          if (mounted) setState(() {});
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.35), width: 1),
        ),
        child: Column(
          children: [
            _buildWorkRow('Work ID', cur.workId, isHighlighted: true),
            const SizedBox(height: 8),
            _buildWorkRow('Customer', cur.customerName),
            const SizedBox(height: 8),
            _buildWorkRow('Vehicle', '${cur.carModel} (${cur.vehiclePlate})'),
            const SizedBox(height: 8),
            _buildWorkRow('Work', cur.service ?? cur.carModel),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Status',
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                Row(
                  children: [
                    Text(
                      cur.status == WorkStatus.inProgress
                          ? 'In Progress'
                          : (cur.status == WorkStatus.completed
                              ? 'Completed'
                              : (cur.status == WorkStatus.onHold
                                  ? 'On Hold'
                                  : 'Pending')),
                      style: TextStyle(
                        color: cur.status == WorkStatus.inProgress
                            ? AppColors.blue
                            : (cur.status == WorkStatus.completed
                                ? AppColors.green
                                : AppColors.amber),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right, color: AppColors.accent, size: 16),
                  ],
                ),
              ],
            ),
          ],
        ),
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

  // ── Bottom Action Buttons (Assign Work & Suspend / Unsuspend) ──────────────
  Widget _buildBottomActionButtons() {
    final isSuspended = _s.status == 'Suspended';

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              if (isSuspended) {
                _showToast('${_s.name} is suspended and cannot be assigned new work.');
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateWorkPage(initialStaff: _s),
                ),
              ).then((_) {
                if (mounted) {
                  final updated = StaffRepository.staffList.firstWhere(
                    (s) => s.id == _s.id,
                    orElse: () => _s,
                  );
                  setState(() => _s = updated);
                }
              });
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: isSuspended ? AppColors.inputFill : AppColors.card,
              side: BorderSide(
                color: isSuspended ? AppColors.divider : AppColors.divider,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: Icon(
              Icons.person_add_alt_1_outlined,
              color: isSuspended ? AppColors.muted : AppColors.accent,
              size: 18,
            ),
            label: Text(
              'Assign Work',
              style: TextStyle(
                color: isSuspended ? AppColors.muted : AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isSuspended ? _confirmUnsuspendStaff : _confirmSuspendStaff,
            style: ElevatedButton.styleFrom(
              backgroundColor: isSuspended
                  ? AppColors.green.withValues(alpha: 0.25)
                  : AppColors.red.withValues(alpha: 0.25),
              side: BorderSide(
                color: isSuspended
                    ? AppColors.green.withValues(alpha: 0.6)
                    : AppColors.red.withValues(alpha: 0.6),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
            ),
            icon: Icon(
              isSuspended ? Icons.lock_open_rounded : Icons.block,
              color: isSuspended ? AppColors.green : AppColors.red,
              size: 18,
            ),
            label: Text(
              isSuspended ? 'Unsuspend' : 'Suspend',
              style: TextStyle(
                color: isSuspended ? AppColors.green : AppColors.red,
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
          Color statusCol = AppColors.green;
          if (r.value == 'Suspended') statusCol = AppColors.red;
          if (r.value == 'On Leave') statusCol = AppColors.amber;
          if (r.value == 'Inactive') statusCol = AppColors.muted;

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
                    style: TextStyle(
                      color: statusCol,
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
    Color bg = AppColors.green.withValues(alpha: 0.15);
    Color border = AppColors.green.withValues(alpha: 0.4);
    Color text = AppColors.green;

    if (status == 'On Leave') {
      bg = AppColors.amber.withValues(alpha: 0.15);
      border = AppColors.amber.withValues(alpha: 0.4);
      text = AppColors.amber;
    } else if (status == 'Suspended') {
      bg = AppColors.red.withValues(alpha: 0.18);
      border = AppColors.red.withValues(alpha: 0.5);
      text = AppColors.red;
    } else if (status == 'Inactive') {
      bg = AppColors.muted.withValues(alpha: 0.15);
      border = AppColors.muted.withValues(alpha: 0.4);
      text = AppColors.muted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == 'Suspended') ...[
            const Icon(Icons.block, color: AppColors.red, size: 10),
            const SizedBox(width: 3),
          ],
          Text(
            status,
            style: TextStyle(
              color: text,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendancePill(String attendance) {
    Color col = AppColors.green;
    if (attendance == 'Absent') col = AppColors.red;
    if (attendance == 'Leave') col = AppColors.amber;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
      decoration: BoxDecoration(
        color: col.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: col.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        attendance,
        style: TextStyle(
          color: col,
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
        title: const Row(
          children: [
            Icon(Icons.block, color: AppColors.red, size: 22),
            SizedBox(width: 8),
            Text(
              'Suspend Staff',
              style: TextStyle(color: AppColors.white),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to suspend ${_s.name}? They will be marked as inactive and blocked from job assignments.',
          style: const TextStyle(color: AppColors.muted, fontSize: 13),
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
              setState(() {
                _s = _s.copyWith(status: 'Suspended', activityStatus: 'Offline');
              });
              StaffRepository.updateStaff(_s);
              _showStatusDialog(
                title: 'Staff Suspended!',
                message: '${_s.name} has been suspended from duty and work allocation.',
                icon: Icons.block,
                iconColor: AppColors.red,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            child: const Text('Suspend', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _confirmUnsuspendStaff() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.divider),
        ),
        title: const Row(
          children: [
            Icon(Icons.lock_open_rounded, color: AppColors.green, size: 22),
            SizedBox(width: 8),
            Text(
              'Reactivate Staff',
              style: TextStyle(color: AppColors.white),
            ),
          ],
        ),
        content: Text(
          'Do you want to remove the suspension for ${_s.name} and restore their Active status?',
          style: const TextStyle(color: AppColors.muted, fontSize: 13),
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
              setState(() {
                _s = _s.copyWith(status: 'Active', activityStatus: 'Working');
              });
              StaffRepository.updateStaff(_s);
              _showStatusDialog(
                title: 'Staff Reactivated!',
                message: '${_s.name} has been successfully reactivated and restored to Active status.',
                icon: Icons.check_circle_rounded,
                iconColor: AppColors.green,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.green),
            child: const Text('Reactivate', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog({
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
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
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: iconColor.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(icon, color: iconColor, size: 36),
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
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: iconColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
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
              ListTile(
                leading: Icon(
                  _s.status == 'Suspended' ? Icons.lock_open_rounded : Icons.block,
                  color: _s.status == 'Suspended' ? AppColors.green : AppColors.red,
                ),
                title: Text(
                  _s.status == 'Suspended' ? 'Unsuspend / Reactivate Staff' : 'Suspend Staff',
                  style: TextStyle(
                    color: _s.status == 'Suspended' ? AppColors.green : AppColors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (_s.status == 'Suspended') {
                    _confirmUnsuspendStaff();
                  } else {
                    _confirmSuspendStaff();
                  }
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
