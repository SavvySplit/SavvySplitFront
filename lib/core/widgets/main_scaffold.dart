import 'package:flutter/material.dart';
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
      body: Stack(
        children: [
          child,
        ],
      ),
      extendBody: true, // Important for curved navigation bar to look good
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: AppColors.gradientStart,
        buttonBackgroundColor:
            AppColors.gradientStart, // Remove the middle button highlight
        height: 60,
        index: tabProvider.currentIndex,
        onTap: (index) {
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
        items: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.receipt_long, color: Colors.white),
          Icon(Icons.group, color: Colors.white),
          Icon(Icons.analytics, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
      ),
    );
  }

  // Removed _buildNavItem method as it's no longer needed with CurvedNavigationBar
}
