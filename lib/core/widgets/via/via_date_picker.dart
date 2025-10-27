import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../theme/industrial_dark_tokens.dart';

/// VIA Design System - Date Picker Component
///
/// A modern date picker following VIA design principles.
/// Uses Material date picker with VIA styling.
///
/// Features:
/// - VIA-styled date picker dialog
/// - Custom date format
/// - Haptic feedback on selection
/// - Disabled state support
/// - Optional label and placeholder
/// - Clear button
/// - Consistent with VIA design tokens
///
/// Usage:
/// ```dart
/// ViaDatePicker(
///   selectedDate: selectedDate,
///   onDateSelected: (date) {
///     setState(() => selectedDate = date);
///   },
///   label: 'Select date',
/// )
/// ```

class ViaDatePicker extends StatelessWidget {
  /// Currently selected date
  final DateTime? selectedDate;

  /// Called when a date is selected
  final ValueChanged<DateTime?>? onDateSelected;

  /// Optional label text displayed above the picker
  final String? label;

  /// Placeholder text when no date is selected
  final String? placeholder;

  /// Date format for display (defaults to 'yyyy-MM-dd')
  final String? dateFormat;

  /// First selectable date (defaults to 100 years ago)
  final DateTime? firstDate;

  /// Last selectable date (defaults to 100 years from now)
  final DateTime? lastDate;

  /// Initial date for the picker (defaults to today or selectedDate)
  final DateTime? initialDate;

  /// Whether to enable haptic feedback
  final bool enableHaptic;

  /// Whether to show clear button
  final bool showClearButton;

  /// Optional leading icon
  final IconData? icon;

  /// Help text shown in the date picker dialog
  final String? helpText;

  const ViaDatePicker({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
    this.label,
    this.placeholder,
    this.dateFormat,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.enableHaptic = true,
    this.showClearButton = true,
    this.icon,
    this.helpText,
  });

  Future<void> _showDatePicker(BuildContext context) async {
    if (onDateSelected == null) return;

    if (enableHaptic) {
      HapticFeedback.lightImpact();
    }

    final DateTime now = DateTime.now();
    final DateTime firstSelectableDate = firstDate ?? DateTime(now.year - 100);
    final DateTime lastSelectableDate = lastDate ?? DateTime(now.year + 100);
    final DateTime initial = initialDate ?? selectedDate ?? now;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstSelectableDate,
      lastDate: lastSelectableDate,
      helpText: helpText ?? (label ?? 'Select date'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: IndustrialDarkTokens.accentPrimary,
              onPrimary: Colors.white,
              surface: IndustrialDarkTokens.surfacePrimary,
              onSurface: IndustrialDarkTokens.textPrimary,
            ),
            dialogBackgroundColor: IndustrialDarkTokens.surfacePrimary,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: IndustrialDarkTokens.accentPrimary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (enableHaptic) {
        HapticFeedback.lightImpact();
      }
      onDateSelected!(picked);
    }
  }

  void _clearDate() {
    if (onDateSelected != null) {
      if (enableHaptic) {
        HapticFeedback.lightImpact();
      }
      onDateSelected!(null);
    }
  }

  String _formatDate(DateTime date) {
    if (dateFormat != null) {
      return DateFormat(dateFormat).format(date);
    }
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onDateSelected == null;
    final String displayText = selectedDate != null
        ? _formatDate(selectedDate!)
        : (placeholder ?? 'Select date');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: IndustrialDarkTokens.labelStyle.copyWith(
              color: isDisabled
                  ? IndustrialDarkTokens.textSecondary
                  : IndustrialDarkTokens.textPrimary,
            ),
          ),
          const SizedBox(height: IndustrialDarkTokens.spacingCompact),
        ],
        GestureDetector(
          onTap: isDisabled ? null : () => _showDatePicker(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: IndustrialDarkTokens.spacingItem,
              vertical: IndustrialDarkTokens.spacingItem,
            ),
            decoration: BoxDecoration(
              color: isDisabled
                  ? IndustrialDarkTokens.bgSurface.withValues(alpha: 0.5)
                  : IndustrialDarkTokens.bgSurface,
              borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
              border: Border.all(
                color: isDisabled
                    ? IndustrialDarkTokens.outline.withValues(alpha: 0.3)
                    : IndustrialDarkTokens.outline,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon ?? Icons.calendar_today,
                  size: 20,
                  color: isDisabled
                      ? IndustrialDarkTokens.textSecondary
                      : IndustrialDarkTokens.textSecondary,
                ),
                const SizedBox(width: IndustrialDarkTokens.spacingItem),
                Expanded(
                  child: Text(
                    displayText,
                    style: IndustrialDarkTokens.bodyStyle.copyWith(
                      color: selectedDate == null
                          ? IndustrialDarkTokens.textSecondary
                          : isDisabled
                              ? IndustrialDarkTokens.textSecondary
                              : IndustrialDarkTokens.textPrimary,
                    ),
                  ),
                ),
                if (showClearButton && selectedDate != null && !isDisabled)
                  GestureDetector(
                    onTap: _clearDate,
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: IndustrialDarkTokens.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// VIA Date Range Picker Component
///
/// For selecting a date range (start and end dates)
class ViaDateRangePicker extends StatelessWidget {
  /// Currently selected date range
  final DateTimeRange? selectedRange;

  /// Called when a date range is selected
  final ValueChanged<DateTimeRange?>? onRangeSelected;

  /// Optional label text displayed above the picker
  final String? label;

  /// Placeholder text when no range is selected
  final String? placeholder;

  /// Date format for display (defaults to 'yyyy-MM-dd')
  final String? dateFormat;

  /// First selectable date (defaults to 100 years ago)
  final DateTime? firstDate;

  /// Last selectable date (defaults to 100 years from now)
  final DateTime? lastDate;

  /// Whether to enable haptic feedback
  final bool enableHaptic;

  /// Whether to show clear button
  final bool showClearButton;

  /// Optional leading icon
  final IconData? icon;

  /// Help text shown in the date picker dialog
  final String? helpText;

  const ViaDateRangePicker({
    super.key,
    this.selectedRange,
    required this.onRangeSelected,
    this.label,
    this.placeholder,
    this.dateFormat,
    this.firstDate,
    this.lastDate,
    this.enableHaptic = true,
    this.showClearButton = true,
    this.icon,
    this.helpText,
  });

  Future<void> _showDateRangePicker(BuildContext context) async {
    if (onRangeSelected == null) return;

    if (enableHaptic) {
      HapticFeedback.lightImpact();
    }

    final DateTime now = DateTime.now();
    final DateTime firstSelectableDate = firstDate ?? DateTime(now.year - 100);
    final DateTime lastSelectableDate = lastDate ?? DateTime(now.year + 100);

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedRange,
      firstDate: firstSelectableDate,
      lastDate: lastSelectableDate,
      helpText: helpText ?? (label ?? 'Select date range'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: IndustrialDarkTokens.accentPrimary,
              onPrimary: Colors.white,
              surface: IndustrialDarkTokens.surfacePrimary,
              onSurface: IndustrialDarkTokens.textPrimary,
            ),
            dialogBackgroundColor: IndustrialDarkTokens.surfacePrimary,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: IndustrialDarkTokens.accentPrimary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (enableHaptic) {
        HapticFeedback.lightImpact();
      }
      onRangeSelected!(picked);
    }
  }

  void _clearRange() {
    if (onRangeSelected != null) {
      if (enableHaptic) {
        HapticFeedback.lightImpact();
      }
      onRangeSelected!(null);
    }
  }

  String _formatDate(DateTime date) {
    if (dateFormat != null) {
      return DateFormat(dateFormat).format(date);
    }
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onRangeSelected == null;
    final String displayText = selectedRange != null
        ? '${_formatDate(selectedRange!.start)} - ${_formatDate(selectedRange!.end)}'
        : (placeholder ?? 'Select date range');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: IndustrialDarkTokens.labelStyle.copyWith(
              color: isDisabled
                  ? IndustrialDarkTokens.textSecondary
                  : IndustrialDarkTokens.textPrimary,
            ),
          ),
          const SizedBox(height: IndustrialDarkTokens.spacingCompact),
        ],
        GestureDetector(
          onTap: isDisabled ? null : () => _showDateRangePicker(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: IndustrialDarkTokens.spacingItem,
              vertical: IndustrialDarkTokens.spacingItem,
            ),
            decoration: BoxDecoration(
              color: isDisabled
                  ? IndustrialDarkTokens.bgSurface.withValues(alpha: 0.5)
                  : IndustrialDarkTokens.bgSurface,
              borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
              border: Border.all(
                color: isDisabled
                    ? IndustrialDarkTokens.outline.withValues(alpha: 0.3)
                    : IndustrialDarkTokens.outline,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon ?? Icons.date_range,
                  size: 20,
                  color: isDisabled
                      ? IndustrialDarkTokens.textSecondary
                      : IndustrialDarkTokens.textSecondary,
                ),
                const SizedBox(width: IndustrialDarkTokens.spacingItem),
                Expanded(
                  child: Text(
                    displayText,
                    style: IndustrialDarkTokens.bodyStyle.copyWith(
                      color: selectedRange == null
                          ? IndustrialDarkTokens.textSecondary
                          : isDisabled
                              ? IndustrialDarkTokens.textSecondary
                              : IndustrialDarkTokens.textPrimary,
                    ),
                  ),
                ),
                if (showClearButton && selectedRange != null && !isDisabled)
                  GestureDetector(
                    onTap: _clearRange,
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: IndustrialDarkTokens.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
