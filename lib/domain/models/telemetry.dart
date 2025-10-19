import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'telemetry.freezed.dart';
part 'telemetry.g.dart';

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
    required LatLng position,
    required DateTime timestamp,
  }) = _Telemetry;

  factory Telemetry.fromJson(Map<String, dynamic> json) =>
      _$TelemetryFromJson(json);
}
