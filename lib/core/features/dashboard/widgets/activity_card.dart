import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import 'activity_item.dart';

class ActivityCard extends StatelessWidget {
  final List<Map<String, dynamic>> activities;
  final Function(Map<String, dynamic>) onActivityTap;
  final Function(int, Map<String, dynamic>) onActivityDismiss;

  const ActivityCard({
    Key? key,
    required this.activities,
    required this.onActivityTap,
    required this.onActivityDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) => ActivityItem(
              activity: activities[index],
              index: index,
              onTap: onActivityTap,
              onDismiss: onActivityDismiss,
            ),
          ),
        ],
      ),
    );
  }
}
