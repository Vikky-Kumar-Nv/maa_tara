import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isStaff;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isStaff = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.navbarBg,
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.white, // selected icon + label white
        unselectedItemColor: const Color(0xFF5A7290), // muted blue-grey
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        items: [
          // 0. Dashboard
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.home, color: Colors.white),
                SizedBox(height: 3),
                SizedBox(
                  width: 20,
                  height: 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFC107), // amber/yellow indicator
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
              ],
            ),
            label: 'Dashboard',
          ),

          // 1. Work
          BottomNavigationBarItem(
            icon: const Icon(Icons.work_outline),
            activeIcon: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.work, color: Colors.white),
                SizedBox(height: 3),
                SizedBox(
                  width: 20,
                  height: 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFC107),
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
              ],
            ),
            label: 'Work',
          ),

          // 2. Inventory
          BottomNavigationBarItem(
            icon: const Icon(Icons.view_in_ar_outlined),
            activeIcon: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.view_in_ar, color: Colors.white),
                SizedBox(height: 3),
                SizedBox(
                  width: 20,
                  height: 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFC107),
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
              ],
            ),
            label: 'Inventory',
          ),

          // 3. Customers (for Staff) OR Staff (for Admin)
          BottomNavigationBarItem(
            icon: Icon(
              isStaff
                  ? Icons.person_outline_rounded
                  : Icons.engineering_outlined,
            ),
            activeIcon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isStaff ? Icons.person_rounded : Icons.engineering,
                  color: Colors.white,
                ),
                const SizedBox(height: 3),
                const SizedBox(
                  width: 20,
                  height: 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFC107),
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
              ],
            ),
            label: isStaff ? 'Customer' : 'Staff',
          ),

          // 4. More
          BottomNavigationBarItem(
            icon: const Icon(Icons.apps_outlined),
            activeIcon: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.apps, color: Colors.white),
                SizedBox(height: 3),
                SizedBox(
                  width: 20,
                  height: 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFC107),
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
              ],
            ),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
