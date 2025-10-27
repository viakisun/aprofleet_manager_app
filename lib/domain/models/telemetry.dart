import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'telemetry.freezed.dart';
part 'telemetry.g.dart';

/// JSON converter for LatLng
class LatLngConverter implements JsonConverter<LatLng, Map<String, dynamic>> {
  const LatLngConverter();

  @override
  LatLng fromJson(Map<String, dynamic> json) {
    return LatLng(
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson(LatLng latLng) {
    return {
      'latitude': latLng.latitude,
      'longitude': latLng.longitude,
    };
  }
}

@freezed
class Telemetry with _$Telemetry {
  const factory Telemetry({
    required String cartId,
    required double battery,
    required double speed,
    required double temperature,
    required double voltage,
    required double current,
    required double runtime,
    required double distance,
    @LatLngConverter() required LatLng position,
    required DateTime timestamp,
  }) = _Telemetry;

  factory Telemetry.fromJson(Map<String, dynamic> json) =>
      _$TelemetryFromJson(json);
}
