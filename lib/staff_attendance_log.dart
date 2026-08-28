import 'package:flutter/material.dart';
import 'package:maa_tara/colors.dart';
import 'package:maa_tara/staff_list.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Attendance Record Model
// ─────────────────────────────────────────────────────────────────────────────
class AttendanceRecord {
  final String date;
  final String dayName;
  String status; // 'Present', 'Absent', 'Half Day', 'On Leave', 'Weekly Off'
  String checkIn;
  String checkOut;
  String workingHours;
  String overtime;
  String note;

  AttendanceRecord({
    required this.date,
    required this.dayName,
    required this.status,
    required this.checkIn,
    required this.checkOut,
    required this.workingHours,
    this.overtime = '-',
    this.note = '',
  });
}

// ─────────────────────────────────────────────────────────────────────────────
//  Staff Monthly Attendance Log Page
// ─────────────────────────────────────────────────────────────────────────────
class StaffAttendanceLogPage extends StatefulWidget {
  final StaffModel staff;

  const StaffAttendanceLogPage({super.key, required this.staff});

  @override
  State<StaffAttendanceLogPage> createState() => _StaffAttendanceLogPageState();
}

class _StaffAttendanceLogPageState extends State<StaffAttendanceLogPage> {
  int _selectedMonthIndex = 4; // May
  int _selectedYear = 2025;
  String _selectedFilter = 'All';

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  late List<AttendanceRecord> _records;

  @override
  void initState() {
    super.initState();
    _loadMonthRecords();
  }

  void _loadMonthRecords() {
    _records = [
      AttendanceRecord(
        date: '23 May 2025',
        dayName: 'Friday',
        status: 'Present',
        checkIn: '09:05 AM',
        checkOut: 'In Office',
        workingHours: '7h 45m (Running)',
        overtime: '+1h 15m',
        note: 'On-time arrival',
      ),
      AttendanceRecord(
        date: '22 May 2025',
        dayName: 'Thursday',
        status: 'Present',
        checkIn: '09:12 AM',
        checkOut: '06:45 PM',
        workingHours: '8h 33m',
        overtime: '+33m',
      ),
      AttendanceRecord(
        date: '21 May 2025',
        dayName: 'Wednesday',
        status: 'Present',
        checkIn: '08:58 AM',
        checkOut: '07:10 PM',
        workingHours: '9h 12m',
        overtime: '+1h 12m',
        note: 'Overtime for engine overhaul',
      ),
      AttendanceRecord(
        date: '20 May 2025',
        dayName: 'Tuesday',
        status: 'Half Day',
        checkIn: '09:00 AM',
        checkOut: '02:00 PM',
        workingHours: '5h 00m',
        note: 'Family emergency permission',
      ),
      AttendanceRecord(
        date: '19 May 2025',
        dayName: 'Monday',
        status: 'Present',
        checkIn: '09:08 AM',
        checkOut: '06:30 PM',
        workingHours: '8h 22m',
      ),
      AttendanceRecord(
        date: '18 May 2025',
        dayName: 'Sunday',
        status: 'Weekly Off',
        checkIn: '--:--',
        checkOut: '--:--',
        workingHours: '0h',
      ),
      AttendanceRecord(
        date: '17 May 2025',
        dayName: 'Saturday',
        status: 'Present',
        checkIn: '09:02 AM',
        checkOut: '06:15 PM',
        workingHours: '8h 13m',
      ),
      AttendanceRecord(
        date: '16 May 2025',
        dayName: 'Friday',
        status: 'On Leave',
        checkIn: '--:--',
        checkOut: '--:--',
        workingHours: '0h',
        note: 'Medical Sick Leave',
      ),
      AttendanceRecord(
        date: '15 May 2025',
        dayName: 'Thursday',
        status: 'Present',
        checkIn: '09:15 AM',
        checkOut: '06:35 PM',
        workingHours: '8h 20m',
      ),
      AttendanceRecord(
        date: '14 May 2025',
        dayName: 'Wednesday',
        status: 'Absent',
        checkIn: '--:--',
        checkOut: '--:--',
        workingHours: '0h',
        note: 'Uninformed absence',
      ),
    ];
  }

  List<AttendanceRecord> get _filteredRecords {
    return _records.where((r) {
      if (_selectedFilter == 'Present') return r.status == 'Present';
      if (_selectedFilter == 'Absent') return r.status == 'Absent';
      if (_selectedFilter == 'Leave / Half') {
        return r.status == 'On Leave' || r.status == 'Half Day';
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final staff = widget.staff;
    final records = _filteredRecords;

    // Monthly KPIs
    final presentCount = _records.where((r) => r.status == 'Present').length;
    final absentCount = _records.where((r) => r.status == 'Absent').length;
    final leaveCount = _records.where((r) => r.status == 'On Leave').length;
    final halfDayCount = _records.where((r) => r.status == 'Half Day').length;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header Bar ───────────────────────────────────────────────
            _buildTopHeader(),

            // ── Scrollable Body ──────────────────────────────────────────────
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
                    // Month Selector Carousel
                    _buildMonthSelector(),
                    const SizedBox(height: 14),

                    // Staff Mini Header Card
                    _buildStaffMiniHeader(staff),
                    const SizedBox(height: 14),

                    // Monthly KPI Summary 4-card Grid
                    _buildKPIGrid(
                      present: presentCount,
                      absent: absentCount,
                      leave: leaveCount,
                      halfDay: halfDayCount,
                    ),
                    const SizedBox(height: 16),

                    // Filter Horizontal Chips
                    _buildFilterChips(),
                    const SizedBox(height: 16),

                    // Attendance Log List Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daily Logs (${records.length})',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        InkWell(
                          onTap: () => _openManualAttendanceModal(),
                          child: const Text(
                            '+ Mark Attendance',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Day-by-Day List
                    if (records.isEmpty)
                      _buildEmptyState()
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: records.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return _buildAttendanceDayCard(records[index]);
                        },
                      ),

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
                  const Text(
                    'Monthly Attendance Log',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _openManualAttendanceModal(),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.edit_calendar_outlined,
                        color: AppColors.accent,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Mark',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Month Selector ──────────────────────────────────────────────────────────
  Widget _buildMonthSelector() {
    final currentMonth = _months[_selectedMonthIndex];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.accent),
            onPressed: () {
              setState(() {
                if (_selectedMonthIndex > 0) {
                  _selectedMonthIndex--;
                } else {
                  _selectedMonthIndex = 11;
                  _selectedYear--;
                }
              });
            },
          ),
          Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                color: AppColors.accent,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                '$currentMonth $_selectedYear',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: AppColors.accent),
            onPressed: () {
              setState(() {
                if (_selectedMonthIndex < 11) {
                  _selectedMonthIndex++;
                } else {
                  _selectedMonthIndex = 0;
                  _selectedYear++;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  // ── Staff Mini Header ───────────────────────────────────────────────────────
  Widget _buildStaffMiniHeader(StaffModel staff) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              staff.avatarUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 40,
                height: 40,
                color: AppColors.inputFill,
                alignment: Alignment.center,
                child: Text(
                  staff.initials,
                  style: const TextStyle(color: AppColors.accent),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  staff.name,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${staff.role} • ${staff.phone}',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.green.withValues(alpha: 0.4)),
            ),
            child: Text(
              staff.attendance,
              style: const TextStyle(
                color: AppColors.green,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Monthly KPI Grid ────────────────────────────────────────────────────────
  Widget _buildKPIGrid({
    required int present,
    required int absent,
    required int leave,
    required int halfDay,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildKPICard(
            'Present',
            '$present',
            AppColors.green,
            Icons.check_circle_outline,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildKPICard(
            'Absent',
            '$absent',
            AppColors.red,
            Icons.cancel_outlined,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildKPICard(
            'Half Day',
            '$halfDay',
            AppColors.amber,
            Icons.timelapse_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildKPICard(
            'Leave',
            '$leave',
            AppColors.blue,
            Icons.event_busy_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(String title, String count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(color: AppColors.muted, fontSize: 10.5),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ── Filter Chips ────────────────────────────────────────────────────────────
  Widget _buildFilterChips() {
    final filters = ['All', 'Present', 'Absent', 'Leave / Half'];

    return Row(
      children: filters.map((f) {
        final isSelected = _selectedFilter == f;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InkWell(
            onTap: () => setState(() => _selectedFilter = f),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accent.withValues(alpha: 0.15)
                    : AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.accent : AppColors.divider,
                  width: 1,
                ),
              ),
              child: Text(
                f,
                style: TextStyle(
                  color: isSelected ? AppColors.accent : AppColors.muted,
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Day-by-Day Card ─────────────────────────────────────────────────────────
  Widget _buildAttendanceDayCard(AttendanceRecord record) {
    Color statusColor = AppColors.green;
    if (record.status == 'Absent') statusColor = AppColors.red;
    if (record.status == 'Half Day' || record.status == 'On Leave') {
      statusColor = AppColors.amber;
    }
    if (record.status == 'Weekly Off') statusColor = AppColors.muted;

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
          // Row 1: Date, Day & Status Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    record.date,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(${record.dayName})',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  record.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Row 2: In Time, Out Time, Total Hours
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeDetail('Check In', record.checkIn, AppColors.green),
                _buildTimeDetail('Check Out', record.checkOut, AppColors.white),
                _buildTimeDetail(
                  'Hours',
                  record.workingHours,
                  AppColors.accent,
                ),
                if (record.overtime != '-')
                  _buildTimeDetail('Overtime', record.overtime, AppColors.blue),
              ],
            ),
          ),

          // Row 3: Note/Remarks if present
          if (record.note.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.muted,
                  size: 13,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    record.note,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11.5,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeDetail(String label, String time, Color timeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 10),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: TextStyle(
            color: timeColor,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ── Empty State ─────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: const [
          Icon(Icons.calendar_today_outlined, color: AppColors.muted, size: 36),
          SizedBox(height: 8),
          Text(
            'No Records for Selected Filter',
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ── Manual Attendance Modal ─────────────────────────────────────────────────
  void _openManualAttendanceModal() {
    String selectedStatus = 'Present';
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                  Text(
                    'Mark Attendance for ${widget.staff.name}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Status chips
                  const Text(
                    'Select Status',
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: ['Present', 'Absent', 'Half Day', 'On Leave'].map(
                      (status) {
                        final isSelected = selectedStatus == status;
                        return ChoiceChip(
                          label: Text(status),
                          selected: isSelected,
                          selectedColor: AppColors.accent,
                          backgroundColor: AppColors.inputFill,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.black : AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                          onSelected: (val) {
                            if (val) {
                              setModalState(() => selectedStatus = status);
                            }
                          },
                        );
                      },
                    ).toList(),
                  ),
                  const SizedBox(height: 14),

                  // Note input
                  const Text(
                    'Remarks / Reason',
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: noteController,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. Approved leave, overtime work...',
                      hintStyle: TextStyle(
                        color: AppColors.muted.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                      filled: true,
                      fillColor: AppColors.inputFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.divider),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _records.insert(
                            0,
                            AttendanceRecord(
                              date: 'Today, 23 May 2025',
                              dayName: 'Friday',
                              status: selectedStatus,
                              checkIn: selectedStatus == 'Present'
                                  ? '09:00 AM'
                                  : '--:--',
                              checkOut: selectedStatus == 'Present'
                                  ? '06:00 PM'
                                  : '--:--',
                              workingHours: selectedStatus == 'Present'
                                  ? '8h 00m'
                                  : '0h',
                              note: noteController.text.trim(),
                            ),
                          );
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Attendance recorded for ${widget.staff.name}!',
                            ),
                            backgroundColor: AppColors.card,
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
                        'Save Attendance',
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
      },
    );
  }
}
