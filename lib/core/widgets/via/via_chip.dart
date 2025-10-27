import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

/// VIA Design System Chip Component
///
/// Filter chips with toggle functionality:
/// - Multiple variants: filter, choice, action, input
/// - Selected/unselected states
/// - Icon and avatar support
/// - Delete/close functionality
/// - Scale animation on press
///
/// Features:
/// - Haptic feedback
/// - Smooth state transitions
/// - Integration with VIA design tokens

enum ViaChipVariant {
  filter, // Toggle filter (e.g., status filters)
  choice, // Single choice (radio-like behavior)
  action, // Action chip (perform action on tap)
  input, // Input chip (deletable)
}

class ViaChip extends StatefulWidget {
  final String label;
  final ViaChipVariant variant;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final IconData? icon;
  final Widget? avatar;
  final bool enabled;
  final bool enableHaptic;

  const ViaChip({
    super.key,
    required this.label,
    this.variant = ViaChipVariant.filter,
    this.selected = false,
    this.onTap,
    this.onDelete,
    this.icon,
    this.avatar,
    this.enabled = true,
    this.enableHaptic = true,
  });

  /// Filter chip - Toggle on/off
  const ViaChip.filter({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
    this.enabled = true,
    this.enableHaptic = true,
  })  : variant = ViaChipVariant.filter,
        onDelete = null,
        avatar = null;

  /// Choice chip - Single selection
  const ViaChip.choice({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
    this.enabled = true,
    this.enableHaptic = true,
  })  : variant = ViaChipVariant.choice,
        onDelete = null,
        avatar = null;

  /// Action chip - Perform action
  const ViaChip.action({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.enabled = true,
    this.enableHaptic = true,
  })  : variant = ViaChipVariant.action,
        selected = false,
        onDelete = null,
        avatar = null;

  /// Input chip - Deletable
  const ViaChip.input({
    super.key,
    required this.label,
    this.onTap,
    required this.onDelete,
    this.avatar,
    this.enabled = true,
    this.enableHaptic = true,
  })  : variant = ViaChipVariant.input,
        selected = false,
        icon = null;

  @override
  State<ViaChip> createState() => _ViaChipState();
}

class _ViaChipState extends State<ViaChip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: IndustrialDarkTokens.durationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: IndustrialDarkTokens.curveStandard,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enabled && widget.onTap != null) {
      _controller.forward();
      if (widget.enableHaptic) {
        HapticFeedback.selectionClick();
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  void _handleTap() {
    if (widget.enabled && widget.onTap != null) {
      widget.onTap!();
    }
  }

  Color _getBackgroundColor() {
    if (!widget.enabled) {
      return IndustrialDarkTokens.bgSurface.withValues(alpha: 0.5);
    }

    if (widget.selected) {
      return IndustrialDarkTokens.accentPrimary.withValues(alpha: 0.2);
    }

    return IndustrialDarkTokens.bgSurface;
  }

  Color _getBorderColor() {
    if (!widget.enabled) {
      return IndustrialDarkTokens.outline.withValues(alpha: 0.5);
    }

    if (widget.selected) {
      return IndustrialDarkTokens.accentPrimary;
    }

    return IndustrialDarkTokens.outline;
  }

  Color _getTextColor() {
    if (!widget.enabled) {
      return IndustrialDarkTokens.textDisabled;
    }

    if (widget.selected) {
      return IndustrialDarkTokens.accentPrimary;
    }

    return IndustrialDarkTokens.textPrimary;
  }

  Color _getIconColor() {
    if (!widget.enabled) {
      return IndustrialDarkTokens.textDisabled;
    }

    if (widget.selected) {
      return IndustrialDarkTokens.accentPrimary;
    }

    return IndustrialDarkTokens.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: IndustrialDarkTokens.durationFast,
          padding: EdgeInsets.symmetric(
            horizontal: widget.avatar != null || widget.icon != null
                ? IndustrialDarkTokens.spacingCompact
                : IndustrialDarkTokens.spacingItem,
            vertical: IndustrialDarkTokens.spacingCompact,
          ),
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            borderRadius:
                BorderRadius.circular(IndustrialDarkTokens.radiusChip),
            border: Border.all(
              color: _getBorderColor(),
              width: widget.selected ? 1.5 : 1.0,
            ),
            boxShadow: widget.selected
                ? [
                    BoxShadow(
                      color: IndustrialDarkTokens.accentPrimary
                          .withValues(alpha: 0.2),
                      blurRadius: 8.0,
                      spreadRadius: 0.0,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar (for input chips)
              if (widget.avatar != null) ...[
                SizedBox(
                  width: 20,
                  height: 20,
                  child: widget.avatar!,
                ),
                const SizedBox(width: IndustrialDarkTokens.spacingCompact),
              ],

              // Leading icon
              if (widget.icon != null && widget.avatar == null) ...[
                Icon(
                  widget.icon,
                  size: 16,
                  color: _getIconColor(),
                ),
                const SizedBox(width: IndustrialDarkTokens.spacingCompact),
              ],

              // Selected indicator (checkmark)
              if (widget.selected &&
                  widget.variant == ViaChipVariant.filter) ...[
                const Icon(
                  Icons.check,
                  size: 16,
                  color: IndustrialDarkTokens.accentPrimary,
                ),
                const SizedBox(width: IndustrialDarkTokens.spacingCompact),
              ],

              // Label
              Text(
                widget.label,
                style: IndustrialDarkTokens.labelStyle.copyWith(
                  color: _getTextColor(),
                  fontWeight:
                      widget.selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),

              // Delete icon (for input chips)
              if (widget.onDelete != null) ...[
                const SizedBox(width: IndustrialDarkTokens.spacingCompact),
                GestureDetector(
                  onTap: widget.enabled ? widget.onDelete : null,
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: _getIconColor(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// VIA Chip Group - Manages multiple filter chips
class ViaChipGroup extends StatefulWidget {
  final List<String> labels;
  final List<String> selectedLabels;
  final ValueChanged<List<String>>? onSelectionChanged;
  final bool multiSelect;
  final bool enabled;
  final WrapAlignment alignment;
  final double spacing;
  final double runSpacing;

  const ViaChipGroup({
    super.key,
    required this.labels,
    this.selectedLabels = const [],
    this.onSelectionChanged,
    this.multiSelect = true,
    this.enabled = true,
    this.alignment = WrapAlignment.start,
    this.spacing = IndustrialDarkTokens.spacingCompact,
    this.runSpacing = IndustrialDarkTokens.spacingCompact,
  });

  @override
  State<ViaChipGroup> createState() => _ViaChipGroupState();
}

class _ViaChipGroupState extends State<ViaChipGroup> {
  late List<String> _selectedLabels;

  @override
  void initState() {
    super.initState();
    _selectedLabels = List.from(widget.selectedLabels);
  }

  @override
  void didUpdateWidget(ViaChipGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedLabels != oldWidget.selectedLabels) {
      _selectedLabels = List.from(widget.selectedLabels);
    }
  }

  void _handleChipTap(String label) {
    setState(() {
      if (_selectedLabels.contains(label)) {
        _selectedLabels.remove(label);
      } else {
        if (widget.multiSelect) {
          _selectedLabels.add(label);
        } else {
          _selectedLabels = [label];
        }
      }
    });

    widget.onSelectionChanged?.call(_selectedLabels);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: widget.alignment,
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
      children: widget.labels.map((label) {
        return ViaChip.filter(
          label: label,
          selected: _selectedLabels.contains(label),
          onTap: widget.enabled ? () => _handleChipTap(label) : null,
          enabled: widget.enabled,
        );
      }).toList(),
    );
  }
}
