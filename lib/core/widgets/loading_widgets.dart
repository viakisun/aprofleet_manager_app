import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// Skeleton screen widget for loading states
class SkeletonCard extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const SkeletonCard({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  State<SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: DesignTokens.bgSecondary,
            borderRadius: widget.borderRadius ??
                BorderRadius.circular(DesignTokens.radiusSm),
          ),
          child: CustomPaint(
            painter: ShimmerPainter(
              animationValue: _animation.value,
            ),
          ),
        );
      },
    );
  }
}

/// Shimmer effect painter
class ShimmerPainter extends CustomPainter {
  final double animationValue;

  ShimmerPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          DesignTokens.bgSecondary,
          DesignTokens.bgTertiary,
          DesignTokens.bgSecondary,
        ],
        stops: [
          0.0,
          animationValue,
          1.0,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(ShimmerPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Loading state for cart list
class CartListSkeleton extends StatelessWidget {
  const CartListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: SkeletonCard(
            height: 120,
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          ),
        );
      },
    );
  }
}

/// Loading state for work order list
class WorkOrderListSkeleton extends StatelessWidget {
  const WorkOrderListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          child: Column(
            children: [
              SkeletonCard(
                height: 80,
                borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              ),
              const SizedBox(height: DesignTokens.spacingSm),
              SkeletonCard(
                height: 20,
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Loading state for analytics dashboard
class AnalyticsSkeleton extends StatelessWidget {
  const AnalyticsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      child: Column(
        children: [
          // KPI Cards
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: DesignTokens.spacingMd,
              mainAxisSpacing: DesignTokens.spacingMd,
              childAspectRatio: 1.5,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return SkeletonCard(
                borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              );
            },
          ),
          const SizedBox(height: DesignTokens.spacingLg),
          // Charts
          SkeletonCard(
            height: 200,
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          SkeletonCard(
            height: 200,
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          ),
        ],
      ),
    );
  }
}

/// Empty state widget
class EmptyState extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: DesignTokens.textTertiary,
            ),
            const SizedBox(height: DesignTokens.spacingLg),
            Text(
              title,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeLg,
                fontWeight: DesignTokens.fontWeightSemibold,
                color: DesignTokens.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            Text(
              description,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMd,
                color: DesignTokens.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: DesignTokens.spacingLg),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.textPrimary,
                  foregroundColor: DesignTokens.bgPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  ),
                ),
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading overlay widget
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? loadingText;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: DesignTokens.bgPrimary.withOpacity(0.8),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      DesignTokens.textPrimary,
                    ),
                  ),
                  if (loadingText != null) ...[
                    const SizedBox(height: DesignTokens.spacingMd),
                    Text(
                      loadingText!,
                      style: TextStyle(
                        color: DesignTokens.textPrimary,
                        fontSize: DesignTokens.fontSizeMd,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
