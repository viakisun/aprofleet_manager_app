import 'dart:math';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../domain/models/cart.dart';
import '../../constants/app_constants.dart';
import '../../../theme/app_theme.dart';

class CanvasMapView extends StatefulWidget {
  final List<Cart> carts;
  final Function(Cart) onCartTap;
  final double zoom;
  final Function(double) onZoomChanged;
  final Offset? centerOffset;
  final Function(Offset) onCenterChanged;

  const CanvasMapView({
    super.key,
    required this.carts,
    required this.onCartTap,
    required this.zoom,
    required this.onZoomChanged,
    this.centerOffset,
    required this.onCenterChanged,
  });

  @override
  State<CanvasMapView> createState() => _CanvasMapViewState();
}

class _CanvasMapViewState extends State<CanvasMapView> {
  late Offset _panOffset;
  Offset? _lastPanPosition;

  @override
  void initState() {
    super.initState();
    _panOffset = widget.centerOffset ?? Offset.zero;
  }

  @override
  void didUpdateWidget(CanvasMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.centerOffset != oldWidget.centerOffset) {
      _panOffset = widget.centerOffset ?? Offset.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _lastPanPosition = details.localFocalPoint;
      },
      onScaleUpdate: (details) {
        // Handle zoom
        if (details.scale != 1.0) {
          final newZoom = (widget.zoom * details.scale).clamp(
            AppConstants.mapZoomMin,
            AppConstants.mapZoomMax,
          );
          widget.onZoomChanged(newZoom);
        }

        // Handle pan (when scale is 1.0, it's just panning)
        if (details.focalPoint != _lastPanPosition) {
          setState(() {
            _panOffset += details.focalPoint - _lastPanPosition!;
            _lastPanPosition = details.focalPoint;
          });
          widget.onCenterChanged(_panOffset);
        }
      },
      child: CustomPaint(
        painter: GolfCourseMapPainter(
          carts: widget.carts,
          zoom: widget.zoom,
          panOffset: _panOffset,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class GolfCourseMapPainter extends CustomPainter {
  final List<Cart> carts;
  final double zoom;
  final Offset panOffset;

  GolfCourseMapPainter({
    required this.carts,
    required this.zoom,
    required this.panOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2) + panOffset;

    // Draw golf course background
    _drawGolfCourseBackground(canvas, size, center);

    // Draw grid
    _drawGrid(canvas, size, center);

    // Draw holes
    _drawHoles(canvas, size, center);

    // Draw cart markers
    _drawCartMarkers(canvas, size, center);
  }

  void _drawGolfCourseBackground(Canvas canvas, Size size, Offset center) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFF0A1F0A),
        const Color(0xFF061506),
      ],
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawRect(rect, paint);
  }

  void _drawGrid(Canvas canvas, Size size, Offset center) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1.0;

    final gridSize = 50.0 * zoom;

    // Vertical lines
    for (double x = center.dx % gridSize; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal lines
    for (double y = center.dy % gridSize; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  void _drawHoles(Canvas canvas, Size size, Offset center) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw 9 holes in a 3x3 grid
    final holeSpacing = 120.0 * zoom;
    final startX = center.dx - holeSpacing;
    final startY = center.dy - holeSpacing;

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        final holeNumber = row * 3 + col + 1;
        final holeCenter = Offset(
          startX + col * holeSpacing,
          startY + row * holeSpacing,
        );

        // Draw hole circle
        canvas.drawCircle(holeCenter, 15.0 * zoom, paint);
        canvas.drawCircle(holeCenter, 15.0 * zoom, strokePaint);

        // Draw hole number
        final textPainter = TextPainter(
          text: TextSpan(
            text: holeNumber.toString(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12.0 * zoom,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            holeCenter.dx - textPainter.width / 2,
            holeCenter.dy - textPainter.height / 2,
          ),
        );
      }
    }
  }

  void _drawCartMarkers(Canvas canvas, Size size, Offset center) {
    for (final cart in carts) {
      final cartPosition = _latLngToOffset(cart.position, center, size);
      if (_isPositionVisible(cartPosition, size)) {
        _drawCartMarker(canvas, cartPosition, cart);
      }
    }
  }

  Offset _latLngToOffset(LatLng latLng, Offset center, Size size) {
    // Convert lat/lng to screen coordinates
    // This is a simplified conversion - in a real app you'd use proper map projection
    final scale = 1000.0 * zoom;
    final x = center.dx + (latLng.longitude - 37.775) * scale;
    final y = center.dy + (latLng.latitude - 37.775) * scale;
    return Offset(x, y);
  }

  bool _isPositionVisible(Offset position, Size size) {
    return position.dx >= -50 &&
        position.dx <= size.width + 50 &&
        position.dy >= -50 &&
        position.dy <= size.height + 50;
  }

  void _drawCartMarker(Canvas canvas, Offset position, Cart cart) {
    final statusColor = AppConstants.statusColors[cart.status] ?? Colors.grey;
    final markerRadius = 12.0 * zoom;

    // Draw outer ring
    final outerPaint = Paint()
      ..color = statusColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, markerRadius + 4, outerPaint);

    // Draw main marker
    final mainPaint = Paint()
      ..color = statusColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, markerRadius, mainPaint);

    // Draw border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * zoom;
    canvas.drawCircle(position, markerRadius, borderPaint);

    // Draw cart icon (simplified)
    final iconPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw a simple car shape
    final carRect = Rect.fromCenter(
      center: position,
      width: 8.0 * zoom,
      height: 6.0 * zoom,
    );
    canvas.drawRect(carRect, iconPaint);

    // Draw battery indicator
    if ((cart.batteryPct ?? 0) < 20) {
      final batteryPaint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(position.dx + markerRadius + 2, position.dy - markerRadius + 2),
        3.0 * zoom,
        batteryPaint,
      );
    }
  }

  @override
  bool shouldRepaint(GolfCourseMapPainter oldDelegate) {
    return carts != oldDelegate.carts ||
        zoom != oldDelegate.zoom ||
        panOffset != oldDelegate.panOffset;
  }
}
