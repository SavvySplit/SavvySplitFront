import 'package:flutter/material.dart';
import '../models/bill.dart';

class BillSplitter extends StatefulWidget {
  final double totalAmount;
  final List<BillSplit> splits;
  final String currentUserId;

  const BillSplitter({
    required this.totalAmount,
    required this.splits,
    required this.currentUserId,
    Key? key,
  }) : super(key: key);

  @override
  State<BillSplitter> createState() => _BillSplitterState();
}

class _BillSplitterState extends State<BillSplitter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with total amount
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                Text(
                  'Total Amount',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${widget.totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          Text(
            'Split Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          
          // List of splits
          Expanded(
            child: ListView.separated(
              itemCount: widget.splits.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final split = widget.splits[index];
                final isCurrentUser = split.userId == widget.currentUserId;
                
                return ListTile(
                  title: Text(
                    isCurrentUser ? 'You' : 'User ${split.userId}',
                    style: TextStyle(
                      fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text('Amount: \$${split.amount.toStringAsFixed(2)}'),
                  trailing: split.isPaid
                      ? const Chip(
                          label: Text('Paid'),
                          backgroundColor: Colors.green,
                          labelStyle: TextStyle(color: Colors.white),
                        )
                      : OutlinedButton(
                          onPressed: () {
                            // TODO: Implement pay functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Payment functionality coming soon!')),
                            );
                          },
                          child: const Text('Pay'),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
