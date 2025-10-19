import 'package:latlong2/latlong.dart';

/// GeoJSON 데이터 모델
class GeoJsonData {
  final String type;
  final List<GeoJsonFeature> features;

  GeoJsonData({
    required this.type,
    required this.features,
  });

  factory GeoJsonData.fromJson(Map<String, dynamic> json) {
    return GeoJsonData(
      type: json['type'],
      features: (json['features'] as List)
          .map((feature) => GeoJsonFeature.fromJson(feature))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'features': features.map((feature) => feature.toJson()).toList(),
    };
  }
}

class GeoJsonFeature {
  final String type;
  final GeoJsonProperties properties;
  final GeoJsonGeometry geometry;

  GeoJsonFeature({
    required this.type,
    required this.properties,
    required this.geometry,
  });

  factory GeoJsonFeature.fromJson(Map<String, dynamic> json) {
    return GeoJsonFeature(
      type: json['type'],
      properties: GeoJsonProperties.fromJson(json['properties']),
      geometry: GeoJsonGeometry.fromJson(json['geometry']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'properties': properties.toJson(),
      'geometry': geometry.toJson(),
    };
  }
}

class GeoJsonProperties {
  final String name;
  final String description;
  final String collectionDate;
  final int totalCoordinates;
  final int originalCoordinates;
  final String dataSource;
  final int routeId;
  final String coordinateOrder;

  GeoJsonProperties({
    required this.name,
    required this.description,
    required this.collectionDate,
    required this.totalCoordinates,
    required this.originalCoordinates,
    required this.dataSource,
    required this.routeId,
    required this.coordinateOrder,
  });

  factory GeoJsonProperties.fromJson(Map<String, dynamic> json) {
    return GeoJsonProperties(
      name: json['name'],
      description: json['description'],
      collectionDate: json['collection_date'],
      totalCoordinates: json['total_coordinates'],
      originalCoordinates: json['original_coordinates'],
      dataSource: json['data_source'],
      routeId: json['route_id'],
      coordinateOrder: json['coordinate_order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'collection_date': collectionDate,
      'total_coordinates': totalCoordinates,
      'original_coordinates': originalCoordinates,
      'data_source': dataSource,
      'route_id': routeId,
      'coordinate_order': coordinateOrder,
    };
  }
}

class GeoJsonGeometry {
  final String type;
  final List<List<double>> coordinates;

  GeoJsonGeometry({
    required this.type,
    required this.coordinates,
  });

  factory GeoJsonGeometry.fromJson(Map<String, dynamic> json) {
    return GeoJsonGeometry(
      type: json['type'],
      coordinates: (json['coordinates'] as List)
          .map((coord) => List<double>.from(coord))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }

  /// LineString 좌표를 LatLng 리스트로 변환
  List<LatLng> get coordinatesAsLatLng {
    // GeoJSON 파일에서 coordinate_order가 "lat_lng"로 명시되어 있으므로
    // 첫 번째 요소가 latitude, 두 번째 요소가 longitude
    return coordinates.map((coord) => LatLng(coord[0], coord[1])).toList();
  }
}
