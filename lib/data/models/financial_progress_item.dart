import 'package:flutter/material.dart';

class FinancialProgressItem {
  final String title;
  final double progress;
  final String description;
  final Color color;

  const FinancialProgressItem({
    required this.title,
    required this.progress,
    required this.description,
    required this.color,
  });

  // Convert from Map (for API responses)
  factory FinancialProgressItem.fromMap(Map<String, dynamic> map) {
    return FinancialProgressItem(
      title: map['title'] as String,
      progress: map['progress'] as double,
      description: map['description'] as String,
      color: map['color'] as Color,
    );
  }

  // Convert to Map (for API requests or storage)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'progress': progress,
      'description': description,
      'color': color,
    };
  }
}
