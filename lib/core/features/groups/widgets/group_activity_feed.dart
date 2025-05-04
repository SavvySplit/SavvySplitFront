import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';

class GroupActivityFeed extends StatefulWidget {
  const GroupActivityFeed({Key? key}) : super(key: key);

  @override
  State<GroupActivityFeed> createState() => _GroupActivityFeedState();
}

class _GroupActivityFeedState extends State<GroupActivityFeed> {
  String _filterOption = 'All';
  final List<String> _filterOptions = ['All', 'Expenses', 'Settlements', 'Groups'];
  
  // Sample activity items for demo
  final List<ActivityItem> _activityItems = [
    ActivityItem(
      id: '1',
      type: ActivityType.expense,
      title: 'Dinner at Italian Restaurant',
      description: 'Jane added an expense in Roommates',
      amount: 120.50,
      groupId: '1',
      groupName: 'Roommates',
      groupColor: Colors.red,
      userId: '2',
      userName: 'Jane Smith',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    ActivityItem(
      id: '2',
      type: ActivityType.settlement,
      title: 'Settlement',
      description: 'Mike paid Jane in Roommates',
      amount: 45.25,
      groupId: '1',
      groupName: 'Roommates',
      groupColor: Colors.red,
      userId: '3',
      userName: 'Mike Johnson',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ActivityItem(
      id: '3',
      type: ActivityType.group,
      title: 'New Group',
      description: 'You created Trip to Paris',
      amount: 0,
      groupId: '2',
      groupName: 'Trip to Paris',
      groupColor: Colors.blue,
      userId: '1',
      userName: 'John Doe',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ActivityItem(
      id: '4',
      type: ActivityType.expense,
      title: 'Movie Tickets',
      description: 'You added an expense in Weekend BBQ',
      amount: 45.00,
      groupId: '3',
      groupName: 'Weekend BBQ',
      groupColor: Colors.green,
      userId: '1',
      userName: 'John Doe',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ActivityItem(
      id: '5',
      type: ActivityType.settlement,
      title: 'Settlement',
      description: 'Sarah paid you in Trip to Paris',
      amount: 175.00,
      groupId: '2',
      groupName: 'Trip to Paris',
      groupColor: Colors.blue,
      userId: '4',
      userName: 'Sarah Williams',
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
    ),
    ActivityItem(
      id: '6',
      type: ActivityType.expense,
      title: 'Groceries',
      description: 'Emily added an expense in Weekend BBQ',
      amount: 90.00,
      groupId: '3',
      groupName: 'Weekend BBQ',
      groupColor: Colors.green,
      userId: '6',
      userName: 'Emily Davis',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: _buildActivityList(),
        ),
      ],
    );
  }
  
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activity Feed',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filterOptions.length,
              itemBuilder: (context, index) {
                final isSelected = _filterOptions[index] == _filterOption;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _filterOption = _filterOptions[index];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accentGradientMiddle : AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        _filterOptions[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActivityList() {
    // Filter activities based on selected filter
    final filteredActivities = _filterOption == 'All'
        ? _activityItems
        : _activityItems.where((activity) {
            if (_filterOption == 'Expenses') {
              return activity.type == ActivityType.expense;
            } else if (_filterOption == 'Settlements') {
              return activity.type == ActivityType.settlement;
            } else if (_filterOption == 'Groups') {
              return activity.type == ActivityType.group;
            }
            return false;
          }).toList();
    
    // Group activities by date
    final groupedActivities = <String, List<ActivityItem>>{};
    
    for (final activity in filteredActivities) {
      final date = _formatDateHeader(activity.timestamp);
      if (!groupedActivities.containsKey(date)) {
        groupedActivities[date] = [];
      }
      groupedActivities[date]!.add(activity);
    }
    
    return filteredActivities.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: groupedActivities.length,
            itemBuilder: (context, index) {
              final date = groupedActivities.keys.elementAt(index);
              final activitiesForDate = groupedActivities[date]!;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateHeader(date),
                  ...activitiesForDate.map((activity) => _buildActivityItem(activity)),
                ],
              );
            },
          );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No activity yet',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Recent activity will appear here',
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
  
  Widget _buildDateHeader(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        date,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
  
  Widget _buildActivityItem(ActivityItem activity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to relevant screen based on activity type
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildActivityIcon(activity),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            activity.title,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (activity.amount > 0)
                          Text(
                            NumberFormat.currency(symbol: '\$').format(activity.amount),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: activity.groupColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            activity.groupName,
                            style: TextStyle(
                              color: activity.groupColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatTime(activity.timestamp),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildActivityIcon(ActivityItem activity) {
    IconData icon;
    Color color;
    
    switch (activity.type) {
      case ActivityType.expense:
        icon = Icons.receipt_long;
        color = Colors.orange;
        break;
      case ActivityType.settlement:
        icon = Icons.account_balance_wallet;
        color = Colors.purple;
        break;
      case ActivityType.group:
        icon = Icons.group;
        color = Colors.blue;
        break;
    }
    
    return CircleAvatar(
      radius: 20,
      backgroundColor: color.withOpacity(0.2),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }
  
  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(date); // Day name
    } else {
      return DateFormat('MMMM d, yyyy').format(date);
    }
  }
  
  String _formatTime(DateTime timestamp) {
    return DateFormat('h:mm a').format(timestamp);
  }
}

class ActivityItem {
  final String id;
  final ActivityType type;
  final String title;
  final String description;
  final double amount;
  final String groupId;
  final String groupName;
  final Color groupColor;
  final String userId;
  final String userName;
  final DateTime timestamp;

  ActivityItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.amount,
    required this.groupId,
    required this.groupName,
    required this.groupColor,
    required this.userId,
    required this.userName,
    required this.timestamp,
  });
}

enum ActivityType {
  expense,
  settlement,
  group,
}
