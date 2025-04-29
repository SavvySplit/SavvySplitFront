class Group {
  final String id;
  final String name;
  final List<String> memberIds;
  final String createdBy;
  final List<String> billIds;
  final bool recurring;

  Group({
    required this.id,
    required this.name,
    required this.memberIds,
    required this.createdBy,
    required this.billIds,
    this.recurring = false,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as String,
      name: json['name'] as String,
      memberIds: List<String>.from(json['memberIds'] ?? []),
      createdBy: json['createdBy'] as String,
      billIds: List<String>.from(json['billIds'] ?? []),
      recurring: json['recurring'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'memberIds': memberIds,
      'createdBy': createdBy,
      'billIds': billIds,
      'recurring': recurring,
    };
  }
}
