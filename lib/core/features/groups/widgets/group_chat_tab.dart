import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';
import '../models/group.dart';
import '../models/group_analytics.dart';

class GroupChatTab extends StatefulWidget {
  final Group group;

  const GroupChatTab({
    required this.group,
    Key? key,
  }) : super(key: key);

  @override
  State<GroupChatTab> createState() => _GroupChatTabState();
}

class _GroupChatTabState extends State<GroupChatTab> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Sample messages for demo
  final List<GroupChatMessage> _messages = [
    GroupChatMessage.sample(
      id: '1',
      senderId: '2',
      senderName: 'Jane Smith',
      message: 'Hey everyone! I just added the dinner expense from last night.',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
    ),
    GroupChatMessage.sample(
      id: '2',
      senderId: '3',
      senderName: 'Mike Johnson',
      message: 'Thanks Jane! I\'ll settle up this weekend.',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
    ),
    GroupChatMessage.sample(
      id: '3',
      senderId: '1',
      senderName: 'John Doe',
      message: 'Can someone add the movie tickets from yesterday?',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    ),
    GroupChatMessage.sample(
      id: '4',
      senderId: '2',
      senderName: 'Jane Smith',
      message: "I'll do it now!",
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
    ),
    GroupChatMessage.sample(
      id: '5',
      senderId: '4',
      senderName: 'Sarah Williams',
      message: 'When are we planning the next group dinner?',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    GroupChatMessage.sample(
      id: '6',
      senderId: '1',
      senderName: 'John Doe',
      message: 'How about this Saturday?',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _messages.isEmpty
              ? _buildEmptyState()
              : _buildMessageList(),
        ),
        _buildMessageInput(),
      ],
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No messages yet',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation with your group',
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.8),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildMessageList() {
    // Group messages by date
    final groupedMessages = <String, List<GroupChatMessage>>{};
    
    for (final message in _messages) {
      final date = DateFormat('MMMM d, yyyy').format(message.timestamp);
      if (!groupedMessages.containsKey(date)) {
        groupedMessages[date] = [];
      }
      groupedMessages[date]!.add(message);
    }
    
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: groupedMessages.length,
      itemBuilder: (context, index) {
        final date = groupedMessages.keys.elementAt(index);
        final messagesForDate = groupedMessages[date]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildDateDivider(date),
            ...messagesForDate.map((message) => _buildMessageBubble(message)),
          ],
        );
      },
    );
  }
  
  Widget _buildDateDivider(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: AppColors.borderPrimary.withOpacity(0.5),
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              date,
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: AppColors.borderPrimary.withOpacity(0.5),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMessageBubble(GroupChatMessage message) {
    final isCurrentUser = message.senderId == '1'; // Assuming '1' is current user
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.accentGradientMiddle,
              child: const Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isCurrentUser)
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                    child: Text(
                      message.senderName,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? AppColors.accentGradientMiddle
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomLeft: isCurrentUser ? const Radius.circular(16) : const Radius.circular(4),
                      bottomRight: isCurrentUser ? const Radius.circular(4) : const Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
                  child: Text(
                    _formatMessageTime(message.timestamp),
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isCurrentUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.accentGradientEnd,
              child: const Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  String _formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays == 0) {
      return DateFormat('h:mm a').format(timestamp);
    } else if (difference.inDays == 1) {
      return 'Yesterday ${DateFormat('h:mm a').format(timestamp)}';
    } else {
      return DateFormat('MMM d, h:mm a').format(timestamp);
    }
  }
  
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: AppColors.accentGradientMiddle),
              onPressed: () {
                _showAttachmentOptions(context);
              },
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
                  filled: true,
                  fillColor: AppColors.background.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                style: const TextStyle(color: AppColors.textPrimary),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.accentGradientMiddle,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 18),
                onPressed: () {
                  _sendMessage();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add(
        GroupChatMessage.sample(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: '1', // Current user
          senderName: 'John Doe',
          message: _messageController.text.trim(),
          timestamp: DateTime.now(),
        ),
      );
      _messageController.clear();
    });
    
    // Scroll to bottom after message is sent
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
  
  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share with group',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Icons.receipt_long,
                  label: 'Expense',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(context);
                    // Show expense dialog
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.photo,
                  label: 'Photo',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    // Handle photo upload
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.account_balance_wallet,
                  label: 'Settlement',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    // Show settlement dialog
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.location_on,
                  label: 'Location',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    // Handle location sharing
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
