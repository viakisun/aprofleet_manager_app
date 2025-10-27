import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

class TelemetryGauge extends StatelessWidget {
  final String label;
  final double value;
  final double maxValue;
  final String unit;
  final Color color;
  final bool showNeedle;
  final double size;

  const TelemetryGauge({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.unit,
    required this.color,
    this.showNeedle = true,
    this.size = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (value / maxValue).clamp(0.0, 1.0);

    return Container(
      width: size,
      height: size,
      decoration: IndustrialDarkTokens.getCardDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Label
          Text(
            label.toUpperCase(),
            style: IndustrialDarkTokens.getUppercaseLabelStyle(
              fontSize: IndustrialDarkTokens.fontSizeSmall,
              color: IndustrialDarkTokens.textSecondary,
            ),
          ),

          const SizedBox(height: IndustrialDarkTokens.spacingCompact),

          // Gauge
          Expanded(
            child: CustomPaint(
              size: Size(size * 0.7, size * 0.35),
              painter: GaugePainter(
                percentage: percentage,
                color: color,
                showNeedle: showNeedle,
              ),
            ),
          ),

          // Value
          Text(
            '${value.toStringAsFixed(1)}$unit',
            style: TextStyle(
              fontSize: IndustrialDarkTokens.fontSizeBody,
              fontWeight: IndustrialDarkTokens.fontWeightBold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class BatteryGauge extends StatelessWidget {
  final double batteryLevel;
  final double size;

  const BatteryGauge({
    super.key,
    required this.batteryLevel,
    this.size = 140.0,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = batteryLevel.clamp(0.0, 100.0) / 100.0;
    Color gaugeColor;

    if (percentage > 0.5) {
      gaugeColor = IndustrialDarkTokens.statusActive;
    } else if (percentage > 0.2) {
      gaugeColor = IndustrialDarkTokens.statusIdle;
    } else {
      gaugeColor = IndustrialDarkTokens.statusMaintenance;
    }

    return Container(
      width: size,
      height: size,
      decoration: IndustrialDarkTokens.getCardDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Battery Icon
          Container(
            width: 40,
            height: 20,
            decoration: BoxDecoration(
              color: gaugeColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: IndustrialDarkTokens.textSecondary,
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                // Battery Fill
                Positioned(
                  left: 2,
                  top: 2,
                  bottom: 2,
                  child: Container(
                    width: (36 * percentage).clamp(0.0, 36.0),
                    decoration: BoxDecoration(
                      color: gaugeColor.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Battery Terminal
                Positioned(
                  right: -4,
                  top: 6,
                  bottom: 6,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: IndustrialDarkTokens.textSecondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: IndustrialDarkTokens.spacingItem),

          // Percentage
          Text(
            '${batteryLevel.toInt()}%',
            style: TextStyle(
              fontSize: IndustrialDarkTokens.fontSizeDisplay,
              fontWeight: IndustrialDarkTokens.fontWeightBold,
              color: gaugeColor,
            ),
          ),

          const SizedBox(height: IndustrialDarkTokens.spacingMinimal),

          Text(
            'BATTERY',
            style: IndustrialDarkTokens.getUppercaseLabelStyle(
              fontSize: IndustrialDarkTokens.fontSizeSmall,
              color: IndustrialDarkTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class SpeedMeter extends StatelessWidget {
  final double speed;
  final double maxSpeed;
  final double size;

  const SpeedMeter({
    super.key,
    required this.speed,
    required this.maxSpeed,
    this.size = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (speed / maxSpeed).clamp(0.0, 1.0);

    return Container(
      width: size,
      height: size,
      decoration: IndustrialDarkTokens.getCardDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Label
          Text(
            'SPEED',
            style: IndustrialDarkTokens.getUppercaseLabelStyle(
              fontSize: IndustrialDarkTokens.fontSizeSmall,
              color: IndustrialDarkTokens.textSecondary,
            ),
          ),

          const SizedBox(height: IndustrialDarkTokens.spacingCompact),

          // Speed Gauge
          Expanded(
            child: CustomPaint(
              size: Size(size * 0.7, size * 0.35),
              painter: SpeedMeterPainter(
                percentage: percentage,
                speed: speed,
                maxSpeed: maxSpeed,
              ),
            ),
          ),

          // Value
          Text(
            '${speed.toInt()} km/h',
            style: const TextStyle(
              fontSize: IndustrialDarkTokens.fontSizeBody,
              fontWeight: IndustrialDarkTokens.fontWeightBold,
              color: IndustrialDarkTokens.statusIdle,
            ),
          ),
        ],
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double percentage;
  final Color color;
  final bool showNeedle;

  GaugePainter({
    required this.percentage,
    required this.color,
    required this.showNeedle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    // Background arc
    final backgroundPaint = Paint()
      ..color = IndustrialDarkTokens.outline
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 4),
      math.pi, // Start from left (180 degrees)
      math.pi, // 180 degrees arc
      false,
      backgroundPaint,
    );

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 4),
      math.pi, // Start from left (180 degrees)
      math.pi * percentage, // Progress arc
      false,
      progressPaint,
    );

    // Needle
    if (showNeedle) {
      final needleAngle = math.pi + (math.pi * percentage);
      final needleLength = radius - 20;

      final needlePaint = Paint()
        ..color = color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final needleEnd = Offset(
        center.dx + needleLength * math.cos(needleAngle),
        center.dy + needleLength * math.sin(needleAngle),
      );

      canvas.drawLine(center, needleEnd, needlePaint);

      // Needle center dot
      final dotPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SpeedMeterPainter extends CustomPainter {
  final double percentage;
  final double speed;
  final double maxSpeed;

  SpeedMeterPainter({
    required this.percentage,
    required this.speed,
    required this.maxSpeed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    // Background arc
    final backgroundPaint = Paint()
      ..color = IndustrialDarkTokens.outline
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 3),
      math.pi,
      math.pi,
      false,
      backgroundPaint,
    );

    // Speed zones
    final zonePaint = Paint()
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Green zone (0-60%)
    zonePaint.color = IndustrialDarkTokens.statusActive;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 3),
      math.pi,
      math.pi * 0.6,
      false,
      zonePaint,
    );

    // Orange zone (60-80%)
    zonePaint.color = IndustrialDarkTokens.statusIdle;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 3),
      math.pi + (math.pi * 0.6),
      math.pi * 0.2,
      false,
      zonePaint,
    );

    // Red zone (80-100%)
    zonePaint.color = IndustrialDarkTokens.statusMaintenance;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 3),
      math.pi + (math.pi * 0.8),
      math.pi * 0.2,
      false,
      zonePaint,
    );

    // Speed markers
    final markerPaint = Paint()
      ..color = IndustrialDarkTokens.textSecondary
      ..strokeWidth = 2;

    for (int i = 0; i <= 5; i++) {
      final angle = math.pi + (math.pi * i / 5);
      final startRadius = radius - 15;
      final endRadius = radius - 5;

      final startPoint = Offset(
        center.dx + startRadius * math.cos(angle),
        center.dy + startRadius * math.sin(angle),
      );

      final endPoint = Offset(
        center.dx + endRadius * math.cos(angle),
        center.dy + endRadius * math.sin(angle),
      );

      canvas.drawLine(startPoint, endPoint, markerPaint);
    }

    // Speed labels
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i <= 5; i++) {
      final angle = math.pi + (math.pi * i / 5);
      final labelRadius = radius - 25;
      final speedValue = (maxSpeed * i / 5).toInt();

      textPainter.text = TextSpan(
        text: speedValue.toString(),
        style: TextStyle(
          color: IndustrialDarkTokens.textSecondary,
          fontSize: 10,
          fontWeight: IndustrialDarkTokens.fontWeightMedium,
        ),
      );

      textPainter.layout();

      final labelPoint = Offset(
        center.dx + labelRadius * math.cos(angle) - textPainter.width / 2,
        center.dy + labelRadius * math.sin(angle) - textPainter.height / 2,
      );

      textPainter.paint(canvas, labelPoint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
