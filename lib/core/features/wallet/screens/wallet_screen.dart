import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';
import '../models/transaction.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  // Tab controller for wallet sections
  late TabController _tabController;
  final List<String> _tabs = [
    'Overview',
    'Transactions',
    'Budgets',
    'Payment Methods',
    'Recurring',
    'Goals',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Transaction> _transactions = [
    Transaction(
      id: '1',
      title: 'Grocery Shopping',
      amount: -85.50,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Food',
      icon: Icons.shopping_basket,
    ),
    Transaction(
      id: '2',
      title: 'Salary Deposit',
      amount: 2500.00,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: 'Income',
      icon: Icons.account_balance_wallet,
    ),
    Transaction(
      id: '3',
      title: 'Restaurant Bill',
      amount: -125.75,
      date: DateTime.now().subtract(const Duration(days: 5)),
      category: 'Dining',
      icon: Icons.restaurant,
    ),
    Transaction(
      id: '4',
      title: 'Utility Bill',
      amount: -95.20,
      date: DateTime.now().subtract(const Duration(days: 7)),
      category: 'Bills',
      icon: Icons.bolt,
    ),
    Transaction(
      id: '5',
      title: 'Freelance Work',
      amount: 750.00,
      date: DateTime.now().subtract(const Duration(days: 10)),
      category: 'Income',
      icon: Icons.work,
    ),
  ];

  double get _totalBalance => _transactions.fold(
    0,
    (previousValue, transaction) => previousValue + transaction.amount,
  );

  double get _income => _transactions
      .where((transaction) => transaction.amount > 0)
      .fold(
        0,
        (previousValue, transaction) => previousValue + transaction.amount,
      );

  double get _expenses => _transactions
      .where((transaction) => transaction.amount < 0)
      .fold(
        0,
        (previousValue, transaction) =>
            previousValue + transaction.amount.abs(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Ensure gradient shows through
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
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                child: _buildHeader(context),
              ),
              // Tab bar
              Container(
                margin: const EdgeInsets.only(
                  right: 8.0,
                  left: 0.0,
                  top: 12.0,
                  bottom: 12.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: AppColors.borderPrimary, width: 0.8),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.6),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.buttonGradientStart,
                        AppColors.buttonGradientEnd,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs:
                      _tabs
                          .map(
                            (String tab) => Tab(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6.0,
                                ),
                                child: Text(tab),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Overview Tab
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            _buildBalanceCard(),
                            const SizedBox(height: 20),
                            _buildQuickActions(),
                            const SizedBox(height: 32),
                            _buildChartSection(),
                            const SizedBox(height: 32),
                            _buildCategoryBreakdown(),
                            const SizedBox(height: 32),
                            _buildBudgetTracker(),
                            const SizedBox(height: 32),
                            _buildUpcomingBills(),
                            const SizedBox(height: 32),
                            _buildTransactionList(),
                            // Add extra bottom padding to ensure content isn't cut off by the navigation bar
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                    // Transactions Tab
                    _buildTransactionsTab(),
                    // Budgets Tab
                    _buildBudgetsTab(),
                    // Payment Methods Tab
                    _buildPaymentMethodsTab(),
                    // Recurring Payments Tab
                    _buildRecurringPaymentsTab(),
                    // Savings Goals Tab
                    _buildSavingsGoalsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tab content methods
  Widget _buildTransactionsTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Transaction History',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'View and manage all your transactions with advanced filtering',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetsTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Budget Management',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create, edit, and track monthly budgets by category',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.credit_card,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment Methods',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage linked cards, accounts, and payment services',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecurringPaymentsTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.repeat,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Recurring Payments',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Track and manage subscriptions and recurring bills',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsGoalsTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.savings,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Savings Goals',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set up and monitor progress toward financial goals',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wallet',
                style:
                    Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ) ??
                    const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your financial overview',
                style: TextStyle(
                  color: AppColors.textPrimary.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
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
                onPressed: () {},
                icon: const Icon(Icons.filter_list, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.secondary.withOpacity(0.22),
                  shape: const CircleBorder(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentGradientStart,
            AppColors.accentGradientMiddle,
            AppColors.accentGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderPrimary.withOpacity(0.5), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            NumberFormat.currency(symbol: '\$').format(_totalBalance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBalanceItem(
                'Income',
                _income,
                Icons.arrow_upward,
                Colors.greenAccent,
              ),
              _buildBalanceItem(
                'Expenses',
                _expenses,
                Icons.arrow_downward,
                Colors.redAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(
    String title,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              NumberFormat.currency(symbol: '\$').format(amount),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Accent bar widget for section titles
  static const Widget accentBar = SizedBox(
    width: 5,
    height: 28,
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: AppColors.accent,
      ),
    ),
  );

  // Chart period selection options
  final List<String> _chartPeriods = ['Week', 'Month', 'Year'];
  String _selectedPeriod = 'Month';

  Widget _buildChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, top: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              accentBar,
              const SizedBox(width: 8),
              const Text(
                'Spending Trends',
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderPrimary.withOpacity(0.5), width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cash Flow',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children:
                          _chartPeriods.map((period) {
                            final isSelected = _selectedPeriod == period;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedPeriod = period;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? AppColors.accentGradientMiddle
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  period,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : AppColors.textSecondary,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Line chart
              SizedBox(height: 180, child: LineChart(_buildLineChartData())),
              const SizedBox(height: 15),
              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem('Income', AppColors.success),
                  const SizedBox(width: 24),
                  _buildLegendItem('Expenses', AppColors.error),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  LineChartData _buildLineChartData() {
    // Generate mock data based on selected period
    final List<FlSpot> incomeSpots = [];
    final List<FlSpot> expenseSpots = [];

    // Number of data points based on period
    int dataPoints =
        _selectedPeriod == 'Week'
            ? 7
            : _selectedPeriod == 'Month'
            ? 30
            : 12;

    // Generate random data for demonstration
    for (int i = 0; i < dataPoints; i++) {
      // Income data (higher values)
      double incomeValue =
          _selectedPeriod == 'Year'
              ? 500 + (i % 3 == 0 ? 300 : 100) + (i * 20) + (100 * (i % 4))
              : 200 + (i % 3 == 0 ? 150 : 50) + (i * 10) + (50 * (i % 4));

      // Expense data (lower values)
      double expenseValue =
          _selectedPeriod == 'Year'
              ? 300 + (i % 2 == 0 ? 200 : 100) + (i * 15) + (80 * (i % 3))
              : 150 + (i % 2 == 0 ? 100 : 50) + (i * 8) + (40 * (i % 3));

      incomeSpots.add(FlSpot(i.toDouble(), incomeValue));
      expenseSpots.add(FlSpot(i.toDouble(), expenseValue));
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 200,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.surface.withOpacity(0.4),
            strokeWidth: 1,
            dashArray: [5, 5],
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval:
                _selectedPeriod == 'Week'
                    ? 1
                    : _selectedPeriod == 'Month'
                    ? 5
                    : 1,
            getTitlesWidget: (value, meta) {
              String text = '';
              if (_selectedPeriod == 'Week') {
                final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                if (value.toInt() < days.length) {
                  text = days[value.toInt()];
                }
              } else if (_selectedPeriod == 'Month') {
                // Show every 5 days
                if (value % 5 == 0) {
                  text = '${value.toInt() + 1}';
                }
              } else {
                // Year
                final months = [
                  'Jan',
                  'Feb',
                  'Mar',
                  'Apr',
                  'May',
                  'Jun',
                  'Jul',
                  'Aug',
                  'Sep',
                  'Oct',
                  'Nov',
                  'Dec',
                ];
                if (value.toInt() < months.length) {
                  text = months[value.toInt()];
                }
              }

              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 200,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                '\$${value.toInt()}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: dataPoints.toDouble() - 1,
      minY: 0,
      maxY: _selectedPeriod == 'Year' ? 1200 : 800,
      lineTouchData: LineTouchData(
        enabled: true,
        touchCallback:
            (FlTouchEvent event, LineTouchResponse? touchResponse) {},
        getTouchedSpotIndicator: (
          LineChartBarData barData,
          List<int> spotIndexes,
        ) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(color: Colors.white, strokeWidth: 2),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: barData.color ?? Colors.white,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 8,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              final isIncome = spot.barIndex == 0;
              return LineTooltipItem(
                '\$${spot.y.toInt()}',
                TextStyle(
                  color:
                      isIncome ? AppColors.success : AppColors.error,
                  fontWeight:
                      isIncome ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 12,
                ),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        // Income line
        LineChartBarData(
          spots: incomeSpots,
          isCurved: true,
          curveSmoothness: 0.3,
          color: AppColors.success.withOpacity(0.8),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.success.withOpacity(0.1),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.success.withOpacity(0.2),
                AppColors.success.withOpacity(0.0),
              ],
            ),
          ),
        ),
        // Expense line
        LineChartBarData(
          spots: expenseSpots,
          isCurved: true,
          curveSmoothness: 0.3,
          color: AppColors.error.withOpacity(0.8),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.error.withOpacity(0.1),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.error.withOpacity(0.2),
                AppColors.error.withOpacity(0.0),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.add, 'label': 'Add', 'color': AppColors.success},
      {
        'icon': Icons.swap_horiz,
        'label': 'Transfer',
        'color': AppColors.secondary,
      },
      {
        'icon': Icons.document_scanner,
        'label': 'Scan',
        'color': AppColors.categoryBills,
      },
      {
        'icon': Icons.pie_chart,
        'label': 'Budget',
        'color': AppColors.categoryTransport,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            actions.map((action) {
              return Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (action['color'] as Color).withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          action['icon'] as IconData,
                          color: action['color'] as Color,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action['label'] as String,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildCategoryBreakdown() {
    // Mock data for category breakdown
    final categories = [
      {
        'name': 'Food',
        'amount': 450.0,
        'percentage': 35.0,
        'color': AppColors.error,
      },
      {
        'name': 'Transport',
        'amount': 200.0,
        'percentage': 15.0,
        'color': AppColors.categoryTransport,
      },
      {
        'name': 'Shopping',
        'amount': 350.0,
        'percentage': 25.0,
        'color': AppColors.categoryShopping,
      },
      {
        'name': 'Bills',
        'amount': 320.0,
        'percentage': 25.0,
        'color': AppColors.categoryBills,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, top: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              accentBar,
              const SizedBox(width: 8),
              const Text(
                'Spending by Category',
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderPrimary, width: 1.0),
          ),
          child: Row(
            children: [
              // Pie chart
              SizedBox(
                height: 120,
                width: 120,
                child: PieChart(
                  PieChartData(
                    sections:
                        categories.map((category) {
                          return PieChartSectionData(
                            color: category['color'] as Color,
                            value:
                                (category['percentage'] is int)
                                    ? (category['percentage'] as int).toDouble()
                                    : category['percentage'] as double,
                            title: '',
                            radius: 38,
                            showTitle: false,
                          );
                        }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 24,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              // Legend
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: category['color'] as Color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                category['name'] as String,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '\$${(category['amount'] is int) ? category['amount'] as int : (category['amount'] as double).toInt()}',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetTracker() {
    // Mock data for budget tracking
    final budgetData = {
      'total': 2500.0,
      'spent': 1320.0,
      'remaining': 1180.0,
      'percentage': 52.8,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, top: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              accentBar,
              const SizedBox(width: 8),
              const Text(
                'Monthly Budget',
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderPrimary.withOpacity(0.5), width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Budget',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${budgetData['total']?.toInt()}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Remaining',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${budgetData['remaining']?.toInt()}',
                        style: TextStyle(
                          color:
                              budgetData['remaining']! > 500
                                  ? AppColors.success
                                  : AppColors.error,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Progress bar
              Stack(
                children: [
                  // Background
                  Container(
                    height: 12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  // Progress
                  Container(
                    height: 12,
                    width:
                        MediaQuery.of(context).size.width *
                        (budgetData['percentage']! / 100) *
                        0.7, // Adjust for padding
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                            budgetData['percentage']! < 80
                                ? [
                                  AppColors.success,
                                  AppColors.success.withOpacity(0.7),
                                ]
                                : [
                                  AppColors.error,
                                  AppColors.error.withOpacity(0.7),
                                ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${budgetData['percentage']?.toStringAsFixed(1)}% of budget used',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingBills() {
    // Mock data for upcoming bills
    final upcomingBills = [
      {
        'name': 'Electricity Bill',
        'amount': 95.20,
        'date': 'May 3',
        'icon': Icons.bolt,
        'color': Colors.amber,
      },
      {
        'name': 'Internet Bill',
        'amount': 65.00,
        'date': 'May 5',
        'icon': Icons.wifi,
        'color': Colors.blue,
      },
      {
        'name': 'Rent Payment',
        'amount': 1200.00,
        'date': 'May 10',
        'icon': Icons.home,
        'color': Colors.purple,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, top: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              accentBar,
              const SizedBox(width: 8),
              const Text(
                'Upcoming Bills',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: 0.1,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Limit to 2 bills to avoid overflow
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderPrimary, width: 1.0),
          ),
          child: Column(
            children:
                List.generate(upcomingBills.length > 2 ? 2 : upcomingBills.length, (
                  index,
                ) {
                  final bill = upcomingBills[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                        ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: (bill['color'] as Color).withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              bill['icon'] as IconData,
                              color: bill['color'] as Color,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bill['name'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.5,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Due on ${bill['date']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.5,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '\$${(bill['amount'] is int) ? (bill['amount'] as int).toDouble().toStringAsFixed(2) : (bill['amount'] as double).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15.5,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, top: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              accentBar,
              const SizedBox(width: 8),
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: 0.1,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Limit to 3 transactions to avoid overflow
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderPrimary, width: 1.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children:
                List.generate(
                  _transactions.length > 3 ? 3 : _transactions.length,
                  (index) {
                    final transaction = _transactions[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: _buildTransactionItem(transaction),
                  );
                },
              ).toList(),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final isIncome = transaction.amount > 0;
    final formattedAmount = NumberFormat.currency(
      symbol: '\$',
    ).format(transaction.amount.abs());
    final formattedDate = DateFormat('MMM dd').format(transaction.date);
    final color = isIncome ? Colors.greenAccent.shade200 : AppColors.error;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {}, // for future interactivity
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: index == 0 ? const BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ) : BorderRadius.zero,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(transaction.icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${transaction.category} • $formattedDate',
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${isIncome ? '+' : '-'}$formattedAmount',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15.5,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
