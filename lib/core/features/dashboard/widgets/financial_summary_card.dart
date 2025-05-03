import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import 'financial_progress_bar.dart';

class FinancialSummaryCard extends StatelessWidget {
  final List<Map<String, dynamic>> progressItems;
  
  const FinancialSummaryCard({
    Key? key,
    required this.progressItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        Container(
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
            children: progressItems.map((item) {
              return Column(
                children: [
                  FinancialProgressBar(
                    title: item['title'] as String,
                    progress: item['progress'] as double,
                    description: item['description'] as String,
                    color: item['color'] as Color,
                  ),
                  if (progressItems.last != item) const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 4),
      child: Row(
        children: [
          _buildAccentBar(),
          const SizedBox(width: 8),
          const Text(
            'Financial Summary',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 18,
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
