// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telemetry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TelemetryImpl _$$TelemetryImplFromJson(Map<String, dynamic> json) =>
    _$TelemetryImpl(
      cartId: json['cartId'] as String,
      battery: (json['battery'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      voltage: (json['voltage'] as num).toDouble(),
      current: (json['current'] as num).toDouble(),
      runtime: (json['runtime'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$TelemetryImplToJson(_$TelemetryImpl instance) =>
    <String, dynamic>{
      'cartId': instance.cartId,
      'battery': instance.battery,
      'speed': instance.speed,
      'temperature': instance.temperature,
      'voltage': instance.voltage,
      'current': instance.current,
      'runtime': instance.runtime,
      'distance': instance.distance,
      'timestamp': instance.timestamp.toIso8601String(),
    };
