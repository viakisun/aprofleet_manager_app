import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

/// Industrial Dark Card Component
///
/// Container cards with multiple variants:
/// - Outline: Bordered card with transparent background
/// - Glass: Glassmorphism effect with blur
/// - Elevated: Card with outline borders (NO shadows)
/// - Filled: Solid background card
///
/// Features:
/// - Optional header, body, footer sections
/// - Tap interaction with scale animation
/// - Customizable padding and border radius
/// - Outline-based depth (no elevation/shadows)

enum ViaCardVariant {
  outline, // Border only
  glass, // Glassmorphism with blur
  elevated, // Outline borders (NO shadows in Industrial Dark)
  filled, // Solid background
}

class ViaCard extends StatefulWidget {
  final Widget? child;
  final ViaCardVariant variant;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? elevation;
  final bool enableAnimation;

  const ViaCard({
    super.key,
    this.child,
    this.variant = ViaCardVariant.outline,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.enableAnimation = true,
  });

  /// Outline card - Border only
  const ViaCard.outline({
    super.key,
    this.child,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.borderColor,
    this.enableAnimation = true,
  })  : variant = ViaCardVariant.outline,
        backgroundColor = null,
        elevation = null;

  /// Glass card - Glassmorphism
  const ViaCard.glass({
    super.key,
    this.child,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.enableAnimation = true,
  })  : variant = ViaCardVariant.glass,
        elevation = null;

  /// Elevated card - With shadow
  const ViaCard.elevated({
    super.key,
    this.child,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.elevation,
    this.enableAnimation = true,
  })  : variant = ViaCardVariant.elevated,
        borderColor = null;

  /// Filled card - Solid background
  const ViaCard.filled({
    super.key,
    this.child,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.enableAnimation = true,
  })  : variant = ViaCardVariant.filled,
        borderColor = null,
        elevation = null;

  @override
  State<ViaCard> createState() => _ViaCardState();
}

class _ViaCardState extends State<ViaCard> with SingleTickerProviderStateMixin {
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
      end: 0.98,
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
    if (widget.onTap != null && widget.enableAnimation) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enableAnimation) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.enableAnimation) {
      _controller.reverse();
    }
  }

  void _handleTap() {
    widget.onTap?.call();
  }

  BoxDecoration _getDecoration() {
    final borderRadius = widget.borderRadius ?? IndustrialDarkTokens.radiusCard;

    switch (widget.variant) {
      case ViaCardVariant.outline:
        return BoxDecoration(
          color: widget.backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: widget.borderColor ?? IndustrialDarkTokens.outline,
            width: IndustrialDarkTokens.borderWidth,
          ),
        );

      case ViaCardVariant.glass:
        return BoxDecoration(
          color: widget.backgroundColor ??
              IndustrialDarkTokens.bgSurface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: widget.borderColor ?? IndustrialDarkTokens.outline,
            width: IndustrialDarkTokens.borderWidth,
          ),
        );

      case ViaCardVariant.elevated:
        // Industrial Dark: NO shadows, use outline borders instead
        return BoxDecoration(
          color: widget.backgroundColor ?? IndustrialDarkTokens.bgSurface,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: widget.borderColor ?? IndustrialDarkTokens.outlineEmphasis,
            width: IndustrialDarkTokens.borderWidth,
          ),
          // NO boxShadow in Industrial Dark
        );

      case ViaCardVariant.filled:
        return BoxDecoration(
          color: widget.backgroundColor ?? IndustrialDarkTokens.bgSurface,
          borderRadius: BorderRadius.circular(borderRadius),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      padding: widget.padding ??
          const EdgeInsets.all(IndustrialDarkTokens.spacingCard),
      decoration: _getDecoration(),
      child: widget.child,
    );

    // Apply glass blur effect for glass variant
    if (widget.variant == ViaCardVariant.glass) {
      cardContent = ClipRRect(
        borderRadius: BorderRadius.circular(
            widget.borderRadius ?? IndustrialDarkTokens.radiusCard),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: cardContent,
        ),
      );
    }

    // Wrap with gesture detector if onTap is provided
    if (widget.onTap != null) {
      cardContent = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _handleTap,
        child: cardContent,
      );
    }

    // Apply scale animation
    if (widget.enableAnimation && widget.onTap != null) {
      return ScaleTransition(
        scale: _scaleAnimation,
        child: cardContent,
      );
    }

    return cardContent;
  }
}

/// VIA Card with Header, Body, Footer sections
class ViaCardSectioned extends StatelessWidget {
  final Widget? header;
  final Widget? body;
  final Widget? footer;
  final ViaCardVariant variant;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? elevation;
  final bool enableAnimation;
  final bool showDividers;

  const ViaCardSectioned({
    super.key,
    this.header,
    this.body,
    this.footer,
    this.variant = ViaCardVariant.outline,
    this.onTap,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.enableAnimation = true,
    this.showDividers = true,
  });

  @override
  Widget build(BuildContext context) {
    return ViaCard(
      variant: variant,
      onTap: onTap,
      padding: EdgeInsets.zero,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      elevation: elevation,
      enableAnimation: enableAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          if (header != null) ...[
            Padding(
              padding: padding ??
                  const EdgeInsets.all(IndustrialDarkTokens.spacingCard),
              child: header!,
            ),
            if (showDividers && (body != null || footer != null))
              const Divider(
                height: 1,
                thickness: 1,
                color: IndustrialDarkTokens.outline,
              ),
          ],

          // Body
          if (body != null) ...[
            Padding(
              padding: padding ??
                  const EdgeInsets.all(IndustrialDarkTokens.spacingCard),
              child: body!,
            ),
            if (showDividers && footer != null)
              const Divider(
                height: 1,
                thickness: 1,
                color: IndustrialDarkTokens.outline,
              ),
          ],

          // Footer
          if (footer != null)
            Padding(
              padding: padding ??
                  const EdgeInsets.all(IndustrialDarkTokens.spacingCard),
              child: footer!,
            ),
        ],
      ),
    );
  }
}

/// VIA Card with Golf Cart specific layout
class ViaCartCard extends StatelessWidget {
  final String cartId;
  final String? cartName;
  final ViaCardVariant variant;
  final Widget? statusBadge;
  final Widget? content;
  final List<Widget>? actions;
  final VoidCallback? onTap;

  const ViaCartCard({
    super.key,
    required this.cartId,
    this.cartName,
    this.variant = ViaCardVariant.outline,
    this.statusBadge,
    this.content,
    this.actions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ViaCardSectioned(
      variant: variant,
      onTap: onTap,
      showDividers: true,
      header: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartName ?? 'Cart $cartId',
                  style: IndustrialDarkTokens.displayStyle.copyWith(
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: IndustrialDarkTokens.spacingMinimal),
                Text(
                  'ID: $cartId',
                  style: IndustrialDarkTokens.bodyStyle.copyWith(
                    fontSize: 14.0,
                    color: IndustrialDarkTokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (statusBadge != null) statusBadge!,
        ],
      ),
      body: content,
      footer: actions != null && actions!.isNotEmpty
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!,
            )
          : null,
    );
  }
}
