import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maa_tara/add_customer.dart';
import 'package:maa_tara/colors.dart';
import 'package:maa_tara/create_work.dart';
import 'package:maa_tara/staff_list.dart';

typedef _C = AppColors;

// ─────────────────────────────────────────────────────────────────────────────
//  Dashboard Page
// ─────────────────────────────────────────────────────────────────────────────
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Welcome Row ────────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _C.accent, width: 2),
                  color: _C.card,
                ),
                child: const Icon(Icons.person, color: _C.white, size: 26),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back,',
                    style: TextStyle(color: _C.muted, fontSize: 12),
                  ),
                  Row(
                    children: const [
                      Text(
                        'Admin',
                        style: TextStyle(
                          color: _C.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.verified, color: _C.accent, size: 16),
                    ],
                  ),
                  const Text(
                    'Have a productive day!',
                    style: TextStyle(color: _C.muted, fontSize: 11),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: _C.card,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color(0xFFE8A020).withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: _C.accent,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '23 May 2025',
                          style: TextStyle(
                            color: _C.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Friday',
                          style: TextStyle(color: _C.muted, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildStatsGrid(),

          const SizedBox(height: 10),
          _buildInventoryValueCard(),
          const SizedBox(height: 16),
          _buildQuickActions(),
          const SizedBox(height: 16),
          _buildRecentActivity(),
          const SizedBox(height: 16),
          _buildChartsRow(),
          const SizedBox(height: 16),
          _buildStaffPerformance(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Stats Grid ──────────────────────────────────────────────────────────────
  Widget _buildStatsGrid() {
    const goldIcon = Color(0xFFC78B35);
    const darkText = Color(0xFF1E1E1E);

    final stats = [
      // Row 1 (White Card, Black text)
      _StatItem(
        label: "TODAY'S CUSTOMERS",
        value: '12',
        icon: Icons.people_outline,
        iconColor: goldIcon,
        valueColor: darkText,
        bgColor: Colors.white,
      ),
      _StatItem(
        label: "TODAY'S WORK",
        value: '18',
        icon: Icons.work_outline,
        iconColor: goldIcon,
        valueColor: darkText,
        bgColor: Colors.white,
      ),
      _StatItem(
        label: 'PENDING WORK',
        value: '7',
        icon: Icons.hourglass_empty,
        iconColor: goldIcon,
        valueColor: darkText,
        bgColor: Colors.white,
      ),

      // Row 2 (White Card, colored/dark values)
      _StatItem(
        label: 'IN PROGRESS',
        value: '6',
        icon: Icons.sync,
        iconColor: darkText,
        valueColor: _C.blue,
        bgColor: Colors.white,
      ),
      _StatItem(
        label: 'COMPLETED',
        value: '11',
        icon: Icons.check_circle_outline,
        iconColor: _C.green,
        valueColor: _C.green,
        bgColor: Colors.white,
      ),
      _StatItem(
        label: 'ON HOLD',
        value: '2',
        icon: Icons.pause_circle_outline,
        iconColor: darkText,
        valueColor: darkText,
        bgColor: Colors.white,
      ),

      // Row 3 (White Card, colored values)
      _StatItem(
        label: 'STAFF PRESENT',
        value: '14',
        icon: Icons.people_outline,
        iconColor: goldIcon,
        valueColor: _C.green,
        bgColor: Colors.white,
      ),
      _StatItem(
        label: 'STAFF WORKING',
        value: '9',
        icon: Icons.person_add_alt_1_outlined,
        iconColor: goldIcon,
        valueColor: _C.blue,
        bgColor: Colors.white,
      ),
      _StatItem(
        label: 'STAFF ABSENT',
        value: '2',
        icon: Icons.person_off_outlined,
        iconColor: goldIcon,
        valueColor: _C.red,
        bgColor: Colors.white,
      ),

      // Row 4 (Dark Card, colored values)
      _StatItem(
        label: 'TOTAL PRODUCTS',
        value: '236',
        icon: Icons.view_in_ar,
        iconColor: _C.accent,
        valueColor: _C.accent,
        labelColor: _C.muted,
        bgColor: _C.card,
        borderColor: _C.divider,
      ),
      _StatItem(
        label: 'LOW STOCK',
        value: '34',
        icon: Icons.warning_amber_rounded,
        iconColor: _C.accent,
        valueColor: _C.accent,
        labelColor: _C.muted,
        bgColor: _C.card,
        borderColor: _C.divider,
      ),
      _StatItem(
        label: 'OUT OF STOCK',
        value: '12',
        icon: Icons.remove_circle_outline,
        iconColor: _C.red,
        valueColor: _C.red,
        labelColor: _C.muted,
        bgColor: _C.card,
        borderColor: _C.divider,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.65,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (_, i) => _buildStatCard(stats[i]),
    );
  }

  Widget _buildStatCard(_StatItem s) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Container(
        decoration: BoxDecoration(
          color: s.bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: s.borderColor ?? Colors.transparent,
            width: 1,
          ),
          boxShadow: s.bgColor == Colors.white
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(s.icon, color: s.iconColor, size: 26),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      s.label,
                      maxLines: 1,
                      style: TextStyle(
                        color: s.labelColor,
                        fontSize: 7.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    s.value,
                    style: TextStyle(
                      color: s.valueColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Inventory Value Card ────────────────────────────────────────────────────
  Widget _buildInventoryValueCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.divider, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFE8A020).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const SizedBox(
              width: 22,
              height: 22,
              child: CustomPaint(
                painter: _CoinsStackPainter(
                  color: _C.accent,
                  bgFill: Color(0xFF1B283A),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'INVENTORY VALUE',
            style: TextStyle(
              color: _C.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          const Text(
            '₹ 4,85,320',
            style: TextStyle(
              color: _C.accent,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick Actions ───────────────────────────────────────────────────────────
  Widget _buildQuickActions() {
    final actions = [
      _ActionItem('Add\nCustomer', Icons.person_add_outlined),
      _ActionItem('Create\nWork', Icons.work_outline),
      _ActionItem('Add\nProduct', Icons.add_box_outlined),
      _ActionItem('Add\nStock', Icons.inventory_2_outlined),
      _ActionItem('Assign\nStaff', Icons.group_add_outlined),
    ];

    return Column(
      children: [
        _sectionHeader('QUICK ACTIONS', 'View All'),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: actions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => _buildActionCard(actions[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(_ActionItem a) {
    return InkWell(
      onTap: () {
        if (a.label.contains('Customer')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCustomerPage()),
          );
        } else if (a.label.contains('Work')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateWorkPage()),
          );
        } else if (a.label.contains('Staff')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StaffListPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening ${a.label.replaceAll("\n", " ")}...'),
              backgroundColor: _C.card,
              duration: const Duration(milliseconds: 800),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 72,
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _C.divider, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8A020).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(a.icon, color: _C.accent, size: 18),
            ),
            const SizedBox(height: 5),
            Text(
              a.label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _C.white, fontSize: 9, height: 1.3),
            ),
          ],
        ),
      ),
    );
  }

  // ── Recent Activity ─────────────────────────────────────────────────────────
  Widget _buildRecentActivity() {
    final activities = [
      _Activity(
        Icons.person_add,
        _C.green,
        'New Customer Added',
        'Rahul Sharma',
        '10:15 AM',
      ),
      _Activity(
        Icons.work,
        _C.blue,
        'New Work Created',
        'WORK-1062 · Swift Dzire',
        '09:41 AM',
      ),
      _Activity(
        Icons.check_circle,
        _C.green,
        'Work Completed',
        'WORK-1058 · Hyundai i20',
        '09:20 AM',
      ),
      _Activity(
        Icons.add_box,
        _C.accent,
        'Stock Added',
        'Engine Oil SW30 · 10 Ltr',
        '09:05 AM',
      ),
      _Activity(
        Icons.remove_circle,
        _C.amber,
        'Stock Used',
        'Brake Pad Set · 1 Unit',
        '09:00 AM',
      ),
      _Activity(
        Icons.login,
        _C.green,
        'Staff Check In',
        'Vikram Singh',
        '08:30 AM',
      ),
      _Activity(
        Icons.logout,
        _C.red,
        'Staff Check Out',
        'Arjun Mehta',
        '07:30 PM',
      ),
    ];

    return Column(
      children: [
        _sectionHeader('RECENT ACTIVITY', 'View All'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _C.divider, width: 1),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (_, __) =>
                const Divider(color: _C.divider, height: 1, thickness: 1),
            itemBuilder: (_, i) => _buildActivityTile(activities[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityTile(_Activity a) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: a.color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(a.icon, color: a.color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.title,
                  style: const TextStyle(
                    color: _C.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  a.subtitle,
                  style: const TextStyle(color: _C.muted, fontSize: 10),
                ),
              ],
            ),
          ),
          Text(a.time, style: const TextStyle(color: _C.muted, fontSize: 10)),
        ],
      ),
    );
  }

  // ── Charts Row ──────────────────────────────────────────────────────────────
  Widget _buildChartsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildWorkStatus()),
        const SizedBox(width: 10),
        Expanded(child: _buildInventoryMovement()),
      ],
    );
  }

  Widget _buildWorkStatus() {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'WORK STATUS',
                style: TextStyle(
                  color: _C.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _C.divider,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'This Week',
                  style: TextStyle(color: _C.muted, fontSize: 9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: 110,
              height: 110,
              child: CustomPaint(
                painter: _DonutChartPainter(
                  segments: const [
                    _Segment(_C.green, 0.50),
                    _Segment(_C.blue, 0.25),
                    _Segment(_C.amber, 0.16),
                    _Segment(_C.red, 0.09),
                  ],
                ),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '36',
                        style: TextStyle(
                          color: _C.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Total',
                        style: TextStyle(color: _C.muted, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _legend(_C.green, 'Completed', '18 (50%)'),
          _legend(_C.blue, 'In Progress', '9 (25%)'),
          _legend(_C.amber, 'Pending', '6 (16%)'),
          _legend(_C.red, 'On Hold', '3 (9%)'),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: _C.muted, fontSize: 9),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: _C.white,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryMovement() {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'INVENTORY\nMOVEMENT',
                style: TextStyle(
                  color: _C.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  height: 1.3,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _C.divider,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'This Week',
                  style: TextStyle(color: _C.muted, fontSize: 9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: _LineChartPainter(
                points: const [20.0, 45.0, 30.0, 60.0, 40.0, 70.0, 55.0],
                lineColor: _C.accent,
                fillColor: Color(0x26E8A020),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map(
                  (d) => Text(
                    d,
                    style: const TextStyle(color: _C.muted, fontSize: 8),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  // ── Staff Performance ───────────────────────────────────────────────────────
  Widget _buildStaffPerformance() {
    const staff = [
      _StaffItem('Vikram Singh', 'VS', 12, 12),
      _StaffItem('Arjun Mehta', 'AM', 10, 12),
      _StaffItem('Rohit Kumar', 'RK', 9, 12),
      _StaffItem('Suresh Patel', 'SP', 8, 12),
    ];

    return Column(
      children: [
        _sectionHeader('STAFF PERFORMANCE', 'This Week'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _C.divider, width: 1),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(14, 12, 14, 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Staff Member',
                        style: TextStyle(
                          color: _C.muted,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      'Jobs Completed',
                      style: TextStyle(
                        color: _C.muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: _C.divider, height: 1),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: staff.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: _C.divider, height: 1),
                itemBuilder: (_, i) => _buildStaffTile(staff[i]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStaffTile(_StaffItem s) {
    final progress = s.completed / s.total;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFFE8A020).withOpacity(0.2),
            child: Text(
              s.initials,
              style: const TextStyle(
                color: _C.accent,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.name,
                  style: const TextStyle(
                    color: _C.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: _C.divider,
                    valueColor: const AlwaysStoppedAnimation<Color>(_C.accent),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${s.completed}',
            style: const TextStyle(
              color: _C.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section Header Helper ───────────────────────────────────────────────────
  Widget _sectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _C.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            action,
            style: const TextStyle(color: _C.accent, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Data Models
// ─────────────────────────────────────────────────────────────────────────────
class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color valueColor;
  final Color labelColor;
  final Color bgColor;
  final Color? borderColor;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.valueColor,
    this.labelColor = const Color(0xFF1E1E1E),
    this.bgColor = Colors.white,
    this.borderColor,
  });
}

class _ActionItem {
  final String label;
  final IconData icon;
  const _ActionItem(this.label, this.icon);
}

class _Activity {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;
  const _Activity(this.icon, this.color, this.title, this.subtitle, this.time);
}

class _StaffItem {
  final String name;
  final String initials;
  final int completed;
  final int total;
  const _StaffItem(this.name, this.initials, this.completed, this.total);
}

class _Segment {
  final Color color;
  final double fraction;
  const _Segment(this.color, this.fraction);
}

// ─────────────────────────────────────────────────────────────────────────────
//  Donut Chart CustomPainter
// ─────────────────────────────────────────────────────────────────────────────
class _DonutChartPainter extends CustomPainter {
  final List<_Segment> segments;
  const _DonutChartPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    const strokeW = 14.0;
    var startAngle = -pi / 2;

    for (final seg in segments) {
      final sweep = 2 * pi * seg.fraction;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.round
        ..color = seg.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeW / 2),
        startAngle,
        sweep - 0.05,
        false,
        paint,
      );
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
//  Line Chart CustomPainter
// ─────────────────────────────────────────────────────────────────────────────
class _LineChartPainter extends CustomPainter {
  final List<double> points;
  final Color lineColor;
  final Color fillColor;
  const _LineChartPainter({
    required this.points,
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final maxVal = points.reduce(max);
    final minVal = points.reduce(min);
    final range = (maxVal - minVal) == 0 ? 1 : (maxVal - minVal);
    final step = size.width / (points.length - 1);

    Offset toOffset(int i) => Offset(
      i * step,
      size.height - ((points[i] - minVal) / range) * size.height * 0.85,
    );

    final path = Path();
    final fillPath = Path();

    path.moveTo(toOffset(0).dx, toOffset(0).dy);
    fillPath.moveTo(0, size.height);
    fillPath.lineTo(toOffset(0).dx, toOffset(0).dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = toOffset(i);
      final p1 = toOffset(i + 1);
      final cp1 = Offset((p0.dx + p1.dx) / 2, p0.dy);
      final cp2 = Offset((p0.dx + p1.dx) / 2, p1.dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
      fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p1.dx, p1.dy);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, Paint()..color = fillColor);
    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(toOffset(i), 3.5, Paint()..color = lineColor);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
//  Coins Stack Icon CustomPainter
// ─────────────────────────────────────────────────────────────────────────────
class _CoinsStackPainter extends CustomPainter {
  final Color color;
  final Color bgFill;
  const _CoinsStackPainter({
    this.color = const Color(0xFFE8A020),
    this.bgFill = const Color(0xFF1B283A),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = bgFill
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final sx = w / 24.0;
    final sy = h / 24.0;

    // ── 1. Left Tall Coin Stack ──
    const lLeft = 2.0;
    const lRight = 14.5;
    const lCx = 8.25;
    const lRx = 6.25;
    const lRy = 2.4;

    // Left vertical lines
    canvas.drawLine(
      Offset(lLeft * sx, 4.5 * sy),
      Offset(lLeft * sx, 20.0 * sy),
      strokePaint,
    );
    canvas.drawLine(
      Offset(lRight * sx, 4.5 * sy),
      Offset(lRight * sx, 20.0 * sy),
      strokePaint,
    );

    // Left top ellipse
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(lCx * sx, 4.5 * sy),
        width: lRx * 2 * sx,
        height: lRy * 2 * sy,
      ),
      strokePaint,
    );

    // Left stack rims
    for (final y in [9.5, 14.5, 19.5]) {
      final path = Path()
        ..moveTo(lLeft * sx, y * sy)
        ..arcToPoint(
          Offset(lRight * sx, y * sy),
          radius: Radius.elliptical(lRx * sx, lRy * sy),
          clockwise: false,
        );
      canvas.drawPath(path, strokePaint);
    }

    // ── 2. Right Short Coin Stack (in front) ──
    const rLeft = 10.5;
    const rRight = 22.0;
    const rCx = 16.25;
    const rRx = 5.75;
    const rRy = 2.2;
    const rTopY = 12.5;
    const rBotY = 21.0;

    // Fill background behind right stack to create clean 3D layering
    final rBgPath = Path()
      ..moveTo(rLeft * sx, rTopY * sy)
      ..arcToPoint(
        Offset(rRight * sx, rTopY * sy),
        radius: Radius.elliptical(rRx * sx, rRy * sy),
        clockwise: true,
      )
      ..lineTo(rRight * sx, rBotY * sy)
      ..arcToPoint(
        Offset(rLeft * sx, rBotY * sy),
        radius: Radius.elliptical(rRx * sx, rRy * sy),
        clockwise: false,
      )
      ..close();
    canvas.drawPath(rBgPath, fillPaint);

    // Right vertical lines
    canvas.drawLine(
      Offset(rLeft * sx, rTopY * sy),
      Offset(rLeft * sx, rBotY * sy),
      strokePaint,
    );
    canvas.drawLine(
      Offset(rRight * sx, rTopY * sy),
      Offset(rRight * sx, rBotY * sy),
      strokePaint,
    );

    // Right top ellipse
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(rCx * sx, rTopY * sy),
        width: rRx * 2 * sx,
        height: rRy * 2 * sy,
      ),
      strokePaint,
    );

    // Right stack rims
    for (final y in [16.8, 20.8]) {
      final path = Path()
        ..moveTo(rLeft * sx, y * sy)
        ..arcToPoint(
          Offset(rRight * sx, y * sy),
          radius: Radius.elliptical(rRx * sx, rRy * sy),
          clockwise: false,
        );
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
