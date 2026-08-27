import 'package:flutter/material.dart';
import 'package:maa_tara/appbar.dart';
import 'package:maa_tara/bottom_tabbar.dart';
import 'package:maa_tara/dashboard.dart';
import 'package:maa_tara/job.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A1628),
        canvasColor: const Color(0xFF0A1628),
        cardColor: const Color(0xFF162336),
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF0A1628),
          primary: Color(0xFFE8A020),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _currentPage() {
    switch (_currentIndex) {
      case 0:
        return const DashboardPage();
      case 1:
        return const JobPage();
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
