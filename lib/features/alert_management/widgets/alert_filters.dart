import 'package:flutter/material.dart';

import '../../../domain/models/alert.dart';
import '../../../domain/models/work_order.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/constants/app_constants.dart';

class AlertFilters extends StatelessWidget {
  final AlertFilter activeFilter;
  final Function(AlertFilter) onFilterChanged;
  final VoidCallback onClearFilters;

  const AlertFilters({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'FILTER ALERTS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (_hasActiveFilters())
                  TextButton(
                    onPressed: onClearFilters,
                    child: const Text(
                      'Clear All',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),

          // Severity filters
          _buildFilterSection(
            'SEVERITY',
            AlertSeverity.values.map((severity) {
              final isActive =
                  activeFilter.severities?.contains(severity) ?? false;
              final color = AppConstants.alertColors[severity] ?? Colors.grey;

              return _buildFilterChip(
                severity.getDisplayName(context),
                isActive,
                color,
                () => _toggleSeverityFilter(severity),
              );
            }).toList(),
          ),

          // State filters
          _buildFilterSection(
            'STATE',
            AlertStatus.values.map((state) {
              final isActive = activeFilter.states?.contains(state) ?? false;
              final color = _getStateColor(state);

              return _buildFilterChip(
                state.getDisplayName(context),
                isActive,
                color,
                () => _toggleStateFilter(state),
              );
            }).toList(),
          ),

          // Priority filters
          _buildFilterSection(
            'PRIORITY',
            Priority.values.map((priority) {
              final isActive =
                  activeFilter.priorities?.contains(priority) ?? false;
              final color =
                  AppConstants.priorityColors[priority] ?? Colors.grey;

              return _buildFilterChip(
                priority.displayName,
                isActive,
                color,
                () => _togglePriorityFilter(priority),
              );
            }).toList(),
          ),

          // Apply button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ActionButton(
                text: 'Apply Filters',
                onPressed: () => Navigator.of(context).pop(),
                type: ActionButtonType.primary,
              ),
            ),
          ),

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<Widget> chips) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chips,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      String label, bool isActive, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? color : Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? color : Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  bool _hasActiveFilters() {
    return (activeFilter.severities?.isNotEmpty ?? false) ||
        (activeFilter.states?.isNotEmpty ?? false) ||
        (activeFilter.priorities?.isNotEmpty ?? false) ||
        (activeFilter.cartId?.isNotEmpty ?? false) ||
        (activeFilter.unreadOnly == true);
  }

  void _toggleSeverityFilter(AlertSeverity severity) {
    final severities = Set<AlertSeverity>.from(activeFilter.severities ?? {});
    if (severities.contains(severity)) {
      severities.remove(severity);
    } else {
      severities.add(severity);
    }
    onFilterChanged(activeFilter.copyWith(severities: severities));
  }

  void _toggleStateFilter(AlertStatus state) {
    final states = Set<AlertStatus>.from(activeFilter.states ?? {});
    if (states.contains(state)) {
      states.remove(state);
    } else {
      states.add(state);
    }
    onFilterChanged(activeFilter.copyWith(states: states));
  }

  void _togglePriorityFilter(Priority priority) {
    final priorities = Set<Priority>.from(activeFilter.priorities ?? {});
    if (priorities.contains(priority)) {
      priorities.remove(priority);
    } else {
      priorities.add(priority);
    }
    onFilterChanged(activeFilter.copyWith(priorities: priorities));
  }

  Color _getStateColor(AlertStatus state) {
    switch (state) {
      case AlertStatus.triggered:
        return Colors.red;
      case AlertStatus.notified:
        return Colors.orange;
      case AlertStatus.acknowledged:
        return Colors.blue;
      case AlertStatus.escalated:
        return Colors.purple;
      case AlertStatus.resolved:
        return Colors.green;
    }
  }
}
