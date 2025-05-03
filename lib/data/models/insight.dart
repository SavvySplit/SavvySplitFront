import 'package:flutter/material.dart';

class Insight {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String actionLabel;

  const Insight({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.actionLabel,
  });

  // Convert from Map (for API responses)
  factory Insight.fromMap(Map<String, dynamic> map) {
    return Insight(
      title: map['title'] as String,
      description: map['description'] as String,
      icon: map['icon'] as IconData,
      color: map['color'] as Color,
      actionLabel: map['actionLabel'] as String,
    );
  }

  // Convert to Map (for API requests or storage)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
      'color': color,
      'actionLabel': actionLabel,
    };
  }
}
