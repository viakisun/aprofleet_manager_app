import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

import '../../core/utils/json_converters.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

@freezed
class Cart with _$Cart {
  const factory Cart({
    required String id,
    required String vin,
    required String manufacturer,
    required String model,
    required int year,
    String? color,
    required String batteryType,
    required int voltage,
    required int seating,
    double? maxSpeed,
    String? gpsTrackerId,
    String? telemetryDeviceId,
    Map<String, String>? componentSerials,
    Map<String, String>? imagePaths,
    DateTime? purchaseDate,
    DateTime? warrantyExpiry,
    String? insuranceNumber,
    double? odometer,
    required CartStatus status,
    @LatLngConverter() required LatLng position,
    double? batteryLevel,
    double? speed,
    DateTime? lastSeen,
    // Additional fields for compatibility
    double? batteryPct,
    double? speedKph,
    String? location,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
}

@freezed
class CartRegistration with _$CartRegistration {
  const factory CartRegistration({
    required String vin,
    required String manufacturer,
    required String model,
    required int year,
    String? color,
    required String batteryType,
    required int voltage,
    required int seating,
    double? maxSpeed,
    String? gpsTrackerId,
    String? telemetryDeviceId,
    Map<String, String>? componentSerials,
    Map<String, String>? imagePaths,
    DateTime? purchaseDate,
    DateTime? warrantyExpiry,
    String? insuranceNumber,
    double? odometer,
  }) = _CartRegistration;

  factory CartRegistration.fromJson(Map<String, dynamic> json) =>
      _$CartRegistrationFromJson(json);
}

@freezed
class CartFilter with _$CartFilter {
  const factory CartFilter({
    Set<CartStatus>? statuses,
    String? manufacturer,
    String? model,
    double? minBattery,
    double? maxBattery,
    String? searchQuery,
  }) = _CartFilter;

  factory CartFilter.fromJson(Map<String, dynamic> json) =>
      _$CartFilterFromJson(json);
}

enum CartStatus {
  @JsonValue('active')
  active,
  @JsonValue('idle')
  idle,
  @JsonValue('charging')
  charging,
  @JsonValue('maintenance')
  maintenance,
  @JsonValue('offline')
  offline,
}

extension CartStatusExtension on CartStatus {
  String get displayName {
    switch (this) {
      case CartStatus.active:
        return 'ACTIVE';
      case CartStatus.idle:
        return 'IDLE';
      case CartStatus.charging:
        return 'CHARGING';
      case CartStatus.maintenance:
        return 'MAINTENANCE';
      case CartStatus.offline:
        return 'OFFLINE';
    }
  }
}
