import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';

class MiniSparkline extends StatelessWidget {
  final List<double> dataPoints;
  final Color? color;
  final double height;
  final double width;
  final bool showPoints;
  final bool showFill;

  const MiniSparkline({
    super.key,
    required this.dataPoints,
    this.color,
    this.height = 20,
    this.width = 60,
    this.showPoints = false,
    this.showFill = true,
  });

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) {
      return SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Text(
            'No Data',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeXs,
              color: DesignTokens.textTertiary,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: MiniSparklinePainter(
          dataPoints: dataPoints,
          color: color ?? DesignTokens.statusActive,
          showPoints: showPoints,
          showFill: showFill,
        ),
      ),
    );
  }
}

class MiniSparklinePainter extends CustomPainter {
  final List<double> dataPoints;
  final Color color;
  final bool showPoints;
  final bool showFill;

  MiniSparklinePainter({
    required this.dataPoints,
    required this.color,
    this.showPoints = false,
    this.showFill = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.length < 2) return;

    // Find min and max values
    final minValue = dataPoints.reduce((a, b) => a < b ? a : b);
    final maxValue = dataPoints.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;

    if (range == 0) {
      // Draw horizontal line if all values are the same
      final y = size.height / 2;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        Paint()
          ..color = color
          ..strokeWidth = 1.5,
      );
      return;
    }

    // Calculate points
    final points = <Offset>[];
    for (int i = 0; i < dataPoints.length; i++) {
      final x = (i / (dataPoints.length - 1)) * size.width;
      final normalizedValue = (dataPoints[i] - minValue) / range;
      final y = size.height - (normalizedValue * size.height);
      points.add(Offset(x, y));
    }

    // Draw fill area
    if (showFill && points.length > 1) {
      final fillPaint = Paint()
        ..color = color.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill;

      final fillPath = Path();
      fillPath.moveTo(points.first.dx, size.height);
      for (final point in points) {
        fillPath.lineTo(point.dx, point.dy);
      }
      fillPath.lineTo(points.last.dx, size.height);
      fillPath.close();
      canvas.drawPath(fillPath, fillPaint);
    }

    // Draw line
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (points.length > 1) {
      final linePath = Path();
      linePath.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        linePath.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(linePath, linePaint);
    }

    // Draw points
    if (showPoints) {
      final pointPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      for (final point in points) {
        canvas.drawCircle(point, 1.5, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is MiniSparklinePainter &&
        (oldDelegate.dataPoints != dataPoints ||
            oldDelegate.color != color ||
            oldDelegate.showPoints != showPoints ||
            oldDelegate.showFill != showFill);
  }
}

class AnimatedMiniSparkline extends StatefulWidget {
  final List<double> dataPoints;
  final Color? color;
  final double height;
  final double width;
  final bool showPoints;
  final bool showFill;
  final Duration animationDuration;

  const AnimatedMiniSparkline({
    super.key,
    required this.dataPoints,
    this.color,
    this.height = 20,
    this.width = 60,
    this.showPoints = false,
    this.showFill = true,
    this.animationDuration = const Duration(milliseconds: 1000),
  });

  @override
  State<AnimatedMiniSparkline> createState() => _AnimatedMiniSparklineState();
}

class _AnimatedMiniSparklineState extends State<AnimatedMiniSparkline>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
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
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: CustomPaint(
            painter: AnimatedMiniSparklinePainter(
              dataPoints: widget.dataPoints,
              color: widget.color ?? DesignTokens.statusActive,
              showPoints: widget.showPoints,
              showFill: widget.showFill,
              animationProgress: _animation.value,
            ),
          ),
        );
      },
    );
  }
}

class AnimatedMiniSparklinePainter extends CustomPainter {
  final List<double> dataPoints;
  final Color color;
  final bool showPoints;
  final bool showFill;
  final double animationProgress;

  AnimatedMiniSparklinePainter({
    required this.dataPoints,
    required this.color,
    this.showPoints = false,
    this.showFill = true,
    required this.animationProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.length < 2) return;

    // Find min and max values
    final minValue = dataPoints.reduce((a, b) => a < b ? a : b);
    final maxValue = dataPoints.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;

    if (range == 0) {
      final y = size.height / 2;
      final animatedWidth = size.width * animationProgress;
      canvas.drawLine(
        Offset(0, y),
        Offset(animatedWidth, y),
        Paint()
          ..color = color
          ..strokeWidth = 1.5,
      );
      return;
    }

    // Calculate points
    final points = <Offset>[];
    for (int i = 0; i < dataPoints.length; i++) {
      final x = (i / (dataPoints.length - 1)) * size.width;
      final normalizedValue = (dataPoints[i] - minValue) / range;
      final y = size.height - (normalizedValue * size.height);
      points.add(Offset(x, y));
    }

    // Calculate how many points to draw based on animation progress
    final visiblePointsCount = (points.length * animationProgress).ceil();
    final visiblePoints = points.take(visiblePointsCount).toList();

    if (visiblePoints.isEmpty) return;

    // Draw fill area
    if (showFill && visiblePoints.length > 1) {
      final fillPaint = Paint()
        ..color = color.withValues(alpha: 0.2 * animationProgress)
        ..style = PaintingStyle.fill;

      final fillPath = Path();
      fillPath.moveTo(visiblePoints.first.dx, size.height);
      for (final point in visiblePoints) {
        fillPath.lineTo(point.dx, point.dy);
      }
      fillPath.lineTo(visiblePoints.last.dx, size.height);
      fillPath.close();
      canvas.drawPath(fillPath, fillPaint);
    }

    // Draw line
    final linePaint = Paint()
      ..color = color.withValues(alpha: animationProgress)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (visiblePoints.length > 1) {
      final linePath = Path();
      linePath.moveTo(visiblePoints.first.dx, visiblePoints.first.dy);
      for (int i = 1; i < visiblePoints.length; i++) {
        linePath.lineTo(visiblePoints[i].dx, visiblePoints[i].dy);
      }
      canvas.drawPath(linePath, linePaint);
    }

    // Draw points
    if (showPoints) {
      final pointPaint = Paint()
        ..color = color.withValues(alpha: animationProgress)
        ..style = PaintingStyle.fill;

      for (final point in visiblePoints) {
        canvas.drawCircle(point, 1.5, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is AnimatedMiniSparklinePainter &&
        (oldDelegate.dataPoints != dataPoints ||
            oldDelegate.color != color ||
            oldDelegate.showPoints != showPoints ||
            oldDelegate.showFill != showFill ||
            oldDelegate.animationProgress != animationProgress);
  }
}
