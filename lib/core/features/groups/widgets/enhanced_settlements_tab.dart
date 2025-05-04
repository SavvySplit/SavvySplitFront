import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';
import '../models/group.dart';
import '../models/group_analytics.dart';

class EnhancedSettlementsTab extends StatefulWidget {
  final Group group;

  const EnhancedSettlementsTab({
    required this.group,
    Key? key,
  }) : super(key: key);

  @override
  State<EnhancedSettlementsTab> createState() => _EnhancedSettlementsTabState();
}

class _EnhancedSettlementsTabState extends State<EnhancedSettlementsTab> {
  bool _showSimplifiedDebts = true;
  
  // Sample settlements for demo
  final List<Settlement> _settlements = [
    Settlement.sample(
      id: '1',
      fromId: '3',
      fromName: 'Mike Johnson',
      toId: '2',
      toName: 'Jane Smith',
      amount: 45.25,
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: SettlementStatus.pending,
    ),
    Settlement.sample(
      id: '2',
      fromId: '1',
      fromName: 'John Doe',
      toId: '2',
      toName: 'Jane Smith',
      amount: 30.00,
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: SettlementStatus.completed,
    ),
    Settlement.sample(
      id: '3',
      fromId: '4',
      fromName: 'Sarah Williams',
      toId: '1',
      toName: 'John Doe',
      amount: 22.50,
      date: DateTime.now().subtract(const Duration(days: 10)),
      status: SettlementStatus.completed,
    ),
  ];
  
  // Sample simplified debts
  final List<Map<String, dynamic>> _simplifiedDebts = [
    {
      'fromId': '3',
      'fromName': 'Mike Johnson',
      'toId': '2',
      'toName': 'Jane Smith',
      'amount': 45.25,
    },
    {
      'fromId': '1',
      'fromName': 'John Doe',
      'toId': '2',
      'toName': 'Jane Smith',
      'amount': 15.75,
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: _settlements.isEmpty
              ? _buildEmptyState()
              : _buildSettlementsList(),
        ),
        _buildActionButton(),
      ],
    );
  }
  
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Text(
            'Simplify Debts',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Tooltip(
            message: 'Minimize the number of transactions needed to settle all debts',
            child: Icon(
              Icons.info_outline,
              size: 16,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
          const Spacer(),
          Switch(
            value: _showSimplifiedDebts,
            onChanged: (value) {
              setState(() {
                _showSimplifiedDebts = value;
              });
            },
            activeColor: AppColors.accentGradientMiddle,
            activeTrackColor: AppColors.accentGradientMiddle.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No settlements yet',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All balances are settled',
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
  
  Widget _buildSettlementsList() {
    final items = _showSimplifiedDebts ? _simplifiedDebts : _settlements;
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length + 1, // +1 for the info card
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildInfoCard();
        }
        
        final itemIndex = index - 1;
        if (_showSimplifiedDebts) {
          final debt = _simplifiedDebts[itemIndex];
          return _buildSimplifiedDebtCard(debt);
        } else {
          final settlement = _settlements[itemIndex];
          return _buildSettlementCard(settlement);
        }
      },
    );
  }
  
  Widget _buildInfoCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.accentGradientMiddle.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(
              Icons.lightbulb_outline,
              color: AppColors.accentGradientMiddle,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _showSimplifiedDebts
                        ? 'Simplified Debts'
                        : 'All Settlements',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _showSimplifiedDebts
                        ? 'We\'ve optimized payments to minimize the number of transactions'
                        : 'Showing all settlement history',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSimplifiedDebtCard(Map<String, dynamic> debt) {
    final isCurrentUserOwes = debt['fromId'] == '1';
    final isCurrentUserOwed = debt['toId'] == '1';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: isCurrentUserOwes
                      ? AppColors.error.withOpacity(0.2)
                      : isCurrentUserOwed
                          ? AppColors.success.withOpacity(0.2)
                          : AppColors.accentGradientMiddle.withOpacity(0.2),
                  child: Icon(
                    isCurrentUserOwes
                        ? Icons.arrow_upward
                        : isCurrentUserOwed
                            ? Icons.arrow_downward
                            : Icons.swap_horiz,
                    color: isCurrentUserOwes
                        ? AppColors.error
                        : isCurrentUserOwed
                            ? AppColors.success
                            : AppColors.accentGradientMiddle,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCurrentUserOwes
                            ? 'You owe ${debt['toName']}'
                            : isCurrentUserOwed
                                ? '${debt['fromName']} owes you'
                                : '${debt['fromName']} owes ${debt['toName']}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        NumberFormat.currency(symbol: '\$').format(debt['amount']),
                        style: TextStyle(
                          color: isCurrentUserOwes
                              ? AppColors.error
                              : isCurrentUserOwed
                                  ? AppColors.success
                                  : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCurrentUserOwes || isCurrentUserOwed)
                  ElevatedButton(
                    onPressed: () {
                      _showPaymentMethodsDialog(context, debt);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCurrentUserOwes
                          ? AppColors.error
                          : AppColors.success,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      isCurrentUserOwes ? 'Pay' : 'Remind',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSettlementCard(Settlement settlement) {
    final isCurrentUserFrom = settlement.fromId == '1';
    final isCurrentUserTo = settlement.toId == '1';
    final isPending = settlement.status == SettlementStatus.pending;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: settlement.status == SettlementStatus.completed
                      ? AppColors.success.withOpacity(0.2)
                      : settlement.status == SettlementStatus.pending
                          ? AppColors.categoryBills.withOpacity(0.2)
                          : AppColors.error.withOpacity(0.2),
                  child: Icon(
                    settlement.status == SettlementStatus.completed
                        ? Icons.check_circle
                        : settlement.status == SettlementStatus.pending
                            ? Icons.pending
                            : Icons.cancel,
                    color: settlement.status == SettlementStatus.completed
                        ? AppColors.success
                        : settlement.status == SettlementStatus.pending
                            ? AppColors.categoryBills
                            : AppColors.error,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            isCurrentUserFrom
                                ? 'You paid ${settlement.toName}'
                                : isCurrentUserTo
                                    ? '${settlement.fromName} paid you'
                                    : '${settlement.fromName} paid ${settlement.toName}',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: settlement.status == SettlementStatus.completed
                                  ? AppColors.success.withOpacity(0.2)
                                  : settlement.status == SettlementStatus.pending
                                      ? AppColors.categoryBills.withOpacity(0.2)
                                      : AppColors.error.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              settlement.status == SettlementStatus.completed
                                  ? 'Completed'
                                  : settlement.status == SettlementStatus.pending
                                      ? 'Pending'
                                      : 'Cancelled',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: settlement.status == SettlementStatus.completed
                                    ? AppColors.success
                                    : settlement.status == SettlementStatus.pending
                                        ? AppColors.categoryBills
                                        : AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            NumberFormat.currency(symbol: '\$').format(settlement.amount),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            DateFormat('MMM d, yyyy').format(settlement.date),
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
            if (isPending && (isCurrentUserFrom || isCurrentUserTo))
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Handle cancel
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Handle confirm
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () {
          _showSettleUpDialog(context);
        },
        icon: const Icon(Icons.account_balance_wallet),
        label: const Text('Settle Up'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentGradientMiddle,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
  
  void _showPaymentMethodsDialog(BuildContext context, Map<String, dynamic> debt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Choose Payment Method',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPaymentMethodItem(
              icon: Icons.money,
              title: 'Cash',
              subtitle: 'Record a cash payment',
              onTap: () {
                Navigator.pop(context);
                // Handle cash payment
              },
            ),
            const Divider(color: AppColors.borderPrimary),
            _buildPaymentMethodItem(
              icon: Icons.account_balance,
              title: 'Bank Transfer',
              subtitle: 'Pay via bank transfer',
              onTap: () {
                Navigator.pop(context);
                // Handle bank transfer
              },
            ),
            const Divider(color: AppColors.borderPrimary),
            _buildPaymentMethodItem(
              icon: Icons.payment,
              title: 'Venmo',
              subtitle: 'Pay with Venmo',
              onTap: () {
                Navigator.pop(context);
                // Handle Venmo payment
              },
            ),
            const Divider(color: AppColors.borderPrimary),
            _buildPaymentMethodItem(
              icon: Icons.paypal,
              title: 'PayPal',
              subtitle: 'Pay with PayPal',
              onTap: () {
                Navigator.pop(context);
                // Handle PayPal payment
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPaymentMethodItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.accentGradientMiddle.withOpacity(0.2),
        child: Icon(
          icon,
          color: AppColors.accentGradientMiddle,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
      onTap: onTap,
    );
  }
  
  void _showSettleUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Settle Up',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'You paid',
                labelStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
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
                  .where((member) => member.id != '1') // Exclude current user
                  .map((member) => DropdownMenuItem(
                        value: member.id,
                        child: Text(
                          member.name,
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {},
              dropdownColor: AppColors.cardBackground,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Amount',
                labelStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
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
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Payment Method',
                labelStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
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
              items: const [
                DropdownMenuItem(
                  value: 'cash',
                  child: Text(
                    'Cash',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                DropdownMenuItem(
                  value: 'bank',
                  child: Text(
                    'Bank Transfer',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                DropdownMenuItem(
                  value: 'venmo',
                  child: Text(
                    'Venmo',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                DropdownMenuItem(
                  value: 'paypal',
                  child: Text(
                    'PayPal',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ),
              ],
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
              // Handle settlement creation
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentGradientMiddle,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Record'),
          ),
        ],
      ),
    );
  }
}
