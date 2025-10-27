import 'package:flutter/material.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

/// Industrial Dark Loading Indicator Component
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
/// - Integration with Industrial Dark tokens

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
          const SizedBox(height: IndustrialDarkTokens.spacingItem),
          Text(
            message!,
            style: IndustrialDarkTokens.bodyStyle.copyWith(
              fontSize: IndustrialDarkTokens.fontSizeSmall,
              color: IndustrialDarkTokens.textSecondary,
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
          color ?? IndustrialDarkTokens.accentPrimary, // Blue accent
        ),
        backgroundColor:
            IndustrialDarkTokens.bgBase.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildLinearLoader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusChip), // 20px pill
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? IndustrialDarkTokens.accentPrimary, // Blue accent
            ),
            backgroundColor:
                IndustrialDarkTokens.bgBase.withValues(alpha: 0.5),
          ),
        ),
        if (value != null) ...[
          const SizedBox(height: IndustrialDarkTokens.spacingMinimal),
          Text(
            '${(value! * 100).toInt()}%',
            style: IndustrialDarkTokens.labelStyle.copyWith(
              fontSize: IndustrialDarkTokens.fontSizeSmall,
              color: IndustrialDarkTokens.textSecondary,
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
          color: IndustrialDarkTokens.bgBase,
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
        ),
      ),
    );
  }

  Widget _buildDotsLoader() {
    return _AnimatedDotsLoader(
      size: size,
      color: color ?? IndustrialDarkTokens.accentPrimary, // Blue accent
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
                IndustrialDarkTokens.bgBase,
                IndustrialDarkTokens.bgSurface,
                IndustrialDarkTokens.bgBase,
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
              padding: const EdgeInsets.symmetric(
                horizontal: 2, // Minimal spacing between dots
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
          color: IndustrialDarkTokens.bgSurface,
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusCard),
          border: Border.all(
            color: IndustrialDarkTokens.outline,
            width: IndustrialDarkTokens.borderWidth, // 2px
          ),
        ),
        padding: const EdgeInsets.all(IndustrialDarkTokens.spacingCard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: IndustrialDarkTokens.bgBase,
                borderRadius:
                    BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
              ),
            ),
            const SizedBox(height: IndustrialDarkTokens.spacingCompact),
            Container(
              height: 12,
              width: 200,
              decoration: BoxDecoration(
                color: IndustrialDarkTokens.bgBase,
                borderRadius:
                    BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
              ),
            ),
            const Spacer(),
            Container(
              height: 12,
              width: 150,
              decoration: BoxDecoration(
                color: IndustrialDarkTokens.bgBase,
                borderRadius:
                    BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
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
          horizontal: IndustrialDarkTokens.spacingCard,
          vertical: IndustrialDarkTokens.spacingItem,
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: IndustrialDarkTokens.bgBase,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: IndustrialDarkTokens.spacingItem),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: IndustrialDarkTokens.bgBase,
                      borderRadius:
                          BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
                    ),
                  ),
                  const SizedBox(height: IndustrialDarkTokens.spacingCompact),
                  Container(
                    height: 12,
                    width: 200,
                    decoration: BoxDecoration(
                      color: IndustrialDarkTokens.bgBase,
                      borderRadius:
                          BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
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
      color: Colors.black.withValues(alpha: 0.8), // Darker overlay
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(IndustrialDarkTokens.spacingSection),
          decoration: BoxDecoration(
            color: IndustrialDarkTokens.bgSurface,
            borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusCard),
            border: Border.all(
              color: IndustrialDarkTokens.outline,
              width: IndustrialDarkTokens.borderWidth, // 2px
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
