import 'package:flutter/material.dart';
import '../../../theme/design_tokens.dart';

/// A reusable secondary button widget with outline styling
class SecondaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final ButtonSize size;
  final bool isFullWidth;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.size = ButtonSize.medium,
    this.isFullWidth = false,
  });

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SizedBox(
            width: widget.isFullWidth ? double.infinity : null,
            child: OutlinedButton(
              onPressed: widget.isLoading
                  ? null
                  : () {
                      _animationController.forward().then((_) {
                        _animationController.reverse();
                      });
                      widget.onPressed?.call();
                    },
              style: OutlinedButton.styleFrom(
                foregroundColor: DesignTokens.textPrimary,
                side: BorderSide(color: DesignTokens.borderSecondary),
                elevation: DesignTokens.elevationNone,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      DesignTokens.radiusMd), // Sharper corners
                ),
                padding: _getPadding(),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      width: _getIconSize(),
                      height: _getIconSize(),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          DesignTokens.textPrimary,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, size: _getIconSize()),
                          const SizedBox(width: DesignTokens.spacingSm),
                        ],
                        Text(
                          widget.text.toUpperCase(),
                          style: TextStyle(
                            fontSize: _getFontSize(),
                            fontWeight:
                                DesignTokens.fontWeightBold, // Bolder text
                            letterSpacing: DesignTokens
                                .letterSpacingNormal, // Tighter tracking
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingSm, // Tighter padding
          vertical: DesignTokens.spacingXs,
        );
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingMd, // Tighter padding
          vertical: DesignTokens.spacingSm,
        );
      case ButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingLg, // Tighter padding
          vertical: DesignTokens.spacingMd,
        );
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return DesignTokens.iconXs;
      case ButtonSize.medium:
        return DesignTokens.iconSm;
      case ButtonSize.large:
        return DesignTokens.iconMd;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return DesignTokens.fontSizeSm;
      case ButtonSize.medium:
        return DesignTokens.fontSizeMd;
      case ButtonSize.large:
        return DesignTokens.fontSizeLg;
    }
  }
}

enum ButtonSize {
  small,
  medium,
  large,
}
