class Transaction {
  final String id;
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  final String? billId; // New: Reference to the bill (if applicable)

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    this.billId,
  });
}
