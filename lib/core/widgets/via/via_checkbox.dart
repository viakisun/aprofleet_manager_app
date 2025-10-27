import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/industrial_dark_tokens.dart';

/// Industrial Dark Checkbox Component
///
/// A professional checkbox following Industrial Dark design principles.
///
/// Features:
/// - Smooth check/uncheck animation
/// - Haptic feedback on toggle
/// - Checked (blue) / unchecked (outline) states
/// - Indeterminate state support
/// - Disabled state (30% opacity)
/// - Optional label with description
/// - Consistent with Industrial Dark tokens
///
/// Usage:
/// ```dart
/// ViaCheckbox(
///   value: isChecked,
///   onChanged: (value) {
///     setState(() => isChecked = value ?? false);
///   },
///   label: 'Accept terms and conditions',
/// )
/// ```

enum ViaCheckboxSize {
  small,
  medium,
  large,
}

class ViaCheckbox extends StatefulWidget {
  /// Current value of the checkbox (true = checked, false = unchecked, null = indeterminate)
  final bool? value;

  /// Called when the checkbox is toggled
  final ValueChanged<bool?>? onChanged;

  /// Optional label text displayed next to the checkbox
  final String? label;

  /// Optional description text below the label
  final String? description;

  /// Size of the checkbox
  final ViaCheckboxSize size;

  /// Whether to enable haptic feedback
  final bool enableHaptic;

  /// Active color when checkbox is checked (defaults to VIA primary)
  final Color? activeColor;

  /// Border color when checkbox is unchecked
  final Color? borderColor;

  /// Whether this is a tristate checkbox (can be null)
  final bool tristate;

  const ViaCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.description,
    this.size = ViaCheckboxSize.medium,
    this.enableHaptic = true,
    this.activeColor,
    this.borderColor,
    this.tristate = false,
  });

  @override
  State<ViaCheckbox> createState() => _ViaCheckboxState();
}

class _ViaCheckboxState extends State<ViaCheckbox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _checkAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: IndustrialDarkTokens.durationMedium,
      vsync: this,
    );

    _checkAnimation = CurvedAnimation(
      parent: _controller,
      curve: IndustrialDarkTokens.curveStandard,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.92),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.92, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: IndustrialDarkTokens.curveStandard,
    ));

    if (widget.value == true) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ViaCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value == true) {
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

      if (widget.tristate) {
        // Cycle through: false -> true -> null -> false
        if (widget.value == false) {
          widget.onChanged!(true);
        } else if (widget.value == true) {
          widget.onChanged!(null);
        } else {
          widget.onChanged!(false);
        }
      } else {
        // Toggle between true and false
        widget.onChanged!(widget.value != true);
      }
    }
  }

  double get _checkboxSize {
    switch (widget.size) {
      case ViaCheckboxSize.small:
        return 18.0;
      case ViaCheckboxSize.medium:
        return 22.0;
      case ViaCheckboxSize.large:
        return 26.0;
    }
  }

  double get _borderRadius {
    switch (widget.size) {
      case ViaCheckboxSize.small:
        return 4.0;
      case ViaCheckboxSize.medium:
        return 5.0;
      case ViaCheckboxSize.large:
        return 6.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onChanged == null;
    final Color activeColor = widget.activeColor ?? IndustrialDarkTokens.accentPrimary; // Blue accent
    final Color borderColor = widget.borderColor ?? IndustrialDarkTokens.outline;

    Widget checkboxWidget = GestureDetector(
      onTap: isDisabled ? null : _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final bool isChecked = widget.value == true;
          final bool isIndeterminate = widget.value == null;

          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: _checkboxSize,
              height: _checkboxSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_borderRadius),
                color: isDisabled
                    ? IndustrialDarkTokens.bgBase.withValues(alpha: 0.5)
                    : (isChecked || isIndeterminate)
                        ? Color.lerp(
                            IndustrialDarkTokens.bgBase,
                            activeColor,
                            _checkAnimation.value,
                          )
                        : IndustrialDarkTokens.bgBase,
                border: Border.all(
                  color: isDisabled
                      ? borderColor.withValues(alpha: 0.3)
                      : (isChecked || isIndeterminate)
                          ? Color.lerp(
                              borderColor,
                              activeColor,
                              _checkAnimation.value,
                            )!
                          : borderColor,
                  width: IndustrialDarkTokens.borderWidth, // 2px
                ),
              ),
              child: isIndeterminate
                  ? Center(
                      child: Container(
                        width: _checkboxSize * 0.5,
                        height: 2,
                        color: Colors.white,
                      ),
                    )
                  : CustomPaint(
                      painter: _CheckPainter(
                        progress: _checkAnimation.value,
                        color: Colors.white,
                      ),
                    ),
            ),
          );
        },
      ),
    );

    // If no label, return just the checkbox
    if (widget.label == null) {
      return checkboxWidget;
    }

    // Return checkbox with label
    return GestureDetector(
      onTap: isDisabled ? null : _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: checkboxWidget,
          ),
          const SizedBox(width: IndustrialDarkTokens.spacingItem),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label!,
                  style: IndustrialDarkTokens.labelStyle.copyWith(
                    fontSize: IndustrialDarkTokens.fontSizeLabel,
                    color: isDisabled
                        ? IndustrialDarkTokens.textSecondary.withValues(alpha: 0.3)
                        : IndustrialDarkTokens.textPrimary,
                  ),
                ),
                if (widget.description != null) ...[
                  const SizedBox(height: IndustrialDarkTokens.spacingMinimal),
                  Text(
                    widget.description!,
                    style: IndustrialDarkTokens.bodyStyle.copyWith(
                      fontSize: IndustrialDarkTokens.fontSizeSmall,
                      color: IndustrialDarkTokens.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for drawing the checkmark
class _CheckPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CheckPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Check mark path
    final double checkWidth = size.width * 0.7;
    final double checkHeight = size.height * 0.7;
    final double startX = size.width * 0.2;
    final double startY = size.height * 0.5;

    // First line (down-left to center)
    final double midX = startX + checkWidth * 0.35;
    final double midY = startY + checkHeight * 0.3;

    // Second line (center to up-right)
    final double endX = startX + checkWidth;
    final double endY = startY - checkHeight * 0.2;

    if (progress < 0.5) {
      // Draw first part (down-left to center)
      final double firstProgress = progress * 2;
      path.moveTo(startX, startY);
      path.lineTo(
        startX + (midX - startX) * firstProgress,
        startY + (midY - startY) * firstProgress,
      );
    } else {
      // Draw complete first part and second part
      final double secondProgress = (progress - 0.5) * 2;
      path.moveTo(startX, startY);
      path.lineTo(midX, midY);
      path.lineTo(
        midX + (endX - midX) * secondProgress,
        midY + (endY - midY) * secondProgress,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// VIA Checkbox List Item
///
/// A convenience widget for using ViaCheckbox in list items.
/// Includes consistent padding and divider support.
class ViaCheckboxListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final IconData? icon;
  final Color? iconColor;
  final bool showDivider;
  final bool tristate;

  const ViaCheckboxListItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.icon,
    this.iconColor,
    this.showDivider = true,
    this.tristate = false,
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
                        fontSize: IndustrialDarkTokens.fontSizeLabel,
                        color: IndustrialDarkTokens.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: IndustrialDarkTokens.spacingMinimal),
                      Text(
                        subtitle!,
                        style: IndustrialDarkTokens.bodyStyle.copyWith(
                          fontSize: IndustrialDarkTokens.fontSizeSmall,
                          color: IndustrialDarkTokens.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: IndustrialDarkTokens.spacingItem),
              ViaCheckbox(
                value: value,
                onChanged: onChanged,
                tristate: tristate,
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
              thickness: IndustrialDarkTokens.borderWidthThin,
              color: IndustrialDarkTokens.outline,
            ),
          ),
      ],
    );
  }
}
