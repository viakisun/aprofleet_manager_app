import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../features/auth/widgets/cart_icon.dart';
import '../../theme/design_tokens.dart';

/// Utility class for creating custom marker icons for Google Maps
class CustomMarkerIcon {
  static final Map<String, BitmapDescriptor> _iconCache = {};

  /// Create a custom cart marker icon
  static Future<BitmapDescriptor> createCartMarkerIcon({
    Color? backgroundColor,
    Color? iconColor,
    double size = 40.0,
    bool showDirection = true,
    String? cacheKey,
  }) async {
    // Use cache key or generate one
    final key = cacheKey ??
        'cart_${backgroundColor?.value}_${iconColor?.value}_${size}_$showDirection';

    if (_iconCache.containsKey(key)) {
      return _iconCache[key]!;
    }

    final icon = await _createMarkerIcon(
      backgroundColor: backgroundColor ?? DesignTokens.statusActive,
      iconColor: iconColor ?? Colors.white,
      size: size,
      showDirection: showDirection,
    );

    _iconCache[key] = icon;
    return icon;
  }

  /// Create a custom marker icon with status color
  static Future<BitmapDescriptor> createStatusCartMarkerIcon({
    required Color statusColor,
    double size = 40.0,
    bool showDirection = true,
  }) async {
    return createCartMarkerIcon(
      backgroundColor: statusColor,
      iconColor: Colors.white,
      size: size,
      showDirection: showDirection,
      cacheKey: 'status_cart_${statusColor.value}_${size}_$showDirection',
    );
  }

  /// Internal method to create marker icon from widget
  static Future<BitmapDescriptor> _createMarkerIcon({
    required Color backgroundColor,
    required Color iconColor,
    required double size,
    required bool showDirection,
  }) async {
    // Create a simple marker using canvas drawing
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw main circle
    paint.color = backgroundColor;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, paint);

    // Draw border
    paint.color = backgroundColor.withValues(alpha: 0.4);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2 - 1, paint);

    // Draw cart icon (simplified version)
    _drawCartIcon(canvas, Offset(size / 2, size / 2), size * 0.6, iconColor,
        showDirection);

    // Draw status dot
    paint.style = PaintingStyle.fill;
    paint.color = iconColor;
    canvas.drawCircle(Offset(size - 6, 6), 4, paint);

    // Convert to image
    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());

    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) {
      throw Exception('Failed to convert marker to bytes');
    }

    return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  }

  /// Draw simplified cart icon on canvas
  static void _drawCartIcon(Canvas canvas, Offset center, double size,
      Color color, bool showDirection) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Cart body circle
    final bodyRadius = size * 0.35;
    canvas.drawCircle(center, bodyRadius, paint);

    // Cart wheels
    final wheelRadius = bodyRadius * 0.2;
    final wheelY = center.dy + bodyRadius * 0.6;

    // Left wheel
    canvas.drawCircle(
      Offset(center.dx - bodyRadius * 0.4, wheelY),
      wheelRadius,
      strokePaint,
    );

    // Right wheel
    canvas.drawCircle(
      Offset(center.dx + bodyRadius * 0.4, wheelY),
      wheelRadius,
      strokePaint,
    );

    // Directional arrow if enabled
    if (showDirection) {
      _drawArrow(canvas, center, bodyRadius * 0.8, color);
    }
  }

  /// Draw directional arrow
  static void _drawArrow(
      Canvas canvas, Offset center, double length, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final arrowWidth = length * 0.15;
    final arrowHeadSize = length * 0.25;

    final path = Path();
    final startPoint = Offset(center.dx - length / 2, center.dy);
    final endPoint = Offset(center.dx + length / 2, center.dy);

    // Arrow path
    path.moveTo(startPoint.dx, startPoint.dy - arrowWidth / 2);
    path.lineTo(endPoint.dx - arrowHeadSize, startPoint.dy - arrowWidth / 2);
    path.lineTo(endPoint.dx - arrowHeadSize, startPoint.dy - arrowWidth);
    path.lineTo(endPoint.dx, startPoint.dy);
    path.lineTo(endPoint.dx - arrowHeadSize, startPoint.dy + arrowWidth);
    path.lineTo(endPoint.dx - arrowHeadSize, startPoint.dy + arrowWidth / 2);
    path.lineTo(startPoint.dx, startPoint.dy + arrowWidth / 2);
    path.close();

    canvas.drawPath(path, paint);
  }
}
