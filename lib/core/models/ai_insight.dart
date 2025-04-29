class AIInsight {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime date;
  final String type;

  AIInsight({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
  });

  factory AIInsight.fromJson(Map<String, dynamic> json) {
    return AIInsight(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'type': type,
    };
  }
}
