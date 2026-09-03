import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/core/widgets/paginated_list.dart';
import 'package:maa_tara/core/widgets/skeleton_loader.dart';
import 'package:maa_tara/features/staff/add_staff.dart';
import 'package:maa_tara/features/staff/staff_details.dart';
import 'package:maa_tara/features/work/create_work.dart';

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

  StaffModel copyWith({
    String? id,
    String? name,
    String? role,
    String? phone,
    String? email,
    String? avatarUrl,
    String? status,
    String? activityStatus,
    int? todayWorks,
    int? completedWorks,
    int? pendingWorks,
    String? currentWork,
    String? currentWorkId,
    String? currentCustomer,
    String? currentVehicle,
    String? attendance,
    String? checkInTime,
    String? checkOutTime,
    String? joiningDate,
  }) {
    return StaffModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
      activityStatus: activityStatus ?? this.activityStatus,
      todayWorks: todayWorks ?? this.todayWorks,
      completedWorks: completedWorks ?? this.completedWorks,
      pendingWorks: pendingWorks ?? this.pendingWorks,
      currentWork: currentWork ?? this.currentWork,
      currentWorkId: currentWorkId ?? this.currentWorkId,
      currentCustomer: currentCustomer ?? this.currentCustomer,
      currentVehicle: currentVehicle ?? this.currentVehicle,
      attendance: attendance ?? this.attendance,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      joiningDate: joiningDate ?? this.joiningDate,
    );
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
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80',
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
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80',
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
      avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80',
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
      avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&auto=format&fit=crop&q=80',
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
      avatarUrl: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=150&auto=format&fit=crop&q=80',
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

  static StaffModel? getStaffByName(String name) {
    final clean = name.trim().toLowerCase();
    return _staffList
        .where((s) => s.name.trim().toLowerCase() == clean)
        .firstOrNull;
  }

  /// Dynamically updates staff when a new work card is assigned to them
  static void assignWorkToStaff({
    required String staffName,
    required String workId,
    required String workTitle,
    required String customerName,
    required String vehiclePlate,
  }) {
    final idx = _staffList.indexWhere(
      (s) =>
          s.name.trim().toLowerCase() == staffName.trim().toLowerCase() ||
          staffName.trim().toLowerCase().contains(s.name.trim().toLowerCase()),
    );
    if (idx != -1) {
      final s = _staffList[idx];
      _staffList[idx] = s.copyWith(
        todayWorks: s.todayWorks + 1,
        pendingWorks: s.pendingWorks + 1,
        currentWork: workTitle.isNotEmpty ? workTitle : s.currentWork,
        currentWorkId: workId,
        currentCustomer: customerName,
        currentVehicle: vehiclePlate,
        activityStatus: 'Working',
      );
    }
  }

  /// Dynamically updates both old and new staff on work reassignment
  static void reassignWorkFromStaff({
    required String oldStaffName,
    required String newStaffName,
    required String workId,
    required String workTitle,
    required String customerName,
    required String vehiclePlate,
  }) {
    // 1. Decrement from old staff
    final oldIdx = _staffList.indexWhere(
      (s) =>
          s.name.trim().toLowerCase() == oldStaffName.trim().toLowerCase() ||
          oldStaffName.trim().toLowerCase().contains(s.name.trim().toLowerCase()),
    );
    if (oldIdx != -1) {
      final oldStaff = _staffList[oldIdx];
      _staffList[oldIdx] = oldStaff.copyWith(
        todayWorks: (oldStaff.todayWorks - 1).clamp(0, 999),
        pendingWorks: (oldStaff.pendingWorks - 1).clamp(0, 999),
        currentWork: oldStaff.currentWorkId == workId ? '-' : oldStaff.currentWork,
      );
    }

    // 2. Assign to new staff
    assignWorkToStaff(
      staffName: newStaffName,
      workId: workId,
      workTitle: workTitle,
      customerName: customerName,
      vehiclePlate: vehiclePlate,
    );
  }

  /// Dynamically updates staff stats when a work card is completed
  static void completeWorkForStaff({
    required String staffName,
    required String workId,
  }) {
    final idx = _staffList.indexWhere(
      (s) =>
          s.name.trim().toLowerCase() == staffName.trim().toLowerCase() ||
          staffName.trim().toLowerCase().contains(s.name.trim().toLowerCase()),
    );
    if (idx != -1) {
      final s = _staffList[idx];
      _staffList[idx] = s.copyWith(
        completedWorks: s.completedWorks + 1,
        pendingWorks: (s.pendingWorks - 1).clamp(0, 999),
        currentWork: s.currentWorkId == workId ? 'Completed' : s.currentWork,
      );
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
  bool _isLoading = false;
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Pagination state
  int _currentPage = 1;
  static const int _pageSize = 6;
  bool _isLoadingMore = false;

  final List<String> _filterTabs = [
    'All',
    'Active',
    'Working',
    'Offline',
    'Leave',
    'Suspended',
  ];

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _currentPage = 1;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLoadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _currentPage++;
        _isLoadingMore = false;
      });
    }
  }

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
        matchesTab =
            staff.status == 'On Leave' || staff.activityStatus == 'Leave';
      } else if (_selectedFilter == 'Suspended') {
        matchesTab = staff.status == 'Suspended';
      }

      // Filter by search query
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        matchesSearch =
            staff.name.toLowerCase().contains(q) ||
            staff.phone.toLowerCase().contains(q) ||
            staff.role.toLowerCase().contains(q);
      }

      return matchesTab && matchesSearch;
    }).toList();
  }

  List<StaffModel> get _paginatedStaff {
    final all = _filteredStaff;
    final end = (_currentPage * _pageSize).clamp(0, all.length);
    return all.sublist(0, end);
  }

  bool get _hasMore => _paginatedStaff.length < _filteredStaff.length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final staffList = _paginatedStaff;

    return PaginatedListView<StaffModel>(
      items: staffList,
      isInitialLoading: _isLoading,
      isLoadingMore: _isLoadingMore,
      hasMore: _hasMore,
      onRefresh: _handleRefresh,
      onLoadMore: _handleLoadMore,
      header: Column(
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

            // ── Search & Filter Row ───────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.divider, width: 1),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 13,
                      ),
                      cursorColor: AppColors.accent,
                      decoration: InputDecoration(
                        hintText: 'Search staff by name, phone or role...',
                        hintStyle: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12.5,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.muted,
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
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 11,
                        ),
                      ),
                      onChanged: (val) => setState(() => _searchQuery = val),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Filter icon button
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

            // ── Filter Horizontal Tabs (Pills) ────────────────────────────────
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _filterTabs.length,
                itemBuilder: (context, index) {
                  final tab = _filterTabs[index];
                  final isSelected = _selectedFilter == tab;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => setState(() => _selectedFilter = tab),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accent.withValues(alpha: 0.15)
                              : AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent
                                : AppColors.divider,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          tab,
                          style: TextStyle(
                            color: isSelected ? AppColors.accent : AppColors.muted,
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
        initialLoadingWidget: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) => const SkeletonStaffCard(),
        ),
        emptyWidget: _buildEmptyState(),
        itemBuilder: (context, staff, index) => _buildStaffCard(staff),
      );
    }

  // ── Staff Card Widget ───────────────────────────────────────────────────────
  Widget _buildStaffCard(StaffModel s) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: s.status == 'Suspended'
              ? AppColors.red.withValues(alpha: 0.4)
              : AppColors.divider,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Row: Avatar, Info, Status & Activity Badges ────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar Image
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  s.avatarUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
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
                        const Icon(
                          Icons.phone,
                          color: AppColors.accent,
                          size: 11,
                        ),
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatColumn(
                    "Today's Works",
                    '${s.todayWorks}',
                    AppColors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatColumn(
                    'Completed',
                    '${s.completedWorks}',
                    AppColors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatColumn(
                    'Current Work',
                    s.currentWork,
                    AppColors.white,
                  ),
                ),
                Expanded(
                  child: _buildAttendanceColumn(s.attendance),
                ),
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
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: const TextStyle(color: AppColors.muted, fontSize: 9.5),
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            maxLines: 1,
            style: TextStyle(
              color: valueColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
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
        const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Attendance',
            maxLines: 1,
            style: TextStyle(color: AppColors.muted, fontSize: 9.5),
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            attendance,
            maxLines: 1,
            style: TextStyle(
              color: col,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
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
    } else if (status == 'Inactive') {
      bg = AppColors.muted.withValues(alpha: 0.15);
      border = AppColors.muted.withValues(alpha: 0.4);
      text = AppColors.muted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: text,
          fontSize: 10.5,
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
          decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
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
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13.5, color: AppColors.accent),
            const SizedBox(width: 3.5),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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

  void _openStaffDetails(StaffModel s) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StaffDetailsPage(staff: s)),
    );
    setState(() {});
  }

  void _assignWorkToStaff(StaffModel s) {
    if (s.status == 'Suspended') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${s.name} is currently suspended and cannot be assigned work.',
          ),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateWorkPage(initialStaff: s),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  void _showStaffQuickMenu(StaffModel s) {
    final isSuspended = s.status == 'Suspended';

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
                title: Text(
                  'Call ${s.name}',
                  style: const TextStyle(color: AppColors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Calling ${s.phone}...'),
                      backgroundColor: AppColors.card,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat, color: AppColors.accent),
                title: Text(
                  'WhatsApp ${s.name}',
                  style: const TextStyle(color: AppColors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening WhatsApp for ${s.phone}...'),
                      backgroundColor: AppColors.card,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  isSuspended ? Icons.lock_open_rounded : Icons.block,
                  color: isSuspended ? AppColors.green : AppColors.red,
                ),
                title: Text(
                  isSuspended
                      ? 'Unsuspend / Reactivate Staff'
                      : 'Suspend Staff',
                  style: TextStyle(
                    color: isSuspended ? AppColors.green : AppColors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmToggleSuspension(s, !isSuspended);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmToggleSuspension(StaffModel s, bool suspend) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.divider),
        ),
        title: Row(
          children: [
            Icon(
              suspend ? Icons.block : Icons.lock_open_rounded,
              color: suspend ? AppColors.red : AppColors.green,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              suspend ? 'Suspend Staff' : 'Reactivate Staff',
              style: const TextStyle(color: AppColors.white),
            ),
          ],
        ),
        content: Text(
          suspend
              ? 'Are you sure you want to suspend ${s.name}? They will be marked as inactive and blocked from job assignments.'
              : 'Do you want to remove the suspension for ${s.name} and restore their Active status?',
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
              final updated = s.copyWith(
                status: suspend ? 'Suspended' : 'Active',
                activityStatus: suspend ? 'Offline' : 'Working',
              );
              StaffRepository.updateStaff(updated);
              setState(() {});
              _showStatusDialog(
                title: suspend ? 'Staff Suspended!' : 'Staff Reactivated!',
                message: suspend
                    ? '${s.name} has been suspended from duty and work allocation.'
                    : '${s.name} has been successfully reactivated and restored to Active status.',
                icon: suspend ? Icons.block : Icons.check_circle_rounded,
                iconColor: suspend ? AppColors.red : AppColors.green,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: suspend ? AppColors.red : AppColors.green,
            ),
            child: Text(
              suspend ? 'Suspend' : 'Reactivate',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                leading: const Icon(
                  Icons.sort_by_alpha,
                  color: AppColors.accent,
                ),
                title: const Text(
                  'Sort A to Z',
                  style: TextStyle(color: AppColors.white),
                ),
                onTap: () {
                  setState(() {
                    StaffRepository.staffList.sort(
                      (a, b) => a.name.compareTo(b.name),
                    );
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.accent,
                ),
                title: const Text(
                  'Only Active Technicians',
                  style: TextStyle(color: AppColors.white),
                ),
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
