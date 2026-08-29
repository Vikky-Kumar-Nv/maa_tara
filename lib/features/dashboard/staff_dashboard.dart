import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/features/customers/add_customer.dart';
import 'package:maa_tara/features/staff/staff_list.dart';
import 'package:maa_tara/features/work/create_work.dart';
import 'package:maa_tara/features/work/job.dart';
import 'package:maa_tara/features/work/job_view.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Staff Dashboard Page
// ─────────────────────────────────────────────────────────────────────────────
class StaffDashboardPage extends StatefulWidget {
  final StaffModel? staff;
  final Function(int)? onNavigateTab;

  const StaffDashboardPage({super.key, this.staff, this.onNavigateTab});

  @override
  State<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends State<StaffDashboardPage> {
  late StaffModel _staff;
  final ImagePicker _picker = ImagePicker();

  bool _isCheckedIn = true;
  String _checkInTime = '09:15 AM';
  String _checkOutTime = '--:-- PM';
  String _workingHours = '4h 25m';

  // Recent Works List for Staff
  final List<WorkModel> _staffRecentWorks = [
    WorkModel(
      workId: 'WRK-1058',
      customerName: 'Rohit Sharma',
      phone: '9876543210',
      vehiclePlate: 'DL 8C AX 1234',
      carModel: 'Hyundai i20',
      service: 'Brake Pad Replacement',
      assignedStaff: 'Arjun Mehta',
      date: 'Today',
      time: '10:30 AM',
      status: WorkStatus.inProgress,
      carImageUrl: 'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?w=300&auto=format&fit=crop&q=80',
      staffAvatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&auto=format&fit=crop&q=80',
    ),
    WorkModel(
      workId: 'WRK-1057',
      customerName: 'Vikram Singh',
      phone: '9812345678',
      vehiclePlate: 'HR 26 DQ 5678',
      carModel: 'Maruti Swift',
      service: 'Full Body Wash & Wax',
      assignedStaff: 'Arjun Mehta',
      date: 'Today',
      time: '09:15 AM',
      status: WorkStatus.completed,
      carImageUrl: 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=300&auto=format&fit=crop&q=80',
      staffAvatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&auto=format&fit=crop&q=80',
    ),
    WorkModel(
      workId: 'WRK-1056',
      customerName: 'Amit Kumar',
      phone: '9998887776',
      vehiclePlate: 'UP 16 AB 9876',
      carModel: 'Tata Nexon',
      service: 'Engine Oil Change',
      assignedStaff: 'Arjun Mehta',
      date: 'Today',
      time: '08:45 AM',
      status: WorkStatus.pending,
      carImageUrl: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=300&auto=format&fit=crop&q=80',
      staffAvatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&auto=format&fit=crop&q=80',
    ),
    WorkModel(
      workId: 'WRK-1055',
      customerName: 'Neeraj Yadav',
      phone: '9123456780',
      vehiclePlate: 'RJ 14 XY 1122',
      carModel: 'Mahindra Thar',
      service: 'AC Service & Filter Clean',
      assignedStaff: 'Arjun Mehta',
      date: 'Today',
      time: '08:20 AM',
      status: WorkStatus.onHold,
      carImageUrl: 'https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=300&auto=format&fit=crop&q=80',
      staffAvatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&auto=format&fit=crop&q=80',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _staff =
        widget.staff ??
        StaffRepository.staffList.firstWhere(
          (s) => s.name.contains('Arjun') || s.name.contains('Vikram'),
          orElse: () => StaffRepository.staffList.first,
        );

    _isCheckedIn = _staff.attendance == 'Present';
    _checkInTime = _staff.checkInTime.isNotEmpty
        ? _staff.checkInTime
        : '09:15 AM';
  }

  void _toggleAttendance() {
    final now = TimeOfDay.now();
    final formattedNow =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.period == DayPeriod.am ? 'AM' : 'PM'}';

    setState(() {
      _isCheckedIn = !_isCheckedIn;
      if (_isCheckedIn) {
        _checkInTime = formattedNow;
        _checkOutTime = '--:-- PM';
        _workingHours = '0h 01m';
      } else {
        _checkOutTime = formattedNow;
        _workingHours = '8h 15m';
      }
    });

    // Update real-time staff repository
    final updatedStaff = StaffModel(
      id: _staff.id,
      name: _staff.name,
      role: _staff.role,
      phone: _staff.phone,
      email: _staff.email,
      avatarUrl: _staff.avatarUrl,
      status: _staff.status,
      activityStatus: _isCheckedIn ? 'Working' : 'Offline',
      todayWorks: _staff.todayWorks,
      completedWorks: _staff.completedWorks,
      pendingWorks: _staff.pendingWorks,
      currentWork: _staff.currentWork,
      currentWorkId: _staff.currentWorkId,
      currentCustomer: _staff.currentCustomer,
      currentVehicle: _staff.currentVehicle,
      attendance: _isCheckedIn ? 'Present' : 'Absent',
      checkInTime: _checkInTime,
      checkOutTime: _checkOutTime,
      joiningDate: _staff.joiningDate,
    );

    StaffRepository.updateStaff(updatedStaff);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isCheckedIn
              ? '✅ Check-In Successful at $_checkInTime! Attendance updated for Admin.'
              : '👋 Check-Out Successful at $_checkOutTime! Working hours recorded.',
        ),
        backgroundColor: _isCheckedIn ? AppColors.green : AppColors.card,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String get _currentFormattedDate {
    final now = DateTime.now();
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
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  String get _currentFormattedWeekday {
    final now = DateTime.now();
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[now.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Header Bar (Identical to Admin Welcome Row) ──────────────
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accent, width: 2),
                  color: AppColors.card,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    _staff.avatarUrl,
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.person,
                      color: AppColors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome back,',
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            _staff.name,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified,
                          color: AppColors.accent,
                          size: 16,
                        ),
                      ],
                    ),
                    const Text(
                      'Have a productive day!',
                      style: TextStyle(color: AppColors.muted, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFE8A020).withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: AppColors.accent,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentFormattedDate,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _currentFormattedWeekday,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── 1. Today's Attendance Card ─────────────────────────────────────
          _buildAttendanceCard(),
          const SizedBox(height: 18),

          // ── 2. Today's Work Summary (5 Metric Cards) ───────────────────────
          _buildSectionTitle("TODAY'S WORK SUMMARY"),
          const SizedBox(height: 10),
          _buildWorkSummaryGrid(),
          const SizedBox(height: 18),

          // ── 3. Quick Actions ───────────────────────────────────────────────
          _buildSectionTitle('QUICK ACTIONS'),
          const SizedBox(height: 10),
          _buildQuickActionsRow(),
          const SizedBox(height: 20),

          // ── 4. Recent Works List ───────────────────────────────────────────
          _buildSectionHeaderWithViewAll(
            title: 'RECENT WORKS',
            onViewAll: () {
              if (widget.onNavigateTab != null) {
                widget.onNavigateTab!(1); // Go to Work tab
              }
            },
          ),
          const SizedBox(height: 10),
          _buildRecentWorksList(),
          const SizedBox(height: 20),

          // ── 5. Recent Activity Timeline ────────────────────────────────────
          _buildSectionHeaderWithViewAll(
            title: 'RECENT ACTIVITY',
            onViewAll: () {},
          ),
          const SizedBox(height: 10),
          _buildRecentActivityTimeline(),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  // ── 1. Today's Attendance Card ──────────────────────────────────────────────
  Widget _buildAttendanceCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "TODAY'S ATTENDANCE",
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // 4-Column Stats Row
          Row(
            children: [
              Expanded(
                child: _buildAttendanceMetric(
                  icon: Icons.login_rounded,
                  label: 'Check In',
                  value: _isCheckedIn ? _checkInTime : '--:--',
                  valueColor: AppColors.white,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildAttendanceMetric(
                  icon: Icons.logout_rounded,
                  label: 'Check Out',
                  value: _checkOutTime,
                  valueColor: AppColors.white,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildAttendanceMetric(
                  icon: Icons.access_time_rounded,
                  label: 'Hours',
                  value: _isCheckedIn ? _workingHours : '--:--',
                  valueColor: AppColors.white,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(child: _buildAttendanceStatusMetric()),
            ],
          ),
          const SizedBox(height: 14),

          // Big Fingerprint Check-In / Check-Out Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _toggleAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isCheckedIn
                    ? AppColors.red.withValues(alpha: 0.85)
                    : AppColors.accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fingerprint_rounded,
                    color: _isCheckedIn ? Colors.white : Colors.black,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isCheckedIn ? 'CHECK OUT' : 'CHECK IN',
                    style: TextStyle(
                      color: _isCheckedIn ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceMetric({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(icon, color: AppColors.accent, size: 12),
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: AppColors.muted, fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildAttendanceStatusMetric() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.person_outline,
                color: AppColors.accent,
                size: 12,
              ),
            ),
            const SizedBox(width: 3),
            const Expanded(
              child: Text(
                'Status',
                style: TextStyle(color: AppColors.muted, fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: _isCheckedIn
                ? AppColors.green.withValues(alpha: 0.15)
                : AppColors.red.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _isCheckedIn ? 'Checked In' : 'Not In',
            style: TextStyle(
              color: _isCheckedIn ? AppColors.green : AppColors.red,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ── 2. Today's Work Summary Grid (5 Horizontal Cards) ───────────────────────
  Widget _buildWorkSummaryGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCardItem(
            icon: Icons.work_outline,
            count: '12',
            label: 'Total Work',
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildSummaryCardItem(
            icon: Icons.schedule_rounded,
            count: '4',
            label: 'Pending',
            color: AppColors.amber,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildSummaryCardItem(
            icon: Icons.autorenew_rounded,
            count: '3',
            label: 'In Progress',
            color: AppColors.blue,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildSummaryCardItem(
            icon: Icons.pause_circle_outline,
            count: '1',
            label: 'On Hold',
            color: AppColors.muted,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildSummaryCardItem(
            icon: Icons.check_circle_outline,
            count: '4',
            label: 'Completed',
            color: AppColors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCardItem({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 4),
          Text(
            count,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ── 3. Quick Actions Row ───────────────────────────────────────────────────
  Widget _buildQuickActionsRow() {
    final actions = [
      _QuickActionData(
        icon: Icons.person_add_alt_1_outlined,
        label: 'Add\nCustomer',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddCustomerPage()),
        ),
      ),
      _QuickActionData(
        icon: Icons.post_add_rounded,
        label: 'Create\nWork',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateWorkPage()),
        ),
      ),
      _QuickActionData(
        icon: Icons.camera_alt_outlined,
        label: 'Add Before\nPhoto',
        onTap: () => _pickInspectionPhoto('Before'),
      ),
      _QuickActionData(
        icon: Icons.add_a_photo_outlined,
        label: 'Add After\nPhoto',
        onTap: () => _pickInspectionPhoto('After'),
      ),
      _QuickActionData(
        icon: Icons.inventory_2_outlined,
        label: 'Use\nStock',
        onTap: () => _showUseStockModal(),
      ),
    ];

    return Row(
      children: actions.map((a) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: InkWell(
              onTap: a.onTap,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.divider, width: 1),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(a.icon, color: AppColors.accent, size: 18),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      a.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── 4. Recent Works List ───────────────────────────────────────────────────
  Widget _buildRecentWorksList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _staffRecentWorks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final work = _staffRecentWorks[index];
        return _buildRecentWorkCard(work);
      },
    );
  }

  Widget _buildRecentWorkCard(WorkModel w) {
    Color statusBg = AppColors.blue.withValues(alpha: 0.15);
    Color statusText = AppColors.blue;
    String statusLabel = 'In Progress';

    if (w.status == WorkStatus.completed) {
      statusBg = AppColors.green.withValues(alpha: 0.15);
      statusText = AppColors.green;
      statusLabel = 'Completed';
    } else if (w.status == WorkStatus.pending) {
      statusBg = AppColors.amber.withValues(alpha: 0.15);
      statusText = AppColors.amber;
      statusLabel = 'Pending';
    } else if (w.status == WorkStatus.onHold) {
      statusBg = AppColors.muted.withValues(alpha: 0.15);
      statusText = AppColors.muted;
      statusLabel = 'On Hold';
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WorkViewPage(work: w)),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Row(
          children: [
            // Vehicle Thumbnail Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                w.carImageUrl,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 52,
                  height: 52,
                  color: AppColors.inputFill,
                  child: const Icon(
                    Icons.directions_car,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Customer, Phone, Vehicle & Work
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        color: AppColors.muted,
                        size: 12,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        w.customerName,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone,
                        color: AppColors.accent,
                        size: 10,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        w.phone,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '• ${w.carModel}',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${w.workId}: ',
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          w.service ?? 'General Inspection',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Status Badge & Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2.5,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusText,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  w.time,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: AppColors.muted, size: 18),
          ],
        ),
      ),
    );
  }

  // ── 5. Recent Activity Timeline ─────────────────────────────────────────────
  Widget _buildRecentActivityTimeline() {
    final activities = [
      _ActivityItem(
        icon: Icons.work_outline,
        iconColor: AppColors.blue,
        title: 'Work Started',
        description: 'WRK-1058 started for Rohit Sharma',
        time: '10:30 AM',
      ),
      _ActivityItem(
        icon: Icons.check_circle_outline,
        iconColor: AppColors.green,
        title: 'Work Completed',
        description: 'WRK-1054 completed for Suresh Patel',
        time: '09:45 AM',
      ),
      _ActivityItem(
        icon: Icons.inventory_2_outlined,
        iconColor: AppColors.accent,
        title: 'Stock Used',
        description: 'Used 2L Engine Oil for WRK-1056',
        time: '09:15 AM',
      ),
      _ActivityItem(
        icon: Icons.person_add_alt_1_outlined,
        iconColor: AppColors.amber,
        title: 'Customer Added',
        description: 'New customer Amit Kumar added',
        time: '08:50 AM',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        children: activities.map((act) {
          final isLast = activities.indexOf(act) == activities.length - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: act.iconColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(act.icon, color: act.iconColor, size: 14),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        act.title,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        act.description,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  act.time,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Helpers & Modals ────────────────────────────────────────────────────────
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.muted,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSectionHeaderWithViewAll({
    required String title,
    required VoidCallback onViewAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionTitle(title),
        InkWell(
          onTap: onViewAll,
          child: const Text(
            'View All',
            style: TextStyle(
              color: AppColors.accent,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickInspectionPhoto(String type) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📸 $type inspection photo captured successfully!'),
            backgroundColor: AppColors.green,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('📸 $type inspection photo added!'),
          backgroundColor: AppColors.card,
        ),
      );
    }
  }

  void _showUseStockModal() {
    String selectedPart = 'Engine Oil (5W-30)';
    final qtyController = TextEditingController(text: '1');
    final workIdController = TextEditingController(text: 'WRK-1058');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.muted.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Requisition Inventory Stock',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Select Item',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.divider),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedPart,
                    isExpanded: true,
                    dropdownColor: AppColors.card,
                    items: const [
                      DropdownMenuItem(
                        value: 'Engine Oil (5W-30)',
                        child: Text(
                          'Engine Oil (5W-30) - 24L In Stock',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Brake Pad Front Set',
                        child: Text(
                          'Brake Pad Front Set - 8 Sets In Stock',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Oil Filter (Hyundai/Kia)',
                        child: Text(
                          'Oil Filter (Hyundai/Kia) - 15 Pcs In Stock',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'AC Cabin Filter',
                        child: Text(
                          'AC Cabin Filter - 10 Pcs In Stock',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => selectedPart = val);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quantity',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: qtyController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.inputFill,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.divider,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'For Work ID',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: workIdController,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.inputFill,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.divider,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '📦 ${qtyController.text}x $selectedPart issued for ${workIdController.text}!',
                        ),
                        backgroundColor: AppColors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Confirm Requisition',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
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
}

class _QuickActionData {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _QuickActionData({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class _ActivityItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String time;

  _ActivityItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.time,
  });
}
