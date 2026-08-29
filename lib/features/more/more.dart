import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';
import 'package:maa_tara/features/auth/login.dart';
import 'package:maa_tara/features/customers/customer_list.dart';
import 'package:maa_tara/features/staff/staff_list.dart';

typedef _C = AppColors;

// ─────────────────────────────────────────────────────────────────────────────
//  More Item Model
// ─────────────────────────────────────────────────────────────────────────────
class _MoreMenuItem {
  final String title;
  final IconData icon;
  final int? badgeCount;
  final VoidCallback? onTap;

  const _MoreMenuItem({
    required this.title,
    required this.icon,
    this.badgeCount,
    this.onTap,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
//  More Page (Body content for More Tab)
// ─────────────────────────────────────────────────────────────────────────────
class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      _MoreMenuItem(
        title: 'Customers',
        icon: Icons.people_outline_rounded,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CustomerListPage()),
          );
        },
      ),
      _MoreMenuItem(
        title: 'Suppliers',
        icon: Icons.local_shipping_outlined,
        onTap: () => _handleItemTap(context, 'Suppliers'),
      ),
      _MoreMenuItem(
        title: 'Categories',
        icon: Icons.grid_view_rounded,
        onTap: () => _handleItemTap(context, 'Categories'),
      ),
      _MoreMenuItem(
        title: 'Brands',
        icon: Icons.loyalty_outlined,
        onTap: () => _handleItemTap(context, 'Brands'),
      ),
      _MoreMenuItem(
        title: 'Attendance',
        icon: Icons.assignment_ind_outlined,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StaffListPage()),
          );
        },
      ),
      _MoreMenuItem(
        title: 'Reports',
        icon: Icons.insert_chart_outlined_rounded,
        onTap: () => _handleItemTap(context, 'Reports'),
      ),
      _MoreMenuItem(
        title: 'Notifications',
        icon: Icons.notifications_none_rounded,
        badgeCount: 7,
        onTap: () => _handleItemTap(context, 'Notifications'),
      ),
      _MoreMenuItem(
        title: 'Settings',
        icon: Icons.settings_outlined,
        onTap: () => _handleItemTap(context, 'Settings'),
      ),
      _MoreMenuItem(
        title: 'Admin Profile',
        icon: Icons.account_circle_outlined,
        onTap: () => _handleItemTap(context, 'Admin Profile'),
      ),
      _MoreMenuItem(
        title: 'Change Password',
        icon: Icons.lock_outline_rounded,
        onTap: () => _handleItemTap(context, 'Change Password'),
      ),
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Title & Subtitle ─────────────────────────────────────────
          const Text(
            'More',
            style: TextStyle(
              color: _C.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Manage all settings and data',
            style: TextStyle(
              color: _C.muted,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 18),

          // ── 2-Column Menu Grid ──────────────────────────────────────────────
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: menuItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.35,
            ),
            itemBuilder: (context, index) {
              return _buildMenuCard(context, menuItems[index]);
            },
          ),
          const SizedBox(height: 14),

          // ── Full-Width Logout Card ──────────────────────────────────────────
          _buildLogoutCard(context),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ── Menu Card Widget ────────────────────────────────────────────────────────
  Widget _buildMenuCard(BuildContext context, _MoreMenuItem item) {
    return Material(
      color: _C.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: _C.accent.withValues(alpha: 0.15),
        highlightColor: _C.accent.withValues(alpha: 0.08),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _C.divider, width: 1),
          ),
          child: Row(
            children: [
              // Icon with optional Notification Badge
              _buildIconWithBadge(item.icon, item.badgeCount),
              const SizedBox(width: 10),

              // Title
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    color: _C.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Right Arrow Chevron
              const Icon(
                Icons.chevron_right_rounded,
                color: _C.muted,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Icon With Optional Red Badge ────────────────────────────────────────────
  Widget _buildIconWithBadge(IconData icon, int? badgeCount) {
    if (badgeCount == null || badgeCount <= 0) {
      return Icon(icon, color: _C.accent, size: 22);
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, color: _C.accent, size: 22),
        Positioned(
          top: -4,
          right: -5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
            decoration: BoxDecoration(
              color: _C.red,
              shape: BoxShape.circle,
              border: Border.all(color: _C.card, width: 1.5),
            ),
            constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
            alignment: Alignment.center,
            child: Text(
              '$badgeCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Full-Width Logout Card ──────────────────────────────────────────────────
  Widget _buildLogoutCard(BuildContext context) {
    return Material(
      color: _C.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _showLogoutConfirmation(context),
        borderRadius: BorderRadius.circular(12),
        splashColor: _C.red.withValues(alpha: 0.15),
        highlightColor: _C.red.withValues(alpha: 0.08),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _C.divider, width: 1),
          ),
          child: Row(
            children: const [
              Icon(Icons.logout_rounded, color: _C.red, size: 22),
              SizedBox(width: 14),
              Text(
                'Logout',
                style: TextStyle(
                  color: _C.red,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Logout Confirmation Dialog ──────────────────────────────────────────────
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: _C.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: _C.divider, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon Circle
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: _C.red.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _C.red.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: _C.red,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 14),

                // Dialog Title
                const Text(
                  'Confirm Logout',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _C.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),

                // Dialog Message
                const Text(
                  'Are you sure you want to log out from MAA TARA Automobiles?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _C.muted,
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 20),

                // Action Buttons (Cancel & Logout)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _C.divider, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: _C.muted,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _C.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── General Item Tap Feedback ───────────────────────────────────────────────
  void _handleItemTap(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $title...'),
        backgroundColor: _C.card,
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }
}
