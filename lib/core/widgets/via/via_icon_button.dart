import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

/// Industrial Dark Icon Button Component
///
/// Provides circular icon-only buttons for UI controls
///
/// Features:
/// - Press scale animation (0.96)
/// - Haptic feedback
/// - 3 sizes: small (32px), medium (40px), large (48px)
/// - 3 variants: primary (blue), secondary (outline), ghost (semi-transparent)
/// - Disabled state (30% opacity)
/// - Tooltip support
enum ViaIconButtonSize {
  small,
  medium,
  large,
}

enum ViaIconButtonVariant {
  primary,
  secondary,
  ghost,
}

class ViaIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final ViaIconButtonSize size;
  final ViaIconButtonVariant variant;
  final String? tooltip;
  final bool enableHaptic;
  final Color? backgroundColor;
  final Color? iconColor;

  const ViaIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = ViaIconButtonSize.medium,
    this.variant = ViaIconButtonVariant.ghost,
    this.tooltip,
    this.enableHaptic = true,
    this.backgroundColor,
    this.iconColor,
  });

  /// Ghost variant - Semi-transparent background (default for map controls)
  const ViaIconButton.ghost({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = ViaIconButtonSize.medium,
    this.tooltip,
    this.enableHaptic = true,
    this.backgroundColor,
    this.iconColor,
  }) : variant = ViaIconButtonVariant.ghost;

  /// Primary variant - VIA green background
  const ViaIconButton.primary({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = ViaIconButtonSize.medium,
    this.tooltip,
    this.enableHaptic = true,
    this.backgroundColor,
    this.iconColor,
  }) : variant = ViaIconButtonVariant.primary;

  /// Secondary variant - Transparent with border
  const ViaIconButton.secondary({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = ViaIconButtonSize.medium,
    this.tooltip,
    this.enableHaptic = true,
    this.backgroundColor,
    this.iconColor,
  }) : variant = ViaIconButtonVariant.secondary;

  @override
  State<ViaIconButton> createState() => _ViaIconButtonState();
}

class _ViaIconButtonState extends State<ViaIconButton>
    with SingleTickerProviderStateMixin {
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
      end: 0.96,
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
    if (widget.onPressed != null) {
      _controller.forward();
      if (widget.enableHaptic) {
        HapticFeedback.lightImpact();
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
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;
    final buttonSize = _getButtonSize();
    final iconSize = _getIconSize();

    final button = ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        child: AnimatedOpacity(
          opacity: isDisabled ? 0.3 : 1.0, // 30% opacity when disabled
          duration: IndustrialDarkTokens.durationFast,
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: _getDecoration(isDisabled),
            child: Center(
              child: Icon(
                widget.icon,
                size: iconSize,
                color: widget.iconColor ?? _getIconColor(),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null && widget.tooltip!.isNotEmpty) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }

  double _getButtonSize() {
    switch (widget.size) {
      case ViaIconButtonSize.small:
        return 32;
      case ViaIconButtonSize.medium:
        return 40;
      case ViaIconButtonSize.large:
        return 48;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case ViaIconButtonSize.small:
        return 16; // Small icon
      case ViaIconButtonSize.medium:
        return 20; // Medium icon
      case ViaIconButtonSize.large:
        return 24; // Large icon
    }
  }

  BoxDecoration _getDecoration(bool isDisabled) {
    // Custom background color overrides variant
    if (widget.backgroundColor != null) {
      return BoxDecoration(
        color: isDisabled
            ? widget.backgroundColor!.withValues(alpha: 0.3)
            : widget.backgroundColor,
        shape: BoxShape.circle,
      );
    }

    switch (widget.variant) {
      case ViaIconButtonVariant.primary:
        // Accent blue background (#0072E5)
        return BoxDecoration(
          color: isDisabled
              ? IndustrialDarkTokens.accentPrimary.withValues(alpha: 0.3)
              : IndustrialDarkTokens.accentPrimary,
          shape: BoxShape.circle,
        );

      case ViaIconButtonVariant.secondary:
        // Transparent with 2px outline
        return BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDisabled
                ? IndustrialDarkTokens.accentPrimary.withValues(alpha: 0.3)
                : IndustrialDarkTokens.accentPrimary,
            width: IndustrialDarkTokens.borderWidth, // 2px
          ),
        );

      case ViaIconButtonVariant.ghost:
        // Semi-transparent dark gray background (for map controls)
        return BoxDecoration(
          color: IndustrialDarkTokens.bgSurface.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        );
    }
  }

  Color _getIconColor() {
    final isDisabled = widget.onPressed == null;

    if (isDisabled) {
      return IndustrialDarkTokens.textSecondary.withValues(alpha: 0.3);
    }

    switch (widget.variant) {
      case ViaIconButtonVariant.primary:
        // White icon on blue background
        return Colors.white;

      case ViaIconButtonVariant.secondary:
        // Accent blue icon (matches border)
        return IndustrialDarkTokens.accentPrimary;

      case ViaIconButtonVariant.ghost:
        // Primary text color (85% white)
        return IndustrialDarkTokens.textPrimary;
    }
  }
}
