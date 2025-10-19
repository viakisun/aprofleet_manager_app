import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/models/cart.dart';

/// Map constants for 웅포CC golf course
class MapConstants {
  // 웅포CC Golf Course coordinates (전북 익산) - GeoJSON 데이터 기반
  static final LatLng ungpoCC = LatLng(35.9558448, 127.0060949);

  // Mapbox access token
  static const String mapboxAccessToken =
      'pk.eyJ1IjoiamVvbmdldW5qaSIsImEiOiJjbGt0ZzljcW4wYWpuM2ttZ2NlOW8zYjc2In0.IbUj-eV7VBIfyBfGdAM9xA';

  // Default camera settings
  static const double defaultZoom = 15.0;
  static const double minZoom = 10.0;
  static const double maxZoom = 20.0;

  // Camera animation duration
  static const Duration animationDuration = Duration(milliseconds: 1000);

  // Marker settings
  static const double markerSize = 24.0;
  static const double lowBatteryIndicatorSize = 8.0;

  // Map styles
  static const String mapboxOutdoorsStyle =
      'mapbox://styles/mapbox/outdoors-v12';
  static const String mapboxSatelliteStyle =
      'mapbox://styles/mapbox/satellite-v9';

  // Google Maps settings
  static const String googleMapsStyle = 'outdoor'; // Suitable for golf courses

  // Status colors for markers
  static const Map<CartStatus, Color> statusColors = {
    CartStatus.active: Color(0xFF22C55E), // Green
    CartStatus.idle: Color(0xFFF97316), // Orange
    CartStatus.charging: Color(0xFF3B82F6), // Blue
    CartStatus.maintenance: Color(0xFFEF4444), // Red
    CartStatus.offline: Color(0xFF666666), // Gray
  };

  /// Get color for cart status
  static Color getStatusColor(CartStatus status) {
    return statusColors[status] ?? Colors.grey;
  }

  /// Check if battery is low
  static bool isLowBattery(double? batteryPct) {
    return (batteryPct ?? 0) < 20.0;
  }
}
