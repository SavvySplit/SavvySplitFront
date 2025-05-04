import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../constants/colors.dart';
import '../providers/tab_provider.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabProvider>(context);

    return Scaffold(
      body: Stack(children: [child]),
      extendBody: true, // Important for curved navigation bar to look good
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: AppColors.gradientStart,
          buttonBackgroundColor: AppColors.accent, // Highlight active button
          height: 65, // Slightly taller
          animationDuration: const Duration(milliseconds: 300),
          animationCurve: Curves.easeInOut,
          index: tabProvider.currentIndex,
          onTap: (index) {
            // Add haptic feedback
            HapticFeedback.lightImpact();

            tabProvider.setIndex(index);
            switch (index) {
              case 0:
                context.go('/dashboard');
                break;
              case 1:
                context.go('/wallet');
                break;
              case 2:
                context.go('/groups');
                break;
              case 3:
                context.go('/analytics');
                break;
              case 4:
                context.go('/settings');
                break;
            }
          },
          items: [
            _buildNavItem(Icons.home, 'Home', tabProvider.currentIndex == 0),
            _buildNavItem(
              Icons.receipt_long,
              'Wallet',
              tabProvider.currentIndex == 1,
            ),
            _buildNavItem(Icons.group, 'Groups', tabProvider.currentIndex == 2),
            _buildNavItem(
              Icons.analytics,
              'Analytics',
              tabProvider.currentIndex == 3,
            ),
            _buildNavItem(
              Icons.person,
              'Profile',
              tabProvider.currentIndex == 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 22, // Smaller consistent size
        ),
        if (isActive) ...[
          // Only show label for active item
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ],
    );
  }
}
