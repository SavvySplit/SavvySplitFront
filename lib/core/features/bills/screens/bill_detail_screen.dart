import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../constants/colors.dart';
import '../../../models/bill.dart';
import '../../../widgets/bill_splitter_widget.dart';

class BillDetailScreen extends StatelessWidget {
  final Bill bill;

  const BillDetailScreen({required this.bill, super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUserId = authProvider.userId;

    if (currentUserId == null) {
      // Redirect to login if user is not authenticated
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
      return const Scaffold(body: Center(child: Text('Please log in')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(bill.title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BillSplitter(
        totalAmount: bill.totalAmount, // Pass totalAmount from bill
        splits: bill.splits, // Pass splits from bill
        currentUserId: currentUserId, // Pass currentUserId
      ),
    );
  }
}
