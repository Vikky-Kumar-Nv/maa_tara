import 'package:flutter/material.dart';
import 'package:maa_tara/add_staff.dart';
import 'package:maa_tara/colors.dart';
import 'package:maa_tara/create_work.dart';
import 'package:maa_tara/staff_details.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Staff Model
// ─────────────────────────────────────────────────────────────────────────────
class StaffModel {
  final String id;
  final String name;
  final String role;
  final String phone;
  final String email;
  final String avatarUrl;
  final String status; // 'Active', 'On Leave', 'Suspended', 'Inactive'
  final String activityStatus; // 'Working', 'Offline', 'Leave'
  final int todayWorks;
  final int completedWorks;
  final int pendingWorks;
  final String currentWork;
  final String currentWorkId;
  final String currentCustomer;
  final String currentVehicle;
  final String attendance; // 'Present', 'Absent', 'Leave'
  final String checkInTime;
  final String checkOutTime;
  final String joiningDate;

  StaffModel({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.email,
    required this.avatarUrl,
    this.status = 'Active',
    this.activityStatus = 'Working',
    this.todayWorks = 0,
    this.completedWorks = 0,
    this.pendingWorks = 0,
    this.currentWork = '-',
    this.currentWorkId = 'WORK-1058',
    this.currentCustomer = 'Rahul Sharma',
    this.currentVehicle = 'Hyundai i20 (DL 8C AX 1234)',
    this.attendance = 'Present',
    this.checkInTime = '09:00 AM',
    this.checkOutTime = '--:--',
    this.joiningDate = '12 Jan 2024',
  });

  // Helper for 2-letter Initials avatar fallback
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts[0].isEmpty) return 'S';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Global In-Memory Staff Repository (Dynamic State)
// ─────────────────────────────────────────────────────────────────────────────
class StaffRepository {
  static final List<StaffModel> _staffList = [
    StaffModel(
      id: 'STF-001',
      name: 'Vikram Singh',
      role: 'Technician',
      phone: '9876549870',
      email: 'vikram.singh@maara.com',
      avatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80',
      status: 'Active',
      activityStatus: 'Working',
      todayWorks: 4,
      completedWorks: 12,
      pendingWorks: 1,
      currentWork: 'Brake Service',
      currentWorkId: 'WORK-1058',
      currentCustomer: 'Rahul Sharma',
      currentVehicle: 'Hyundai i20 (DL 8C AX 1234)',
      attendance: 'Present',
      checkInTime: '09:05 AM',
      joiningDate: '12 Jan 2024',
    ),
    StaffModel(
      id: 'STF-002',
      name: 'Arjun Mehta',
      role: 'Mechanic',
      phone: '9876512345',
      email: 'arjun.mehta@maara.com',
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80',
      status: 'Active',
      activityStatus: 'Working',
      todayWorks: 3,
      completedWorks: 9,
      pendingWorks: 1,
      currentWork: 'Oil Change',
      currentWorkId: 'WORK-1057',
      currentCustomer: 'Amit Verma',
      currentVehicle: 'Maruti Brezza (UP 16 AB 5678)',
      attendance: 'Present',
      checkInTime: '09:15 AM',
      joiningDate: '18 Mar 2024',
    ),
    StaffModel(
      id: 'STF-003',
      name: 'Rohit Kumar',
      role: 'Technician',
      phone: '9876533221',
      email: 'rohit.kumar@maara.com',
      avatarUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80',
      status: 'Active',
      activityStatus: 'Offline',
      todayWorks: 0,
      completedWorks: 6,
      pendingWorks: 0,
      currentWork: '-',
      currentWorkId: 'WORK-1056',
      currentCustomer: 'Neha Gupta',
      currentVehicle: 'Honda City (GJ 05 CD 6789)',
      attendance: 'Absent',
      checkInTime: '--:--',
      joiningDate: '05 Jan 2024',
    ),
    StaffModel(
      id: 'STF-004',
      name: 'Suresh Patel',
      role: 'Electrician',
      phone: '9876567788',
      email: 'suresh.patel@maara.com',
      avatarUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&auto=format&fit=crop&q=80',
      status: 'On Leave',
      activityStatus: 'Leave',
      todayWorks: 0,
      completedWorks: 7,
      pendingWorks: 0,
      currentWork: '-',
      currentWorkId: 'WORK-1055',
      currentCustomer: 'Vikas Patel',
      currentVehicle: 'Swift Dzire (RJ 14 XY 9876)',
      attendance: 'Leave',
      checkInTime: '--:--',
      joiningDate: '14 Nov 2023',
    ),
    StaffModel(
      id: 'STF-005',
      name: 'Neeraj Yadav',
      role: 'Helper',
      phone: '9876589123',
      email: 'neeraj.yadav@maara.com',
      avatarUrl:
          'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150&auto=format&fit=crop&q=80',
      status: 'Suspended',
      activityStatus: 'Offline',
      todayWorks: 0,
      completedWorks: 3,
      pendingWorks: 0,
      currentWork: '-',
      currentWorkId: 'WORK-1054',
      currentCustomer: 'Pooja Singh',
      currentVehicle: 'Tata Nexon (DL 01 AA 1122)',
      attendance: 'Absent',
      checkInTime: '--:--',
      joiningDate: '20 Dec 2023',
    ),
  ];

  static List<StaffModel> get staffList => _staffList;

  static void addStaff(StaffModel staff) {
    _staffList.insert(0, staff);
  }

  static void updateStaff(StaffModel staff) {
    final index = _staffList.indexWhere((s) => s.id == staff.id);
    if (index != -1) {
      _staffList[index] = staff;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Staff List Page (Tab 3 in Bottom Navigation Bar)
// ─────────────────────────────────────────────────────────────────────────────
class StaffListPage extends StatefulWidget {
  const StaffListPage({super.key});

  @override
  State<StaffListPage> createState() => _StaffListPageState();
}

class _StaffListPageState extends State<StaffListPage> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filterTabs = [
    'All',
    'Active',
    'Working',
    'Offline',
    'Leave',
    'Suspended',
  ];

  List<StaffModel> get _filteredStaff {
    final list = StaffRepository.staffList;
    return list.where((staff) {
      // Filter by tab
      bool matchesTab = true;
      if (_selectedFilter == 'Active') {
        matchesTab = staff.status == 'Active';
      } else if (_selectedFilter == 'Working') {
        matchesTab = staff.activityStatus == 'Working';
      } else if (_selectedFilter == 'Offline') {
        matchesTab = staff.activityStatus == 'Offline';
      } else if (_selectedFilter == 'Leave') {
        matchesTab = staff.status == 'On Leave' || staff.activityStatus == 'Leave';
      } else if (_selectedFilter == 'Suspended') {
        matchesTab = staff.status == 'Suspended';
      }

      // Filter by search query
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        matchesSearch = staff.name.toLowerCase().contains(q) ||
            staff.phone.toLowerCase().contains(q) ||
            staff.role.toLowerCase().contains(q);
      }

      return matchesTab && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final staffList = _filteredStaff;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Row: Title & + Add Staff Button ────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Staff',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Manage your workshop staff',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),

              // + Add Staff Button
              ElevatedButton.icon(
                onPressed: () => _openAddStaffPage(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.card,
                  side: const BorderSide(color: AppColors.accent, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.add, color: AppColors.accent, size: 16),
                label: const Text(
                  'Add Staff',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Search Bar with Filter Icon ────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.divider, width: 1),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: AppColors.white, fontSize: 13),
                    cursorColor: AppColors.accent,
                    decoration: InputDecoration(
                      hintText: 'Search staff by name, phone or role...',
                      hintStyle: TextStyle(
                        color: AppColors.muted.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.accent,
                        size: 18,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: AppColors.muted,
                                size: 16,
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _searchController.clear();
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Filter Icon Button
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.divider, width: 1),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                    color: AppColors.muted,
                    size: 20,
                  ),
                  onPressed: () => _showFilterModal(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Filter Horizontal Tabs ─────────────────────────────────────────
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _filterTabs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final tab = _filterTabs[index];
                final isSelected = _selectedFilter == tab;

                return InkWell(
                  onTap: () => setState(() => _selectedFilter = tab),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accent.withValues(alpha: 0.15)
                          : AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.accent : AppColors.divider,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      tab,
                      style: TextStyle(
                        color: isSelected ? AppColors.accent : AppColors.muted,
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // ── Staff Cards List ───────────────────────────────────────────────
          if (staffList.isEmpty)
            _buildEmptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: staffList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildStaffCard(staffList[index]);
              },
            ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ── Staff Card Widget ───────────────────────────────────────────────────────
  Widget _buildStaffCard(StaffModel s) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Row: Avatar, Info, Status & Activity Badges ────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Image
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  s.avatarUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.inputFill,
                      border: Border.all(color: AppColors.accent, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      s.initials,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name, Role, Phone
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.name,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s.role,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          s.phone,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 11.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.phone, color: AppColors.accent, size: 11),
                      ],
                    ),
                  ],
                ),
              ),

              // Status Pill & Live Indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildStatusPill(s.status),
                  const SizedBox(height: 4),
                  _buildActivityIndicator(s.activityStatus),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Stats 4-Column Row ─────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatColumn("Today's Works", '${s.todayWorks}', AppColors.blue),
                _buildStatColumn('Completed', '${s.completedWorks}', AppColors.green),
                _buildStatColumn('Current Work', s.currentWork, AppColors.white),
                _buildAttendanceColumn(s.attendance),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.divider, height: 1, thickness: 1),
          const SizedBox(height: 8),

          // ── Bottom Action Buttons: View, Assign Work, Edit, More ───────────
          Row(
            children: [
              Expanded(
                child: _cardActionButton(
                  icon: Icons.visibility_outlined,
                  label: 'View',
                  onTap: () => _openStaffDetails(s),
                ),
              ),
              Container(width: 1, height: 16, color: AppColors.divider),
              Expanded(
                child: _cardActionButton(
                  icon: Icons.assignment_turned_in_outlined,
                  label: 'Assign Work',
                  onTap: () => _assignWorkToStaff(s),
                ),
              ),
              Container(width: 1, height: 16, color: AppColors.divider),
              Expanded(
                child: _cardActionButton(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  onTap: () => _openEditStaffPage(s),
                ),
              ),
              Container(width: 1, height: 16, color: AppColors.divider),
              InkWell(
                onTap: () => _showStaffQuickMenu(s),
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Icon(
                    Icons.more_horiz,
                    color: AppColors.muted,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Stat Column Helper ──────────────────────────────────────────────────────
  Widget _buildStatColumn(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 10),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceColumn(String attendance) {
    Color col = AppColors.green;
    if (attendance == 'Absent') col = AppColors.red;
    if (attendance == 'Leave') col = AppColors.amber;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Attendance',
          style: TextStyle(color: AppColors.muted, fontSize: 10),
        ),
        const SizedBox(height: 2),
        Text(
          attendance,
          style: TextStyle(
            color: col,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ── Status Pill ─────────────────────────────────────────────────────────────
  Widget _buildStatusPill(String status) {
    Color bg = AppColors.green.withValues(alpha: 0.15);
    Color border = AppColors.green.withValues(alpha: 0.4);
    Color text = AppColors.green;

    if (status == 'On Leave') {
      bg = AppColors.amber.withValues(alpha: 0.15);
      border = AppColors.amber.withValues(alpha: 0.4);
      text = AppColors.amber;
    } else if (status == 'Suspended') {
      bg = AppColors.red.withValues(alpha: 0.15);
      border = AppColors.red.withValues(alpha: 0.4);
      text = AppColors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border, width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: text,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ── Activity Indicator Dot ──────────────────────────────────────────────────
  Widget _buildActivityIndicator(String activityStatus) {
    Color dotColor = AppColors.green;
    if (activityStatus == 'Offline') dotColor = AppColors.muted;
    if (activityStatus == 'Leave') dotColor = AppColors.amber;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          activityStatus,
          style: TextStyle(
            color: dotColor,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ── Card Action Button Helper ───────────────────────────────────────────────
  Widget _cardActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: AppColors.accent),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty State ─────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 48,
            color: AppColors.muted.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 12),
          const Text(
            'No Staff Found',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try selecting another filter or add a new staff member',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ── Navigation & Action Handlers ────────────────────────────────────────────
  Future<void> _openAddStaffPage() async {
    final result = await Navigator.push<StaffModel>(
      context,
      MaterialPageRoute(builder: (context) => const AddStaffPage()),
    );

    if (result != null) {
      setState(() {
        StaffRepository.addStaff(result);
      });
    } else {
      setState(() {});
    }
  }

  Future<void> _openEditStaffPage(StaffModel staff) async {
    final result = await Navigator.push<StaffModel>(
      context,
      MaterialPageRoute(builder: (context) => AddStaffPage(staffToEdit: staff)),
    );

    if (result != null) {
      setState(() {
        StaffRepository.updateStaff(result);
      });
    } else {
      setState(() {});
    }
  }

  void _openStaffDetails(StaffModel s) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StaffDetailsPage(staff: s),
      ),
    );
  }

  void _assignWorkToStaff(StaffModel s) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateWorkPage(),
      ),
    );
  }

  void _showStaffQuickMenu(StaffModel s) {
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
                leading: const Icon(Icons.phone, color: AppColors.accent),
                title: Text('Call ${s.name}', style: const TextStyle(color: AppColors.white)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Calling ${s.phone}...'), backgroundColor: AppColors.card),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat, color: AppColors.accent),
                title: Text('WhatsApp ${s.name}', style: const TextStyle(color: AppColors.white)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening WhatsApp for ${s.phone}...'), backgroundColor: AppColors.card),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: AppColors.red),
                title: const Text('Suspend Staff', style: TextStyle(color: AppColors.red)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${s.name} marked as suspended'), backgroundColor: AppColors.card),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterModal() {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Staff Members',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.sort_by_alpha, color: AppColors.accent),
                title: const Text('Sort A to Z', style: TextStyle(color: AppColors.white)),
                onTap: () {
                  setState(() {
                    StaffRepository.staffList.sort((a, b) => a.name.compareTo(b.name));
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle_outline, color: AppColors.accent),
                title: const Text('Only Active Technicians', style: TextStyle(color: AppColors.white)),
                onTap: () {
                  setState(() => _selectedFilter = 'Active');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
