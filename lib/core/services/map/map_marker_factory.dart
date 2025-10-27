import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;
import '../../../domain/models/cart.dart';
import 'custom_marker_icon.dart';
import 'map_style_constants.dart';

/// 맵 마커 생성을 담당하는 팩토리 클래스
///
/// 이 클래스의 목적:
/// - Cart 객체를 Google Maps Marker로 변환
/// - 마커 생성 로직을 한 곳에 집중
/// - 테스트 가능한 순수 함수 제공
/// - 커스텀 아이콘 캐싱으로 성능 최적화
///
/// # 사용 방법
///
/// 1. 앱 시작 시 한 번 초기화:
/// ```dart
/// await MapMarkerFactory.initializeCustomIcons();
/// ```
///
/// 2. 마커 생성:
/// ```dart
/// final markers = MapMarkerFactory.createMarkersFromCarts(
///   carts: cartList,
///   useCustomIcons: true, // 커스텀 아이콘 사용
/// );
/// ```
class MapMarkerFactory {
  // Private constructor - 이 클래스는 인스턴스화할 수 없음 (유틸리티 클래스)
  MapMarkerFactory._();

  /// 커스텀 아이콘 초기화 완료 플래그
  static bool _customIconsInitialized = false;

  /// 커스텀 마커 아이콘을 미리 생성하고 캐시합니다.
  ///
  /// **중요**: 이 메서드는 앱 시작 시 한 번만 호출해야 합니다.
  ///
  /// 왜 미리 생성하나요?
  /// - 아이콘 생성은 비용이 큰 작업 (UI 렌더링 필요)
  /// - 맵 로딩 중에 생성하면 지연(lag) 발생
  /// - 미리 캐시하면 마커 표시가 즉각적
  ///
  /// Returns: 초기화 성공 여부
  static Future<bool> initializeCustomIcons() async {
    if (_customIconsInitialized) {
      debugPrint('Custom marker icons already initialized. Skipping.');
      return true;
    }

    try {
      debugPrint('Initializing custom marker icons...');

      // 카트 상태별 색상 리스트 준비
      final statusColors = CartStatus.values
          .map((status) =>
              _getColorForStatus(status)) // MapStyleConstants 대신 실제 Color 사용
          .toList();

      // CustomMarkerIcon 캐시 초기화
      // 각 상태별로 일반/선택 마커 모두 생성
      await CustomMarkerIcon.initializeIconCache(
        colors: statusColors,
        sizes: [1.0], // 기본 크기만 사용 (필요 시 [0.8, 1.0, 1.2] 등 추가 가능)
        includeSelected: false, // 선택 상태는 사용하지 않음 (간단히 유지)
      );

      _customIconsInitialized = true;
      debugPrint('Custom marker icons initialized successfully.');
      return true;
    } catch (error, stackTrace) {
      debugPrint('Failed to initialize custom marker icons: $error');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// 카트 목록에서 Google Maps 마커 Set을 생성합니다.
  ///
  /// [carts] - 마커로 변환할 카트 목록
  /// [onCartTap] - 마커를 탭했을 때 실행될 콜백 (선택사항)
  /// [useCustomIcons] - 커스텀 아이콘 사용 여부 (기본값: false)
  ///
  /// Returns: Google Maps에 표시할 수 있는 Marker Set
  ///
  /// 참고:
  /// - position이 null인 카트는 자동으로 제외됩니다
  /// - 각 마커는 카트의 ID를 markerId로 사용합니다
  /// - useCustomIcons=true이면 커스텀 아이콘 사용, false이면 기본 색상 핀 사용
  ///
  /// 성능 최적화:
  /// - useCustomIcons=true 사용 전에 반드시 `initializeCustomIcons()` 호출 필요
  /// - 초기화하지 않으면 자동으로 기본 핀으로 폴백
  static Future<Set<google.Marker>> createMarkersFromCarts({
    required List<Cart> carts,
    Function(Cart cart)? onCartTap,
    bool useCustomIcons = false, // 기본값: 기본 핀 사용 (안전)
  }) async {
    final markers = <google.Marker>{};

    // 커스텀 아이콘 사용 요청했지만 초기화 안 됨 → 경고 + 기본 핀 사용
    if (useCustomIcons && !_customIconsInitialized) {
      debugPrint(
        'Warning: Custom icons requested but not initialized. '
        'Call MapMarkerFactory.initializeCustomIcons() first. '
        'Falling back to default marker icons.',
      );
      useCustomIcons = false; // 안전하게 기본 핀 사용
    }

    for (final cart in carts) {
      // 위치 정보가 없는 카트는 건너뜁니다
      final marker = await _createSingleMarker(
        cart: cart,
        onTap: onCartTap != null ? () => onCartTap(cart) : null,
        useCustomIcon: useCustomIcons,
      );

      markers.add(marker);
    }

    return markers;
  }

  /// 단일 카트로부터 Google Maps Marker를 생성합니다 (내부 헬퍼 메서드)
  ///
  /// [cart] - 마커로 변환할 카트
  /// [onTap] - 마커를 탭했을 때 실행될 콜백
  /// [useCustomIcon] - 커스텀 아이콘 사용 여부
  ///
  /// Returns: 생성된 Google Maps Marker
  static Future<google.Marker> _createSingleMarker({
    required Cart cart,
    VoidCallback? onTap,
    bool useCustomIcon = false,
  }) async {
    // 마커 아이콘 결정
    final icon = await _getMarkerIcon(
      status: cart.status,
      useCustom: useCustomIcon,
    );

    return google.Marker(
      // 고유 식별자: 카트 ID 사용
      markerId: google.MarkerId(cart.id),

      // 마커 위치
      position: google.LatLng(
        cart.position.latitude,
        cart.position.longitude,
      ),

      // 마커 아이콘 (커스텀 또는 기본)
      icon: icon,

      // 탭 이벤트 핸들러
      onTap: onTap,
    );
  }

  /// 카트 상태에 따른 마커 아이콘을 반환합니다
  ///
  /// [status] - 카트 상태
  /// [useCustom] - 커스텀 아이콘 사용 여부
  ///
  /// Returns: Google Maps BitmapDescriptor (마커 아이콘)
  ///
  /// 로직:
  /// 1. 커스텀 사용 + 캐시에 있음 → 커스텀 아이콘 반환
  /// 2. 커스텀 사용 + 캐시에 없음 → 기본 핀으로 폴백
  /// 3. 커스텀 미사용 → 기본 핀 반환
  static Future<google.BitmapDescriptor> _getMarkerIcon({
    required CartStatus status,
    bool useCustom = false,
  }) async {
    if (useCustom) {
      // 커스텀 아이콘 캐시에서 가져오기 시도
      final statusColor = _getColorForStatus(status);
      final cachedIcon = CustomMarkerIcon.getCachedMarkerIcon(
        color: statusColor,
        selected: false,
        scale: 1.0,
      );

      if (cachedIcon != null) {
        return cachedIcon;
      } else {
        // 캐시에 없으면 경고 + 기본 핀 사용
        debugPrint(
          'Warning: Custom icon for status $status not found in cache. '
          'Using default marker.',
        );
      }
    }

    // 기본 색상 핀 반환
    final hue = MapStyleConstants.markerHueByStatus[status] ??
        google.BitmapDescriptor.hueRed;

    return google.BitmapDescriptor.defaultMarkerWithHue(hue);
  }

  /// 카트 상태에 따른 Color를 반환합니다
  ///
  /// [status] - 카트 상태
  ///
  /// Returns: Flutter Color 객체
  ///
  /// 참고: MapStyleConstants는 Hue(색조)만 제공하므로,
  /// 여기서 상태별 실제 Color를 정의합니다.
  static Color _getColorForStatus(CartStatus status) {
    switch (status) {
      case CartStatus.active:
        return const Color(0xFF00FF00); // 밝은 초록
      case CartStatus.idle:
        return const Color(0xFFFFAA00); // 주황
      case CartStatus.charging:
        return const Color(0xFF0088FF); // 파랑
      case CartStatus.maintenance:
        return const Color(0xFFFF4444); // 빨강
      case CartStatus.offline:
        return const Color(0xFF9C27B0); // 보라
    }
  }
}
