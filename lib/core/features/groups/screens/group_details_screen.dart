import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';
import '../models/group.dart';

class GroupDetailsScreen extends StatefulWidget {
  final Group group;

  const GroupDetailsScreen({
    required this.group,
    super.key,
  });

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                    _buildSettlementsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog to add expense
          _showAddExpenseDialog(context);
        },
        backgroundColor: AppColors.accentGradientEnd,
        child: const Icon(Icons.add, color: Colors.white),
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
    final balanceText = isPositiveBalance
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
                  child: Icon(
                    Icons.group,
                    color: widget.group.color,
                    size: 24,
                  ),
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
                      color: isPositiveBalance
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
                    // Handle add expense
                    _showAddExpenseDialog(context);
                  },
                  icon: const Icon(Icons.add_circle_outline, size: 16),
                  label: const Text('Add Expense'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.accentGradientMiddle,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.accentGradientMiddle,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        tabs: const [
          Tab(text: 'Expenses'),
          Tab(text: 'Members'),
          Tab(text: 'Settlements'),
        ],
        padding: const EdgeInsets.all(4),
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
                color: member.id == '1'
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

  Widget _buildSettlementsTab() {
    // Mock settlement data
    final settlements = [
      {
        'from': 'Mike Johnson',
        'to': 'Jane Smith',
        'amount': 45.25,
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'status': 'Pending',
      },
      {
        'from': 'John Doe',
        'to': 'Jane Smith',
        'amount': 30.00,
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'status': 'Completed',
      },
    ];

    return settlements.isEmpty
        ? _buildEmptyState('No settlements yet', 'All balances are settled')
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: settlements.length,
            itemBuilder: (context, index) {
              final settlement = settlements[index];
              final isPending = settlement['status'] == 'Pending';
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: AppColors.cardBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Row(
                    children: [
                      Text(
                        '${settlement['from']} → ${settlement['to']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isPending
                              ? AppColors.categoryBills.withOpacity(0.2)
                              : AppColors.success.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          settlement['status'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isPending
                                ? AppColors.categoryBills
                                : AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Amount: ${NumberFormat.currency(symbol: '\$').format(settlement['amount'])}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date: ${_formatDate(settlement['date'] as DateTime)}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: isPending
                      ? IconButton(
                          icon: const Icon(
                            Icons.check_circle_outline,
                            color: AppColors.success,
                          ),
                          onPressed: () {
                            // Mark as completed
                          },
                        )
                      : null,
                ),
              );
            },
          );
  }

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

  void _showAddExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Add Expense',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
                filled: true,
                fillColor: AppColors.background.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Amount',
                hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
                filled: true,
                fillColor: AppColors.background.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                prefixIcon: const Icon(
                  Icons.attach_money,
                  color: AppColors.textSecondary,
                ),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: 'Paid by',
                hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
                filled: true,
                fillColor: AppColors.background.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              items: widget.group.members
                  .map((member) => DropdownMenuItem(
                        value: member.id,
                        child: Text(
                          member.id == '1' ? 'You' : member.name,
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {},
              dropdownColor: AppColors.cardBackground,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle expense creation
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentGradientMiddle,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showGroupSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: const Row(
              children: [
                Icon(Icons.exit_to_app, color: AppColors.error),
                SizedBox(width: 16),
                Text(
                  'Leave Group',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
