import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';
import '../models/group.dart';
import '../widgets/group_activity_feed.dart';
import 'group_details_screen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  bool _isLoading = true;
  String _filterOption = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Mock data for groups
  final List<Group> _groups = [
    Group(
      id: '1',
      name: 'Roommates',
      members: [
        GroupMember(
          id: '1',
          name: 'John Doe',
          imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
          balance: -45.50,
        ),
        GroupMember(
          id: '2',
          name: 'Jane Smith',
          imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
          balance: 120.75,
          isAdmin: true,
        ),
        GroupMember(
          id: '3',
          name: 'Mike Johnson',
          imageUrl: 'https://randomuser.me/api/portraits/men/22.jpg',
          balance: -75.25,
        ),
      ],
      totalAmount: 241.50,
      lastActivity: DateTime.now().subtract(const Duration(hours: 5)),
      color: AppColors.error,
    ),
    Group(
      id: '2',
      name: 'Trip to Paris',
      members: [
        GroupMember(
          id: '1',
          name: 'John Doe',
          imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
          balance: 350.00,
          isAdmin: true,
        ),
        GroupMember(
          id: '4',
          name: 'Sarah Williams',
          imageUrl: 'https://randomuser.me/api/portraits/women/67.jpg',
          balance: -175.00,
        ),
        GroupMember(
          id: '5',
          name: 'Alex Brown',
          imageUrl: 'https://randomuser.me/api/portraits/men/45.jpg',
          balance: -175.00,
        ),
      ],
      totalAmount: 700.00,
      lastActivity: DateTime.now().subtract(const Duration(days: 2)),
      color: AppColors.categoryBills,
    ),
    Group(
      id: '3',
      name: 'Weekend BBQ',
      members: [
        GroupMember(
          id: '1',
          name: 'John Doe',
          imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
          balance: -30.00,
        ),
        GroupMember(
          id: '6',
          name: 'Emily Davis',
          imageUrl: 'https://randomuser.me/api/portraits/women/17.jpg',
          balance: 90.00,
          isAdmin: true,
        ),
        GroupMember(
          id: '7',
          name: 'David Wilson',
          imageUrl: 'https://randomuser.me/api/portraits/men/52.jpg',
          balance: -60.00,
        ),
      ],
      totalAmount: 180.00,
      lastActivity: DateTime.now().subtract(const Duration(days: 5)),
      color: AppColors.categoryShopping,
    ),
  ];

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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                child: _buildHeader(context),
              ),
              _buildTabBar(),
              Expanded(
                child:
                    _isLoading
                        ? _buildLoadingState()
                        : FadeTransition(
                          opacity: _animationController,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Groups Tab
                              SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics(),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      _buildGroupSummary(),
                                      const SizedBox(height: 24),
                                      _buildGroupsList(),
                                      const SizedBox(
                                        height: 100,
                                      ), // Extra padding for nav bar
                                    ],
                                  ),
                                ),
                              ),
                              // Activity Tab
                              const GroupActivityFeed(),
                            ],
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 65.0, right: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGradientEnd.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 2,
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            // Show dialog to create a new group
            _showCreateGroupDialog(context);
          },
          backgroundColor: AppColors.accentGradientEnd,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          label: const Row(
            children: [
              Icon(Icons.add_circle_outline_rounded, size: 20),
              SizedBox(width: 8),
              Text('New Group', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              'Groups',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.secondary.withOpacity(0.22),
                shape: const CircleBorder(),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () {
                // Show notifications
              },
              icon: Stack(
                children: [
                  const Icon(Icons.notifications, color: Colors.white),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: const Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.secondary.withOpacity(0.22),
                shape: const CircleBorder(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGroupSummary() {
    // Calculate total balance across all groups
    double totalBalance = 0;
    for (var group in _groups) {
      for (var member in group.members) {
        if (member.id == '1') {
          // Assuming user ID is '1'
          totalBalance += member.balance;
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.accentGradientStart, AppColors.accentGradientEnd],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.group, color: Colors.white, size: 22),
              SizedBox(width: 8),
              Text(
                'Group Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    NumberFormat.currency(symbol: '\$').format(totalBalance),
                    style: TextStyle(
                      color:
                          totalBalance >= 0
                              ? Colors.white
                              : Colors.redAccent.shade100,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Active Groups',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_groups.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
                  },
                  icon: const Icon(Icons.add_circle_outline, size: 16),
                  label: const Text('Add Expense'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.white),
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

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skeleton for group summary card
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title skeleton
                  Container(
                    height: 20,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Balance skeleton
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 14,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 24,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 14,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 24,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Button skeletons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Skeleton for group list title
          Row(
            children: [
              Container(
                width: 3,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.accentGradientMiddle,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 18,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Skeleton for group cards
          ...List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 18,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 12,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(height: 1, color: AppColors.borderPrimary),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 14,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Container(
                                height: 14,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
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
          ),
        ],
      ),
    );
  }

  List<Group> get _filteredGroups {
    if (_filterOption == 'All') {
      return _groups;
    } else if (_filterOption == 'You owe') {
      return _groups.where((group) {
        final userMember = group.members.firstWhere(
          (member) => member.id == '1', // Assuming user ID is '1'
        );
        return userMember.balance < 0;
      }).toList();
    } else if (_filterOption == 'Owed to you') {
      return _groups.where((group) {
        final userMember = group.members.firstWhere(
          (member) => member.id == '1', // Assuming user ID is '1'
        );
        return userMember.balance > 0;
      }).toList();
    } else {
      // Settled
      return _groups.where((group) {
        final userMember = group.members.firstWhere(
          (member) => member.id == '1', // Assuming user ID is '1'
        );
        return userMember.balance == 0;
      }).toList();
    }
  }

  Widget _buildGroupsList() {
    final accentBar = Container(
      width: 3,
      height: 20,
      decoration: BoxDecoration(
        color: AppColors.accentGradientMiddle,
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              accentBar,
              const SizedBox(width: 8),
              const Text(
                'Your Groups',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
        if (_filteredGroups.isEmpty)
          _buildEmptyState()
        else
          ..._filteredGroups.map((group) => _buildGroupCard(group)).toList(),
      ],
    );
  }

  Widget _buildGroupCard(Group group) {
    // Find the user's balance in this group
    final userMember = group.members.firstWhere(
      (member) => member.id == '1', // Assuming user ID is '1'
    );

    final isPositiveBalance = userMember.balance >= 0;
    final balanceText =
        isPositiveBalance
            ? 'You are owed ${NumberFormat.currency(symbol: '\$').format(userMember.balance.abs())}'
            : 'You owe ${NumberFormat.currency(symbol: '\$').format(userMember.balance.abs())}';

    final formattedDate = _formatDate(group.lastActivity);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupDetailsScreen(group: group),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.borderPrimary.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Group header with color
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: group.color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Group icon with background
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: group.color.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.group,
                                color: group.color,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  group.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${group.members.length} members · Last activity $formattedDate',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: AppColors.borderPrimary),
                      const SizedBox(height: 16),
                      // Balance info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Text(
                            'Total: ${NumberFormat.currency(symbol: '\$').format(group.totalAmount)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Member avatars
                      Row(
                        children: [
                          ...group.members.map(
                            (member) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: _buildMemberAvatar(member),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          GroupDetailsScreen(group: group),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppColors.textSecondary,
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
      ),
    );
  }

  Widget _buildMemberAvatar(GroupMember member) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(member.imageUrl),
        ),
        if (member.isAdmin)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.accentGradientEnd,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.cardBackground, width: 1.5),
              ),
              child: const Center(
                child: Icon(Icons.star, size: 8, color: Colors.white),
              ),
            ),
          ),
      ],
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

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_off,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _filterOption == 'All'
                ? 'No groups yet'
                : 'No ${_filterOption.toLowerCase()} groups',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _filterOption == 'All'
                ? 'Create a group to start splitting expenses'
                : 'Try a different filter option',
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.8),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (_filterOption == 'All')
            ElevatedButton.icon(
              onPressed: () => _showCreateGroupDialog(context),
              icon: const Icon(Icons.add_circle_outline, size: 18),
              label: const Text('Create Group'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGradientMiddle,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
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
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: [
          Tab(
            icon: const Icon(Icons.group_rounded, size: 20),
            text: 'Groups',
            iconMargin: const EdgeInsets.only(bottom: 4),
            height: 56,
          ),
          Tab(
            icon: const Icon(Icons.insights_rounded, size: 20),
            text: 'Activity',
            iconMargin: const EdgeInsets.only(bottom: 4),
            height: 56,
          ),
        ],
        padding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStateProperty.resolveWith<Color>((
          Set<MaterialState> states,
        ) {
          return Colors.transparent;
        }),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: AppColors.borderPrimary.withOpacity(0.3),
                width: 1,
              ),
            ),
            elevation: 10,
            title: const Text(
              'Create New Group',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Group templates selection
                const Text(
                  'Choose a template or create custom:',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTemplateOption(
                        'Roommates',
                        Icons.home,
                        Colors.purple,
                      ),
                      _buildTemplateOption('Trip', Icons.flight, Colors.blue),
                      _buildTemplateOption(
                        'Couple',
                        Icons.favorite,
                        Colors.red,
                      ),
                      _buildTemplateOption(
                        'Family',
                        Icons.family_restroom,
                        Colors.green,
                      ),
                      _buildTemplateOption('Custom', Icons.add, Colors.grey),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Group Name',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.7),
                    ),
                    filled: true,
                    fillColor: AppColors.background.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.borderPrimary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.borderPrimary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.accentGradientMiddle,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.group_work_rounded,
                      color: AppColors.accentGradientMiddle,
                    ),
                  ),
                  style: const TextStyle(color: AppColors.textPrimary),
                  cursorColor: AppColors.accentGradientMiddle,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Add Members:',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                // Mock member selection UI
                ...['Jane Smith', 'Mike Johnson', 'Sarah Williams']
                    .map(
                      (name) => CheckboxListTile(
                        value: false,
                        onChanged: (_) {},
                        title: Text(
                          name,
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                        activeColor: AppColors.accentGradientMiddle,
                        checkColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    )
                    .toList(),
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
                  // Handle group creation
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentGradientMiddle,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Create'),
              ),
            ],
          ),
    );
  }

  Widget _buildTemplateOption(String name, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        // Handle template selection
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              name,
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
