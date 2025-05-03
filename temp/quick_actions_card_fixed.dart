import 'package:flutter/material.dart';
import 'package:savvysplit/common/theme/app_colors.dart';

class QuickActionsCard extends StatefulWidget {
  final List<Map<String, dynamic>> actions;

  const QuickActionsCard({Key? key, required this.actions}) : super(key: key);

  @override
  State<QuickActionsCard> createState() => _QuickActionsCardState();
}

class _QuickActionsCardState extends State<QuickActionsCard> {
  // Controller for ScrollView
  final ScrollController _scrollController = ScrollController();
  // Current page for indicator
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Listen to scroll position changes
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      // Calculate which item is most visible
      final itemWidth = 116.0; // Width of button (100) + padding (16)
      final offset = _scrollController.offset;
      final newPage = (offset / itemWidth).round();

      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(0, 4),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Introduction text to explain quick actions
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      "Quick access to your most common financial tasks",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  // Horizontal scrollable row of action buttons with indicators
                  Column(
                    children: [
                      SizedBox(
                        height: 110, // Fixed height for the row
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(
                            left: 4.0,
                          ), // Add padding to start
                          itemCount: widget.actions.length,
                          itemBuilder: (context, index) {
                            final action = widget.actions[index];
                            return Padding(
                              // Add a visual indicator by showing a bit of the next button
                              padding: const EdgeInsets.only(
                                right: 12.0,
                                left: 4.0,
                              ),
                              child: SizedBox(
                                width: 100, // Fixed width for each button
                                child: ActionButton(
                                  icon: action['icon'] as IconData,
                                  label: action['label'] as String,
                                  colorStart: action['colorStart'] as Color,
                                  colorEnd: action['colorEnd'] as Color,
                                  onTap: action['onTap'] as VoidCallback,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Page indicator dots
                      if (widget.actions.length > 2)
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.actions.length > 4
                                  ? 4
                                  : widget.actions.length,
                              (index) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                ),
                                height: 6.0,
                                width: 6.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      index == _currentPage % 4
                                          ? AppColors.accent
                                          : AppColors.textSecondary.withOpacity(
                                            0.3,
                                          ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 12),
      child: Row(
        children: [
          _buildAccentBar(),
          const SizedBox(width: 8),
          const Text(
            "Quick Actions",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccentBar() {
    return Container(
      width: 4,
      height: 18,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
