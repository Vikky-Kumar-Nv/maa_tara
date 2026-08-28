import 'package:flutter/material.dart';
import 'package:maa_tara/colors.dart';
import 'package:maa_tara/job.dart';
import 'package:maa_tara/job_view.dart';
import 'package:maa_tara/staff_list.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Staff Work Item Model
// ─────────────────────────────────────────────────────────────────────────────
class StaffWorkItem {
  final String workId;
  final String customerName;
  final String phone;
  final String vehiclePlate;
  final String carModel;
  final String service;
  final String date;
  final String duration;
  final WorkStatus status;
  final double rating;

  StaffWorkItem({
    required this.workId,
    required this.customerName,
    required this.phone,
    required this.vehiclePlate,
    required this.carModel,
    required this.service,
    required this.date,
    required this.duration,
    required this.status,
    this.rating = 4.8,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
//  Staff Work History Page
// ─────────────────────────────────────────────────────────────────────────────
class StaffWorkHistoryPage extends StatefulWidget {
  final StaffModel staff;

  const StaffWorkHistoryPage({super.key, required this.staff});

  @override
  State<StaffWorkHistoryPage> createState() => _StaffWorkHistoryPageState();
}

class _StaffWorkHistoryPageState extends State<StaffWorkHistoryPage> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  late List<StaffWorkItem> _historyList;

  @override
  void initState() {
    super.initState();
    // Dynamic sample work history tailored for this staff member
    _historyList = [
      StaffWorkItem(
        workId: widget.staff.currentWorkId,
        customerName: widget.staff.currentCustomer,
        phone: '9876543210',
        vehiclePlate: widget.staff.currentVehicle,
        carModel: 'Hyundai i20',
        service: 'Brake Pad Replacement & Inspection',
        date: 'Today, 09:15 AM',
        duration: 'In Progress (2h 15m)',
        status: WorkStatus.inProgress,
      ),
      StaffWorkItem(
        workId: 'WORK-1050',
        customerName: 'Amit Verma',
        phone: '9876501122',
        vehiclePlate: 'UP 16 AB 5678',
        carModel: 'Maruti Brezza',
        service: 'Full Engine Oil Service & Filter Change',
        date: 'Yesterday, 04:30 PM',
        duration: '1h 45m',
        status: WorkStatus.completed,
      ),
      StaffWorkItem(
        workId: 'WORK-1044',
        customerName: 'Neha Gupta',
        phone: '9876512345',
        vehiclePlate: 'GJ 05 CD 6789',
        carModel: 'Honda City',
        service: 'AC Gas Refill & Compressor Tuning',
        date: '21 May 2025',
        duration: '3h 10m',
        status: WorkStatus.completed,
      ),
      StaffWorkItem(
        workId: 'WORK-1039',
        customerName: 'Vikas Patel',
        phone: '9876523456',
        vehiclePlate: 'RJ 14 XY 9876',
        carModel: 'Swift Dzire',
        service: 'Front Suspension Arm Bushing Overhaul',
        date: '19 May 2025',
        duration: '4h 00m',
        status: WorkStatus.completed,
      ),
      StaffWorkItem(
        workId: 'WORK-1032',
        customerName: 'Pooja Singh',
        phone: '9876534567',
        vehiclePlate: 'DL 01 AA 1122',
        carModel: 'Tata Nexon',
        service: 'Clutch Plate & Flywheel Servicing',
        date: '16 May 2025',
        duration: '3h 30m',
        status: WorkStatus.completed,
      ),
      StaffWorkItem(
        workId: 'WORK-1025',
        customerName: 'Rajesh Kumar',
        phone: '9876578901',
        vehiclePlate: 'HR 26 DQ 4455',
        carModel: 'Kia Seltos',
        service: 'Wheel Alignment & Balancing',
        date: '12 May 2025',
        duration: '1h 15m',
        status: WorkStatus.completed,
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<StaffWorkItem> get _filteredList {
    return _historyList.where((item) {
      bool matchesFilter = true;
      if (_selectedFilter == 'In Progress') {
        matchesFilter = item.status == WorkStatus.inProgress;
      } else if (_selectedFilter == 'Completed') {
        matchesFilter = item.status == WorkStatus.completed;
      }

      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        matchesSearch = item.workId.toLowerCase().contains(q) ||
            item.customerName.toLowerCase().contains(q) ||
            item.vehiclePlate.toLowerCase().contains(q) ||
            item.service.toLowerCase().contains(q);
      }

      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredList;
    final staff = widget.staff;

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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Staff Profile Summary Card
                    _buildStaffSummaryCard(staff),
                    const SizedBox(height: 16),

                    // Search & Filter Row
                    _buildSearchBar(),
                    const SizedBox(height: 12),

                    // Filter Chips Row
                    _buildFilterChips(),
                    const SizedBox(height: 16),

                    // Section Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Work History (${list.length})',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'Showing All Months',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // List of Work Cards
                    if (list.isEmpty)
                      _buildEmptyState()
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _buildWorkHistoryCard(list[index]);
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
                      child: Icon(Icons.close, color: AppColors.white, size: 22),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Work History',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.tune, color: AppColors.accent, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Filter',
                      style: TextStyle(color: AppColors.accent, fontSize: 11.5, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Staff Profile Summary Card ──────────────────────────────────────────────
  Widget _buildStaffSummaryCard(StaffModel staff) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  staff.avatarUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 48,
                    height: 48,
                    color: AppColors.inputFill,
                    alignment: Alignment.center,
                    child: Text(staff.initials, style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      staff.name,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${staff.role} • ${staff.phone}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.green.withValues(alpha: 0.4)),
                ),
                child: Text(
                  staff.status,
                  style: const TextStyle(
                    color: AppColors.green,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricItem('Total Works', '${staff.completedWorks + staff.todayWorks}', AppColors.white),
              _buildMetricItem('Completed', '${staff.completedWorks}', AppColors.green),
              _buildMetricItem('Rating', '4.9 ★', AppColors.accent),
              _buildMetricItem('Efficiency', '96%', AppColors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 10.5),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ── Search Bar ──────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
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
          hintText: 'Search by Work ID, customer or vehicle...',
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
                  icon: const Icon(Icons.close, color: AppColors.muted, size: 16),
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
    );
  }

  // ── Filter Chips ────────────────────────────────────────────────────────────
  Widget _buildFilterChips() {
    final filters = ['All', 'In Progress', 'Completed'];

    return Row(
      children: filters.map((f) {
        final isSelected = _selectedFilter == f;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InkWell(
            onTap: () => setState(() => _selectedFilter = f),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accent.withValues(alpha: 0.15)
                    : AppColors.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? AppColors.accent : AppColors.divider,
                  width: 1,
                ),
              ),
              child: Text(
                f,
                style: TextStyle(
                  color: isSelected ? AppColors.accent : AppColors.muted,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Work History Card ───────────────────────────────────────────────────────
  Widget _buildWorkHistoryCard(StaffWorkItem item) {
    final isCompleted = item.status == WorkStatus.completed;

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
          // Top Row: Work ID & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      item.workId,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.date,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.green.withValues(alpha: 0.15)
                      : AppColors.blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCompleted
                        ? AppColors.green.withValues(alpha: 0.4)
                        : AppColors.blue.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  isCompleted ? 'Completed' : 'In Progress',
                  style: TextStyle(
                    color: isCompleted ? AppColors.green : AppColors.blue,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Service Title
          Text(
            item.service,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),

          // Customer & Vehicle info
          Row(
            children: [
              const Icon(Icons.person_outline, color: AppColors.muted, size: 14),
              const SizedBox(width: 4),
              Text(
                item.customerName,
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              const SizedBox(width: 10),
              const Text('•', style: TextStyle(color: AppColors.muted)),
              const SizedBox(width: 10),
              const Icon(Icons.directions_car_outlined, color: AppColors.muted, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${item.carModel} (${item.vehiclePlate})',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 8),

          // Bottom Info: Duration & View Details link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer_outlined, color: AppColors.accent, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'Time: ${item.duration}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkViewPage(
                        work: WorkModel(
                          workId: item.workId,
                          customerName: item.customerName,
                          phone: item.phone,
                          vehiclePlate: item.vehiclePlate,
                          carModel: item.carModel,
                          service: item.service,
                          assignedStaff: widget.staff.name,
                          date: item.date,
                          time: '10:00 AM',
                          status: item.status,
                          carImageUrl:
                              'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?w=300&auto=format&fit=crop&q=80',
                          staffAvatarUrl: widget.staff.avatarUrl,
                        ),
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(6),
                child: Row(
                  children: const [
                    Text(
                      'View Job Card',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.chevron_right, color: AppColors.accent, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Empty State ─────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: const [
          Icon(Icons.work_off_outlined, color: AppColors.muted, size: 40),
          SizedBox(height: 8),
          Text(
            'No Work Records Found',
            style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4),
          Text(
            'Try changing the filter or search query',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
