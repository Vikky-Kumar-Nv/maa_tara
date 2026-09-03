import 'package:flutter/material.dart';
import 'package:maa_tara/core/constants/colors.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.card,
      elevation: 0,
      titleSpacing: 0,
      centerTitle: true,
      toolbarHeight: 65,

      // Left side menu
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.white),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Menu clicked'),
              backgroundColor: AppColors.card,
              duration: Duration(milliseconds: 800),
            ),
          );
        },
      ),

      // Center Brand Logo (Full & Unclipped)
      title: SizedBox(
        width: 220,
        height: 56,
        child: Image.asset(
          'assets/images/app_nav-barrr.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'lib/core/images/app_nav-barrr.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),

      // Right side notification
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: AppColors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notifications clicked'),
                backgroundColor: AppColors.card,
                duration: Duration(milliseconds: 800),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65);
}
