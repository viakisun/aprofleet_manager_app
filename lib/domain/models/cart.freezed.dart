// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Cart _$CartFromJson(Map<String, dynamic> json) {
  return _Cart.fromJson(json);
}

/// @nodoc
mixin _$Cart {
  String get id => throw _privateConstructorUsedError;
  String get vin => throw _privateConstructorUsedError;
  String get manufacturer => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String get batteryType => throw _privateConstructorUsedError;
  int get voltage => throw _privateConstructorUsedError;
  int get seating => throw _privateConstructorUsedError;
  double? get maxSpeed => throw _privateConstructorUsedError;
  String? get gpsTrackerId => throw _privateConstructorUsedError;
  String? get telemetryDeviceId => throw _privateConstructorUsedError;
  Map<String, String>? get componentSerials =>
      throw _privateConstructorUsedError;
  Map<String, String>? get imagePaths => throw _privateConstructorUsedError;
  DateTime? get purchaseDate => throw _privateConstructorUsedError;
  DateTime? get warrantyExpiry => throw _privateConstructorUsedError;
  String? get insuranceNumber => throw _privateConstructorUsedError;
  double? get odometer => throw _privateConstructorUsedError;
  CartStatus get status => throw _privateConstructorUsedError;
  @LatLngConverter()
  LatLng get position => throw _privateConstructorUsedError;
  double? get batteryLevel => throw _privateConstructorUsedError;
  double? get speed => throw _privateConstructorUsedError;
  DateTime? get lastSeen =>
      throw _privateConstructorUsedError; // Additional fields for compatibility
  double? get batteryPct => throw _privateConstructorUsedError;
  double? get speedKph => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;

  /// Serializes this Cart to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartCopyWith<Cart> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartCopyWith<$Res> {
  factory $CartCopyWith(Cart value, $Res Function(Cart) then) =
      _$CartCopyWithImpl<$Res, Cart>;
  @useResult
  $Res call(
      {String id,
      String vin,
      String manufacturer,
      String model,
      int year,
      String? color,
      String batteryType,
      int voltage,
      int seating,
      double? maxSpeed,
      String? gpsTrackerId,
      String? telemetryDeviceId,
      Map<String, String>? componentSerials,
      Map<String, String>? imagePaths,
      DateTime? purchaseDate,
      DateTime? warrantyExpiry,
      String? insuranceNumber,
      double? odometer,
      CartStatus status,
      @LatLngConverter() LatLng position,
      double? batteryLevel,
      double? speed,
      DateTime? lastSeen,
      double? batteryPct,
      double? speedKph,
      String? location});
}

/// @nodoc
class _$CartCopyWithImpl<$Res, $Val extends Cart>
    implements $CartCopyWith<$Res> {
  _$CartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vin = null,
    Object? manufacturer = null,
    Object? model = null,
    Object? year = null,
    Object? color = freezed,
    Object? batteryType = null,
    Object? voltage = null,
    Object? seating = null,
    Object? maxSpeed = freezed,
    Object? gpsTrackerId = freezed,
    Object? telemetryDeviceId = freezed,
    Object? componentSerials = freezed,
    Object? imagePaths = freezed,
    Object? purchaseDate = freezed,
    Object? warrantyExpiry = freezed,
    Object? insuranceNumber = freezed,
    Object? odometer = freezed,
    Object? status = null,
    Object? position = null,
    Object? batteryLevel = freezed,
    Object? speed = freezed,
    Object? lastSeen = freezed,
    Object? batteryPct = freezed,
    Object? speedKph = freezed,
    Object? location = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vin: null == vin
          ? _value.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String,
      manufacturer: null == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      batteryType: null == batteryType
          ? _value.batteryType
          : batteryType // ignore: cast_nullable_to_non_nullable
              as String,
      voltage: null == voltage
          ? _value.voltage
          : voltage // ignore: cast_nullable_to_non_nullable
              as int,
      seating: null == seating
          ? _value.seating
          : seating // ignore: cast_nullable_to_non_nullable
              as int,
      maxSpeed: freezed == maxSpeed
          ? _value.maxSpeed
          : maxSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      gpsTrackerId: freezed == gpsTrackerId
          ? _value.gpsTrackerId
          : gpsTrackerId // ignore: cast_nullable_to_non_nullable
              as String?,
      telemetryDeviceId: freezed == telemetryDeviceId
          ? _value.telemetryDeviceId
          : telemetryDeviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      componentSerials: freezed == componentSerials
          ? _value.componentSerials
          : componentSerials // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      imagePaths: freezed == imagePaths
          ? _value.imagePaths
          : imagePaths // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      warrantyExpiry: freezed == warrantyExpiry
          ? _value.warrantyExpiry
          : warrantyExpiry // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      insuranceNumber: freezed == insuranceNumber
          ? _value.insuranceNumber
          : insuranceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      odometer: freezed == odometer
          ? _value.odometer
          : odometer // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CartStatus,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as LatLng,
      batteryLevel: freezed == batteryLevel
          ? _value.batteryLevel
          : batteryLevel // ignore: cast_nullable_to_non_nullable
              as double?,
      speed: freezed == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double?,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      batteryPct: freezed == batteryPct
          ? _value.batteryPct
          : batteryPct // ignore: cast_nullable_to_non_nullable
              as double?,
      speedKph: freezed == speedKph
          ? _value.speedKph
          : speedKph // ignore: cast_nullable_to_non_nullable
              as double?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartImplCopyWith<$Res> implements $CartCopyWith<$Res> {
  factory _$$CartImplCopyWith(
          _$CartImpl value, $Res Function(_$CartImpl) then) =
      __$$CartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String vin,
      String manufacturer,
      String model,
      int year,
      String? color,
      String batteryType,
      int voltage,
      int seating,
      double? maxSpeed,
      String? gpsTrackerId,
      String? telemetryDeviceId,
      Map<String, String>? componentSerials,
      Map<String, String>? imagePaths,
      DateTime? purchaseDate,
      DateTime? warrantyExpiry,
      String? insuranceNumber,
      double? odometer,
      CartStatus status,
      @LatLngConverter() LatLng position,
      double? batteryLevel,
      double? speed,
      DateTime? lastSeen,
      double? batteryPct,
      double? speedKph,
      String? location});
}

/// @nodoc
class __$$CartImplCopyWithImpl<$Res>
    extends _$CartCopyWithImpl<$Res, _$CartImpl>
    implements _$$CartImplCopyWith<$Res> {
  __$$CartImplCopyWithImpl(_$CartImpl _value, $Res Function(_$CartImpl) _then)
      : super(_value, _then);

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vin = null,
    Object? manufacturer = null,
    Object? model = null,
    Object? year = null,
    Object? color = freezed,
    Object? batteryType = null,
    Object? voltage = null,
    Object? seating = null,
    Object? maxSpeed = freezed,
    Object? gpsTrackerId = freezed,
    Object? telemetryDeviceId = freezed,
    Object? componentSerials = freezed,
    Object? imagePaths = freezed,
    Object? purchaseDate = freezed,
    Object? warrantyExpiry = freezed,
    Object? insuranceNumber = freezed,
    Object? odometer = freezed,
    Object? status = null,
    Object? position = null,
    Object? batteryLevel = freezed,
    Object? speed = freezed,
    Object? lastSeen = freezed,
    Object? batteryPct = freezed,
    Object? speedKph = freezed,
    Object? location = freezed,
  }) {
    return _then(_$CartImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vin: null == vin
          ? _value.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String,
      manufacturer: null == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      batteryType: null == batteryType
          ? _value.batteryType
          : batteryType // ignore: cast_nullable_to_non_nullable
              as String,
      voltage: null == voltage
          ? _value.voltage
          : voltage // ignore: cast_nullable_to_non_nullable
              as int,
      seating: null == seating
          ? _value.seating
          : seating // ignore: cast_nullable_to_non_nullable
              as int,
      maxSpeed: freezed == maxSpeed
          ? _value.maxSpeed
          : maxSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      gpsTrackerId: freezed == gpsTrackerId
          ? _value.gpsTrackerId
          : gpsTrackerId // ignore: cast_nullable_to_non_nullable
              as String?,
      telemetryDeviceId: freezed == telemetryDeviceId
          ? _value.telemetryDeviceId
          : telemetryDeviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      componentSerials: freezed == componentSerials
          ? _value._componentSerials
          : componentSerials // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      imagePaths: freezed == imagePaths
          ? _value._imagePaths
          : imagePaths // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      warrantyExpiry: freezed == warrantyExpiry
          ? _value.warrantyExpiry
          : warrantyExpiry // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      insuranceNumber: freezed == insuranceNumber
          ? _value.insuranceNumber
          : insuranceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      odometer: freezed == odometer
          ? _value.odometer
          : odometer // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as CartStatus,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as LatLng,
      batteryLevel: freezed == batteryLevel
          ? _value.batteryLevel
          : batteryLevel // ignore: cast_nullable_to_non_nullable
              as double?,
      speed: freezed == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double?,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      batteryPct: freezed == batteryPct
          ? _value.batteryPct
          : batteryPct // ignore: cast_nullable_to_non_nullable
              as double?,
      speedKph: freezed == speedKph
          ? _value.speedKph
          : speedKph // ignore: cast_nullable_to_non_nullable
              as double?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CartImpl implements _Cart {
  const _$CartImpl(
      {required this.id,
      required this.vin,
      required this.manufacturer,
      required this.model,
      required this.year,
      this.color,
      required this.batteryType,
      required this.voltage,
      required this.seating,
      this.maxSpeed,
      this.gpsTrackerId,
      this.telemetryDeviceId,
      final Map<String, String>? componentSerials,
      final Map<String, String>? imagePaths,
      this.purchaseDate,
      this.warrantyExpiry,
      this.insuranceNumber,
      this.odometer,
      required this.status,
      @LatLngConverter() required this.position,
      this.batteryLevel,
      this.speed,
      this.lastSeen,
      this.batteryPct,
      this.speedKph,
      this.location})
      : _componentSerials = componentSerials,
        _imagePaths = imagePaths;

  factory _$CartImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartImplFromJson(json);

  @override
  final String id;
  @override
  final String vin;
  @override
  final String manufacturer;
  @override
  final String model;
  @override
  final int year;
  @override
  final String? color;
  @override
  final String batteryType;
  @override
  final int voltage;
  @override
  final int seating;
  @override
  final double? maxSpeed;
  @override
  final String? gpsTrackerId;
  @override
  final String? telemetryDeviceId;
  final Map<String, String>? _componentSerials;
  @override
  Map<String, String>? get componentSerials {
    final value = _componentSerials;
    if (value == null) return null;
    if (_componentSerials is EqualUnmodifiableMapView) return _componentSerials;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, String>? _imagePaths;
  @override
  Map<String, String>? get imagePaths {
    final value = _imagePaths;
    if (value == null) return null;
    if (_imagePaths is EqualUnmodifiableMapView) return _imagePaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? purchaseDate;
  @override
  final DateTime? warrantyExpiry;
  @override
  final String? insuranceNumber;
  @override
  final double? odometer;
  @override
  final CartStatus status;
  @override
  @LatLngConverter()
  final LatLng position;
  @override
  final double? batteryLevel;
  @override
  final double? speed;
  @override
  final DateTime? lastSeen;
// Additional fields for compatibility
  @override
  final double? batteryPct;
  @override
  final double? speedKph;
  @override
  final String? location;

  @override
  String toString() {
    return 'Cart(id: $id, vin: $vin, manufacturer: $manufacturer, model: $model, year: $year, color: $color, batteryType: $batteryType, voltage: $voltage, seating: $seating, maxSpeed: $maxSpeed, gpsTrackerId: $gpsTrackerId, telemetryDeviceId: $telemetryDeviceId, componentSerials: $componentSerials, imagePaths: $imagePaths, purchaseDate: $purchaseDate, warrantyExpiry: $warrantyExpiry, insuranceNumber: $insuranceNumber, odometer: $odometer, status: $status, position: $position, batteryLevel: $batteryLevel, speed: $speed, lastSeen: $lastSeen, batteryPct: $batteryPct, speedKph: $speedKph, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vin, vin) || other.vin == vin) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.batteryType, batteryType) ||
                other.batteryType == batteryType) &&
            (identical(other.voltage, voltage) || other.voltage == voltage) &&
            (identical(other.seating, seating) || other.seating == seating) &&
            (identical(other.maxSpeed, maxSpeed) ||
                other.maxSpeed == maxSpeed) &&
            (identical(other.gpsTrackerId, gpsTrackerId) ||
                other.gpsTrackerId == gpsTrackerId) &&
            (identical(other.telemetryDeviceId, telemetryDeviceId) ||
                other.telemetryDeviceId == telemetryDeviceId) &&
            const DeepCollectionEquality()
                .equals(other._componentSerials, _componentSerials) &&
            const DeepCollectionEquality()
                .equals(other._imagePaths, _imagePaths) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate) &&
            (identical(other.warrantyExpiry, warrantyExpiry) ||
                other.warrantyExpiry == warrantyExpiry) &&
            (identical(other.insuranceNumber, insuranceNumber) ||
                other.insuranceNumber == insuranceNumber) &&
            (identical(other.odometer, odometer) ||
                other.odometer == odometer) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.batteryLevel, batteryLevel) ||
                other.batteryLevel == batteryLevel) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            (identical(other.batteryPct, batteryPct) ||
                other.batteryPct == batteryPct) &&
            (identical(other.speedKph, speedKph) ||
                other.speedKph == speedKph) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        vin,
        manufacturer,
        model,
        year,
        color,
        batteryType,
        voltage,
        seating,
        maxSpeed,
        gpsTrackerId,
        telemetryDeviceId,
        const DeepCollectionEquality().hash(_componentSerials),
        const DeepCollectionEquality().hash(_imagePaths),
        purchaseDate,
        warrantyExpiry,
        insuranceNumber,
        odometer,
        status,
        position,
        batteryLevel,
        speed,
        lastSeen,
        batteryPct,
        speedKph,
        location
      ]);

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartImplCopyWith<_$CartImpl> get copyWith =>
      __$$CartImplCopyWithImpl<_$CartImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartImplToJson(
      this,
    );
  }
}

abstract class _Cart implements Cart {
  const factory _Cart(
      {required final String id,
      required final String vin,
      required final String manufacturer,
      required final String model,
      required final int year,
      final String? color,
      required final String batteryType,
      required final int voltage,
      required final int seating,
      final double? maxSpeed,
      final String? gpsTrackerId,
      final String? telemetryDeviceId,
      final Map<String, String>? componentSerials,
      final Map<String, String>? imagePaths,
      final DateTime? purchaseDate,
      final DateTime? warrantyExpiry,
      final String? insuranceNumber,
      final double? odometer,
      required final CartStatus status,
      @LatLngConverter() required final LatLng position,
      final double? batteryLevel,
      final double? speed,
      final DateTime? lastSeen,
      final double? batteryPct,
      final double? speedKph,
      final String? location}) = _$CartImpl;

  factory _Cart.fromJson(Map<String, dynamic> json) = _$CartImpl.fromJson;

  @override
  String get id;
  @override
  String get vin;
  @override
  String get manufacturer;
  @override
  String get model;
  @override
  int get year;
  @override
  String? get color;
  @override
  String get batteryType;
  @override
  int get voltage;
  @override
  int get seating;
  @override
  double? get maxSpeed;
  @override
  String? get gpsTrackerId;
  @override
  String? get telemetryDeviceId;
  @override
  Map<String, String>? get componentSerials;
  @override
  Map<String, String>? get imagePaths;
  @override
  DateTime? get purchaseDate;
  @override
  DateTime? get warrantyExpiry;
  @override
  String? get insuranceNumber;
  @override
  double? get odometer;
  @override
  CartStatus get status;
  @override
  @LatLngConverter()
  LatLng get position;
  @override
  double? get batteryLevel;
  @override
  double? get speed;
  @override
  DateTime? get lastSeen; // Additional fields for compatibility
  @override
  double? get batteryPct;
  @override
  double? get speedKph;
  @override
  String? get location;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartImplCopyWith<_$CartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CartRegistration _$CartRegistrationFromJson(Map<String, dynamic> json) {
  return _CartRegistration.fromJson(json);
}

/// @nodoc
mixin _$CartRegistration {
  String get vin => throw _privateConstructorUsedError;
  String get manufacturer => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String get batteryType => throw _privateConstructorUsedError;
  int get voltage => throw _privateConstructorUsedError;
  int get seating => throw _privateConstructorUsedError;
  double? get maxSpeed => throw _privateConstructorUsedError;
  String? get gpsTrackerId => throw _privateConstructorUsedError;
  String? get telemetryDeviceId => throw _privateConstructorUsedError;
  Map<String, String>? get componentSerials =>
      throw _privateConstructorUsedError;
  Map<String, String>? get imagePaths => throw _privateConstructorUsedError;
  DateTime? get purchaseDate => throw _privateConstructorUsedError;
  DateTime? get warrantyExpiry => throw _privateConstructorUsedError;
  String? get insuranceNumber => throw _privateConstructorUsedError;
  double? get odometer => throw _privateConstructorUsedError;

  /// Serializes this CartRegistration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartRegistration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartRegistrationCopyWith<CartRegistration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartRegistrationCopyWith<$Res> {
  factory $CartRegistrationCopyWith(
          CartRegistration value, $Res Function(CartRegistration) then) =
      _$CartRegistrationCopyWithImpl<$Res, CartRegistration>;
  @useResult
  $Res call(
      {String vin,
      String manufacturer,
      String model,
      int year,
      String? color,
      String batteryType,
      int voltage,
      int seating,
      double? maxSpeed,
      String? gpsTrackerId,
      String? telemetryDeviceId,
      Map<String, String>? componentSerials,
      Map<String, String>? imagePaths,
      DateTime? purchaseDate,
      DateTime? warrantyExpiry,
      String? insuranceNumber,
      double? odometer});
}

/// @nodoc
class _$CartRegistrationCopyWithImpl<$Res, $Val extends CartRegistration>
    implements $CartRegistrationCopyWith<$Res> {
  _$CartRegistrationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartRegistration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vin = null,
    Object? manufacturer = null,
    Object? model = null,
    Object? year = null,
    Object? color = freezed,
    Object? batteryType = null,
    Object? voltage = null,
    Object? seating = null,
    Object? maxSpeed = freezed,
    Object? gpsTrackerId = freezed,
    Object? telemetryDeviceId = freezed,
    Object? componentSerials = freezed,
    Object? imagePaths = freezed,
    Object? purchaseDate = freezed,
    Object? warrantyExpiry = freezed,
    Object? insuranceNumber = freezed,
    Object? odometer = freezed,
  }) {
    return _then(_value.copyWith(
      vin: null == vin
          ? _value.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String,
      manufacturer: null == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      batteryType: null == batteryType
          ? _value.batteryType
          : batteryType // ignore: cast_nullable_to_non_nullable
              as String,
      voltage: null == voltage
          ? _value.voltage
          : voltage // ignore: cast_nullable_to_non_nullable
              as int,
      seating: null == seating
          ? _value.seating
          : seating // ignore: cast_nullable_to_non_nullable
              as int,
      maxSpeed: freezed == maxSpeed
          ? _value.maxSpeed
          : maxSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      gpsTrackerId: freezed == gpsTrackerId
          ? _value.gpsTrackerId
          : gpsTrackerId // ignore: cast_nullable_to_non_nullable
              as String?,
      telemetryDeviceId: freezed == telemetryDeviceId
          ? _value.telemetryDeviceId
          : telemetryDeviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      componentSerials: freezed == componentSerials
          ? _value.componentSerials
          : componentSerials // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      imagePaths: freezed == imagePaths
          ? _value.imagePaths
          : imagePaths // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      warrantyExpiry: freezed == warrantyExpiry
          ? _value.warrantyExpiry
          : warrantyExpiry // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      insuranceNumber: freezed == insuranceNumber
          ? _value.insuranceNumber
          : insuranceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      odometer: freezed == odometer
          ? _value.odometer
          : odometer // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartRegistrationImplCopyWith<$Res>
    implements $CartRegistrationCopyWith<$Res> {
  factory _$$CartRegistrationImplCopyWith(_$CartRegistrationImpl value,
          $Res Function(_$CartRegistrationImpl) then) =
      __$$CartRegistrationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String vin,
      String manufacturer,
      String model,
      int year,
      String? color,
      String batteryType,
      int voltage,
      int seating,
      double? maxSpeed,
      String? gpsTrackerId,
      String? telemetryDeviceId,
      Map<String, String>? componentSerials,
      Map<String, String>? imagePaths,
      DateTime? purchaseDate,
      DateTime? warrantyExpiry,
      String? insuranceNumber,
      double? odometer});
}

/// @nodoc
class __$$CartRegistrationImplCopyWithImpl<$Res>
    extends _$CartRegistrationCopyWithImpl<$Res, _$CartRegistrationImpl>
    implements _$$CartRegistrationImplCopyWith<$Res> {
  __$$CartRegistrationImplCopyWithImpl(_$CartRegistrationImpl _value,
      $Res Function(_$CartRegistrationImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartRegistration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vin = null,
    Object? manufacturer = null,
    Object? model = null,
    Object? year = null,
    Object? color = freezed,
    Object? batteryType = null,
    Object? voltage = null,
    Object? seating = null,
    Object? maxSpeed = freezed,
    Object? gpsTrackerId = freezed,
    Object? telemetryDeviceId = freezed,
    Object? componentSerials = freezed,
    Object? imagePaths = freezed,
    Object? purchaseDate = freezed,
    Object? warrantyExpiry = freezed,
    Object? insuranceNumber = freezed,
    Object? odometer = freezed,
  }) {
    return _then(_$CartRegistrationImpl(
      vin: null == vin
          ? _value.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String,
      manufacturer: null == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      batteryType: null == batteryType
          ? _value.batteryType
          : batteryType // ignore: cast_nullable_to_non_nullable
              as String,
      voltage: null == voltage
          ? _value.voltage
          : voltage // ignore: cast_nullable_to_non_nullable
              as int,
      seating: null == seating
          ? _value.seating
          : seating // ignore: cast_nullable_to_non_nullable
              as int,
      maxSpeed: freezed == maxSpeed
          ? _value.maxSpeed
          : maxSpeed // ignore: cast_nullable_to_non_nullable
              as double?,
      gpsTrackerId: freezed == gpsTrackerId
          ? _value.gpsTrackerId
          : gpsTrackerId // ignore: cast_nullable_to_non_nullable
              as String?,
      telemetryDeviceId: freezed == telemetryDeviceId
          ? _value.telemetryDeviceId
          : telemetryDeviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      componentSerials: freezed == componentSerials
          ? _value._componentSerials
          : componentSerials // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      imagePaths: freezed == imagePaths
          ? _value._imagePaths
          : imagePaths // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      warrantyExpiry: freezed == warrantyExpiry
          ? _value.warrantyExpiry
          : warrantyExpiry // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      insuranceNumber: freezed == insuranceNumber
          ? _value.insuranceNumber
          : insuranceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      odometer: freezed == odometer
          ? _value.odometer
          : odometer // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CartRegistrationImpl implements _CartRegistration {
  const _$CartRegistrationImpl(
      {required this.vin,
      required this.manufacturer,
      required this.model,
      required this.year,
      this.color,
      required this.batteryType,
      required this.voltage,
      required this.seating,
      this.maxSpeed,
      this.gpsTrackerId,
      this.telemetryDeviceId,
      final Map<String, String>? componentSerials,
      final Map<String, String>? imagePaths,
      this.purchaseDate,
      this.warrantyExpiry,
      this.insuranceNumber,
      this.odometer})
      : _componentSerials = componentSerials,
        _imagePaths = imagePaths;

  factory _$CartRegistrationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartRegistrationImplFromJson(json);

  @override
  final String vin;
  @override
  final String manufacturer;
  @override
  final String model;
  @override
  final int year;
  @override
  final String? color;
  @override
  final String batteryType;
  @override
  final int voltage;
  @override
  final int seating;
  @override
  final double? maxSpeed;
  @override
  final String? gpsTrackerId;
  @override
  final String? telemetryDeviceId;
  final Map<String, String>? _componentSerials;
  @override
  Map<String, String>? get componentSerials {
    final value = _componentSerials;
    if (value == null) return null;
    if (_componentSerials is EqualUnmodifiableMapView) return _componentSerials;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, String>? _imagePaths;
  @override
  Map<String, String>? get imagePaths {
    final value = _imagePaths;
    if (value == null) return null;
    if (_imagePaths is EqualUnmodifiableMapView) return _imagePaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? purchaseDate;
  @override
  final DateTime? warrantyExpiry;
  @override
  final String? insuranceNumber;
  @override
  final double? odometer;

  @override
  String toString() {
    return 'CartRegistration(vin: $vin, manufacturer: $manufacturer, model: $model, year: $year, color: $color, batteryType: $batteryType, voltage: $voltage, seating: $seating, maxSpeed: $maxSpeed, gpsTrackerId: $gpsTrackerId, telemetryDeviceId: $telemetryDeviceId, componentSerials: $componentSerials, imagePaths: $imagePaths, purchaseDate: $purchaseDate, warrantyExpiry: $warrantyExpiry, insuranceNumber: $insuranceNumber, odometer: $odometer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartRegistrationImpl &&
            (identical(other.vin, vin) || other.vin == vin) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.batteryType, batteryType) ||
                other.batteryType == batteryType) &&
            (identical(other.voltage, voltage) || other.voltage == voltage) &&
            (identical(other.seating, seating) || other.seating == seating) &&
            (identical(other.maxSpeed, maxSpeed) ||
                other.maxSpeed == maxSpeed) &&
            (identical(other.gpsTrackerId, gpsTrackerId) ||
                other.gpsTrackerId == gpsTrackerId) &&
            (identical(other.telemetryDeviceId, telemetryDeviceId) ||
                other.telemetryDeviceId == telemetryDeviceId) &&
            const DeepCollectionEquality()
                .equals(other._componentSerials, _componentSerials) &&
            const DeepCollectionEquality()
                .equals(other._imagePaths, _imagePaths) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate) &&
            (identical(other.warrantyExpiry, warrantyExpiry) ||
                other.warrantyExpiry == warrantyExpiry) &&
            (identical(other.insuranceNumber, insuranceNumber) ||
                other.insuranceNumber == insuranceNumber) &&
            (identical(other.odometer, odometer) ||
                other.odometer == odometer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      vin,
      manufacturer,
      model,
      year,
      color,
      batteryType,
      voltage,
      seating,
      maxSpeed,
      gpsTrackerId,
      telemetryDeviceId,
      const DeepCollectionEquality().hash(_componentSerials),
      const DeepCollectionEquality().hash(_imagePaths),
      purchaseDate,
      warrantyExpiry,
      insuranceNumber,
      odometer);

  /// Create a copy of CartRegistration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartRegistrationImplCopyWith<_$CartRegistrationImpl> get copyWith =>
      __$$CartRegistrationImplCopyWithImpl<_$CartRegistrationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartRegistrationImplToJson(
      this,
    );
  }
}

abstract class _CartRegistration implements CartRegistration {
  const factory _CartRegistration(
      {required final String vin,
      required final String manufacturer,
      required final String model,
      required final int year,
      final String? color,
      required final String batteryType,
      required final int voltage,
      required final int seating,
      final double? maxSpeed,
      final String? gpsTrackerId,
      final String? telemetryDeviceId,
      final Map<String, String>? componentSerials,
      final Map<String, String>? imagePaths,
      final DateTime? purchaseDate,
      final DateTime? warrantyExpiry,
      final String? insuranceNumber,
      final double? odometer}) = _$CartRegistrationImpl;

  factory _CartRegistration.fromJson(Map<String, dynamic> json) =
      _$CartRegistrationImpl.fromJson;

  @override
  String get vin;
  @override
  String get manufacturer;
  @override
  String get model;
  @override
  int get year;
  @override
  String? get color;
  @override
  String get batteryType;
  @override
  int get voltage;
  @override
  int get seating;
  @override
  double? get maxSpeed;
  @override
  String? get gpsTrackerId;
  @override
  String? get telemetryDeviceId;
  @override
  Map<String, String>? get componentSerials;
  @override
  Map<String, String>? get imagePaths;
  @override
  DateTime? get purchaseDate;
  @override
  DateTime? get warrantyExpiry;
  @override
  String? get insuranceNumber;
  @override
  double? get odometer;

  /// Create a copy of CartRegistration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartRegistrationImplCopyWith<_$CartRegistrationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CartFilter _$CartFilterFromJson(Map<String, dynamic> json) {
  return _CartFilter.fromJson(json);
}

/// @nodoc
mixin _$CartFilter {
  Set<CartStatus>? get statuses => throw _privateConstructorUsedError;
  String? get manufacturer => throw _privateConstructorUsedError;
  String? get model => throw _privateConstructorUsedError;
  double? get minBattery => throw _privateConstructorUsedError;
  double? get maxBattery => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;

  /// Serializes this CartFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartFilterCopyWith<CartFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartFilterCopyWith<$Res> {
  factory $CartFilterCopyWith(
          CartFilter value, $Res Function(CartFilter) then) =
      _$CartFilterCopyWithImpl<$Res, CartFilter>;
  @useResult
  $Res call(
      {Set<CartStatus>? statuses,
      String? manufacturer,
      String? model,
      double? minBattery,
      double? maxBattery,
      String? searchQuery});
}

/// @nodoc
class _$CartFilterCopyWithImpl<$Res, $Val extends CartFilter>
    implements $CartFilterCopyWith<$Res> {
  _$CartFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statuses = freezed,
    Object? manufacturer = freezed,
    Object? model = freezed,
    Object? minBattery = freezed,
    Object? maxBattery = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(_value.copyWith(
      statuses: freezed == statuses
          ? _value.statuses
          : statuses // ignore: cast_nullable_to_non_nullable
              as Set<CartStatus>?,
      manufacturer: freezed == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      minBattery: freezed == minBattery
          ? _value.minBattery
          : minBattery // ignore: cast_nullable_to_non_nullable
              as double?,
      maxBattery: freezed == maxBattery
          ? _value.maxBattery
          : maxBattery // ignore: cast_nullable_to_non_nullable
              as double?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartFilterImplCopyWith<$Res>
    implements $CartFilterCopyWith<$Res> {
  factory _$$CartFilterImplCopyWith(
          _$CartFilterImpl value, $Res Function(_$CartFilterImpl) then) =
      __$$CartFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Set<CartStatus>? statuses,
      String? manufacturer,
      String? model,
      double? minBattery,
      double? maxBattery,
      String? searchQuery});
}

/// @nodoc
class __$$CartFilterImplCopyWithImpl<$Res>
    extends _$CartFilterCopyWithImpl<$Res, _$CartFilterImpl>
    implements _$$CartFilterImplCopyWith<$Res> {
  __$$CartFilterImplCopyWithImpl(
      _$CartFilterImpl _value, $Res Function(_$CartFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statuses = freezed,
    Object? manufacturer = freezed,
    Object? model = freezed,
    Object? minBattery = freezed,
    Object? maxBattery = freezed,
    Object? searchQuery = freezed,
  }) {
    return _then(_$CartFilterImpl(
      statuses: freezed == statuses
          ? _value._statuses
          : statuses // ignore: cast_nullable_to_non_nullable
              as Set<CartStatus>?,
      manufacturer: freezed == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      minBattery: freezed == minBattery
          ? _value.minBattery
          : minBattery // ignore: cast_nullable_to_non_nullable
              as double?,
      maxBattery: freezed == maxBattery
          ? _value.maxBattery
          : maxBattery // ignore: cast_nullable_to_non_nullable
              as double?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CartFilterImpl implements _CartFilter {
  const _$CartFilterImpl(
      {final Set<CartStatus>? statuses,
      this.manufacturer,
      this.model,
      this.minBattery,
      this.maxBattery,
      this.searchQuery})
      : _statuses = statuses;

  factory _$CartFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartFilterImplFromJson(json);

  final Set<CartStatus>? _statuses;
  @override
  Set<CartStatus>? get statuses {
    final value = _statuses;
    if (value == null) return null;
    if (_statuses is EqualUnmodifiableSetView) return _statuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(value);
  }

  @override
  final String? manufacturer;
  @override
  final String? model;
  @override
  final double? minBattery;
  @override
  final double? maxBattery;
  @override
  final String? searchQuery;

  @override
  String toString() {
    return 'CartFilter(statuses: $statuses, manufacturer: $manufacturer, model: $model, minBattery: $minBattery, maxBattery: $maxBattery, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartFilterImpl &&
            const DeepCollectionEquality().equals(other._statuses, _statuses) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.minBattery, minBattery) ||
                other.minBattery == minBattery) &&
            (identical(other.maxBattery, maxBattery) ||
                other.maxBattery == maxBattery) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_statuses),
      manufacturer,
      model,
      minBattery,
      maxBattery,
      searchQuery);

  /// Create a copy of CartFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartFilterImplCopyWith<_$CartFilterImpl> get copyWith =>
      __$$CartFilterImplCopyWithImpl<_$CartFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartFilterImplToJson(
      this,
    );
  }
}

abstract class _CartFilter implements CartFilter {
  const factory _CartFilter(
      {final Set<CartStatus>? statuses,
      final String? manufacturer,
      final String? model,
      final double? minBattery,
      final double? maxBattery,
      final String? searchQuery}) = _$CartFilterImpl;

  factory _CartFilter.fromJson(Map<String, dynamic> json) =
      _$CartFilterImpl.fromJson;

  @override
  Set<CartStatus>? get statuses;
  @override
  String? get manufacturer;
  @override
  String? get model;
  @override
  double? get minBattery;
  @override
  double? get maxBattery;
  @override
  String? get searchQuery;

  /// Create a copy of CartFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartFilterImplCopyWith<_$CartFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
