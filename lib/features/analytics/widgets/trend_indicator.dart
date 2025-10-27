import 'package:flutter/material.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

enum TrendDirection {
  up,
  down,
  stable,
}

class TrendIndicator extends StatelessWidget {
  final TrendDirection direction;
  final double value;
  final String? label;
  final bool showPercentage;
  final Color? customColor;

  const TrendIndicator({
    super.key,
    required this.direction,
    required this.value,
    this.label,
    this.showPercentage = true,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = customColor ?? _getTrendColor();
    final icon = _getTrendIcon();
    final formattedValue = showPercentage
        ? '${value.abs().toStringAsFixed(1)}%'
        : value.abs().toStringAsFixed(1);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(IndustrialDarkTokens.spacingMinimal),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
        const SizedBox(width: IndustrialDarkTokens.spacingMinimal),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formattedValue,
              style: TextStyle(
                fontSize: IndustrialDarkTokens.fontSizeSmall,
                fontWeight: IndustrialDarkTokens.fontWeightBold,
                color: color,
              ),
            ),
            if (label != null)
              Text(
                label!,
                style: TextStyle(
                  fontSize: 10,
                  color: IndustrialDarkTokens.textSecondary,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Color _getTrendColor() {
    switch (direction) {
      case TrendDirection.up:
        return IndustrialDarkTokens.alertSuccess;
      case TrendDirection.down:
        return IndustrialDarkTokens.error;
      case TrendDirection.stable:
        return IndustrialDarkTokens.textSecondary;
    }
  }

  IconData _getTrendIcon() {
    switch (direction) {
      case TrendDirection.up:
        return Icons.trending_up;
      case TrendDirection.down:
        return Icons.trending_down;
      case TrendDirection.stable:
        return Icons.trending_flat;
    }
  }
}

class TrendIndicatorCompact extends StatelessWidget {
  final TrendDirection direction;
  final double value;
  final bool showPercentage;

  const TrendIndicatorCompact({
    super.key,
    required this.direction,
    required this.value,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getTrendColor();
    final icon = _getTrendIcon();
    final formattedValue = showPercentage
        ? '${value.abs().toStringAsFixed(0)}%'
        : value.abs().toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: IndustrialDarkTokens.spacingMinimal,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 2),
          Text(
            formattedValue,
            style: TextStyle(
              fontSize: 10,
              fontWeight: IndustrialDarkTokens.fontWeightBold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTrendColor() {
    switch (direction) {
      case TrendDirection.up:
        return IndustrialDarkTokens.alertSuccess;
      case TrendDirection.down:
        return IndustrialDarkTokens.error;
      case TrendDirection.stable:
        return IndustrialDarkTokens.textSecondary;
    }
  }

  IconData _getTrendIcon() {
    switch (direction) {
      case TrendDirection.up:
        return Icons.trending_up;
      case TrendDirection.down:
        return Icons.trending_down;
      case TrendDirection.stable:
        return Icons.trending_flat;
    }
  }
}

class TrendIndicatorWithSparkline extends StatelessWidget {
  final TrendDirection direction;
  final double value;
  final List<double> dataPoints;
  final String? label;
  final bool showPercentage;

  const TrendIndicatorWithSparkline({
    super.key,
    required this.direction,
    required this.value,
    required this.dataPoints,
    this.label,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getTrendColor();
    final icon = _getTrendIcon();
    final formattedValue = showPercentage
        ? '${value.abs().toStringAsFixed(1)}%'
        : value.abs().toStringAsFixed(1);

    return Row(
      children: [
        // Sparkline
        SizedBox(
          width: 40,
          height: 20,
          child: CustomPaint(
            painter: SparklinePainter(
              dataPoints: dataPoints,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: IndustrialDarkTokens.spacingCompact),

        // Trend info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
                const SizedBox(width: IndustrialDarkTokens.spacingMinimal),
                Text(
                  formattedValue,
                  style: TextStyle(
                    fontSize: IndustrialDarkTokens.fontSizeSmall,
                    fontWeight: IndustrialDarkTokens.fontWeightBold,
                    color: color,
                  ),
                ),
              ],
            ),
            if (label != null)
              Text(
                label!,
                style: TextStyle(
                  fontSize: 10,
                  color: IndustrialDarkTokens.textSecondary,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Color _getTrendColor() {
    switch (direction) {
      case TrendDirection.up:
        return IndustrialDarkTokens.alertSuccess;
      case TrendDirection.down:
        return IndustrialDarkTokens.error;
      case TrendDirection.stable:
        return IndustrialDarkTokens.textSecondary;
    }
  }

  IconData _getTrendIcon() {
    switch (direction) {
      case TrendDirection.up:
        return Icons.trending_up;
      case TrendDirection.down:
        return Icons.trending_down;
      case TrendDirection.stable:
        return Icons.trending_flat;
    }
  }
}

class SparklinePainter extends CustomPainter {
  final List<double> dataPoints;
  final Color color;

  SparklinePainter({
    required this.dataPoints,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    // Find min and max values
    final minValue = dataPoints.reduce((a, b) => a < b ? a : b);
    final maxValue = dataPoints.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;

    if (range == 0) return;

    // Calculate points
    final points = <Offset>[];
    for (int i = 0; i < dataPoints.length; i++) {
      final x = (i / (dataPoints.length - 1)) * size.width;
      final normalizedValue = (dataPoints[i] - minValue) / range;
      final y = size.height - (normalizedValue * size.height);
      points.add(Offset(x, y));
    }

    // Draw fill area
    if (points.length > 1) {
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
    if (points.length > 1) {
      final linePath = Path();
      linePath.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        linePath.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(linePath, paint);
    }

    // Draw points
    for (final point in points) {
      canvas.drawCircle(point, 1, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is SparklinePainter &&
        (oldDelegate.dataPoints != dataPoints || oldDelegate.color != color);
  }
}
