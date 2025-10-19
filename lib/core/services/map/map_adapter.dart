import 'package:latlong2/latlong.dart';

import '../../../domain/models/cart.dart';

/// Abstract interface for map providers
abstract class MapAdapter {
  /// Initialize the map adapter
  Future<void> initialize();

  /// Set camera position
  Future<void> setCameraPosition({
    required LatLng center,
    double? zoom,
    double? bearing,
    double? tilt,
    Duration? animationDuration,
  });

  /// Add a cart marker to the map
  Future<void> addMarker(Cart cart);

  /// Remove a cart marker from the map
  Future<void> removeMarker(String cartId);

  /// Update an existing cart marker
  Future<void> updateMarker(Cart cart);

  /// Clear all markers
  Future<void> clearMarkers();

  /// Animate camera to follow a specific cart
  Future<void> animateToCart(String cartId, {Duration? duration});

  /// Get current camera position
  Future<CameraPosition?> getCurrentCameraPosition();

  /// Dispose resources
  void dispose();
}

/// Camera position data model
class CameraPosition {
  final LatLng center;
  final double zoom;
  final double bearing;
  final double tilt;

  const CameraPosition({
    required this.center,
    required this.zoom,
    this.bearing = 0.0,
    this.tilt = 0.0,
  });

  CameraPosition copyWith({
    LatLng? center,
    double? zoom,
    double? bearing,
    double? tilt,
  }) {
    return CameraPosition(
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
      bearing: bearing ?? this.bearing,
      tilt: tilt ?? this.tilt,
    );
  }
}

/// Cart marker data for map rendering
class CartMarkerData {
  final String cartId;
  final LatLng position;
  final CartStatus status;
  final double? batteryPct;
  final String model;
  final bool isLowBattery;

  const CartMarkerData({
    required this.cartId,
    required this.position,
    required this.status,
    this.batteryPct,
    required this.model,
    this.isLowBattery = false,
  });

  factory CartMarkerData.fromCart(Cart cart) {
    return CartMarkerData(
      cartId: cart.id,
      position: cart.position,
      status: cart.status,
      batteryPct: cart.batteryPct,
      model: cart.model,
      isLowBattery: (cart.batteryPct ?? 0) < 20,
    );
  }
}

/// Callback types for map interactions
typedef OnMapTap = void Function(LatLng position);
typedef OnMarkerTap = void Function(Cart cart);
typedef OnCameraChanged = void Function(CameraPosition position);
typedef OnMapReady = void Function();
