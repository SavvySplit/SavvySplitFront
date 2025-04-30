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
          // Position the FAB at the bottom center
          Positioned(
            bottom: 40, // Increased to ensure it's above the navigation bar
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 48, // Smaller size
                width: 48, // Smaller size
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accentGradientStart,
                      AppColors.accentGradientEnd,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
          // Show bottom sheet with options to add expense, income, or split bill
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder:
                (context) => Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.gradientStart,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.add, color: Colors.white),
                        title: const Text(
                          'Add Expense',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Navigate to Add Expense'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.attach_money,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'Add Income',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Navigate to Add Income'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.group, color: Colors.white),
                        title: const Text(
                          'Split Bill',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Navigate to Split Bill'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
          );
                    },
                    customBorder: const CircleBorder(),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24, // Smaller icon
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      extendBody: true, // Important for curved navigation bar to look good
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: AppColors.gradientStart,
        buttonBackgroundColor: AppColors.gradientStart, // Remove the middle button highlight
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
              context.go('/settings');
              break;
          }
        },
        items: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.receipt_long, color: Colors.white),
          Icon(Icons.group, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
      ),
    );
  }

  // Removed _buildNavItem method as it's no longer needed with CurvedNavigationBar
}
