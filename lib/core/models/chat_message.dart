class ChatMessage {
  final String id;
  final String groupId;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final String messageType;

  ChatMessage({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.messageType,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      messageType: json['messageType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'messageType': messageType,
    };
  }
}
