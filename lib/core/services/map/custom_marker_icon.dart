import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../theme/design_tokens.dart';

/// Utility class for creating custom marker icons for Google Maps
class CustomMarkerIcon {
  static final Map<String, BitmapDescriptor> _iconCache = {};

  /// Prebuild and cache marker icons for given colors and sizes.
  /// Call once (e.g., when map is created) to avoid runtime icon generation spikes.
  static Future<void> initializeIconCache({
    required List<Color> colors,
    List<double> sizes = const [1.0],
    bool includeSelected = true,
  }) async {
    final tasks = <Future<void>>[];
    for (final color in colors) {
      for (final size in sizes) {
        // Normal marker
        final normalKey = 'marker_${color.value}_normal_$size';
        if (!_iconCache.containsKey(normalKey)) {
          tasks.add(buildMarkerIcon(
            color: color,
            selected: false,
            scale: size,
          ).then((icon) => _iconCache[normalKey] = icon));
        }

        // Selected marker
        if (includeSelected) {
          final selectedKey = 'marker_${color.value}_selected_$size';
          if (!_iconCache.containsKey(selectedKey)) {
            tasks.add(buildMarkerIcon(
              color: color,
              selected: true,
              scale: size,
            ).then((icon) => _iconCache[selectedKey] = icon));
          }
        }
      }
    }
    await Future.wait(tasks);
  }

  /// Get a cached status icon if available. Returns null if not cached.
  static BitmapDescriptor? getCachedStatusIcon({
    required Color statusColor,
    double size = 40.0,
    bool showDirection = true,
  }) {
    final key =
        _cacheKey(color: statusColor, size: size, showDirection: showDirection);
    return _iconCache[key];
  }

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

  /// Get a cached marker icon if available. Returns null if not cached.
  static BitmapDescriptor? getCachedMarkerIcon({
    required Color color,
    bool selected = false,
    double scale = 1.0,
  }) {
    final key =
        'marker_${color.value}_${selected ? 'selected' : 'normal'}_$scale';
    return _iconCache[key];
  }

  static String _cacheKey(
      {required Color color,
      required double size,
      required bool showDirection}) {
    return 'status_cart_${color.value}_${size}_$showDirection';
  }

  /// Create a new marker icon with dot + ring design
  static Future<BitmapDescriptor> buildMarkerIcon({
    required Color color,
    bool selected = false,
    double scale = 1.0,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Platform-specific sizing - 웹은 작게, 모바일은 명확하게
    const baseSize = kIsWeb ? 24.0 : 64.0; // 모바일 크기 유지 (사용자 선호)
    final size = baseSize * scale;
    final center = Offset(size / 2, size / 2);

    // Halo (selected only)
    if (selected) {
      final haloPaint = Paint()
        ..color = color.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(center, size * 0.5, haloPaint);
    }

    // Outer white ring (3-tier design for clarity)
    final outerRing = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 // 굵게
      ..color = Colors.white;
    canvas.drawCircle(center, size * 0.38, outerRing);

    // Status colored ring (middle layer)
    final statusRing = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = color;
    canvas.drawCircle(center, size * 0.32, statusRing);

    // Inner dot (core)
    final dot = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawCircle(center, size * 0.22, dot);

    final img =
        await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final bytes = (await img.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }

  /// Create a custom marker icon with status color
  static Future<BitmapDescriptor> createStatusCartMarkerIcon({
    required Color statusColor,
    double size = 40.0,
    bool showDirection = true,
  }) async {
    final cached = getCachedStatusIcon(
      statusColor: statusColor,
      size: size,
      showDirection: showDirection,
    );
    if (cached != null) return cached;
    final icon = await createCartMarkerIcon(
      backgroundColor: statusColor,
      iconColor: Colors.white,
      size: size,
      showDirection: showDirection,
      cacheKey: _cacheKey(
          color: statusColor, size: size, showDirection: showDirection),
    );
    _iconCache[_cacheKey(
        color: statusColor, size: size, showDirection: showDirection)] = icon;
    return icon;
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
