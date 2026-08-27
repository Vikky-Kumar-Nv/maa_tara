import 'package:flutter/material.dart';
import 'package:maa_tara/colors.dart';
import 'package:maa_tara/job_view.dart';

typedef _C = AppColors;

// ─────────────────────────────────────────────────────────────────────────────
//  Work Model
// ─────────────────────────────────────────────────────────────────────────────
enum WorkStatus { inProgress, pending, onHold, completed }
typedef JobStatus = WorkStatus;

class WorkModel {
  final String workId;
  final String customerName;
  final String phone;
  final String vehiclePlate;
  final String carModel;
  final String? service;
  final String assignedStaff;
  final String date;
  final String time;
  final WorkStatus status;
  final String carImageUrl;
  final String staffAvatarUrl;

  // Compatibility getter
  String get jobId => workId;

  WorkModel({
    required this.workId,
    required this.customerName,
    required this.phone,
    required this.vehiclePlate,
    required this.carModel,
    this.service,
    required this.assignedStaff,
    required this.date,
    required this.time,
    required this.status,
    required this.carImageUrl,
    required this.staffAvatarUrl,
  });
}

typedef JobModel = WorkModel;

// ─────────────────────────────────────────────────────────────────────────────
//  Work Page (Body content for Work Tab)
// ─────────────────────────────────────────────────────────────────────────────
class WorkPage extends StatefulWidget {
  const WorkPage({super.key});

  @override
  State<WorkPage> createState() => _WorkPageState();
}

typedef JobPage = WorkPage;

class _WorkPageState extends State<WorkPage> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = [
    'All',
    'Pending',
    'In Progress',
    'On Hold',
    'Completed',
  ];

  final List<WorkModel> _allWorks = [
    WorkModel(
      workId: 'WORK-1058',
      customerName: 'Rahul Sharma',
      phone: '9876543210',
      vehiclePlate: 'DL 8C AX 1234',
      carModel: 'Hyundai i20',
      service: 'General Service & Brake Check',
      assignedStaff: 'Vikram Singh',
      date: '23 May 2025',
      time: '09:15 AM',
      status: WorkStatus.inProgress,
      carImageUrl:
          'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?w=300&auto=format&fit=crop&q=80',
      staffAvatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=80',
    ),
    WorkModel(
      workId: 'WORK-1057',
      customerName: 'Amit Verma',
      phone: '9876501122',
      vehiclePlate: 'UP 16 AB 5678',
      carModel: 'Maruti Brezza',
      service: 'Full Service & Oil Change',
      assignedStaff: 'Arjun Mehta',
      date: '23 May 2025',
      time: '10:30 AM',
      status: WorkStatus.pending,
      carImageUrl:
          'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=300&auto=format&fit=crop&q=80',
      staffAvatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&auto=format&fit=crop&q=80',
    ),
    WorkModel(
      workId: 'WORK-1056',
      customerName: 'Neha Gupta',
      phone: '9876512345',
      vehiclePlate: 'GJ 05 CD 6789',
      carModel: 'Honda City',
      service: 'AC Service & Gas Refilling',
      assignedStaff: 'Rohit Kumar',
      date: '23 May 2025',
      time: '11:00 AM',
      status: WorkStatus.inProgress,
      carImageUrl:
          'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=300&auto=format&fit=crop&q=80',
      staffAvatarUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&auto=format&fit=crop&q=80',
    ),
    WorkModel(
      workId: 'WORK-1055',
      customerName: 'Vikas Patel',
      phone: '9876523456',
      vehiclePlate: 'RJ 14 XY 9876',
      carModel: 'Swift Dzire',
      service: 'Suspension Repair',
      assignedStaff: 'Suresh Patel',
      date: '22 May 2025',
      time: '04:45 PM',
      status: WorkStatus.onHold,
      carImageUrl:
          'https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=300&auto=format&fit=crop&q=80',
      staffAvatarUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&auto=format&fit=crop&q=80',
    ),
    WorkModel(
      workId: 'WORK-1054',
      customerName: 'Pooja Singh',
      phone: '9876534567',
      vehiclePlate: 'DL 01 AA 1122',
      carModel: 'Tata Nexon',
      service: 'Brake Pad Replacement & Wash',
      assignedStaff: 'Vikram Singh',
      date: '22 May 2025',
      time: '02:15 PM',
      status: WorkStatus.completed,
      carImageUrl:
          'https://images.unsplash.com/photo-1617814076367-b759c7d7e738?w=300&auto=format&fit=crop&q=80',
      staffAvatarUrl:
          'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=100&auto=format&fit=crop&q=80',
    ),
  ];

  List<WorkModel> get _filteredWorks {
    return _allWorks.where((work) {
      // Filter by status tab
      bool matchesStatus = true;
      if (_selectedFilter == 'Pending') {
        matchesStatus = work.status == WorkStatus.pending;
      } else if (_selectedFilter == 'In Progress') {
        matchesStatus = work.status == WorkStatus.inProgress;
      } else if (_selectedFilter == 'On Hold') {
        matchesStatus = work.status == WorkStatus.onHold;
      } else if (_selectedFilter == 'Completed') {
        matchesStatus = work.status == WorkStatus.completed;
      }

      // Filter by search query
      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        matchesSearch =
            work.workId.toLowerCase().contains(query) ||
            work.customerName.toLowerCase().contains(query) ||
            work.vehiclePlate.toLowerCase().contains(query) ||
            work.carModel.toLowerCase().contains(query) ||
            work.assignedStaff.toLowerCase().contains(query);
      }

      return matchesStatus && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final works = _filteredWorks;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Page Title ─────────────────────────────────────────────────────
          const Text(
            'Work',
            style: TextStyle(
              color: _C.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 14),

          // ── Top Action / Filter Buttons ────────────────────────────────────
          _buildTopActionButtons(),
          const SizedBox(height: 14),

          // ── Search Bar (Expandable) ────────────────────────────────────────
          if (_isSearchExpanded) ...[
            _buildSearchInput(),
            const SizedBox(height: 12),
          ],

          // ── Status Filter Tabs ─────────────────────────────────────────────
          _buildStatusFilterTabs(),
          const SizedBox(height: 16),

          // ── Work Cards List ─────────────────────────────────────────────────
          if (works.isEmpty)
            _buildEmptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: works.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) => _buildWorkCard(works[index]),
            ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Top Action Buttons ───────────────────────────────────────────────────────
  Widget _buildTopActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            icon: Icons.search,
            label: 'Search',
            isActive: _isSearchExpanded || _searchQuery.isNotEmpty,
            onTap: () {
              setState(() {
                _isSearchExpanded = !_isSearchExpanded;
                if (!_isSearchExpanded) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _actionButton(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            onTap: () => _showDateFilter(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _actionButton(
            icon: Icons.person_outline,
            label: 'Staff',
            onTap: () => _showStaffFilter(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _actionButton(
            icon: Icons.filter_alt_outlined,
            label: 'Status',
            onTap: () => _showStatusFilterModal(),
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
        decoration: BoxDecoration(
          color: isActive ? _C.accent.withOpacity(0.18) : _C.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? _C.accent : _C.divider,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: isActive ? _C.accent : _C.white),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: isActive ? _C.accent : _C.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Search Input ────────────────────────────────────────────────────────────
  Widget _buildSearchInput() {
    return Container(
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _C.divider, width: 1),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: _C.white, fontSize: 13),
        cursorColor: _C.accent,
        decoration: InputDecoration(
          hintText: 'Search by Work ID, Customer, Car, Staff...',
          hintStyle: const TextStyle(color: _C.muted, fontSize: 12),
          prefixIcon: const Icon(Icons.search, color: _C.accent, size: 18),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: _C.muted, size: 16),
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

  // ── Status Filter Tabs ──────────────────────────────────────────────────────
  Widget _buildStatusFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? _C.accent : _C.muted,
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 24,
                      height: 2.5,
                      decoration: BoxDecoration(
                        color: _C.accent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    )
                  else
                    const SizedBox(height: 2.5),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Work Card ────────────────────────────────────────────────────────────────
  Widget _buildWorkCard(WorkModel work) {
    return Container(
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.divider, width: 1),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Section: Car Image, Details, Status Badge ──────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Car Thumbnail Box
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 72,
                  height: 58,
                  color: const Color(0xFF0F1B2B),
                  child: Image.network(
                    work.carImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(
                        Icons.directions_car,
                        color: _C.muted,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Middle: Work ID, Customer, Phone
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      work.workId,
                      style: const TextStyle(
                        color: _C.accent,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      work.customerName,
                      style: const TextStyle(
                        color: _C.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          work.phone,
                          style: const TextStyle(color: _C.muted, fontSize: 11),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.phone, color: _C.accent, size: 11),
                      ],
                    ),
                  ],
                ),
              ),

              // Right: Status Badge
              _statusBadge(work.status),
            ],
          ),

          const SizedBox(height: 10),

          // ── Vehicle Plate & Model ──────────────────────────────────────────
          Row(
            children: [
              const Icon(
                Icons.credit_card_outlined,
                color: _C.accent,
                size: 14,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${work.vehiclePlate} • ${work.carModel}',
                  style: const TextStyle(
                    color: _C.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          // ── Service Details (if present) ───────────────────────────────────
          if (work.service != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.build_circle_outlined,
                  color: _C.accent,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    work.service!,
                    style: const TextStyle(color: _C.muted, fontSize: 11.5),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 10),

          // ── Staff Assigned & Date/Time ─────────────────────────────────────
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 24,
                  height: 24,
                  color: const Color(0xFF0F1B2B),
                  child: Image.network(
                    work.staffAvatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.person, color: _C.muted, size: 16),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Assigned: ${work.assignedStaff}',
                  style: const TextStyle(
                    color: _C.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    work.date,
                    style: const TextStyle(
                      color: _C.muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    work.time,
                    style: const TextStyle(color: _C.muted, fontSize: 9.5),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(color: _C.divider, height: 1, thickness: 1),
          const SizedBox(height: 8),

          // ── Bottom Action Buttons ──────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _cardActionButton(
                  icon: Icons.visibility_outlined,
                  label: 'View',
                  onTap: () => _viewWorkDetails(work),
                ),
              ),
              Container(width: 1, height: 16, color: _C.divider),
              Expanded(
                child: _cardActionButton(
                  icon: Icons.person_add_alt_outlined,
                  label: 'Assign',
                  onTap: () => _assignWork(work),
                ),
              ),
              Container(width: 1, height: 16, color: _C.divider),
              Expanded(
                child: _cardActionButton(
                  icon: Icons.sync,
                  label: 'Change Status',
                  onTap: () => _changeWorkStatus(work),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Status Badge ────────────────────────────────────────────────────────────
  Widget _statusBadge(WorkStatus status) {
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
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
            Icon(icon, size: 14, color: _C.accent),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                color: _C.white,
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
        color: _C.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.divider),
      ),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 48, color: _C.muted.withOpacity(0.6)),
          const SizedBox(height: 12),
          const Text(
            'No Work Found',
            style: TextStyle(
              color: _C.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try changing the filter or search query',
            style: TextStyle(color: _C.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ── Action Handlers / Modals ────────────────────────────────────────────────
  void _showDateFilter() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _C.accent,
              surface: _C.card,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  void _showStaffFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final staffList = [
          'All Staff',
          'Vikram Singh',
          'Arjun Mehta',
          'Rohit Kumar',
          'Suresh Patel',
        ];
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Staff',
                style: TextStyle(
                  color: _C.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...staffList.map(
                (staff) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.person_outline, color: _C.accent),
                  title: Text(
                    staff,
                    style: const TextStyle(color: _C.white, fontSize: 14),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    if (staff != 'All Staff') {
                      setState(() {
                        _searchQuery = staff;
                        _searchController.text = staff;
                        _isSearchExpanded = true;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStatusFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Status',
                style: TextStyle(
                  color: _C.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ..._filters.map(
                (filter) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    filter,
                    style: TextStyle(
                      color: _selectedFilter == filter ? _C.accent : _C.white,
                      fontWeight: _selectedFilter == filter
                          ? FontWeight.w700
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: _selectedFilter == filter
                      ? const Icon(Icons.check, color: _C.accent)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _viewWorkDetails(WorkModel work) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkViewPage(work: work),
      ),
    );
  }

  void _assignWork(WorkModel work) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Assign staff for ${work.workId}'),
        backgroundColor: _C.card,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _changeWorkStatus(WorkModel work) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _C.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Status for ${work.workId}',
                style: const TextStyle(
                  color: _C.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...WorkStatus.values.map((status) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    status.name.toUpperCase(),
                    style: const TextStyle(color: _C.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Status updated to ${status.name}'),
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
}
