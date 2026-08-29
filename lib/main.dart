import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/core/widgets/appbar.dart';
import 'package:maa_tara/core/widgets/bottom_tabbar.dart';
import 'package:maa_tara/features/auth/login.dart';
import 'package:maa_tara/features/dashboard/dashboard.dart';
import 'package:maa_tara/features/dashboard/staff_dashboard.dart';
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

  final List<String> _pageTitles = [
    'Dashboard',
    'Work',
    'Inventory',
    'Staff',
    'More',
  ];

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
    });
  }

  Widget _currentPage() {
    switch (_currentIndex) {
      case 0:
        return AuthSession.currentUserRole == 'staff'
            ? StaffDashboardPage(
                staff: AuthSession.currentStaff,
                onNavigateTab: _onTabTapped,
              )
            : const DashboardPage();
      case 1:
        return const JobPage();
      case 3:
        return const StaffListPage();
      case 4:
        return const MorePage();
      default:
        return Center(
          child: Text(
            _pageTitles[_currentIndex],
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: Navbar(),
      body: _currentPage(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
