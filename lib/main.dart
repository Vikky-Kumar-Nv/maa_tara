import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/core/widgets/appbar.dart';
import 'package:maa_tara/core/widgets/bottom_tabbar.dart';
import 'package:maa_tara/features/auth/login.dart';
import 'package:maa_tara/features/customers/customer_list.dart';
import 'package:maa_tara/features/dashboard/dashboard.dart';
import 'package:maa_tara/features/dashboard/staff_dashboard.dart';
import 'package:maa_tara/features/inventory/inventory_page.dart';
import 'package:maa_tara/features/more/more.dart';
import 'package:maa_tara/features/staff/staff_list.dart';
import 'package:maa_tara/features/work/job.dart';

void main() {
  runApp(const MyApp());
}

// ─────────────────────────────────────────────────────────────────────────────
//  Global Auth Session
// ─────────────────────────────────────────────────────────────────────────────
class AuthSession {
  static String currentUserRole = 'admin'; // 'admin' or 'staff'
  static StaffModel? currentStaff;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        canvasColor: AppColors.bg,
        cardColor: AppColors.card,
        colorScheme: const ColorScheme.dark(
          surface: AppColors.bg,
          primary: AppColors.accent,
        ),
      ),
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: mediaQuery.textScaler.clamp(
              minScaleFactor: 0.85,
              maxScaleFactor: 1.0,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const LoginPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  final String? userRole;
  final StaffModel? staff;

  const HomePage({super.key, this.userRole, this.staff});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Track which tabs have been visited (for lazy initialization)
  final Set<int> _visitedTabs = {0};

  @override
  void initState() {
    super.initState();
    if (widget.userRole != null) {
      AuthSession.currentUserRole = widget.userRole!;
    }
    if (widget.staff != null) {
      AuthSession.currentStaff = widget.staff;
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _visitedTabs.add(index);
    });
  }

  List<Widget> _buildPages() {
    final isStaff = AuthSession.currentUserRole == 'staff';

    return [
      // Tab 0: Dashboard
      _visitedTabs.contains(0)
          ? (isStaff
                ? StaffDashboardPage(
                    staff: AuthSession.currentStaff,
                    onNavigateTab: _onTabTapped,
                  )
                : const DashboardPage())
          : const SizedBox.shrink(),

      // Tab 1: Jobs
      _visitedTabs.contains(1)
          ? const JobPage()
          : const SizedBox.shrink(),

      // Tab 2: Inventory
      _visitedTabs.contains(2)
          ? const InventoryPage()
          : const SizedBox.shrink(),

      // Tab 3: Staff / Customers
      _visitedTabs.contains(3)
          ? (isStaff ? const CustomerListPage() : const StaffListPage())
          : const SizedBox.shrink(),

      // Tab 4: More
      _visitedTabs.contains(4)
          ? const MorePage()
          : const SizedBox.shrink(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isStaff = AuthSession.currentUserRole == 'staff';

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: const Navbar(),
      body: IndexedStack(
        index: _currentIndex,
        children: _buildPages(),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        isStaff: isStaff,
      ),
    );
  }
}
