import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/transaction.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({required this.transaction, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        transaction.description,
        style: const TextStyle(color: AppColors.textPrimary),
      ),
      subtitle: Text(
        '${transaction.date.toString().substring(0, 10)} | ${transaction.category}',
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      trailing: Text(
        '-\$${transaction.amount.toStringAsFixed(2)}',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
