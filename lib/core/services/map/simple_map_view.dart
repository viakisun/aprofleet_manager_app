import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;

import '../../../domain/models/cart.dart';
import '../../constants/map_constants.dart';
import 'golf_course_route_provider.dart';
import 'map_adapter.dart';
import 'map_marker_factory.dart';
import 'map_polyline_factory.dart';
import 'map_style_constants.dart';

/// 극도로 단순화된 Google Maps 뷰 위젯
///
/// # 설계 철학 (Design Philosophy)
///
/// 이 위젯은 **"한 번 로드, 영원히 정적"** 원칙을 따릅니다:
///
/// 1. **초기화 시 한 번만 로드**
///    - 마커(Markers)와 경로(Route)를 앱 시작 시 한 번만 로딩
///    - 로딩 완료 후에는 절대 업데이트하지 않음
///
/// 2. **동적 업데이트 제로**
///    - Provider watching 없음 → 리빌드 없음
///    - 상태 변경 없음 → 성능 이슈 없음
///    - setState는 초기화 시 딱 한 번만 호출
///
/// 3. **순수한 사용자 인터랙션만 허용**
///    - 지도 팬(드래그), 줌, 마커 탭만 가능
///    - 모든 인터랙션은 Google Maps가 직접 처리
///    - Flutter 위젯 트리 리빌드와 완전히 분리
///
/// # 왜 이렇게 설계했는가?
///
/// 기존 복잡한 GoogleMapView는 다음 문제들이 있었습니다:
/// - Provider watching으로 인한 무한 리빌드
/// - 빈번한 setState 호출로 인한 프레임 드롭
/// - Google Maps SDK 로그 스팸 (ProxyAndroidLoggerBackend 경고)
/// - 앱 크래시 및 응답 없음
///
/// 이 SimpleMapView는 이 모든 문제를 **근본적으로 제거**합니다.
///
/// # 사용 예시
///
/// ```dart
/// SimpleMapView(
///   carts: [cart1, cart2, cart3],
///   initialCameraPosition: CameraPosition(
///     center: LatLng(37.5, 127.0),
///     zoom: 15,
///   ),
///   onCartTap: (cart) {
///     print('Tapped cart: ${cart.id}');
///   },
/// )
/// ```
class SimpleMapView extends ConsumerStatefulWidget {
  /// 지도에 표시할 카트 목록
  ///
  /// 참고: 이 목록은 초기화 시 한 번만 사용되며, 이후 변경되어도 반영되지 않습니다.
  final List<Cart> carts;

  /// 지도의 초기 카메라 위치 (중심 좌표 + 줌 레벨)
  ///
  /// null이면 기본값(Ungpo CC)을 사용합니다.
  final CameraPosition? initialCameraPosition;

  /// 카트 마커를 탭했을 때 실행될 콜백 함수
  ///
  /// 탭된 카트 객체를 인자로 받습니다.
  final Function(Cart)? onCartTap;

  /// 미리 생성된 마커들
  ///
  /// LiveMapView에서 로딩 중에 미리 생성한 마커 Set을 전달받습니다.
  /// 이렇게 하면 SimpleMapView가 표시될 때 즉시 마커가 보입니다.
  final Set<google.Marker> preloadedMarkers;

  /// 미리 생성된 Polyline들 (경로선)
  ///
  /// LiveMapView에서 로딩 중에 미리 생성한 경로 Set을 전달받습니다.
  /// 이렇게 하면 SimpleMapView가 표시될 때 즉시 경로가 보입니다.
  final Set<google.Polyline> preloadedPolylines;

  const SimpleMapView({
    super.key,
    required this.carts,
    required this.preloadedMarkers,
    required this.preloadedPolylines,
    this.initialCameraPosition,
    this.onCartTap,
  });

  @override
  ConsumerState<SimpleMapView> createState() => _SimpleMapViewState();
}

class _SimpleMapViewState extends ConsumerState<SimpleMapView> {
  // ============================================================================
  // State Variables (상태 변수)
  // ============================================================================

  /// Google Maps 컨트롤러
  ///
  /// 지도와 상호작용하기 위한 컨트롤러 (카메라 이동, 줌 등)
  google.GoogleMapController? _controller;

  // ============================================================================
  // Lifecycle Methods (생명주기 메서드)
  // ============================================================================

  @override
  void initState() {
    super.initState();

    // 초기화 로그 출력
    debugPrint('[SimpleMapView] Initialized with preloaded data');
    debugPrint('[SimpleMapView] Preloaded markers: ${widget.preloadedMarkers.length}');
    debugPrint('[SimpleMapView] Preloaded polylines: ${widget.preloadedPolylines.length}');
  }

  @override
  void dispose() {
    // 메모리 누수 방지: 컨트롤러 정리
    _controller?.dispose();
    super.dispose();
  }

  // ============================================================================
  // Build Method (UI 구축)
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    // 초기 카메라 위치 결정 (전달받은 값 또는 기본값)
    final initialPosition = widget.initialCameraPosition ??
        CameraPosition(
          center: MapConstants.ungpoCC,
          zoom: 17.0,
        );

    // Google Maps 위젯 반환
    // 중요: preloadedMarkers와 preloadedPolylines를 직접 사용하여
    // 위젯이 표시되는 즉시 마커와 경로가 보이도록 함
    return google.GoogleMap(
      // 초기 카메라 위치 설정
      initialCameraPosition: google.CameraPosition(
        target: google.LatLng(
          initialPosition.center.latitude,
          initialPosition.center.longitude,
        ),
        zoom: initialPosition.zoom,
      ),

      // 미리 생성된 마커들을 직접 사용
      markers: widget.preloadedMarkers,

      // 미리 생성된 Polyline들을 직접 사용
      polylines: widget.preloadedPolylines,

      // 지도 생성 완료 시 컨트롤러 저장
      onMapCreated: (controller) {
        _controller = controller;
        debugPrint('[SimpleMapView] GoogleMap created and ready');
      },

      // 맵 설정 (MapStyleConstants에서 중앙 관리)
      myLocationEnabled: MapStyleConstants.showMyLocation,
      myLocationButtonEnabled: MapStyleConstants.showMyLocationButton,
      zoomControlsEnabled: MapStyleConstants.showZoomControls,
      mapToolbarEnabled: MapStyleConstants.showMapToolbar,
      mapType: MapStyleConstants.defaultMapType,
    );
  }
}
