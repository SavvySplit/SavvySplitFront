import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import 'action_button.dart';

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
      // Calculate visible page more precisely
      final itemWidth = 116.0; // Width of button (100) + padding (16)
      final offset = _scrollController.offset;
      
      // Calculate which page is most visible in the viewport
      // Using floor instead of round ensures the dot changes exactly when a new item becomes most visible
      final newPage = (offset / itemWidth).floor();
      
      // Only update if the page has changed
      if (newPage != _currentPage && newPage < _calculatePageCount()) {
        setState(() {
          _currentPage = newPage;
        });
      }
    }
  }
  
  // Calculate number of pages based on viewport size and number of items
  int _calculatePageCount() {
    if (!_scrollController.hasClients || widget.actions.isEmpty) {
      return 1;
    }
    
    // Calculate how many items fit on screen
    final viewportWidth = _scrollController.position.viewportDimension;
    final itemWidth = 116.0; // Width of button (100) + padding (16)
    final itemsPerPage = (viewportWidth / itemWidth).floor();
    
    // Calculate total pages needed (minimum 1)
    int totalPages = (widget.actions.length / itemsPerPage).ceil();
    return totalPages > 0 ? totalPages : 1;
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
            border: Border.all(
              color: Colors.grey.withOpacity(0.15),
              width: 1.0,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Introduction text to explain quick actions
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      "Quick access to your most common financial tasks",
                      style: Theme.of(context).textTheme.bodyMedium,
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
                          padding: const EdgeInsets.only(left: 4.0), // Add padding to start
                          itemCount: widget.actions.length,
                          itemBuilder: (context, index) {
                            final action = widget.actions[index];
                            return Padding(
                              // Add a visual indicator by showing a bit of the next button
                              padding: const EdgeInsets.only(right: 12.0, left: 4.0),
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
                              // Calculate actual number of "pages" based on screen width
                              // Each page is a group of buttons visible at once
                              _calculatePageCount(),
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                height: 6.0,
                                width: index == _currentPage ? 18.0 : 6.0, // Active dot is wider
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  color: index == _currentPage
                                      ? AppColors.accent
                                      : AppColors.textSecondary.withOpacity(0.3),
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
          Text(
            "Quick Actions",
            style: Theme.of(context).textTheme.titleLarge,
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
