import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

import '../../core/utils/json_converters.dart';
import 'alert.dart';
import 'cart_issue.dart';

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
    // Alert integration
    String? activeAlertId,
    AlertSeverity? alertSeverity,
    // Manager-centric fields
    String? courseLocation, // e.g., "On Course - Hole 7", "In Garage", "Charging Station"
    String? firmwareVersion, // e.g., "v2.5.1"
    @Default(false) bool firmwareUpdateAvailable, // Whether firmware update is needed
    DateTime? lastMaintenanceDate, // Last maintenance/service date
    DateTime? nextMaintenanceDate, // Next scheduled maintenance
    @Default(0) int activeIssuesCount, // Count of active unresolved issues
    @Default([]) List<CartIssue> activeIssues, // List of active issues
    double? todayDistance, // Distance traveled today (km)
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

extension CartExtension on Cart {
  /// Returns true if this cart has an active alert
  bool get hasActiveAlert => activeAlertId != null;

  /// Returns true if this cart is on the route (active or has alert)
  bool get isOnRoute => status == CartStatus.active || hasActiveAlert;
}
