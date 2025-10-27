import 'package:google_maps_flutter/google_maps_flutter.dart' as google;
import '../../../domain/models/geojson_data.dart';
import '../geojson_service.dart';
import 'map_style_constants.dart';

/// 맵 Polyline (선/경로) 생성을 담당하는 팩토리 클래스
///
/// 이 클래스의 목적:
/// - GeoJSON 데이터를 Google Maps Polyline으로 변환
/// - Polyline 스타일링 로직을 한 곳에 집중
/// - 테스트 가능한 순수 함수 제공
class MapPolylineFactory {
  // Private constructor - 이 클래스는 인스턴스화할 수 없음 (유틸리티 클래스)
  MapPolylineFactory._();

  /// GeoJSON 데이터로부터 골프장 경로 Polyline을 생성합니다.
  ///
  /// [routeData] - GeoJSON 형식의 경로 데이터
  ///
  /// Returns: Google Maps에 표시할 수 있는 Polyline Set
  ///
  /// 참고:
  /// - 경로 좌표가 없으면 빈 Set을 반환합니다
  /// - Polyline은 점선 패턴으로 스타일링됩니다
  /// - 색상과 두께는 MapStyleConstants에서 관리됩니다
  static Set<google.Polyline> createGolfCourseRoute({
    required GeoJsonData routeData,
  }) {
    // 빈 Polyline Set 생성
    final polylines = <google.Polyline>{};

    // GeoJSON에서 좌표 추출
    final routeCoordinates =
        GeoJsonService.instance.extractRouteCoordinates(routeData);

    // 좌표가 없으면 빈 Set 반환
    if (routeCoordinates.isEmpty) {
      return polylines;
    }

    // LatLng 좌표를 Google Maps LatLng 형식으로 변환
    final googleMapPoints = routeCoordinates
        .map((latLng) => google.LatLng(
              latLng.latitude,
              latLng.longitude,
            ))
        .toList();

    // Polyline 생성 및 추가
    final polyline = _createStyledPolyline(
      points: googleMapPoints,
      polylineId: 'golf_course_route', // 고유 식별자
    );

    polylines.add(polyline);

    return polylines;
  }

  /// 스타일이 적용된 Polyline을 생성합니다 (내부 헬퍼 메서드)
  ///
  /// [points] - Polyline을 구성하는 좌표 리스트
  /// [polylineId] - Polyline의 고유 식별자
  ///
  /// Returns: 스타일링된 Google Maps Polyline
  ///
  /// 스타일 특징:
  /// - 점선 패턴 (대시 20px, 간격 10px)
  /// - 반투명 (80% 불투명도)
  /// - 적절한 Z-Index로 다른 요소들과 레이어 순서 관리
  static google.Polyline _createStyledPolyline({
    required List<google.LatLng> points,
    required String polylineId,
  }) {
    return google.Polyline(
      // 고유 식별자
      polylineId: google.PolylineId(polylineId),

      // 경로를 구성하는 좌표들
      points: points,

      // 선 색상 (MapStyleConstants에서 정의)
      color: MapStyleConstants.routeColor,

      // 선 두께 (픽셀)
      width: MapStyleConstants.routeLineWidth.toInt(),

      // Z-Index (레이어 순서, 높을수록 위에 표시)
      zIndex: MapStyleConstants.routeZIndex,

      // 점선 패턴: [대시, 간격, 대시, 간격, ...]
      patterns: [
        google.PatternItem.dash(MapStyleConstants.routeDashLength),
        google.PatternItem.gap(MapStyleConstants.routeGapLength),
      ],
    );
  }
}
