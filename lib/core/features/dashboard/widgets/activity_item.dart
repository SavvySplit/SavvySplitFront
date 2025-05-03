import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

class ActivityItem extends StatelessWidget {
  final Map<String, dynamic> activity;
  final int index;
  final Function(Map<String, dynamic>) onTap;
  final Function(int, Map<String, dynamic>) onDismiss;

  const ActivityItem({
    Key? key,
    required this.activity,
    required this.index,
    required this.onTap,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIncome = (activity['category'] as String).toLowerCase() == 'income';
    
    return Dismissible(
      key: Key('activity_${index}_${activity['label']}'),
      background: _buildDismissBackground(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDismiss(context),
      onDismissed: (_) => onDismiss(index, activity),
      child: _buildActivityCard(context, isIncome),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.shade300,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20.0),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Future<bool> _confirmDismiss(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Confirm Delete',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete ${activity['label']}?',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ?? false;
  }

  Widget _buildActivityCard(BuildContext context, bool isIncome) {
    return Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(14),
      color: AppColors.cardBackground,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => onTap(activity),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 7,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: _buildActivityContent(isIncome),
        ),
      ),
    );
  }

  Widget _buildActivityContent(bool isIncome) {
    return Row(
      children: [
        _buildActivityIcon(),
        const SizedBox(width: 14),
        _buildActivityDetails(),
        const SizedBox(width: 12),
        _buildActivityAmount(isIncome),
      ],
    );
  }

  Widget _buildActivityIcon() {
    return Container(
      decoration: BoxDecoration(
        color: (activity['color'] as Color).withOpacity(0.18),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(10),
      child: Icon(
        activity['icon'] as IconData,
        color: activity['color'] as Color,
        size: 22,
      ),
    );
  }

  Widget _buildActivityDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            activity['label'] as String,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15.5,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            activity['category'] as String,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityAmount(bool isIncome) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          activity['amount'] as String,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15.5,
            color: isIncome
                ? Colors.greenAccent.shade200
                : Colors.redAccent.shade100,
          ),
        ),
        Text(
          activity['date'] as String,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
