import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;
import 'package:latlong2/latlong.dart' as latlong;
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../domain/models/cart.dart';
import '../../../domain/models/geojson_data.dart';
import '../../constants/map_constants.dart';
import '../../services/geojson_service.dart';
import 'golf_course_route_provider.dart';
import 'map_adapter.dart';
import 'custom_marker_icon.dart';
// Web-only imports removed for Android compatibility

/// Google Maps view widget
class GoogleMapView extends ConsumerStatefulWidget {
  final List<Cart> carts;
  final Function(Cart) onCartTap;
  final Function(latlong.LatLng)? onMapTap;
  final Function(CameraPosition)? onCameraChanged;
  final CameraPosition? initialCameraPosition;
  final bool showUserLocation;
  final double mapOpacity;
  
  const GoogleMapView({
    super.key,
    required this.carts,
    required this.onCartTap,
    this.onMapTap,
    this.onCameraChanged,
    this.initialCameraPosition,
    this.showUserLocation = false,
    this.mapOpacity = 0.5,
  });
  
  @override
  ConsumerState<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends ConsumerState<GoogleMapView> {
  google.GoogleMapController? _controller;
  bool _isMapReady = false;
  Set<google.Marker> _markers = {};
  final Set<google.Polyline> _polylines = {};
  
  @override
  void initState() {
    super.initState();
  }

  /// 골프장 경로 폴리라인 생성
  void _createGolfCoursePolyline(GeoJsonData geoJsonData) {
    final routeCoordinates = GeoJsonService.instance.extractRouteCoordinates(geoJsonData);
    
    if (routeCoordinates.isEmpty) {
      return;
    }

    final points = routeCoordinates.map((latLng) => google.LatLng(latLng.latitude, latLng.longitude)).toList();
    
    // Create subtle white outline for contrast
    final routeOutline = google.Polyline(
      polylineId: const google.PolylineId('golf_course_route_outline'),
      points: points,
      color: Colors.white.withOpacity(0.8),
      width: 4,
      patterns: [
        google.PatternItem.dash(30),
        google.PatternItem.gap(15),
      ],
      zIndex: 999,
    );
    
    // Create bright green center line
    final routeCenter = google.Polyline(
      polylineId: const google.PolylineId('golf_course_route'),
      points: points,
      color: const Color(0xFF4CAF50), // Material green for better visibility
      width: 6,
      patterns: [
        google.PatternItem.dash(30),
        google.PatternItem.gap(15),
      ],
      zIndex: 1000,
    );

    setState(() {
      _polylines.clear();
      _polylines.add(routeOutline);  // Add outline first
      _polylines.add(routeCenter);   // Add bright center on top
    });
  }

  /// Google Maps 스타일 생성 (지도 톤 조정용)
  String _generateMapStyle() {
    // Return empty style since we'll use dark underlay for satellite imagery
    return '[]';
  }

  /// Apply CSS filter to darken map tiles (Web only)
  void _applyMapTileDarkening() {
    // Skip this functionality for non-web platforms
    // This is web-specific CSS manipulation
  }

  /// 골프장 경로 중심으로 카메라 조정
  void _adjustCameraToRoute(GeoJsonData geoJsonData) {
    if (_controller == null) {
      return;
    }

    final routeCoordinates = GeoJsonService.instance.extractRouteCoordinates(geoJsonData);
    if (routeCoordinates.isEmpty) {
      return;
    }

    final routeCenter = GeoJsonService.instance.calculateRouteCenter(routeCoordinates);
    final bounds = GeoJsonService.instance.calculateBounds(routeCoordinates);
    
    // 경로의 경계에 맞춰 줌 레벨 계산
    final latDiff = bounds['maxLat']! - bounds['minLat']!;
    final lngDiff = bounds['maxLng']! - bounds['minLng']!;
    final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;
    
    // 줌 레벨 계산 (경로 크기에 따라 조정) - 전체 경로가 화면에 잘 보이도록
    double zoom = 14.5; // 기본 줌 레벨을 낮춰서 전체 경로가 보이도록
    if (maxDiff > 0.005) zoom = 14.0;
    if (maxDiff > 0.01) zoom = 13.5;
    if (maxDiff > 0.015) zoom = 13.0;
    if (maxDiff > 0.02) zoom = 12.5;
    if (maxDiff > 0.03) zoom = 12.0;
    if (maxDiff > 0.05) zoom = 11.5;

    // 골프장 경로 중심으로 카메라 이동
    _controller!.animateCamera(
      google.CameraUpdate.newCameraPosition(
        google.CameraPosition(
          target: google.LatLng(routeCenter.latitude, routeCenter.longitude),
          zoom: zoom,
        ),
      ),
    );

    // Live Map Controller에도 새로운 카메라 위치 전달
    final newCameraPosition = CameraPosition(
      center: latlong.LatLng(routeCenter.latitude, routeCenter.longitude),
      zoom: zoom,
    );
    widget.onCameraChanged?.call(newCameraPosition);
  }
  
  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final routeState = ref.watch(golfCourseRouteProvider);
    
    // Update polylines when route data changes (without auto-adjusting camera)
    if (routeState.data != null && _isMapReady) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _createGolfCoursePolyline(routeState.data!);
        // Camera auto-adjustment removed - user can freely navigate
      });
    }
    
    // Force route loading when in live map view
    if (!routeState.isLoading && routeState.data == null && routeState.error == null && _isMapReady) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(golfCourseRouteProvider.notifier).loadRoute();
      });
    }

    return google.GoogleMap(
      initialCameraPosition: widget.initialCameraPosition != null
          ? google.CameraPosition(
              target: google.LatLng(
                widget.initialCameraPosition!.center.latitude,
                widget.initialCameraPosition!.center.longitude,
              ),
              zoom: widget.initialCameraPosition!.zoom,
              bearing: widget.initialCameraPosition!.bearing,
              tilt: widget.initialCameraPosition!.tilt,
            )
          : google.CameraPosition(
              target: google.LatLng(
                MapConstants.ungpoCC.latitude,
                MapConstants.ungpoCC.longitude,
              ),
              zoom: MapConstants.defaultZoom,
            ),
      mapType: google.MapType.hybrid, // Good for golf courses
      style: _generateMapStyle(), // 지도 톤 조정 스타일 적용
      zoomGesturesEnabled: true,      // Enable zoom gestures
      scrollGesturesEnabled: true,    // Enable drag/pan gestures
      rotateGesturesEnabled: true,    // Enable rotation gestures
      tiltGesturesEnabled: true,      // Enable tilt gestures
      zoomControlsEnabled: false,     // Disable default controls (we have custom)
      liteModeEnabled: false,         // Disable lite mode for full interactivity
      onMapCreated: _onMapCreated,
      onTap: _onMapTap,
      onCameraMove: _onCameraMove,
      onCameraIdle: _onCameraIdle,
      myLocationEnabled: widget.showUserLocation,
      myLocationButtonEnabled: widget.showUserLocation,
      compassEnabled: true,
      mapToolbarEnabled: false,
      markers: _markers,
      polylines: _polylines,
    );
  }
  
  void _onMapCreated(google.GoogleMapController controller) {
    _controller = controller;
    
    setState(() {
      _isMapReady = true;
    });
    
    // Apply CSS darkening to map tiles (Web only)
    _applyMapTileDarkening();
    
    // Update markers when map is ready
    _updateMarkers();
    
    // Route loading removed - no auto loading
  }
  
  void _onMapTap(google.LatLng point) {
    widget.onMapTap?.call(latlong.LatLng(point.latitude, point.longitude));
  }
  
  void _onCameraMove(google.CameraPosition position) {
    // Handle camera movement if needed
  }
  
  void _onCameraIdle() {
    if (_controller != null) {
      _controller!.getVisibleRegion().then((region) {
        final center = latlong.LatLng(
          (region.northeast.latitude + region.southwest.latitude) / 2,
          (region.northeast.longitude + region.southwest.longitude) / 2,
        );
        
        _controller!.getZoomLevel().then((zoom) {
          final cameraPosition = CameraPosition(
            center: center,
            zoom: zoom,
            bearing: 0.0,
            tilt: 0.0,
          );
          widget.onCameraChanged?.call(cameraPosition);
        });
      });
    }
  }
  
  void _updateMarkers() async {
    if (!_isMapReady) return;
    
    print('Updating markers: ${widget.carts.length} carts');
    
    final markers = <google.Marker>{};
    
    for (final cart in widget.carts) {
      print('Adding marker for cart ${cart.id} at ${cart.position.latitude}, ${cart.position.longitude}');
      final statusColor = MapConstants.getStatusColor(cart.status);
      
      // Create custom cart marker icon
      final customIcon = await CustomMarkerIcon.createStatusCartMarkerIcon(
        statusColor: statusColor,
        size: 40.0,
        showDirection: true,
      );
      
      markers.add(
        google.Marker(
          markerId: google.MarkerId(cart.id),
          position: google.LatLng(cart.position.latitude, cart.position.longitude),
          infoWindow: google.InfoWindow(
            title: cart.id,
            snippet: '${cart.model} - ${cart.status.name}',
          ),
          icon: customIcon,
          onTap: () => widget.onCartTap(cart),
        ),
      );
      
      // Add low battery indicator if needed
      if (MapConstants.isLowBattery(cart.batteryPct)) {
        final batteryIcon = await CustomMarkerIcon.createCartMarkerIcon(
          backgroundColor: Colors.red,
          iconColor: Colors.white,
          size: 30.0,
          showDirection: false,
          cacheKey: 'battery_warning',
        );
        
        markers.add(
          google.Marker(
            markerId: google.MarkerId('${cart.id}_battery'),
            position: google.LatLng(
              cart.position.latitude + 0.0001,
              cart.position.longitude + 0.0001,
            ),
            icon: batteryIcon,
            infoWindow: const google.InfoWindow(
              title: 'Low Battery',
              snippet: 'Battery level below 20%',
            ),
          ),
        );
      }
    }
    
    print('Total markers created: ${markers.length}');
    
    if (mounted) {
      setState(() {
        _markers = markers;
      });
    }
  }
  
  @override
  void didUpdateWidget(GoogleMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update markers if cart list changed
    if (oldWidget.carts != widget.carts) {
      _updateMarkers();
    }
    
    // Update camera position if it changed
    if (oldWidget.initialCameraPosition != widget.initialCameraPosition &&
        widget.initialCameraPosition != null) {
      setCameraPosition(widget.initialCameraPosition!);
    }
    
    // Apply CSS darkening when opacity changes
    if (oldWidget.mapOpacity != widget.mapOpacity) {
      _applyMapTileDarkening();
    }
  }
  
  /// Get marker hue from color
  double _getMarkerHue(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.hue;
  }
  
  /// Public method to animate to a specific cart
  Future<void> animateToCart(String cartId) async {
    final cart = widget.carts.firstWhere((c) => c.id == cartId);
    await _controller?.animateCamera(
      google.CameraUpdate.newLatLng(
        google.LatLng(cart.position.latitude, cart.position.longitude),
      ),
    );
  }
  
  /// Public method to set camera position
  Future<void> setCameraPosition(CameraPosition position) async {
    await _controller?.animateCamera(
      google.CameraUpdate.newCameraPosition(
        google.CameraPosition(
          target: google.LatLng(
            position.center.latitude, 
            position.center.longitude,
          ),
          zoom: position.zoom,
          bearing: position.bearing,
          tilt: position.tilt,
        ),
      ),
    );
  }
}
