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

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'] as String,
      title: json['title'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      createdBy: json['createdBy'] as String,
      date: DateTime.parse(json['date'] as String),
      splits: (json['splits'] as List<dynamic>?)?.map((e) => BillSplit.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'totalAmount': totalAmount,
      'createdBy': createdBy,
      'date': date.toIso8601String(),
      'splits': splits.map((e) => e.toJson()).toList(),
    };
  }
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

  factory BillSplit.fromJson(Map<String, dynamic> json) {
    return BillSplit(
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      isPaid: json['isPaid'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'amount': amount,
      'isPaid': isPaid,
    };
  }
}
