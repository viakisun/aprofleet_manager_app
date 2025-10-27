import 'package:flutter/material.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

/// VIA Design System Modal Component
///
/// Centered modal dialog with:
/// - Backdrop overlay
/// - Fade + scale animation
/// - Optional header, body, footer
/// - Close button
/// - Custom actions
///
/// Features:
/// - Smooth animations
/// - Integration with VIA design tokens
/// - Responsive sizing

enum ViaModalSize {
  small,  // 300px width
  medium, // 400px width
  large,  // 500px width
  full,   // 90% screen width
}

class ViaModal extends StatefulWidget {
  final Widget? child;
  final Widget? header;
  final Widget? body;
  final Widget? footer;
  final ViaModalSize size;
  final bool showCloseButton;
  final bool closeOnBackdropTap;
  final VoidCallback? onClose;
  final Color? backgroundColor;
  final Color? backdropColor;

  const ViaModal({
    super.key,
    this.child,
    this.header,
    this.body,
    this.footer,
    this.size = ViaModalSize.medium,
    this.showCloseButton = true,
    this.closeOnBackdropTap = true,
    this.onClose,
    this.backgroundColor,
    this.backdropColor,
  });

  @override
  State<ViaModal> createState() => _ViaModalState();

  /// Show VIA modal
  static Future<T?> show<T>({
    required BuildContext context,
    Widget? child,
    Widget? header,
    Widget? body,
    Widget? footer,
    ViaModalSize size = ViaModalSize.medium,
    bool showCloseButton = true,
    bool closeOnBackdropTap = true,
    Color? backgroundColor,
    Color? backdropColor,
  }) {
    return showDialog<T>(
      context: context,
      barrierColor: backdropColor ??
          Colors.black.withValues(alpha: 0.7),
      builder: (context) => ViaModal(
        size: size,
        showCloseButton: showCloseButton,
        closeOnBackdropTap: closeOnBackdropTap,
        backgroundColor: backgroundColor,
        header: header,
        body: body,
        footer: footer,
        onClose: () => Navigator.of(context).pop(),
        child: child,
      ),
    );
  }

  /// Show confirmation dialog
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDangerous = false,
  }) {
    return show<bool>(
      context: context,
      size: ViaModalSize.small,
      header: Row(
        children: [
          if (isDangerous)
            Icon(
              Icons.warning_amber_rounded,
              color: IndustrialDarkTokens.critical,
              size: 24,
            ),
          if (isDangerous) const SizedBox(width: IndustrialDarkTokens.spacingCompact),
          Expanded(
            child: Text(
              title,
              style: IndustrialDarkTokens.headingMedium,
            ),
          ),
        ],
      ),
      body: Text(
        message,
        style: IndustrialDarkTokens.bodyStyle,
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              cancelText,
              style: IndustrialDarkTokens.labelStyle.copyWith(
                color: IndustrialDarkTokens.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: IndustrialDarkTokens.spacingCompact),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDangerous
                  ? IndustrialDarkTokens.critical
                  : IndustrialDarkTokens.accentPrimary,
            ),
            child: Text(
              confirmText,
              style: IndustrialDarkTokens.labelStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViaModalState extends State<ViaModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: IndustrialDarkTokens.durationNormal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: IndustrialDarkTokens.curveDeceleration,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: IndustrialDarkTokens.curveDeceleration,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() {
    _controller.reverse().then((_) {
      widget.onClose?.call();
    });
  }

  double _getModalWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    switch (widget.size) {
      case ViaModalSize.small:
        return 300.0;
      case ViaModalSize.medium:
        return 400.0;
      case ViaModalSize.large:
        return 500.0;
      case ViaModalSize.full:
        return screenWidth * 0.9;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.closeOnBackdropTap ? _close : null,
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent backdrop tap when tapping modal
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: _getModalWidth(context),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                decoration: BoxDecoration(
                  color: widget.backgroundColor ??
                      IndustrialDarkTokens.bgSurface,
                  borderRadius:
                      BorderRadius.circular(IndustrialDarkTokens.radiusXl),
                  border: Border.all(
                    color: IndustrialDarkTokens.outline,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header with close button
                    if (widget.header != null || widget.showCloseButton)
                      Container(
                        padding:
                            const EdgeInsets.all(IndustrialDarkTokens.spacingCard),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: IndustrialDarkTokens.outline,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            if (widget.header != null)
                              Expanded(child: widget.header!),
                            if (widget.showCloseButton)
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: 24,
                                  color: IndustrialDarkTokens.textSecondary,
                                ),
                                onPressed: _close,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                          ],
                        ),
                      ),

                    // Body (scrollable)
                    if (widget.body != null || widget.child != null)
                      Flexible(
                        child: SingleChildScrollView(
                          padding:
                              const EdgeInsets.all(IndustrialDarkTokens.spacingCard),
                          child: widget.body ?? widget.child,
                        ),
                      ),

                    // Footer
                    if (widget.footer != null)
                      Container(
                        padding:
                            const EdgeInsets.all(IndustrialDarkTokens.spacingCard),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: IndustrialDarkTokens.outline,
                              width: 1,
                            ),
                          ),
                        ),
                        child: widget.footer!,
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

/// VIA Alert Modal - Simple alert with icon and message
class ViaAlertModal extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  const ViaAlertModal({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.info_outline,
    this.iconColor = IndustrialDarkTokens.accentPrimary,
    this.buttonText = 'OK',
    this.onButtonPressed,
  });

  /// Show alert modal
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    IconData icon = Icons.info_outline,
    Color iconColor = IndustrialDarkTokens.accentPrimary,
    String buttonText = 'OK',
  }) {
    return ViaModal.show(
      context: context,
      size: ViaModalSize.small,
      showCloseButton: false,
      body: Column(
        children: [
          Icon(
            icon,
            size: 64,
            color: iconColor,
          ),
          const SizedBox(height: IndustrialDarkTokens.spacingCard),
          Text(
            title,
            style: IndustrialDarkTokens.headingMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: IndustrialDarkTokens.spacingCompact),
          Text(
            message,
            style: IndustrialDarkTokens.bodyStyle.copyWith(
              color: IndustrialDarkTokens.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      footer: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: iconColor,
            minimumSize: const Size(120, 40),
          ),
          child: Text(
            buttonText,
            style: IndustrialDarkTokens.labelStyle.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Not used directly
  }
}
