class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final DateTime date;
  final bool read;
  final String type;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.date,
    this.read = false,
    required this.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      date: DateTime.parse(json['date'] as String),
      read: json['read'] ?? false,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'date': date.toIso8601String(),
      'read': read,
      'type': type,
    };
  }
}
