import 'package:flutter/material.dart';
import '../../core/models/goal.dart';
import '../constants/colors.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;

  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: 'Goal Title',
            child: Text(
              goal.title, // Fixed: Use goal.title instead of goal.name
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Semantics(
            label: 'Goal Target Amount',
            child: Text(
              'Target: \$${goal.targetAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 4),
          Semantics(
            label: 'Goal Progress',
            child: Text(
              'Progress: ${goal.progress.toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 8),
          Semantics(
            label: 'Progress bar for goal',
            child: LinearProgressIndicator(
              value: goal.progress / 100, // Convert percentage to 0-1 range
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
              minHeight: 6,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
