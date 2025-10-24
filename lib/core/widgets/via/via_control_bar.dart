import 'package:flutter/material.dart';
import '../../theme/industrial_dark_tokens.dart';
import 'via_stat_chip.dart';

/// Industrial Dark - Control Bar Component
///
/// A sticky control bar that replaces tab navigation with:
/// - Summary stat chips
/// - Filter dropdown
/// - Sort dropdown
/// - View mode toggle
/// - Optional search
/// - Outline-based depth (no shadows)
///
/// Example:
/// ```dart
/// ViaControlBar(
///   stats: [
///     ViaStatData(label: 'Critical', count: 3, color: IndustrialDarkTokens.error),
///     ViaStatData(label: 'Warning', count: 5, color: IndustrialDarkTokens.warning),
///   ],
///   filterOptions: ['All', 'Unread', 'Critical'],
///   sortOptions: ['Newest', 'Oldest', 'Priority'],
///   currentFilter: 'All',
///   currentSort: 'Newest',
///   onFilterChanged: (filter) { },
///   onSortChanged: (sort) { },
/// )
/// ```
class ViaControlBar extends StatelessWidget {
  /// Summary statistics to display as chips
  final List<ViaStatData> stats;

  /// Filter options for dropdown
  final List<ViaFilterOption> filterOptions;

  /// Sort options for dropdown
  final List<ViaSortOption> sortOptions;

  /// View mode options (optional)
  final List<ViaViewMode>? viewModes;

  /// Currently selected filter
  final String currentFilter;

  /// Currently selected sort
  final String currentSort;

  /// Currently selected view mode
  final String? currentViewMode;

  /// Callback when filter changes
  final ValueChanged<String> onFilterChanged;

  /// Callback when sort changes
  final ValueChanged<String> onSortChanged;

  /// Callback when view mode changes
  final ValueChanged<String>? onViewModeChanged;

  /// Callback when stat chip is tapped
  final ValueChanged<String>? onStatTapped;

  /// Whether to show search input
  final bool showSearch;

  /// Search callback
  final ValueChanged<String>? onSearch;

  /// Background color
  final Color? backgroundColor;

  const ViaControlBar({
    super.key,
    required this.stats,
    required this.filterOptions,
    required this.sortOptions,
    required this.currentFilter,
    required this.currentSort,
    required this.onFilterChanged,
    required this.onSortChanged,
    this.viewModes,
    this.currentViewMode,
    this.onViewModeChanged,
    this.onStatTapped,
    this.showSearch = false,
    this.onSearch,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? IndustrialDarkTokens.bgSurface,
        border: Border(
          bottom: BorderSide(
            color: IndustrialDarkTokens.outline,
            width: IndustrialDarkTokens.borderWidth, // 2px
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Stats row
          if (stats.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: IndustrialDarkTokens.spacingItem,
                vertical: IndustrialDarkTokens.spacingCompact,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < stats.length; i++) ...[
                      ViaStatChip(
                        label: stats[i].label,
                        count: stats[i].count,
                        color: stats[i].color,
                        isActive: stats[i].isActive,
                        onTap: onStatTapped != null
                            ? () => onStatTapped!(stats[i].id ?? stats[i].label)
                            : null,
                      ),
                      if (i < stats.length - 1)
                        const SizedBox(width: IndustrialDarkTokens.spacingCompact),
                    ],
                  ],
                ),
              ),
            ),

          // Controls row
          Container(
            padding: const EdgeInsets.only(
              left: IndustrialDarkTokens.spacingItem,
              right: IndustrialDarkTokens.spacingItem,
              bottom: IndustrialDarkTokens.spacingCompact,
            ),
            child: Row(
              children: [
                // Filter dropdown
                _ControlDropdown(
                  icon: Icons.filter_list,
                  label: 'Filter',
                  value: currentFilter,
                  items: filterOptions
                      .map((option) => DropdownMenuItem(
                            value: option.value,
                            child: Row(
                              children: [
                                if (option.icon != null) ...[
                                  Icon(option.icon, size: 16),
                                  const SizedBox(width: 8),
                                ],
                                Text(option.label),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onFilterChanged(value);
                  },
                ),

                const SizedBox(width: IndustrialDarkTokens.spacingCompact),

                // Sort dropdown
                _ControlDropdown(
                  icon: Icons.sort,
                  label: 'Sort',
                  value: currentSort,
                  items: sortOptions
                      .map((option) => DropdownMenuItem(
                            value: option.value,
                            child: Row(
                              children: [
                                if (option.icon != null) ...[
                                  Icon(option.icon, size: 16),
                                  const SizedBox(width: 8),
                                ],
                                Text(option.label),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onSortChanged(value);
                  },
                ),

                const Spacer(),

                // View mode toggle
                if (viewModes != null && viewModes!.isNotEmpty)
                  _ViewModeToggle(
                    modes: viewModes!,
                    currentMode: currentViewMode ?? viewModes!.first.value,
                    onChanged: onViewModeChanged ?? (_) {},
                  ),
              ],
            ),
          ),

          // Search bar (optional)
          if (showSearch)
            Padding(
              padding: const EdgeInsets.only(
                left: IndustrialDarkTokens.spacingItem,
                right: IndustrialDarkTokens.spacingItem,
                bottom: IndustrialDarkTokens.spacingCompact,
              ),
              child: TextField(
                onChanged: onSearch,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: IndustrialDarkTokens.spacingItem,
                    vertical: IndustrialDarkTokens.spacingCompact,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(IndustrialDarkTokens.radiusButton),
                    borderSide: BorderSide(
                      color: IndustrialDarkTokens.outline,
                      width: IndustrialDarkTokens.borderWidth,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Data model for stat chip
class ViaStatData {
  final String label;
  final int count;
  final Color color;
  final bool isActive;
  final String? id;

  const ViaStatData({
    required this.label,
    required this.count,
    required this.color,
    this.isActive = false,
    this.id,
  });
}

/// Filter option model
class ViaFilterOption {
  final String label;
  final String value;
  final IconData? icon;

  const ViaFilterOption({
    required this.label,
    required this.value,
    this.icon,
  });
}

/// Sort option model
class ViaSortOption {
  final String label;
  final String value;
  final IconData? icon;

  const ViaSortOption({
    required this.label,
    required this.value,
    this.icon,
  });
}

/// View mode model
class ViaViewMode {
  final String label;
  final String value;
  final IconData icon;

  const ViaViewMode({
    required this.label,
    required this.value,
    required this.icon,
  });
}

/// Internal dropdown widget
class _ControlDropdown extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;

  const _ControlDropdown({
    required this.icon,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: IndustrialDarkTokens.spacingCompact,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: IndustrialDarkTokens.bgBase,
        borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
        border: Border.all(
          color: IndustrialDarkTokens.outline,
          width: IndustrialDarkTokens.borderWidthThin,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: IndustrialDarkTokens.textSecondary),
          const SizedBox(width: 6),
          DropdownButton<String>(
            value: value,
            items: items,
            onChanged: onChanged,
            underline: const SizedBox(),
            isDense: true,
            style: TextStyle(
              fontSize: IndustrialDarkTokens.fontSizeSmall,
              color: IndustrialDarkTokens.textPrimary,
              fontWeight: IndustrialDarkTokens.fontWeightBold,
            ),
            dropdownColor: IndustrialDarkTokens.bgBase,
            icon: Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: IndustrialDarkTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal view mode toggle
class _ViewModeToggle extends StatelessWidget {
  final List<ViaViewMode> modes;
  final String currentMode;
  final ValueChanged<String> onChanged;

  const _ViewModeToggle({
    required this.modes,
    required this.currentMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: IndustrialDarkTokens.bgBase,
        borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
        border: Border.all(
          color: IndustrialDarkTokens.outline,
          width: IndustrialDarkTokens.borderWidthThin,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: modes.map((mode) {
          final isActive = mode.value == currentMode;
          return GestureDetector(
            onTap: () => onChanged(mode.value),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: IndustrialDarkTokens.spacingCompact,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? IndustrialDarkTokens.accentPrimary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
              ),
              child: Icon(
                mode.icon,
                size: 18,
                color: isActive
                    ? Colors.white
                    : IndustrialDarkTokens.textSecondary,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
