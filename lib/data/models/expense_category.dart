import 'package:flutter/material.dart';

class ExpenseCategory {
  final String label;
  final double value;
  final Color color;

  const ExpenseCategory({
    required this.label,
    required this.value,
    required this.color,
  });

  // Convert from Map (for API responses)
  factory ExpenseCategory.fromMap(Map<String, dynamic> map) {
    return ExpenseCategory(
      label: map['label'] as String,
      value: map['value'] as double,
      color: map['color'] as Color,
    );
  }

  // Convert to Map (for API requests or storage)
  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'value': value,
      'color': color,
    };
  }
}
