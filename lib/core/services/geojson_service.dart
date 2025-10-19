import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/models/geojson_data.dart';

/// GeoJSON 데이터를 로드하고 관리하는 서비스
class GeoJsonService {
  static GeoJsonService? _instance;
  static GeoJsonService get instance => _instance ??= GeoJsonService._();

  GeoJsonService._();

  /// 골프장 경로 GeoJSON 데이터를 로드
  Future<GeoJsonData> loadGolfCourseData() async {
    try {
      // 로딩 시뮬레이션 (사용자가 로딩 상태를 볼 수 있도록)
      await Future.delayed(const Duration(milliseconds: 800));

      final jsonString =
          await rootBundle.loadString('assets/seeds/course_playground.geojson');

      await Future.delayed(const Duration(milliseconds: 600));

      final jsonData = jsonDecode(jsonString);

      if (jsonData == null || jsonData['features'] == null) {
        throw Exception('Invalid GeoJSON format: missing features');
      }

      final geoJsonData = GeoJsonData.fromJson(jsonData);

      if (geoJsonData.features.isEmpty) {
        throw Exception('No features found in GeoJSON data');
      }

      await Future.delayed(const Duration(milliseconds: 400));

      return geoJsonData;
    } catch (e) {
      throw Exception('Failed to load golf course data: $e');
    }
  }

  /// GeoJSON 데이터에서 경로 좌표 추출
  List<LatLng> extractRouteCoordinates(GeoJsonData data) {
    if (data.features.isEmpty) return [];

    final feature = data.features.first;
    if (feature.geometry.type == 'LineString') {
      return feature.geometry.coordinatesAsLatLng;
    }

    return [];
  }

  /// 경로의 중심점 계산
  LatLng calculateRouteCenter(List<LatLng> coordinates) {
    if (coordinates.isEmpty) {
      return LatLng(35.95, 126.95); // 웅포CC 기본 좌표
    }

    double totalLat = 0;
    double totalLng = 0;

    for (final coord in coordinates) {
      totalLat += coord.latitude;
      totalLng += coord.longitude;
    }

    return LatLng(
      totalLat / coordinates.length,
      totalLng / coordinates.length,
    );
  }

  /// 경로의 경계 박스 계산
  Map<String, double> calculateBounds(List<LatLng> coordinates) {
    if (coordinates.isEmpty) {
      return {
        'minLat': 35.95,
        'maxLat': 35.95,
        'minLng': 126.95,
        'maxLng': 126.95,
      };
    }

    double minLat = coordinates.first.latitude;
    double maxLat = coordinates.first.latitude;
    double minLng = coordinates.first.longitude;
    double maxLng = coordinates.first.longitude;

    for (final coord in coordinates) {
      minLat = minLat < coord.latitude ? minLat : coord.latitude;
      maxLat = maxLat > coord.latitude ? maxLat : coord.latitude;
      minLng = minLng < coord.longitude ? minLng : coord.longitude;
      maxLng = maxLng > coord.longitude ? maxLng : coord.longitude;
    }

    return {
      'minLat': minLat,
      'maxLat': maxLat,
      'minLng': minLng,
      'maxLng': maxLng,
    };
  }
}
