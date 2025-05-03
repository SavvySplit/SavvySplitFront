import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import 'action_button.dart';

class QuickActionsCard extends StatelessWidget {
  final List<Map<String, dynamic>> actions;
  
  const QuickActionsCard({
    Key? key,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8),
          color: AppColors.cardBackground,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.surface, width: 1.2),
            ),
            child: Wrap(
              spacing: 5.0, // Reduced from 8.0
              runSpacing: 10.0, // Increased from 8.0 for better vertical separation
              alignment: WrapAlignment.spaceBetween, // Changed to spaceBetween for better distribution
              children: actions.map((action) {
                return ActionButton(
                  icon: action['icon'] as IconData,
                  label: action['label'] as String,
                  colorStart: action['colorStart'] as Color,
                  colorEnd: action['colorEnd'] as Color,
                  onTap: action['onTap'] as VoidCallback,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 12),
      child: Row(
        children: [
          _buildAccentBar(),
          const SizedBox(width: 8),
          const Text(
            'Quick Actions',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccentBar() {
    return const SizedBox(
      width: 5,
      height: 28,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: AppColors.accent,
        ),
      ),
    );
  }
}
