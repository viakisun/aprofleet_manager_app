import 'package:flutter/material.dart';
import 'package:aprofleet_manager/core/theme/via_design_tokens.dart';

/// VIA Design System Loading Indicator Component
///
/// Multiple loading indicator variants:
/// - Circular: Spinning circle loader
/// - Linear: Progress bar (determinate/indeterminate)
/// - Skeleton: Placeholder shimmer effect
/// - Dots: Animated bouncing dots
///
/// Features:
/// - Smooth animations
/// - Customizable colors and sizes
/// - Integration with VIA design tokens

enum ViaLoadingIndicatorType {
  circular,
  linear,
  skeleton,
  dots,
}

enum ViaLoadingIndicatorSize {
  small,
  medium,
  large,
}

class ViaLoadingIndicator extends StatelessWidget {
  final ViaLoadingIndicatorType type;
  final ViaLoadingIndicatorSize size;
  final Color? color;
  final double? value; // For determinate progress (0.0 to 1.0)
  final String? message;

  const ViaLoadingIndicator({
    super.key,
    this.type = ViaLoadingIndicatorType.circular,
    this.size = ViaLoadingIndicatorSize.medium,
    this.color,
    this.value,
    this.message,
  });

  /// Circular loading indicator
  const ViaLoadingIndicator.circular({
    super.key,
    this.size = ViaLoadingIndicatorSize.medium,
    this.color,
    this.message,
  })  : type = ViaLoadingIndicatorType.circular,
        value = null;

  /// Linear loading indicator (progress bar)
  const ViaLoadingIndicator.linear({
    super.key,
    this.value,
    this.color,
    this.message,
  })  : type = ViaLoadingIndicatorType.linear,
        size = ViaLoadingIndicatorSize.medium;

  /// Skeleton loading placeholder
  const ViaLoadingIndicator.skeleton({
    super.key,
    this.size = ViaLoadingIndicatorSize.medium,
  })  : type = ViaLoadingIndicatorType.skeleton,
        color = null,
        value = null,
        message = null;

  /// Animated dots loader
  const ViaLoadingIndicator.dots({
    super.key,
    this.size = ViaLoadingIndicatorSize.medium,
    this.color,
    this.message,
  })  : type = ViaLoadingIndicatorType.dots,
        value = null;

  double _getSize() {
    switch (size) {
      case ViaLoadingIndicatorSize.small:
        return 24.0;
      case ViaLoadingIndicatorSize.medium:
        return 40.0;
      case ViaLoadingIndicatorSize.large:
        return 64.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget loader;

    switch (type) {
      case ViaLoadingIndicatorType.circular:
        loader = _buildCircularLoader();
        break;
      case ViaLoadingIndicatorType.linear:
        loader = _buildLinearLoader();
        break;
      case ViaLoadingIndicatorType.skeleton:
        loader = _buildSkeletonLoader();
        break;
      case ViaLoadingIndicatorType.dots:
        loader = _buildDotsLoader();
        break;
    }

    if (message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loader,
          const SizedBox(height: ViaDesignTokens.spacingMd),
          Text(
            message!,
            style: ViaDesignTokens.bodySmall.copyWith(
              color: ViaDesignTokens.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return loader;
  }

  Widget _buildCircularLoader() {
    final indicatorSize = _getSize();
    return SizedBox(
      width: indicatorSize,
      height: indicatorSize,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: size == ViaLoadingIndicatorSize.small ? 2.0 : 3.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? ViaDesignTokens.primary,
        ),
        backgroundColor:
            ViaDesignTokens.surfaceSecondary.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildLinearLoader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusFull),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? ViaDesignTokens.primary,
            ),
            backgroundColor:
                ViaDesignTokens.surfaceSecondary.withValues(alpha: 0.5),
          ),
        ),
        if (value != null) ...[
          const SizedBox(height: ViaDesignTokens.spacingXs),
          Text(
            '${(value! * 100).toInt()}%',
            style: ViaDesignTokens.labelSmall.copyWith(
              color: ViaDesignTokens.textMuted,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ],
    );
  }

  Widget _buildSkeletonLoader() {
    return _SkeletonShimmer(
      child: Container(
        height: _getSize(),
        decoration: BoxDecoration(
          color: ViaDesignTokens.surfaceSecondary,
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusSm),
        ),
      ),
    );
  }

  Widget _buildDotsLoader() {
    return _AnimatedDotsLoader(
      size: size,
      color: color ?? ViaDesignTokens.primary,
    );
  }
}

/// Skeleton shimmer effect
class _SkeletonShimmer extends StatefulWidget {
  final Widget child;

  const _SkeletonShimmer({required this.child});

  @override
  State<_SkeletonShimmer> createState() => _SkeletonShimmerState();
}

class _SkeletonShimmerState extends State<_SkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
              colors: [
                ViaDesignTokens.surfaceSecondary,
                ViaDesignTokens.surfaceTertiary,
                ViaDesignTokens.surfaceSecondary,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Animated bouncing dots loader
class _AnimatedDotsLoader extends StatefulWidget {
  final ViaLoadingIndicatorSize size;
  final Color color;

  const _AnimatedDotsLoader({
    required this.size,
    required this.color,
  });

  @override
  State<_AnimatedDotsLoader> createState() => _AnimatedDotsLoaderState();
}

class _AnimatedDotsLoaderState extends State<_AnimatedDotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getDotSize() {
    switch (widget.size) {
      case ViaLoadingIndicatorSize.small:
        return 6.0;
      case ViaLoadingIndicatorSize.medium:
        return 8.0;
      case ViaLoadingIndicatorSize.large:
        return 12.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = _getDotSize();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final value = (_controller.value - delay) % 1.0;
            final scale = (value < 0.5)
                ? 1.0 + (value * 0.6)
                : 1.3 - ((value - 0.5) * 0.6);

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ViaDesignTokens.spacingXxs,
              ),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/// VIA Skeleton placeholders for common UI elements
class ViaSkeletonCard extends StatelessWidget {
  final double? height;
  final double? width;

  const ViaSkeletonCard({
    super.key,
    this.height = 120,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return _SkeletonShimmer(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: ViaDesignTokens.surfaceSecondary,
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusLg),
          border: Border.all(
            color: ViaDesignTokens.borderPrimary,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(ViaDesignTokens.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ViaDesignTokens.surfaceTertiary,
                borderRadius:
                    BorderRadius.circular(ViaDesignTokens.radiusSm),
              ),
            ),
            const SizedBox(height: ViaDesignTokens.spacingSm),
            Container(
              height: 12,
              width: 200,
              decoration: BoxDecoration(
                color: ViaDesignTokens.surfaceTertiary,
                borderRadius:
                    BorderRadius.circular(ViaDesignTokens.radiusSm),
              ),
            ),
            const Spacer(),
            Container(
              height: 12,
              width: 150,
              decoration: BoxDecoration(
                color: ViaDesignTokens.surfaceTertiary,
                borderRadius:
                    BorderRadius.circular(ViaDesignTokens.radiusSm),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// VIA Skeleton list item
class ViaSkeletonListItem extends StatelessWidget {
  const ViaSkeletonListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return _SkeletonShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ViaDesignTokens.spacingLg,
          vertical: ViaDesignTokens.spacingMd,
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: ViaDesignTokens.surfaceTertiary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: ViaDesignTokens.spacingMd),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ViaDesignTokens.surfaceTertiary,
                      borderRadius:
                          BorderRadius.circular(ViaDesignTokens.radiusSm),
                    ),
                  ),
                  const SizedBox(height: ViaDesignTokens.spacingSm),
                  Container(
                    height: 12,
                    width: 200,
                    decoration: BoxDecoration(
                      color: ViaDesignTokens.surfaceTertiary,
                      borderRadius:
                          BorderRadius.circular(ViaDesignTokens.radiusSm),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full screen loading overlay
class ViaLoadingOverlay extends StatelessWidget {
  final String? message;
  final bool isLoading;

  const ViaLoadingOverlay({
    super.key,
    this.message,
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(ViaDesignTokens.spacing2xl),
          decoration: BoxDecoration(
            color: ViaDesignTokens.surfaceSecondary,
            borderRadius: BorderRadius.circular(ViaDesignTokens.radiusLg),
            border: Border.all(
              color: ViaDesignTokens.borderPrimary,
              width: 1,
            ),
          ),
          child: ViaLoadingIndicator.circular(
            size: ViaLoadingIndicatorSize.large,
            message: message,
          ),
        ),
      ),
    );
  }
}
