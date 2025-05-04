import 'package:flutter/material.dart';

class GroupAnalytics {
  final List<ExpenseCategory> categoryBreakdown;
  final List<MemberContribution> memberContributions;
  final List<TimeSeriesExpense> spendingTrends;

  GroupAnalytics({
    required this.categoryBreakdown,
    required this.memberContributions,
    required this.spendingTrends,
  });

  // Factory method to create sample analytics data
  factory GroupAnalytics.sample() {
    return GroupAnalytics(
      categoryBreakdown: [
        ExpenseCategory(name: 'Food', amount: 320.50, color: Colors.orange),
        ExpenseCategory(name: 'Entertainment', amount: 145.75, color: Colors.purple),
        ExpenseCategory(name: 'Transportation', amount: 95.25, color: Colors.blue),
        ExpenseCategory(name: 'Groceries', amount: 210.30, color: Colors.green),
        ExpenseCategory(name: 'Utilities', amount: 180.00, color: Colors.red),
      ],
      memberContributions: [
        MemberContribution(
          memberId: '1',
          memberName: 'John Doe',
          totalContribution: 350.80,
          categoryContributions: {
            'Food': 120.50,
            'Entertainment': 80.30,
            'Transportation': 50.00,
            'Groceries': 100.00,
          },
        ),
        MemberContribution(
          memberId: '2',
          memberName: 'Jane Smith',
          totalContribution: 420.00,
          categoryContributions: {
            'Food': 150.00,
            'Entertainment': 65.45,
            'Utilities': 180.00,
            'Groceries': 24.55,
          },
        ),
        MemberContribution(
          memberId: '3',
          memberName: 'Mike Johnson',
          totalContribution: 180.00,
          categoryContributions: {
            'Food': 50.00,
            'Transportation': 45.25,
            'Groceries': 84.75,
          },
        ),
      ],
      spendingTrends: [
        TimeSeriesExpense(date: DateTime.now().subtract(const Duration(days: 30)), amount: 120.00),
        TimeSeriesExpense(date: DateTime.now().subtract(const Duration(days: 25)), amount: 85.50),
        TimeSeriesExpense(date: DateTime.now().subtract(const Duration(days: 20)), amount: 210.25),
        TimeSeriesExpense(date: DateTime.now().subtract(const Duration(days: 15)), amount: 45.00),
        TimeSeriesExpense(date: DateTime.now().subtract(const Duration(days: 10)), amount: 180.75),
        TimeSeriesExpense(date: DateTime.now().subtract(const Duration(days: 5)), amount: 95.25),
        TimeSeriesExpense(date: DateTime.now(), amount: 150.00),
      ],
    );
  }
}

class ExpenseCategory {
  final String name;
  final double amount;
  final Color color;

  ExpenseCategory({
    required this.name,
    required this.amount,
    required this.color,
  });
}

class MemberContribution {
  final String memberId;
  final String memberName;
  final double totalContribution;
  final Map<String, double> categoryContributions;

  MemberContribution({
    required this.memberId,
    required this.memberName,
    required this.totalContribution,
    required this.categoryContributions,
  });
}

class TimeSeriesExpense {
  final DateTime date;
  final double amount;

  TimeSeriesExpense({
    required this.date,
    required this.amount,
  });
}

// Model for expense with enhanced splitting options
class GroupExpense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String paidById;
  final String paidByName;
  final String category;
  final SplitType splitType;
  final Map<String, double> customSplits;
  final bool isRecurring;
  final RecurringFrequency? recurringFrequency;
  final String? receiptImageUrl;
  final String? notes;

  GroupExpense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.paidById,
    required this.paidByName,
    required this.category,
    this.splitType = SplitType.equal,
    this.customSplits = const {},
    this.isRecurring = false,
    this.recurringFrequency,
    this.receiptImageUrl,
    this.notes,
  });

  // Factory method to create sample expense
  factory GroupExpense.sample({
    required String id,
    required String title,
    required double amount,
    required DateTime date,
    required String paidById,
    required String paidByName,
    required String category,
  }) {
    return GroupExpense(
      id: id,
      title: title,
      amount: amount,
      date: date,
      paidById: paidById,
      paidByName: paidByName,
      category: category,
    );
  }
}

enum SplitType {
  equal,
  percentage,
  exact,
  shares,
}

enum RecurringFrequency {
  daily,
  weekly,
  monthly,
  yearly,
}

// Model for settlement with enhanced features
class Settlement {
  final String id;
  final String fromId;
  final String fromName;
  final String toId;
  final String toName;
  final double amount;
  final DateTime date;
  final SettlementStatus status;
  final PaymentMethod? paymentMethod;

  Settlement({
    required this.id,
    required this.fromId,
    required this.fromName,
    required this.toId,
    required this.toName,
    required this.amount,
    required this.date,
    required this.status,
    this.paymentMethod,
  });

  // Factory method to create sample settlement
  factory Settlement.sample({
    required String id,
    required String fromId,
    required String fromName,
    required String toId,
    required String toName,
    required double amount,
    required DateTime date,
    required SettlementStatus status,
  }) {
    return Settlement(
      id: id,
      fromId: fromId,
      fromName: fromName,
      toId: toId,
      toName: toName,
      amount: amount,
      date: date,
      status: status,
    );
  }
}

enum SettlementStatus {
  pending,
  completed,
  cancelled,
}

enum PaymentMethod {
  cash,
  bankTransfer,
  venmo,
  paypal,
  other,
}

// Model for group chat message
class GroupChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderAvatarUrl;
  final String message;
  final DateTime timestamp;
  final MessageType type;
  final String? attachmentUrl;

  GroupChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderAvatarUrl,
    required this.message,
    required this.timestamp,
    this.type = MessageType.text,
    this.attachmentUrl,
  });

  // Factory method to create sample message
  factory GroupChatMessage.sample({
    required String id,
    required String senderId,
    required String senderName,
    required String message,
    required DateTime timestamp,
  }) {
    return GroupChatMessage(
      id: id,
      senderId: senderId,
      senderName: senderName,
      message: message,
      timestamp: timestamp,
    );
  }
}

enum MessageType {
  text,
  image,
  expense,
  settlement,
}
