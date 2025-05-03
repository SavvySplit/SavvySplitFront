import 'package:flutter/material.dart';

class Activity {
  final String label;
  final String category;
  final String amount;
  final Color color;
  final IconData icon;
  final String date;

  const Activity({
    required this.label,
    required this.category,
    required this.amount,
    required this.color,
    required this.icon,
    required this.date,
  });

  bool get isIncome => category.toLowerCase() == 'income';

  // Convert from Map (for API responses)
  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      label: map['label'] as String,
      category: map['category'] as String,
      amount: map['amount'] as String,
      color: map['color'] as Color,
      icon: map['icon'] as IconData,
      date: map['date'] as String,
    );
  }

  // Convert to Map (for API requests or storage)
  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'category': category,
      'amount': amount,
      'color': color,
      'icon': icon,
      'date': date,
    };
  }
}
