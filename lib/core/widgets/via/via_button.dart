import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aprofleet_manager/core/theme/via_design_tokens.dart';

/// VIA Design System Button Component
///
/// Provides 4 button variants:
/// - Primary: VIA green fill with white text
/// - Secondary: Transparent with border + green text
/// - Ghost: Text-only with hover state
/// - Danger: Critical red for emergency actions
///
/// Features:
/// - Press scale animation (0.96)
/// - Haptic feedback
/// - Loading state
/// - Disabled state
/// - Custom icon support
enum ViaButtonVariant {
  primary,
  secondary,
  ghost,
  danger,
}

enum ViaButtonSize {
  small,
  medium,
  large,
}

class ViaButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ViaButtonVariant variant;
  final ViaButtonSize size;
  final IconData? icon;
  final bool iconTrailing;
  final bool isLoading;
  final bool isFullWidth;
  final bool enableHaptic;

  const ViaButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ViaButtonVariant.primary,
    this.size = ViaButtonSize.medium,
    this.icon,
    this.iconTrailing = false,
    this.isLoading = false,
    this.isFullWidth = false,
    this.enableHaptic = true,
  });

  /// Primary button - VIA green fill
  const ViaButton.primary({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = ViaButtonSize.medium,
    this.icon,
    this.iconTrailing = false,
    this.isLoading = false,
    this.isFullWidth = false,
    this.enableHaptic = true,
  }) : variant = ViaButtonVariant.primary;

  /// Secondary button - Transparent with border
  const ViaButton.secondary({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = ViaButtonSize.medium,
    this.icon,
    this.iconTrailing = false,
    this.isLoading = false,
    this.isFullWidth = false,
    this.enableHaptic = true,
  }) : variant = ViaButtonVariant.secondary;

  /// Ghost button - Text only
  const ViaButton.ghost({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = ViaButtonSize.medium,
    this.icon,
    this.iconTrailing = false,
    this.isLoading = false,
    this.isFullWidth = false,
    this.enableHaptic = true,
  }) : variant = ViaButtonVariant.ghost;

  /// Danger button - Critical red
  const ViaButton.danger({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = ViaButtonSize.medium,
    this.icon,
    this.iconTrailing = false,
    this.isLoading = false,
    this.isFullWidth = false,
    this.enableHaptic = true,
  }) : variant = ViaButtonVariant.danger;

  @override
  State<ViaButton> createState() => _ViaButtonState();
}

class _ViaButtonState extends State<ViaButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

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
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
      if (widget.enableHaptic) {
        HapticFeedback.lightImpact();
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTap() {
    if (widget.onPressed != null && !widget.isLoading) {
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return ScaleTransition(
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
            width: widget.isFullWidth ? double.infinity : null,
            padding: _getPadding(),
            decoration: _getDecoration(isDisabled),
            child: Row(
              mainAxisSize:
                  widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null && !widget.iconTrailing) ...[
                  if (widget.isLoading)
                    SizedBox(
                      width: _getIconSize(),
                      height: _getIconSize(),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getTextColor(),
                        ),
                      ),
                    )
                  else
                    Icon(
                      widget.icon,
                      size: _getIconSize(),
                      color: _getTextColor(),
                    ),
                  SizedBox(width: ViaDesignTokens.spacingSm),
                ],
                if (!widget.isLoading || widget.icon == null)
                  Text(
                    widget.text.toUpperCase(),
                    style: _getTextStyle().copyWith(
                      color: _getTextColor(),
                    ),
                  ),
                if (widget.icon != null && widget.iconTrailing) ...[
                  SizedBox(width: ViaDesignTokens.spacingSm),
                  if (widget.isLoading)
                    SizedBox(
                      width: _getIconSize(),
                      height: _getIconSize(),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getTextColor(),
                        ),
                      ),
                    )
                  else
                    Icon(
                      widget.icon,
                      size: _getIconSize(),
                      color: _getTextColor(),
                    ),
                ],
                if (widget.isLoading && widget.icon == null) ...[
                  SizedBox(width: ViaDesignTokens.spacingSm),
                  SizedBox(
                    width: _getIconSize(),
                    height: _getIconSize(),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getTextColor(),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case ViaButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: ViaDesignTokens.spacingMd,
          vertical: ViaDesignTokens.spacingSm,
        );
      case ViaButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: ViaDesignTokens.spacingXl,
          vertical: ViaDesignTokens.spacingMd,
        );
      case ViaButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: ViaDesignTokens.spacing2xl,
          vertical: ViaDesignTokens.spacingLg,
        );
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case ViaButtonSize.small:
        return ViaDesignTokens.iconXs;
      case ViaButtonSize.medium:
        return ViaDesignTokens.iconSm;
      case ViaButtonSize.large:
        return ViaDesignTokens.iconMd;
    }
  }

  TextStyle _getTextStyle() {
    switch (widget.size) {
      case ViaButtonSize.small:
        return ViaDesignTokens.labelSmall;
      case ViaButtonSize.medium:
        return ViaDesignTokens.labelMedium;
      case ViaButtonSize.large:
        return ViaDesignTokens.labelLarge;
    }
  }

  BoxDecoration _getDecoration(bool isDisabled) {
    switch (widget.variant) {
      case ViaButtonVariant.primary:
        return BoxDecoration(
          color: isDisabled
              ? ViaDesignTokens.primary.withValues(alpha: 0.3)
              : ViaDesignTokens.primary,
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
        );

      case ViaButtonVariant.secondary:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
          border: Border.all(
            color: isDisabled
                ? ViaDesignTokens.primary.withValues(alpha: 0.3)
                : ViaDesignTokens.primary,
            width: 1.5,
          ),
        );

      case ViaButtonVariant.ghost:
        return BoxDecoration(
          color: _isPressed && !isDisabled
              ? ViaDesignTokens.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
        );

      case ViaButtonVariant.danger:
        return BoxDecoration(
          color: isDisabled
              ? ViaDesignTokens.critical.withValues(alpha: 0.3)
              : ViaDesignTokens.critical,
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
        );
    }
  }

  Color _getTextColor() {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    switch (widget.variant) {
      case ViaButtonVariant.primary:
        return Colors.white;

      case ViaButtonVariant.secondary:
        return isDisabled
            ? ViaDesignTokens.primary.withValues(alpha: 0.3)
            : ViaDesignTokens.primary;

      case ViaButtonVariant.ghost:
        return isDisabled
            ? ViaDesignTokens.textDisabled
            : ViaDesignTokens.primary;

      case ViaButtonVariant.danger:
        return Colors.white;
    }
  }
}
