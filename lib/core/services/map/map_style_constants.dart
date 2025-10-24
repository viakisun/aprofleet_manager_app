import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;
import '../../theme/industrial_dark_tokens.dart';
import '../../../domain/models/cart.dart';

/// 맵 관련 모든 스타일 상수를 중앙 관리하는 클래스
///
/// 이 클래스의 목적:
/// - 하드코딩된 값들을 명확한 이름으로 정의
/// - 코드 전체에서 일관된 스타일 사용 보장
/// - 스타일 변경 시 한 곳만 수정하면 전체에 반영
class MapStyleConstants {
  // Private constructor - 이 클래스는 인스턴스화할 수 없음 (유틸리티 클래스)
  MapStyleConstants._();

  // ============================================================================
  // Polyline (경로선) 스타일
  // ============================================================================

  /// 경로선의 두께 (픽셀)
  static const double routeLineWidth = 5.0;

  /// 경로선의 점선 길이 (픽셀)
  static const double routeDashLength = 20.0;

  /// 경로선의 점선 간격 (픽셀)
  static const double routeGapLength = 10.0;

  /// 경로선의 투명도 (0.0 ~ 1.0)
  static const double routeOpacity = 0.8;

  /// 경로선의 Z-Index (다른 요소들과의 레이어 순서)
  static const int routeZIndex = 1;

  /// 경로선의 색상 (import 'package:flutter/material.dart'의 Color 사용)
  /// Note: withOpacity를 사용하여 메모리 안전성 확보
  static Color get routeColor =>
      IndustrialDarkTokens.accentPrimary.withOpacity(routeOpacity);

  // ============================================================================
  // Marker (마커) 색상 매핑
  // ============================================================================

  /// 카트 상태별 마커 색상 (Hue 값)
  ///
  /// Google Maps는 기본 마커의 색상을 Hue (색조) 값으로 지정합니다.
  /// Hue 값은 0~360도 사이의 색상환 각도입니다.
  static const Map<CartStatus, double> markerHueByStatus = {
    CartStatus.active: google.BitmapDescriptor.hueGreen,      // 활성 (초록)
    CartStatus.idle: google.BitmapDescriptor.hueOrange,       // 대기 (주황)
    CartStatus.charging: google.BitmapDescriptor.hueBlue,     // 충전 중 (파랑)
    CartStatus.maintenance: google.BitmapDescriptor.hueRed,   // 정비 중 (빨강)
    CartStatus.offline: google.BitmapDescriptor.hueViolet,    // 오프라인 (보라)
  };

  // ============================================================================
  // Map Settings (맵 설정)
  // ============================================================================

  /// 기본 맵 타입
  static const google.MapType defaultMapType = google.MapType.satellite;

  /// 내 위치 표시 여부
  static const bool showMyLocation = false;

  /// 내 위치 버튼 표시 여부
  static const bool showMyLocationButton = false;

  /// 줌 컨트롤 버튼 표시 여부
  static const bool showZoomControls = false;

  /// 맵 툴바 표시 여부 (길찾기, Google Maps 앱 열기 등)
  static const bool showMapToolbar = false;
}
