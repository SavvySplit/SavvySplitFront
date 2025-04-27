class Bill {
  final String id;
  final String title;
  final double totalAmount;
  final String createdBy;
  final DateTime date;
  final List<BillSplit> splits;

  Bill({
    required this.id,
    required this.title, 
    required this.totalAmount,
    required this.createdBy,
    required this.date,
    required this.splits,
  });
}

class BillSplit {
  final String userId;
  final double amount;
  final bool isPaid;

  BillSplit({
    required this.userId,
    required this.amount,
    this.isPaid = false,
  });
}
