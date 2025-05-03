import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import 'enhanced_ai_insight_card.dart';

class AIInsightsCard extends StatelessWidget {
  final List<Map<String, dynamic>> insights;
  
  const AIInsightsCard({
    Key? key,
    required this.insights,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                ...insights.map((insight) {
                  return Column(
                    children: [
                      EnhancedAIInsightCard(
                        title: insight['title'] as String,
                        description: insight['description'] as String,
                        icon: insight['icon'] as IconData,
                        color: insight['color'] as Color,
                        onDismiss: insight['onDismiss'] as VoidCallback,
                        onAction: insight['onAction'] as VoidCallback,
                        actionLabel: insight['actionLabel'] as String,
                      ),
                      if (insight != insights.last) const SizedBox(height: 12),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          _buildAccentBar(),
          const SizedBox(width: 8),
          const Text(
            'AI Insights',
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
