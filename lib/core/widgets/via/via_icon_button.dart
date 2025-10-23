import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aprofleet_manager/core/theme/via_design_tokens.dart';

/// VIA Design System Icon Button Component
///
/// Provides circular icon-only buttons for UI controls
///
/// Features:
/// - Press scale animation (0.96)
/// - Haptic feedback
/// - 3 sizes: small (32px), medium (40px), large (48px)
/// - 3 variants: primary, secondary, ghost
/// - Disabled state
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
      duration: ViaDesignTokens.durationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: ViaDesignTokens.curveStandard,
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
          opacity: isDisabled ? ViaDesignTokens.opacityDisabled : 1.0,
          duration: ViaDesignTokens.durationFast,
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
        return ViaDesignTokens.iconXs;
      case ViaIconButtonSize.medium:
        return ViaDesignTokens.iconSm;
      case ViaIconButtonSize.large:
        return ViaDesignTokens.iconMd;
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
        return BoxDecoration(
          color: isDisabled
              ? ViaDesignTokens.primary.withValues(alpha: 0.3)
              : ViaDesignTokens.primary,
          shape: BoxShape.circle,
        );

      case ViaIconButtonVariant.secondary:
        return BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDisabled
                ? ViaDesignTokens.primary.withValues(alpha: 0.3)
                : ViaDesignTokens.primary,
            width: 1.5,
          ),
        );

      case ViaIconButtonVariant.ghost:
        // Semi-transparent background (default for map controls)
        return BoxDecoration(
          color: ViaDesignTokens.surfaceSecondary.withValues(alpha: 0.8),
          shape: BoxShape.circle,
        );
    }
  }

  Color _getIconColor() {
    final isDisabled = widget.onPressed == null;

    if (isDisabled) {
      return ViaDesignTokens.textDisabled;
    }

    switch (widget.variant) {
      case ViaIconButtonVariant.primary:
        return Colors.white;

      case ViaIconButtonVariant.secondary:
        return ViaDesignTokens.primary;

      case ViaIconButtonVariant.ghost:
        return ViaDesignTokens.textPrimary;
    }
  }
}
