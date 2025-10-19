import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';

/// Custom cart icon with directional arrow for APRO FLEET
class CartIcon extends StatelessWidget {
  final double size;
  final Color? color;
  final bool showDirection;

  const CartIcon({
    super.key,
    this.size = 60,
    this.color,
    this.showDirection = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: CartIconPainter(
        color: color ?? DesignTokens.statusActive,
        showDirection: showDirection,
      ),
    );
  }
}

/// Custom painter for the cart icon
class CartIconPainter extends CustomPainter {
  final Color color;
  final bool showDirection;

  CartIconPainter({
    required this.color,
    this.showDirection = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    // Draw main circle (cart body)
    canvas.drawCircle(center, radius, paint);

    // Draw cart wheels (two smaller circles)
    final wheelRadius = radius * 0.2;
    final wheelY = center.dy + radius * 0.6;
    
    // Left wheel
    canvas.drawCircle(
      Offset(center.dx - radius * 0.4, wheelY),
      wheelRadius,
      strokePaint,
    );
    
    // Right wheel
    canvas.drawCircle(
      Offset(center.dx + radius * 0.4, wheelY),
      wheelRadius,
      strokePaint,
    );

    // Draw directional arrow if enabled
    if (showDirection) {
      _drawDirectionalArrow(canvas, center, radius);
    }
  }

  void _drawDirectionalArrow(Canvas canvas, Offset center, double radius) {
    final arrowPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Arrow parameters
    final arrowLength = radius * 0.8;
    final arrowWidth = radius * 0.15;
    final arrowHeadSize = radius * 0.25;

    // Arrow direction (pointing right)
    final startPoint = Offset(center.dx - arrowLength / 2, center.dy);
    final endPoint = Offset(center.dx + arrowLength / 2, center.dy);

    // Create arrow path
    final arrowPath = Path();
    
    // Arrow shaft
    arrowPath.moveTo(startPoint.dx, startPoint.dy - arrowWidth / 2);
    arrowPath.lineTo(endPoint.dx - arrowHeadSize, startPoint.dy - arrowWidth / 2);
    arrowPath.lineTo(endPoint.dx - arrowHeadSize, startPoint.dy - arrowWidth);
    arrowPath.lineTo(endPoint.dx, startPoint.dy);
    arrowPath.lineTo(endPoint.dx - arrowHeadSize, startPoint.dy + arrowWidth);
    arrowPath.lineTo(endPoint.dx - arrowHeadSize, startPoint.dy + arrowWidth / 2);
    arrowPath.lineTo(startPoint.dx, startPoint.dy + arrowWidth / 2);
    arrowPath.close();

    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Animated cart icon with pulsing effect
class AnimatedCartIcon extends StatefulWidget {
  final double size;
  final Color? color;
  final bool showDirection;
  final Duration animationDuration;

  const AnimatedCartIcon({
    super.key,
    this.size = 60,
    this.color,
    this.showDirection = true,
    this.animationDuration = const Duration(seconds: 2),
  });

  @override
  State<AnimatedCartIcon> createState() => _AnimatedCartIconState();
}

class _AnimatedCartIconState extends State<AnimatedCartIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: CartIcon(
            size: widget.size,
            color: widget.color,
            showDirection: widget.showDirection,
          ),
        );
      },
    );
  }
}
