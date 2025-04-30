import 'package:flutter/material.dart';

class Group {
  final String id;
  final String name;
  final List<GroupMember> members;
  final double totalAmount;
  final DateTime lastActivity;
  final Color color;
  final String imageUrl;

  Group({
    required this.id,
    required this.name,
    required this.members,
    required this.totalAmount,
    required this.lastActivity,
    required this.color,
    this.imageUrl = '',
  });
}

class GroupMember {
  final String id;
  final String name;
  final String imageUrl;
  final double balance;
  final bool isAdmin;

  GroupMember({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.balance,
    this.isAdmin = false,
  });
}
