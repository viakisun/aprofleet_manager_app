import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../domain/models/cart.dart';
import 'route_loader.dart';

/// Mapbox 기반의 단순하고 강력한 지도 뷰
///
/// # 새로운 로딩 플로우:
///
/// 1. **Globe Scale로 시작**: 지구본 뷰에서 시작 (zoom: 0)
/// 2. **경로 로딩**: GeoJSON 경로 데이터를 로드하고 파싱
/// 3. **바운드 계산**: 경로 좌표로부터 동적으로 카메라 위치/줌 계산
/// 4. **부드러운 줌인**: 경로 바운드로 애니메이션하며 줌인
/// 5. **경로 + 카트 표시**: 경로와 카트 마커를 함께 표시
///
/// # 사용 방법
///
/// ```dart
/// MapboxMapView(
///   carts: cartList,
///   routeCoordinates: routeCoords,  // 경로 좌표 (선택사항)
///   onCartTap: (cart) {
///     print('Tapped: ${cart.id}');
///   },
/// )
/// ```
class MapboxMapView extends ConsumerStatefulWidget {
  /// 지도에 표시할 카트 목록
  final List<Cart> carts;

  /// 경로 좌표 (LatLng 리스트)
  final List<LatLng>? routeCoordinates;

  /// 카트 마커를 탭했을 때 실행될 콜백 함수
  final Function(Cart)? onCartTap;

  /// Mapbox Access Token
  static const String accessToken =
      'pk.eyJ1IjoiamVvbmdldW5qaSIsImEiOiJjbGt0ZzljcW4wYWpuM2ttZ2NlOW8zYjc2In0.IbUj-eV7VBIfyBfGdAM9xA';

  const MapboxMapView({
    super.key,
    required this.carts,
    this.routeCoordinates,
    this.onCartTap,
  });

  @override
  ConsumerState<MapboxMapView> createState() => MapboxMapViewState();
}

class MapboxMapViewState extends ConsumerState<MapboxMapView> {
  MapboxMap? _mapboxMap;
  bool _hasAnimatedToRoute = false;

  @override
  void initState() {
    super.initState();
    // Set Mapbox access token globally
    MapboxOptions.setAccessToken(MapboxMapView.accessToken);
  }

  @override
  void didUpdateWidget(MapboxMapView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 경로 좌표가 업데이트되었고 아직 애니메이션하지 않았다면 애니메이션 실행
    if (widget.routeCoordinates != null &&
        oldWidget.routeCoordinates == null &&
        !_hasAnimatedToRoute) {
      _animateToRouteBounds();
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '[MapboxMapView] Building with ${widget.carts.length} carts, route: ${widget.routeCoordinates?.length ?? 0} points');

    return MapWidget(
      key: const ValueKey('mapWidget'),
      // Globe Scale 초기 카메라 (지구본 뷰)
      cameraOptions: CameraOptions(
        center: Point(coordinates: Position(0, 0)), // 적도, 본초 자오선
        zoom: 0.0, // 최대 줌 아웃 (지구본 스케일)
      ),
      // 스타일 URL (Satellite)
      styleUri: MapboxStyles.SATELLITE_STREETS,
      // 지도 생성 완료 콜백
      onMapCreated: _onMapCreated,
    );
  }

  /// 지도 생성 완료 시 호출
  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    debugPrint('[MapboxMapView] Map created at globe scale');

    // Hide scale bar
    await mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));

    // 경로가 있으면 즉시 애니메이션 시작
    if (widget.routeCoordinates != null && !_hasAnimatedToRoute) {
      await _animateToRouteBounds();
    }
  }

  /// 경로 바운드로 부드럽게 애니메이션 (4단계)
  /// 1단계: 지구본 줌 레벨 유지 (2초)
  /// 2단계: 경로 위치로 이동 (5초, zoom 0 유지)
  /// 3단계: 멈춤 (1초)
  /// 4단계: 줌인 - 해당 위치에서 확대 (2초)
  Future<void> _animateToRouteBounds() async {
    if (_mapboxMap == null ||
        widget.routeCoordinates == null ||
        widget.routeCoordinates!.isEmpty) {
      return;
    }

    _hasAnimatedToRoute = true;

    try {
      // 1. 경로 바운드 계산
      final bounds = RouteLoader.calculateBounds(widget.routeCoordinates!);
      debugPrint('[MapboxMapView] Route bounds: $bounds');

      // 2. 경로를 Polyline으로 추가
      await _addRoutePolyline(widget.routeCoordinates!);

      // ========================================================================
      // 3. 1단계: 지구본 줌 레벨 유지 (2초)
      // ========================================================================
      debugPrint('[MapboxMapView] Stage 1: Holding at globe zoom level...');
      await Future.delayed(const Duration(seconds: 2));
      debugPrint(
          '[MapboxMapView] Stage 1 complete: Held at globe level for 2 seconds');

      // ========================================================================
      // 4. 2단계 애니메이션: 경로 위치로 이동 (5초, 약간의 줌으로 위경도 이동)
      // ========================================================================
      debugPrint('[MapboxMapView] Stage 2: Moving to route location...');

      final rotationCameraOptions = CameraOptions(
        center: Point(
          coordinates: Position(
            bounds.center.longitude,
            bounds.center.latitude,
          ),
        ),
        zoom: 2.0, // 약간의 줌으로 위경도 이동이 더 명확하게 보임
        pitch: 0.0,
        bearing: 0.0,
      );

      _mapboxMap!.easeTo(
        rotationCameraOptions,
        MapAnimationOptions(duration: 5000, startDelay: 0), // 5초 회전 애니메이션
      );

      // easeTo는 완료를 기다리지 않으므로, duration만큼 수동으로 대기
      await Future.delayed(const Duration(milliseconds: 5000));

      debugPrint('[MapboxMapView] Stage 2 complete: Moved to route location');

      // ========================================================================
      // 5. 3단계: 멈춤 (1초)
      // ========================================================================
      debugPrint('[MapboxMapView] Stage 3: Pausing...');
      await Future.delayed(const Duration(seconds: 1));
      debugPrint('[MapboxMapView] Stage 3 complete: Paused for 1 second');

      // ========================================================================
      // 6. 4단계 애니메이션: 줌인 - 해당 위치에서 확대 (동적 속도)
      // ========================================================================
      debugPrint('[MapboxMapView] Stage 4: Zooming in to route...');

      final targetZoom = _calculateZoomLevel(bounds);
      final zoomDifference = targetZoom - 0.0; // 0에서 targetZoom까지의 차이

      // 줌 레벨당 500ms씩 할당 (예: zoom 16이면 16 * 500ms = 8초)
      final zoomDuration = (zoomDifference * 500).toInt();

      debugPrint(
          '[MapboxMapView] Zoom from 0.0 to $targetZoom (difference: $zoomDifference) - Duration: ${zoomDuration}ms');

      final zoomCameraOptions = CameraOptions(
        center: Point(
          coordinates: Position(
            bounds.center.longitude,
            bounds.center.latitude,
          ),
        ),
        zoom: targetZoom, // 바운드에 맞는 줌 레벨 계산
        pitch: 0.0,
        bearing: 0.0,
      );

      _mapboxMap!.easeTo(
        zoomCameraOptions,
        MapAnimationOptions(
            duration: zoomDuration, startDelay: 0), // 동적 줌인 애니메이션
      );

      // easeTo는 완료를 기다리지 않으므로, duration만큼 수동으로 대기
      await Future.delayed(Duration(milliseconds: zoomDuration));

      debugPrint('[MapboxMapView] Stage 4 complete: Zoom animation finished');

      // 7. 애니메이션 완료 후 카트 마커 추가
      await _addCartMarkersAsCircles();

      debugPrint('[MapboxMapView] Route and carts displayed');
    } catch (e, stackTrace) {
      debugPrint('[MapboxMapView] Error animating to route: $e');
      debugPrint('[MapboxMapView] Stack trace: $stackTrace');
    }
  }

  /// 특정 카트 위치로 카메라 이동 (외부에서 호출 가능)
  ///
  /// 카트 선택 시 해당 위치로 부드럽고 우아하게 줌인
  /// - easeTo: 부드러운 이징 애니메이션 (flyTo보다 젠틀함)
  /// - zoom 16.5: 적절한 거리감 (너무 가깝지 않게)
  /// - 2.5초 애니메이션: 여유있고 우아한 움직임
  Future<void> animateCameraToCart(LatLng position) async {
    if (_mapboxMap == null) {
      debugPrint('[MapboxMapView] Cannot animate: map not initialized');
      return;
    }

    try {
      debugPrint(
          '[MapboxMapView] Gently animating camera to cart at: $position');

      await _mapboxMap!.easeTo(
        CameraOptions(
          center: Point(
              coordinates: Position(position.longitude, position.latitude)),
          zoom: 16.5, // 적절한 줌 레벨 (너무 가깝지 않음)
          pitch: 0.0,
          bearing: 0.0,
        ),
        MapAnimationOptions(duration: 2500, startDelay: 0), // 2.5초 부드러운 애니메이션
      );

      debugPrint('[MapboxMapView] Gentle camera animation complete');
    } catch (e, stackTrace) {
      debugPrint('[MapboxMapView] Error animating camera to cart: $e');
      debugPrint('[MapboxMapView] Stack trace: $stackTrace');
    }
  }

  /// 바운드에 맞는 줌 레벨 계산
  double _calculateZoomLevel(RouteBounds bounds) {
    // 바운드의 크기에 따라 적절한 줌 레벨 계산
    // 작은 영역일수록 높은 줌 레벨 (더 확대)
    final latSpan = bounds.height;
    final lngSpan = bounds.width;
    final maxSpan = latSpan > lngSpan ? latSpan : lngSpan;

    // 경험적 공식: span이 작을수록 zoom이 높아짐
    if (maxSpan > 1.0) {
      return 8.0;
    } else if (maxSpan > 0.5) {
      return 10.0;
    } else if (maxSpan > 0.1) {
      return 12.0;
    } else if (maxSpan > 0.05) {
      return 14.0;
    } else if (maxSpan > 0.01) {
      return 16.0;
    } else {
      return 17.0; // 매우 작은 영역
    }
  }

  /// 경로를 Polyline Annotation으로 추가
  Future<void> _addRoutePolyline(List<LatLng> coordinates) async {
    if (_mapboxMap == null) return;

    try {
      debugPrint(
          '[MapboxMapView] Adding route with ${coordinates.length} points');

      // Polyline Annotation Manager 생성
      final polylineManager =
          await _mapboxMap!.annotations.createPolylineAnnotationManager();

      // 좌표를 Mapbox Position 리스트로 변환
      final positions = coordinates.map((coord) {
        return Position(coord.longitude, coord.latitude);
      }).toList();

      // Polyline Annotation 옵션 생성
      final options = PolylineAnnotationOptions(
        geometry: LineString(coordinates: positions),
        lineColor: 0xFF00FF00, // 밝은 초록색 (ARGB)
        lineWidth: 4.0,
        lineOpacity: 0.8,
      );

      await polylineManager.create(options);

      debugPrint('[MapboxMapView] Route polyline added successfully');
    } catch (e, stackTrace) {
      debugPrint('[MapboxMapView] Error adding route polyline: $e');
      debugPrint('[MapboxMapView] Stack trace: $stackTrace');
    }
  }

  /// 카트 마커들을 Circle (원형) + Text (ID 레이블)로 추가
  Future<void> _addCartMarkersAsCircles() async {
    if (_mapboxMap == null) return;

    // 위치가 있는 카트만 필터링
    final cartsWithPosition =
        widget.carts.where((cart) => cart.position != null).toList();

    debugPrint(
        '[MapboxMapView] Adding ${cartsWithPosition.length} cart markers with labels');

    try {
      // 1. Circle Annotation Manager 생성 (원형 마커)
      final circleManager =
          await _mapboxMap!.annotations.createCircleAnnotationManager();

      // 2. Point Annotation Manager 생성 (텍스트 레이블)
      final pointManager =
          await _mapboxMap!.annotations.createPointAnnotationManager();

      // 각 카트에 대해 Circle + Text 생성
      for (final cart in cartsWithPosition) {
        final position = Point(
          coordinates: Position(
            cart.position.longitude,
            cart.position.latitude,
          ),
        );

        // A. Circle 마커 생성 (상태별 색상)
        await circleManager.create(CircleAnnotationOptions(
          geometry: position,
          circleRadius: 10.0,
          circleColor: _getColorForStatus(cart.status),
          circleStrokeWidth: 2.0,
          circleStrokeColor: Colors.white.value,
        ));

        // B. Text 레이블 생성 (ID 표시)
        await pointManager.create(PointAnnotationOptions(
          geometry: position,
          textField: cart.id, // "APRO-001"
          textSize: 12.0,
          textColor: Colors.white.value, // 흰색 글자
          textOffset: [0.0, -2.0], // 원 위쪽으로 offset
          textHaloColor: Colors.black.value, // 검은색 외곽선 (가독성)
          textHaloWidth: 1.5,
          textAnchor: TextAnchor.BOTTOM, // 텍스트 하단이 position에 고정
        ));

        debugPrint(
            '[MapboxMapView] Added marker for ${cart.id} at ${cart.position}');
      }

      debugPrint(
          '[MapboxMapView] Added ${cartsWithPosition.length} cart markers with labels successfully');
    } catch (e, stackTrace) {
      debugPrint('[MapboxMapView] Error adding cart markers: $e');
      debugPrint('[MapboxMapView] Stack trace: $stackTrace');
    }
  }

  /// 카트 상태에 따른 색상 반환 (ARGB int 값)
  int _getColorForStatus(CartStatus status) {
    switch (status) {
      case CartStatus.active:
        return 0xFF00FF00; // 초록색
      case CartStatus.idle:
        return 0xFFFFAA00; // 주황색
      case CartStatus.charging:
        return 0xFF0088FF; // 파란색
      case CartStatus.maintenance:
        return 0xFFFF4444; // 빨간색
      case CartStatus.offline:
        return 0xFF666666; // 회색
    }
  }

  @override
  void dispose() {
    _mapboxMap = null;
    super.dispose();
  }
}
