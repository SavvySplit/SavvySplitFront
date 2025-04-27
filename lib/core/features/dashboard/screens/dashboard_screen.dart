import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import 'package:savvysplit/core/features/dashboard/widgets/ai_insight_card.dart';
import '../widgets/transaction_item.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gradientStart,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF010D21),
              const Color(0xFF060121),
              const Color(0xFF000046),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  _buildTransactionList(context),
                  const SizedBox(height: 20),
                  _buildAIInsights(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Dashboard',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // Notification action
                },
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.secondary.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  // Profile action
                },
                icon: const Icon(Icons.person_outline, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.secondary.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context) {
    // Mock data for the transaction list
    final transactions = [
      {
        'category': 'OTHERS',
        'title': 'Uber Ride',
        'date': '23/04/2025',
        'amount': -35.50,
        'icon': Icons.directions_car_outlined,
        'color': Colors.blue,
        'type': 'TRANSPORT',
      },
      {
        'category': 'BILLS',
        'title': 'Electric Bill',
        'date': '22/04/2025',
        'amount': -89.99,
        'icon': Icons.electrical_services_outlined,
        'color': Colors.blue,
        'type': 'BILLS',
      },
      {
        'category': 'SHOPPING',
        'title': 'Shopping Mall',
        'date': '21/04/2025',
        'amount': -120.00,
        'icon': Icons.shopping_bag_outlined,
        'color': Colors.teal,
        'type': 'SHOPPING',
      },
    ];

    return Column(
      children:
          transactions.map((transaction) {
            return TransactionItem(
              title: transaction['title'] as String,
              date: transaction['date'] as String,
              amount: transaction['amount'] as double,
              type: transaction['type'] as String,
              icon: transaction['icon'] as IconData,
              color: transaction['color'] as Color,
            );
          }).toList(),
    );
  }

  Widget _buildAIInsights(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.lightbulb_outline, color: Colors.tealAccent, size: 24),
            const SizedBox(width: 8),
            Text(
              'AI Insights',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const AIInsightCard(
          title: 'Unusual Spending',
          description: 'Your restaurant spending is 40% higher than last month',
          icon: Icons.warning_amber_outlined,
          color: Colors.orange,
        ),
        const SizedBox(height: 12),
        const AIInsightCard(
          title: 'Savings Opportunity',
          description: 'You could save \$200 by optimizing your subscriptions',
          icon: Icons.savings_outlined,
          color: Colors.teal,
        ),
        const SizedBox(height: 100), // Add extra space at bottom
      ],
    );
  }
}
