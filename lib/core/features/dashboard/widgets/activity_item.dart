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
    // Get amount and format it for display
    final amount = activity['amount'] as String;
    final isIncome = (activity['category'] as String).toLowerCase() == 'income';
    final icon = activity['icon'] as IconData;
    final color = activity['color'] as Color;
    final category = activity['category'] as String;
    
    return await showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.surface, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with warning icon
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.red.shade500,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Confirm Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Transaction details
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Transaction icon and info
                    Row(
                      children: [
                        // Transaction icon
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            color: color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 15),
                        // Transaction details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity['label'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                category,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Amount
                        Text(
                          amount,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isIncome ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Warning text
                    Text(
                      'Are you sure you want to delete this transaction? This action cannot be undone directly.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Action buttons
                    Row(
                      children: [
                        // Cancel button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade200,
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'CANCEL',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Delete button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade500,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'DELETE',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ) ?? false;
  }

  Widget _buildActivityCard(BuildContext context, bool isIncome) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => onTap(activity),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.grey.withOpacity(0.15),
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: _buildActivityContent(isIncome),
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
