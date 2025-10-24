import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aprofleet_manager/core/theme/via_design_tokens.dart';

/// VIA Design System Toast Component
///
/// Slide-in notification toasts with:
/// - 4 variants: success, error, warning, info
/// - Auto-dismiss with countdown
/// - Swipe to dismiss
/// - Custom position (top/bottom)
/// - Icon and action button support
///
/// Features:
/// - Smooth slide + fade animations
/// - Haptic feedback
/// - Queue management for multiple toasts
/// - Integration with VIA design tokens

enum ViaToastVariant {
  success,
  error,
  warning,
  info,
}

enum ViaToastPosition {
  top,
  bottom,
}

class ViaToast {
  final String message;
  final ViaToastVariant variant;
  final ViaToastPosition position;
  final Duration duration;
  final IconData? customIcon;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final VoidCallback? onDismissed;
  final bool enableHaptic;

  const ViaToast({
    required this.message,
    this.variant = ViaToastVariant.info,
    this.position = ViaToastPosition.bottom,
    this.duration = const Duration(seconds: 3),
    this.customIcon,
    this.actionLabel,
    this.onActionPressed,
    this.onDismissed,
    this.enableHaptic = true,
  });

  /// Success toast
  const ViaToast.success({
    required this.message,
    this.position = ViaToastPosition.bottom,
    this.duration = const Duration(seconds: 3),
    this.actionLabel,
    this.onActionPressed,
    this.onDismissed,
    this.enableHaptic = true,
  })  : variant = ViaToastVariant.success,
        customIcon = null;

  /// Error toast
  const ViaToast.error({
    required this.message,
    this.position = ViaToastPosition.bottom,
    this.duration = const Duration(seconds: 4),
    this.actionLabel,
    this.onActionPressed,
    this.onDismissed,
    this.enableHaptic = true,
  })  : variant = ViaToastVariant.error,
        customIcon = null;

  /// Warning toast
  const ViaToast.warning({
    required this.message,
    this.position = ViaToastPosition.bottom,
    this.duration = const Duration(seconds: 3),
    this.actionLabel,
    this.onActionPressed,
    this.onDismissed,
    this.enableHaptic = true,
  })  : variant = ViaToastVariant.warning,
        customIcon = null;

  /// Info toast
  const ViaToast.info({
    required this.message,
    this.position = ViaToastPosition.bottom,
    this.duration = const Duration(seconds: 3),
    this.actionLabel,
    this.onActionPressed,
    this.onDismissed,
    this.enableHaptic = true,
  })  : variant = ViaToastVariant.info,
        customIcon = null;

  /// Show toast notification
  static void show({
    required BuildContext context,
    required String message,
    ViaToastVariant variant = ViaToastVariant.info,
    ViaToastPosition position = ViaToastPosition.bottom,
    Duration duration = const Duration(seconds: 3),
    IconData? customIcon,
    String? actionLabel,
    VoidCallback? onActionPressed,
    VoidCallback? onDismissed,
    bool enableHaptic = true,
  }) {
    final toast = ViaToast(
      message: message,
      variant: variant,
      position: position,
      duration: duration,
      customIcon: customIcon,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      onDismissed: onDismissed,
      enableHaptic: enableHaptic,
    );

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => _ViaToastWidget(
        toast: toast,
        onDismiss: () {
          onDismissed?.call();
        },
      ),
    );

    overlay.insert(overlayEntry);

    // Auto dismiss after duration
    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
        onDismissed?.call();
      }
    });
  }
}

class _ViaToastWidget extends StatefulWidget {
  final ViaToast toast;
  final VoidCallback? onDismiss;

  const _ViaToastWidget({
    required this.toast,
    this.onDismiss,
  });

  @override
  State<_ViaToastWidget> createState() => _ViaToastWidgetState();
}

class _ViaToastWidgetState extends State<_ViaToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  double _dragOffset = 0.0;

  @override
  void initState() {
    super.initState();

    if (widget.toast.enableHaptic) {
      HapticFeedback.lightImpact();
    }

    _controller = AnimationController(
      duration: ViaDesignTokens.durationNormal,
      vsync: this,
    );

    final slideBegin = widget.toast.position == ViaToastPosition.top
        ? const Offset(0, -1)
        : const Offset(0, 1);

    _slideAnimation = Tween<Offset>(
      begin: slideBegin,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: ViaDesignTokens.curveDeceleration,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: ViaDesignTokens.curveDeceleration,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDismiss() {
    _controller.reverse().then((_) {
      widget.onDismiss?.call();
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.primaryDelta ?? 0;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final threshold = 100.0;

    if (widget.toast.position == ViaToastPosition.top) {
      if (_dragOffset < -threshold || velocity < -500) {
        _handleDismiss();
        return;
      }
    } else {
      if (_dragOffset > threshold || velocity > 500) {
        _handleDismiss();
        return;
      }
    }

    // Reset position
    setState(() {
      _dragOffset = 0.0;
    });
  }

  Color _getBackgroundColor() {
    switch (widget.toast.variant) {
      case ViaToastVariant.success:
        return ViaDesignTokens.primary.withValues(alpha: 0.15);
      case ViaToastVariant.error:
        return ViaDesignTokens.critical.withValues(alpha: 0.15);
      case ViaToastVariant.warning:
        return ViaDesignTokens.warning.withValues(alpha: 0.15);
      case ViaToastVariant.info:
        return ViaDesignTokens.secondary.withValues(alpha: 0.15);
    }
  }

  Color _getBorderColor() {
    switch (widget.toast.variant) {
      case ViaToastVariant.success:
        return ViaDesignTokens.primary;
      case ViaToastVariant.error:
        return ViaDesignTokens.critical;
      case ViaToastVariant.warning:
        return ViaDesignTokens.warning;
      case ViaToastVariant.info:
        return ViaDesignTokens.secondary;
    }
  }

  IconData _getIcon() {
    if (widget.toast.customIcon != null) {
      return widget.toast.customIcon!;
    }

    switch (widget.toast.variant) {
      case ViaToastVariant.success:
        return Icons.check_circle_outline;
      case ViaToastVariant.error:
        return Icons.error_outline;
      case ViaToastVariant.warning:
        return Icons.warning_amber_outlined;
      case ViaToastVariant.info:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;

    return Positioned(
      top: widget.toast.position == ViaToastPosition.top
          ? topPadding + ViaDesignTokens.spacingLg
          : null,
      bottom: widget.toast.position == ViaToastPosition.bottom
          ? bottomPadding + ViaDesignTokens.spacingLg
          : null,
      left: ViaDesignTokens.spacingLg,
      right: ViaDesignTokens.spacingLg,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: child,
            ),
          );
        },
        child: Transform.translate(
          offset: Offset(0, _dragOffset),
          child: GestureDetector(
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(ViaDesignTokens.spacingMd),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(),
                  borderRadius:
                      BorderRadius.circular(ViaDesignTokens.radiusMd),
                  border: Border.all(
                    color: _getBorderColor(),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Icon
                    Icon(
                      _getIcon(),
                      size: ViaDesignTokens.iconMd,
                      color: _getBorderColor(),
                    ),
                    const SizedBox(width: ViaDesignTokens.spacingMd),
                    // Message
                    Expanded(
                      child: Text(
                        widget.toast.message,
                        style: ViaDesignTokens.bodyMedium.copyWith(
                          color: ViaDesignTokens.textPrimary,
                        ),
                      ),
                    ),
                    // Action button
                    if (widget.toast.actionLabel != null) ...[
                      const SizedBox(width: ViaDesignTokens.spacingMd),
                      TextButton(
                        onPressed: () {
                          widget.toast.onActionPressed?.call();
                          _handleDismiss();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: ViaDesignTokens.spacingSm,
                            vertical: ViaDesignTokens.spacingXs,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          widget.toast.actionLabel!.toUpperCase(),
                          style: ViaDesignTokens.labelSmall.copyWith(
                            color: _getBorderColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    // Close button
                    const SizedBox(width: ViaDesignTokens.spacingSm),
                    GestureDetector(
                      onTap: _handleDismiss,
                      child: Icon(
                        Icons.close,
                        size: ViaDesignTokens.iconSm,
                        color: ViaDesignTokens.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
