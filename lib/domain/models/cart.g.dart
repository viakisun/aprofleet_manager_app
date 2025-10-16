// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartRegistrationImpl _$$CartRegistrationImplFromJson(
        Map<String, dynamic> json) =>
    _$CartRegistrationImpl(
      vin: json['vin'] as String,
      manufacturer: json['manufacturer'] as String,
      model: json['model'] as String,
      year: (json['year'] as num).toInt(),
      color: json['color'] as String?,
      batteryType: json['batteryType'] as String,
      voltage: (json['voltage'] as num).toInt(),
      seating: (json['seating'] as num).toInt(),
      maxSpeed: (json['maxSpeed'] as num?)?.toDouble(),
      gpsTrackerId: json['gpsTrackerId'] as String?,
      telemetryDeviceId: json['telemetryDeviceId'] as String?,
      componentSerials:
          (json['componentSerials'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      imagePaths: (json['imagePaths'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      purchaseDate: json['purchaseDate'] == null
          ? null
          : DateTime.parse(json['purchaseDate'] as String),
      warrantyExpiry: json['warrantyExpiry'] == null
          ? null
          : DateTime.parse(json['warrantyExpiry'] as String),
      insuranceNumber: json['insuranceNumber'] as String?,
      odometer: (json['odometer'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$CartRegistrationImplToJson(
        _$CartRegistrationImpl instance) =>
    <String, dynamic>{
      'vin': instance.vin,
      'manufacturer': instance.manufacturer,
      'model': instance.model,
      'year': instance.year,
      'color': instance.color,
      'batteryType': instance.batteryType,
      'voltage': instance.voltage,
      'seating': instance.seating,
      'maxSpeed': instance.maxSpeed,
      'gpsTrackerId': instance.gpsTrackerId,
      'telemetryDeviceId': instance.telemetryDeviceId,
      'componentSerials': instance.componentSerials,
      'imagePaths': instance.imagePaths,
      'purchaseDate': instance.purchaseDate?.toIso8601String(),
      'warrantyExpiry': instance.warrantyExpiry?.toIso8601String(),
      'insuranceNumber': instance.insuranceNumber,
      'odometer': instance.odometer,
    };

_$CartFilterImpl _$$CartFilterImplFromJson(Map<String, dynamic> json) =>
    _$CartFilterImpl(
      statuses: (json['statuses'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$CartStatusEnumMap, e))
          .toSet(),
      manufacturer: json['manufacturer'] as String?,
      model: json['model'] as String?,
      minBattery: (json['minBattery'] as num?)?.toDouble(),
      maxBattery: (json['maxBattery'] as num?)?.toDouble(),
      searchQuery: json['searchQuery'] as String?,
    );

Map<String, dynamic> _$$CartFilterImplToJson(_$CartFilterImpl instance) =>
    <String, dynamic>{
      'statuses':
          instance.statuses?.map((e) => _$CartStatusEnumMap[e]!).toList(),
      'manufacturer': instance.manufacturer,
      'model': instance.model,
      'minBattery': instance.minBattery,
      'maxBattery': instance.maxBattery,
      'searchQuery': instance.searchQuery,
    };

const _$CartStatusEnumMap = {
  CartStatus.active: 'active',
  CartStatus.idle: 'idle',
  CartStatus.charging: 'charging',
  CartStatus.maintenance: 'maintenance',
  CartStatus.offline: 'offline',
};
