import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

/// 경로 데이터를 로딩하고 파싱하는 서비스
class RouteLoader {
  /// GeoJSON 파일에서 경로 좌표를 로드
  static Future<List<LatLng>> loadCourseRoute() async {
    try {
      // GeoJSON 파일 로드
      final String jsonString = await rootBundle.loadString(
        'assets/seeds/course_playground.geojson',
      );

      // JSON 파싱
      final Map<String, dynamic> geojson = json.decode(jsonString);

      // 첫 번째 Feature의 coordinates 추출
      final List<dynamic> coordinates = geojson['features'][0]['geometry']['coordinates'];

      // LatLng 리스트로 변환
      // 주의: 이 GeoJSON 파일은 표준 형식이 아니라 [latitude, longitude] 순서입니다!
      // (properties.coordinate_order = "lat_lng" 참고)
      // LatLng 생성자도 LatLng(latitude, longitude) 순서이므로 그대로 사용
      return coordinates.map((coord) {
        return LatLng(
          (coord[0] as num).toDouble(),  // latitude
          (coord[1] as num).toDouble(),  // longitude
        );
      }).toList();
    } catch (e) {
      debugPrint('[RouteLoader] Error loading route: $e');
      return [];
    }
  }

  /// 경로 좌표들로부터 바운딩 박스 계산
  static RouteBounds calculateBounds(List<LatLng> coordinates) {
    if (coordinates.isEmpty) {
      return RouteBounds(
        minLat: 0,
        maxLat: 0,
        minLng: 0,
        maxLng: 0,
        center: LatLng(0, 0),
      );
    }

    double minLat = coordinates.first.latitude;
    double maxLat = coordinates.first.latitude;
    double minLng = coordinates.first.longitude;
    double maxLng = coordinates.first.longitude;

    for (final coord in coordinates) {
      if (coord.latitude < minLat) minLat = coord.latitude;
      if (coord.latitude > maxLat) maxLat = coord.latitude;
      if (coord.longitude < minLng) minLng = coord.longitude;
      if (coord.longitude > maxLng) maxLng = coord.longitude;
    }

    // 중심점 계산
    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;

    return RouteBounds(
      minLat: minLat,
      maxLat: maxLat,
      minLng: minLng,
      maxLng: maxLng,
      center: LatLng(centerLat, centerLng),
    );
  }

  /// 두 지점 간 거리 계산 (Haversine 공식, 단위: km)
  static double calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadiusKm = 6371.0;

    final lat1Rad = point1.latitude * math.pi / 180.0;
    final lat2Rad = point2.latitude * math.pi / 180.0;
    final deltaLat = (point2.latitude - point1.latitude) * math.pi / 180.0;
    final deltaLng = (point2.longitude - point1.longitude) * math.pi / 180.0;

    final a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLng / 2) *
            math.sin(deltaLng / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  /// 경로의 총 거리 계산 (단위: km)
  static double calculateTotalDistance(List<LatLng> coordinates) {
    if (coordinates.isEmpty || coordinates.length < 2) {
      return 0.0;
    }

    double totalDistance = 0.0;
    for (int i = 0; i < coordinates.length - 1; i++) {
      totalDistance += calculateDistance(coordinates[i], coordinates[i + 1]);
    }

    return totalDistance;
  }

  /// 각 경로 포인트까지의 누적 거리 계산 (단위: km)
  /// 반환값: [0.0, 0.1, 0.25, 0.5, ...] (각 포인트까지의 누적 거리)
  static List<double> calculateCumulativeDistances(List<LatLng> coordinates) {
    if (coordinates.isEmpty) {
      return [];
    }

    final cumulativeDistances = <double>[0.0]; // 시작점은 0km
    double cumulativeDistance = 0.0;

    for (int i = 0; i < coordinates.length - 1; i++) {
      cumulativeDistance += calculateDistance(coordinates[i], coordinates[i + 1]);
      cumulativeDistances.add(cumulativeDistance);
    }

    return cumulativeDistances;
  }

  /// 특정 지점(카트)이 경로상 어디에 위치하는지 찾기
  /// 가장 가까운 경로 포인트의 인덱스와 해당 포인트까지의 누적 거리를 반환
  static CartRoutePosition findNearestRoutePoint(
    LatLng cartPosition,
    List<LatLng> routeCoordinates,
    List<double> cumulativeDistances,
  ) {
    if (routeCoordinates.isEmpty) {
      return CartRoutePosition(routeIndex: 0, distanceTraveled: 0.0);
    }

    // 가장 가까운 경로 포인트 찾기
    int nearestIndex = 0;
    double minDistance = calculateDistance(cartPosition, routeCoordinates[0]);

    for (int i = 1; i < routeCoordinates.length; i++) {
      final distance = calculateDistance(cartPosition, routeCoordinates[i]);
      if (distance < minDistance) {
        minDistance = distance;
        nearestIndex = i;
      }
    }

    return CartRoutePosition(
      routeIndex: nearestIndex,
      distanceTraveled: cumulativeDistances[nearestIndex],
    );
  }
}

/// 경로의 바운딩 박스 정보
class RouteBounds {
  final double minLat;
  final double maxLat;
  final double minLng;
  final double maxLng;
  final LatLng center;

  RouteBounds({
    required this.minLat,
    required this.maxLat,
    required this.minLng,
    required this.maxLng,
    required this.center,
  });

  /// 바운딩 박스의 너비 (경도 차이)
  double get width => maxLng - minLng;

  /// 바운딩 박스의 높이 (위도 차이)
  double get height => maxLat - minLat;

  @override
  String toString() {
    return 'RouteBounds(center: $center, width: $width, height: $height)';
  }
}

/// 카트의 경로상 위치 정보
class CartRoutePosition {
  final int routeIndex;          // 경로상 가장 가까운 포인트의 인덱스
  final double distanceTraveled; // 해당 포인트까지의 누적 거리 (km)

  CartRoutePosition({
    required this.routeIndex,
    required this.distanceTraveled,
  });
}
