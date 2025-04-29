class Goal {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;

  Goal({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
  });

  double get progress =>
      (currentAmount / targetAmount.clamp(0.01, double.infinity)) * 100;

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] as String,
      title: json['title'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
    };
  }
}
