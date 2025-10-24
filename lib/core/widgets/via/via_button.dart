import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

/// Industrial Dark Button Component
///
/// Provides 4 button variants:
/// - Primary: Accent blue fill with white text
/// - Secondary: Transparent with 2px outline border
/// - Ghost: Text-only with hover state
/// - Danger: Critical red for emergency actions
///
/// Features:
/// - Press scale animation (0.96)
/// - Haptic feedback
/// - Loading state
/// - Disabled state
/// - Custom icon support
/// - Outline-based depth (no shadows)
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
          opacity: isDisabled ? 0.3 : 1.0,
          duration: IndustrialDarkTokens.durationFast,
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
                  SizedBox(width: IndustrialDarkTokens.spacingCompact),
                ],
                if (!widget.isLoading || widget.icon == null)
                  Text(
                    widget.text.toUpperCase(),
                    style: _getTextStyle().copyWith(
                      color: _getTextColor(),
                    ),
                  ),
                if (widget.icon != null && widget.iconTrailing) ...[
                  SizedBox(width: IndustrialDarkTokens.spacingCompact),
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
                  SizedBox(width: IndustrialDarkTokens.spacingCompact),
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
          horizontal: IndustrialDarkTokens.spacingItem,
          vertical: IndustrialDarkTokens.spacingCompact,
        );
      case ViaButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: IndustrialDarkTokens.spacingCard,
          vertical: IndustrialDarkTokens.spacingItem,
        );
      case ViaButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: IndustrialDarkTokens.spacingSection,
          vertical: IndustrialDarkTokens.spacingCard,
        );
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case ViaButtonSize.small:
        return 16.0;
      case ViaButtonSize.medium:
        return 20.0;
      case ViaButtonSize.large:
        return 24.0;
    }
  }

  TextStyle _getTextStyle() {
    switch (widget.size) {
      case ViaButtonSize.small:
        return IndustrialDarkTokens.labelStyle.copyWith(
          fontSize: IndustrialDarkTokens.fontSizeSmall,
          fontWeight: IndustrialDarkTokens.fontWeightBold,
        );
      case ViaButtonSize.medium:
        return IndustrialDarkTokens.labelStyle.copyWith(
          fontSize: IndustrialDarkTokens.fontSizeLabel,
          fontWeight: IndustrialDarkTokens.fontWeightBold,
        );
      case ViaButtonSize.large:
        return IndustrialDarkTokens.labelStyle.copyWith(
          fontSize: IndustrialDarkTokens.fontSizeBody,
          fontWeight: IndustrialDarkTokens.fontWeightBold,
        );
    }
  }

  BoxDecoration _getDecoration(bool isDisabled) {
    switch (widget.variant) {
      case ViaButtonVariant.primary:
        return BoxDecoration(
          color: isDisabled
              ? IndustrialDarkTokens.accentDisabled
              : IndustrialDarkTokens.accentPrimary,
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
          // No shadow in Industrial Dark
        );

      case ViaButtonVariant.secondary:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
          border: Border.all(
            color: isDisabled
                ? IndustrialDarkTokens.accentDisabled
                : IndustrialDarkTokens.accentPrimary,
            width: IndustrialDarkTokens.borderWidth, // 2px outline
          ),
        );

      case ViaButtonVariant.ghost:
        return BoxDecoration(
          color: _isPressed && !isDisabled
              ? IndustrialDarkTokens.accentPrimary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
        );

      case ViaButtonVariant.danger:
        return BoxDecoration(
          color: isDisabled
              ? IndustrialDarkTokens.error.withValues(alpha: 0.3)
              : IndustrialDarkTokens.error,
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
          // No shadow in Industrial Dark
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
            ? IndustrialDarkTokens.accentDisabled
            : IndustrialDarkTokens.accentPrimary;

      case ViaButtonVariant.ghost:
        return isDisabled
            ? IndustrialDarkTokens.textDisabled
            : IndustrialDarkTokens.accentPrimary;

      case ViaButtonVariant.danger:
        return Colors.white;
    }
  }
}
