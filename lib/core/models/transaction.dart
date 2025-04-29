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

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      billId: json['billId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'billId': billId,
    };
  }
}
