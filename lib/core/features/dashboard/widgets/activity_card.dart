import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import 'activity_item.dart';
import 'dart:math' as math;

class ActivityCard extends StatefulWidget {
  final List<Map<String, dynamic>> activities;
  final Function(Map<String, dynamic>) onActivityTap;
  final Function(int, Map<String, dynamic>) onActivityDismiss;
  final int itemsPerPage;
  final Function(String)? onFilterChanged;

  const ActivityCard({
    Key? key,
    required this.activities,
    required this.onActivityTap,
    required this.onActivityDismiss,
    this.itemsPerPage = 5,
    this.onFilterChanged,
  }) : super(key: key);

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  int _currentPage = 0;
  String _currentFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'Income',
    'Expense',
    'Transfer',
    'Bills',
  ];
  bool _showFilterOptions = false;

  List<Map<String, dynamic>> get _filteredActivities {
    if (_currentFilter == 'All') {
      return widget.activities;
    }
    return widget.activities.where((activity) {
      String category = (activity['category'] as String).toLowerCase();
      return category == _currentFilter.toLowerCase();
    }).toList();
  }

  List<Map<String, dynamic>> get _paginatedActivities {
    final startIndex = _currentPage * widget.itemsPerPage;
    final endIndex = math.min(
      startIndex + widget.itemsPerPage,
      _filteredActivities.length,
    );

    if (startIndex >= _filteredActivities.length) {
      // If current page is beyond available data, reset to first page
      _currentPage = 0;
      return _filteredActivities.take(widget.itemsPerPage).toList();
    }

    return _filteredActivities.sublist(startIndex, endIndex);
  }

  int get _totalPages {
    return (_filteredActivities.length / widget.itemsPerPage).ceil();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  void _applyFilter(String filter) {
    setState(() {
      _currentFilter = filter;
      _currentPage = 0; // Reset to first page when filter changes
      _showFilterOptions = false;
    });

    if (widget.onFilterChanged != null) {
      widget.onFilterChanged!(filter);
    }
  }

  @override
  Widget build(BuildContext context) {
    final paginatedItems = _paginatedActivities;
    final bool hasItems = _filteredActivities.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterBar(),
          if (_showFilterOptions) _buildFilterOptions(),
          if (hasItems) ...[
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paginatedItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder:
                  (context, index) => ActivityItem(
                    activity: paginatedItems[index],
                    index: index,
                    onTap: widget.onActivityTap,
                    onDismiss: widget.onActivityDismiss,
                  ),
            ),
            if (_totalPages > 1) ...[
              const SizedBox(height: 16),
              _buildPagination(),
            ],
          ] else ...[
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    color: AppColors.textSecondary.withOpacity(0.5),
                    size: 40,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No activities found',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (_currentFilter != 'All') ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => _applyFilter('All'),
                      child: const Text('Show all activities'),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Activity',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            if (_currentFilter != 'All') ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _currentFilter,
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => _applyFilter('All'),
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        InkWell(
          onTap: () {
            setState(() {
              _showFilterOptions = !_showFilterOptions;
            });
          },
          borderRadius: BorderRadius.circular(4),
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Icon(
                  Icons.filter_list,
                  size: 18,
                  color:
                      _showFilterOptions
                          ? AppColors.accent
                          : AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Filter',
                  style: TextStyle(
                    color:
                        _showFilterOptions
                            ? AppColors.accent
                            : AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterOptions() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: _showFilterOptions ? 50 : 0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.15), width: 1.0),
        ),
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
                  _filterOptions
                      .map(
                        (filter) => (Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(filter),
                            selected: _currentFilter == filter,
                            onSelected: (_) => _applyFilter(filter),
                            backgroundColor: Colors.grey.withOpacity(0.1),
                            selectedColor: AppColors.accent.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color:
                                  _currentFilter == filter
                                      ? AppColors.accent
                                      : AppColors.textPrimary,
                              fontSize: 12,
                            ),
                          ),
                        )),
                      )
                      .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 14),
          onPressed: _currentPage > 0 ? _previousPage : null,
          color:
              _currentPage > 0
                  ? AppColors.accent
                  : Colors.grey.withOpacity(0.3),
          splashRadius: 20,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Page ${_currentPage + 1} of $_totalPages',
            style: TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 14),
          onPressed: _currentPage < _totalPages - 1 ? _nextPage : null,
          color:
              _currentPage < _totalPages - 1
                  ? AppColors.accent
                  : Colors.grey.withOpacity(0.3),
          splashRadius: 20,
        ),
      ],
    );
  }
}
