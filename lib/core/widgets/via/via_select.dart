import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/via_design_tokens.dart';
import 'via_bottom_sheet.dart';

/// VIA Design System - Select/Dropdown Component
///
/// A modern select dropdown following VIA design principles.
/// Uses ViaBottomSheet for mobile-friendly selection.
///
/// Features:
/// - Bottom sheet for selection (mobile-friendly)
/// - Search functionality for large lists
/// - Haptic feedback on selection
/// - Disabled state support
/// - Optional label and placeholder
/// - Consistent with VIA design tokens
///
/// Usage:
/// ```dart
/// ViaSelect<String>(
///   value: selectedValue,
///   items: ['Option 1', 'Option 2', 'Option 3'],
///   onChanged: (value) {
///     setState(() => selectedValue = value);
///   },
///   label: 'Select an option',
///   itemBuilder: (item) => item,
/// )
/// ```

class ViaSelect<T> extends StatelessWidget {
  /// Current selected value
  final T? value;

  /// List of items to select from
  final List<T> items;

  /// Called when an item is selected
  final ValueChanged<T?>? onChanged;

  /// Optional label text displayed above the select
  final String? label;

  /// Placeholder text when no value is selected
  final String? placeholder;

  /// Builder function to convert item to display string
  final String Function(T item) itemBuilder;

  /// Optional custom widget builder for items in the bottom sheet
  final Widget Function(T item)? itemWidgetBuilder;

  /// Whether to enable haptic feedback
  final bool enableHaptic;

  /// Whether to enable search for large lists
  final bool enableSearch;

  /// Optional leading icon
  final IconData? icon;

  /// Title for the bottom sheet
  final String? sheetTitle;

  const ViaSelect({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemBuilder,
    this.label,
    this.placeholder,
    this.itemWidgetBuilder,
    this.enableHaptic = true,
    this.enableSearch = false,
    this.icon,
    this.sheetTitle,
  });

  void _showSelectionSheet(BuildContext context) {
    if (onChanged == null) return;

    if (enableHaptic) {
      HapticFeedback.lightImpact();
    }

    ViaBottomSheet.show(
      context: context,
      snapPoints: [0.5, 0.8],
      header: Text(
        sheetTitle ?? label ?? 'Select',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ViaDesignTokens.textPrimary,
        ),
      ),
      child: _SelectionList<T>(
        items: items,
        value: value,
        onChanged: (newValue) {
          Navigator.pop(context);
          if (enableHaptic) {
            HapticFeedback.lightImpact();
          }
          onChanged!(newValue);
        },
        itemBuilder: itemBuilder,
        itemWidgetBuilder: itemWidgetBuilder,
        enableSearch: enableSearch,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onChanged == null;
    final String displayText = value != null ? itemBuilder(value as T) : (placeholder ?? 'Select');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: ViaDesignTokens.labelMedium.copyWith(
              color: isDisabled
                  ? ViaDesignTokens.textMuted
                  : ViaDesignTokens.textPrimary,
            ),
          ),
          const SizedBox(height: ViaDesignTokens.spacingSm),
        ],
        GestureDetector(
          onTap: isDisabled ? null : () => _showSelectionSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ViaDesignTokens.spacingMd,
              vertical: ViaDesignTokens.spacingMd,
            ),
            decoration: BoxDecoration(
              color: isDisabled
                  ? ViaDesignTokens.surfaceSecondary.withValues(alpha: 0.5)
                  : ViaDesignTokens.surfaceSecondary,
              borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
              border: Border.all(
                color: isDisabled
                    ? ViaDesignTokens.borderPrimary.withValues(alpha: 0.3)
                    : ViaDesignTokens.borderPrimary,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: ViaDesignTokens.iconSm,
                    color: isDisabled
                        ? ViaDesignTokens.textMuted
                        : ViaDesignTokens.textSecondary,
                  ),
                  const SizedBox(width: ViaDesignTokens.spacingMd),
                ],
                Expanded(
                  child: Text(
                    displayText,
                    style: ViaDesignTokens.bodyMedium.copyWith(
                      color: value == null
                          ? ViaDesignTokens.textMuted
                          : isDisabled
                              ? ViaDesignTokens.textMuted
                              : ViaDesignTokens.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: ViaDesignTokens.iconMd,
                  color: isDisabled
                      ? ViaDesignTokens.textMuted
                      : ViaDesignTokens.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Internal widget for the selection list in the bottom sheet
class _SelectionList<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String Function(T item) itemBuilder;
  final Widget Function(T item)? itemWidgetBuilder;
  final bool enableSearch;

  const _SelectionList({
    required this.items,
    required this.value,
    required this.onChanged,
    required this.itemBuilder,
    this.itemWidgetBuilder,
    this.enableSearch = false,
  });

  @override
  State<_SelectionList<T>> createState() => _SelectionListState<T>();
}

class _SelectionListState<T> extends State<_SelectionList<T>> {
  late List<T> _filteredItems;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredItems = widget.items
          .where((item) => widget.itemBuilder(item).toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.enableSearch) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: ViaDesignTokens.spacingMd),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: ViaDesignTokens.textMuted),
                prefixIcon: Icon(
                  Icons.search,
                  color: ViaDesignTokens.textSecondary,
                ),
                filled: true,
                fillColor: ViaDesignTokens.surfaceSecondary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
                  borderSide: BorderSide(
                    color: ViaDesignTokens.borderPrimary,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
                  borderSide: BorderSide(
                    color: ViaDesignTokens.borderPrimary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
                  borderSide: const BorderSide(
                    color: ViaDesignTokens.primary,
                    width: 2,
                  ),
                ),
              ),
              style: const TextStyle(color: ViaDesignTokens.textPrimary),
            ),
          ),
        ],
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              final item = _filteredItems[index];
              final isSelected = item == widget.value;

              return InkWell(
                onTap: () => widget.onChanged(item),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ViaDesignTokens.spacingLg,
                    vertical: ViaDesignTokens.spacingMd,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ViaDesignTokens.primary.withValues(alpha: 0.1)
                        : null,
                    border: Border(
                      bottom: BorderSide(
                        color: ViaDesignTokens.borderPrimary.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: widget.itemWidgetBuilder != null
                            ? widget.itemWidgetBuilder!(item)
                            : Text(
                                widget.itemBuilder(item),
                                style: ViaDesignTokens.bodyMedium.copyWith(
                                  color: isSelected
                                      ? ViaDesignTokens.primary
                                      : ViaDesignTokens.textPrimary,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: ViaDesignTokens.primary,
                          size: ViaDesignTokens.iconMd,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// VIA Select with custom item type
///
/// For cases where you need to select from complex objects
class ViaSelectItem<T> {
  final T value;
  final String label;
  final IconData? icon;
  final String? description;

  const ViaSelectItem({
    required this.value,
    required this.label,
    this.icon,
    this.description,
  });
}

/// VIA Select that uses ViaSelectItem for richer display
class ViaSelectWithItems<T> extends StatelessWidget {
  final T? value;
  final List<ViaSelectItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? placeholder;
  final bool enableHaptic;
  final bool enableSearch;
  final IconData? icon;
  final String? sheetTitle;

  const ViaSelectWithItems({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.placeholder,
    this.enableHaptic = true,
    this.enableSearch = false,
    this.icon,
    this.sheetTitle,
  });

  @override
  Widget build(BuildContext context) {
    return ViaSelect<ViaSelectItem<T>>(
      value: items.firstWhere(
        (item) => item.value == value,
        orElse: () => items.first,
      ),
      items: items,
      onChanged: onChanged != null ? (item) => onChanged!(item?.value) : null,
      itemBuilder: (item) => item.label,
      itemWidgetBuilder: (item) => Row(
        children: [
          if (item.icon != null) ...[
            Icon(
              item.icon,
              color: ViaDesignTokens.textSecondary,
              size: ViaDesignTokens.iconMd,
            ),
            const SizedBox(width: ViaDesignTokens.spacingMd),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: ViaDesignTokens.labelMedium.copyWith(
                    color: ViaDesignTokens.textPrimary,
                  ),
                ),
                if (item.description != null) ...[
                  const SizedBox(height: ViaDesignTokens.spacingXxs),
                  Text(
                    item.description!,
                    style: ViaDesignTokens.bodySmall.copyWith(
                      color: ViaDesignTokens.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      label: label,
      placeholder: placeholder,
      enableHaptic: enableHaptic,
      enableSearch: enableSearch,
      icon: icon,
      sheetTitle: sheetTitle,
    );
  }
}
