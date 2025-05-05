import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';
import '../models/group.dart';
import '../models/group_analytics.dart';
import '../widgets/group_analytics_tab.dart';
import '../widgets/enhanced_settlements_tab.dart';
import '../widgets/group_chat_tab.dart';
import '../widgets/enhanced_expense_dialog.dart';

class GroupDetailsScreen extends StatefulWidget {
  final Group group;

  const GroupDetailsScreen({required this.group, super.key});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildGroupInfo(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildExpensesTab(),
                    _buildMembersTab(),
                    EnhancedSettlementsTab(group: widget.group),
                    GroupAnalyticsTab(analytics: GroupAnalytics.sample()),
                    GroupChatTab(group: widget.group),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          Expanded(
            child: Text(
              widget.group.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () {
              // Show group settings
              _showGroupSettingsDialog(context);
            },
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupInfo() {
    // Find the user's balance in this group
    final userMember = widget.group.members.firstWhere(
      (member) => member.id == '1', // Assuming user ID is '1'
    );

    final isPositiveBalance = userMember.balance >= 0;
    final balanceText =
        isPositiveBalance
            ? 'You are owed ${NumberFormat.currency(symbol: '\$').format(userMember.balance.abs())}'
            : 'You owe ${NumberFormat.currency(symbol: '\$').format(userMember.balance.abs())}';

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: widget.group.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.group, color: widget.group.color, size: 24),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total: ${NumberFormat.currency(symbol: '\$').format(widget.group.totalAmount)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.group.members.length} members',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    balanceText,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color:
                          isPositiveBalance
                              ? AppColors.success
                              : AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last activity: ${_formatDate(widget.group.lastActivity)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle settle up
                  },
                  icon: const Icon(Icons.account_balance_wallet, size: 16),
                  label: const Text('Settle Up'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.accentGradientEnd,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Show enhanced expense dialog
                    showDialog(
                      context: context,
                      builder:
                          (context) =>
                              EnhancedExpenseDialog(group: widget.group),
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline, size: 16),
                  label: const Text('Add Expense'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.accentGradientMiddle,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderPrimary.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            colors: [
              AppColors.accentGradientStart,
              AppColors.accentGradientEnd,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGradientEnd.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        isScrollable: false,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: EdgeInsets.zero,
        tabs: const [
          Tab(
            icon: Icon(Icons.receipt_long_rounded, size: 18),
            text: 'Expenses',
            iconMargin: EdgeInsets.only(bottom: 2),
          ),
          Tab(
            icon: Icon(Icons.people_alt_rounded, size: 18),
            text: 'Members',
            iconMargin: EdgeInsets.only(bottom: 2),
          ),
          Tab(
            icon: Icon(Icons.account_balance_wallet_rounded, size: 18),
            text: 'Settle',
            iconMargin: EdgeInsets.only(bottom: 2),
          ),
          Tab(
            icon: Icon(Icons.insights_rounded, size: 18),
            text: 'Stats',
            iconMargin: EdgeInsets.only(bottom: 2),
          ),
          Tab(
            icon: Icon(Icons.chat_rounded, size: 18),
            text: 'Chat',
            iconMargin: EdgeInsets.only(bottom: 2),
          ),
        ],
        padding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStateProperty.resolveWith<Color>((
          Set<MaterialState> states,
        ) {
          return Colors.transparent;
        }),
      ),
    );
  }

  Widget _buildExpensesTab() {
    // Mock expense data
    final expenses = [
      {
        'title': 'Dinner at Italian Restaurant',
        'amount': 120.50,
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'paidBy': 'Jane Smith',
        'category': 'Food',
      },
      {
        'title': 'Movie Tickets',
        'amount': 45.00,
        'date': DateTime.now().subtract(const Duration(days: 4)),
        'paidBy': 'John Doe',
        'category': 'Entertainment',
      },
      {
        'title': 'Groceries',
        'amount': 76.25,
        'date': DateTime.now().subtract(const Duration(days: 7)),
        'paidBy': 'Mike Johnson',
        'category': 'Groceries',
      },
    ];

    return expenses.isEmpty
        ? _buildEmptyState('No expenses yet', 'Add an expense to get started')
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: AppColors.cardBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  expense['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      'Paid by ${expense['paidBy']} • ${_formatDate(expense['date'] as DateTime)}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      expense['category'] as String,
                      style: TextStyle(
                        color: AppColors.accentGradientMiddle.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                trailing: Text(
                  NumberFormat.currency(symbol: '\$').format(expense['amount']),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            );
          },
        );
  }

  Widget _buildMembersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.group.members.length,
      itemBuilder: (context, index) {
        final member = widget.group.members[index];
        final isPositiveBalance = member.balance >= 0;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(member.imageUrl),
            ),
            title: Row(
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (member.isAdmin)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentGradientMiddle.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.accentGradientMiddle,
                      ),
                    ),
                  ),
              ],
            ),
            subtitle: Text(
              member.id == '1'
                  ? 'You'
                  : isPositiveBalance
                  ? 'Owes you ${NumberFormat.currency(symbol: '\$').format(member.balance.abs())}'
                  : 'You owe ${NumberFormat.currency(symbol: '\$').format(member.balance.abs())}',
              style: TextStyle(
                color:
                    member.id == '1'
                        ? AppColors.textSecondary
                        : isPositiveBalance
                        ? AppColors.success
                        : AppColors.error,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.more_horiz,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                // Show member options
              },
            ),
          ),
        );
      },
    );
  }

  // The _buildSettlementsTab method has been removed as it's been replaced by the EnhancedSettlementsTab widget

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  // This method is no longer needed as we're using the EnhancedExpenseDialog

  void _showGroupSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => SimpleDialog(
            backgroundColor: AppColors.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Group Settings',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  // Handle edit group
                },
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.edit, color: AppColors.textSecondary),
                    SizedBox(width: 16),
                    Text(
                      'Edit Group',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  // Handle add member
                },
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.person_add, color: AppColors.textSecondary),
                    SizedBox(width: 16),
                    Text(
                      'Add Member',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  // Handle leave group
                },
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.exit_to_app, color: AppColors.error),
                    SizedBox(width: 16),
                    Text(
                      'Leave Group',
                      style: TextStyle(color: AppColors.error, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}
