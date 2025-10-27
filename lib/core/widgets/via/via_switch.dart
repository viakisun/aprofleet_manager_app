import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/industrial_dark_tokens.dart';

/// VIA Design System - Switch/Toggle Component
///
/// A modern, monochrome toggle switch following VIA design principles.
///
/// Features:
/// - Smooth slide animation
/// - Haptic feedback on toggle
/// - Active/inactive states with proper colors
/// - Disabled state support
/// - Optional label
/// - Consistent with VIA design tokens
///
/// Usage:
/// ```dart
/// ViaSwitch(
///   value: isEnabled,
///   onChanged: (value) {
///     setState(() => isEnabled = value);
///   },
///   label: 'Enable notifications',
/// )
/// ```

enum ViaSwitchSize {
  small,
  medium,
  large,
}

class ViaSwitch extends StatefulWidget {
  /// Current value of the switch
  final bool value;

  /// Called when the switch is toggled
  final ValueChanged<bool>? onChanged;

  /// Optional label text displayed next to the switch
  final String? label;

  /// Optional description text below the label
  final String? description;

  /// Size of the switch
  final ViaSwitchSize size;

  /// Whether to enable haptic feedback
  final bool enableHaptic;

  /// Active color when switch is ON (defaults to VIA primary)
  final Color? activeColor;

  /// Track color when switch is OFF
  final Color? inactiveTrackColor;

  /// Thumb color when switch is OFF
  final Color? inactiveThumbColor;

  const ViaSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.size = ViaSwitchSize.medium,
    this.enableHaptic = true,
    this.activeColor,
    this.inactiveTrackColor,
    this.inactiveThumbColor,
  });

  @override
  State<ViaSwitch> createState() => _ViaSwitchState();
}

class _ViaSwitchState extends State<ViaSwitch> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: IndustrialDarkTokens.durationNormal,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: IndustrialDarkTokens.curveStandard,
    );

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ViaSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onChanged != null) {
      if (widget.enableHaptic) {
        HapticFeedback.lightImpact();
      }
      widget.onChanged!(!widget.value);
    }
  }

  double get _switchWidth {
    switch (widget.size) {
      case ViaSwitchSize.small:
        return 44.0;
      case ViaSwitchSize.medium:
        return 52.0;
      case ViaSwitchSize.large:
        return 60.0;
    }
  }

  double get _switchHeight {
    switch (widget.size) {
      case ViaSwitchSize.small:
        return 24.0;
      case ViaSwitchSize.medium:
        return 28.0;
      case ViaSwitchSize.large:
        return 32.0;
    }
  }

  double get _thumbSize {
    switch (widget.size) {
      case ViaSwitchSize.small:
        return 18.0;
      case ViaSwitchSize.medium:
        return 22.0;
      case ViaSwitchSize.large:
        return 26.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onChanged == null;
    final Color activeColor = widget.activeColor ?? IndustrialDarkTokens.accentPrimary;
    final Color inactiveTrackColor = widget.inactiveTrackColor ?? IndustrialDarkTokens.bgSurface;
    final Color inactiveThumbColor = widget.inactiveThumbColor ?? IndustrialDarkTokens.textSecondary;

    Widget switchWidget = GestureDetector(
      onTap: isDisabled ? null : _handleTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: _switchWidth,
            height: _switchHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_switchHeight / 2),
              color: isDisabled
                  ? IndustrialDarkTokens.bgSurface.withValues(alpha: 0.5)
                  : Color.lerp(
                      inactiveTrackColor,
                      activeColor.withValues(alpha: 0.3),
                      _animation.value,
                    ),
              border: Border.all(
                color: isDisabled
                    ? IndustrialDarkTokens.outline.withValues(alpha: 0.3)
                    : Color.lerp(
                        IndustrialDarkTokens.outline,
                        activeColor,
                        _animation.value,
                      )!,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Align(
                alignment: Alignment.lerp(
                  Alignment.centerLeft,
                  Alignment.centerRight,
                  _animation.value,
                )!,
                child: Container(
                  width: _thumbSize,
                  height: _thumbSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDisabled
                        ? IndustrialDarkTokens.textSecondary.withValues(alpha: 0.5)
                        : Color.lerp(
                            inactiveThumbColor,
                            activeColor,
                            _animation.value,
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    // If no label, return just the switch
    if (widget.label == null) {
      return switchWidget;
    }

    // Return switch with label
    return GestureDetector(
      onTap: isDisabled ? null : _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label!,
                  style: IndustrialDarkTokens.labelStyle.copyWith(
                    color: isDisabled
                        ? IndustrialDarkTokens.textSecondary
                        : IndustrialDarkTokens.textPrimary,
                  ),
                ),
                if (widget.description != null) ...[
                  const SizedBox(height: IndustrialDarkTokens.spacingMinimal),
                  Text(
                    widget.description!,
                    style: IndustrialDarkTokens.bodyStyle.copyWith(
                      color: IndustrialDarkTokens.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: IndustrialDarkTokens.spacingItem),
          switchWidget,
        ],
      ),
    );
  }
}

/// VIA Switch List Item
///
/// A convenience widget for using ViaSwitch in list items (like Settings).
/// Includes consistent padding and divider support.
class ViaSwitchListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final IconData? icon;
  final Color? iconColor;
  final bool showDivider;

  const ViaSwitchListItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.icon,
    this.iconColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: IndustrialDarkTokens.spacingCard,
            vertical: IndustrialDarkTokens.spacingItem,
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 24,
                  color: iconColor ?? IndustrialDarkTokens.textSecondary,
                ),
                const SizedBox(width: IndustrialDarkTokens.spacingItem),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: IndustrialDarkTokens.labelStyle.copyWith(
                        color: IndustrialDarkTokens.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: IndustrialDarkTokens.spacingMinimal),
                      Text(
                        subtitle!,
                        style: IndustrialDarkTokens.bodyStyle.copyWith(
                          color: IndustrialDarkTokens.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: IndustrialDarkTokens.spacingItem),
              ViaSwitch(
                value: value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsets.only(
              left: icon != null
                  ? IndustrialDarkTokens.spacingCard +
                      24 +
                      IndustrialDarkTokens.spacingItem
                  : IndustrialDarkTokens.spacingCard,
            ),
            child: Divider(
              height: 1,
              color: IndustrialDarkTokens.outline,
            ),
          ),
      ],
    );
  }
}
