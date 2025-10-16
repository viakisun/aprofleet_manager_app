// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kpi.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Kpi _$KpiFromJson(Map<String, dynamic> json) {
  return _Kpi.fromJson(json);
}

/// @nodoc
mixin _$Kpi {
  double get availabilityRate => throw _privateConstructorUsedError;
  double get mttr => throw _privateConstructorUsedError;
  double get utilization => throw _privateConstructorUsedError;
  double get dailyDistance => throw _privateConstructorUsedError;
  KpiTrendDirection get trend => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this Kpi to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Kpi
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KpiCopyWith<Kpi> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KpiCopyWith<$Res> {
  factory $KpiCopyWith(Kpi value, $Res Function(Kpi) then) =
      _$KpiCopyWithImpl<$Res, Kpi>;
  @useResult
  $Res call(
      {double availabilityRate,
      double mttr,
      double utilization,
      double dailyDistance,
      KpiTrendDirection trend,
      DateTime lastUpdated});
}

/// @nodoc
class _$KpiCopyWithImpl<$Res, $Val extends Kpi> implements $KpiCopyWith<$Res> {
  _$KpiCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Kpi
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availabilityRate = null,
    Object? mttr = null,
    Object? utilization = null,
    Object? dailyDistance = null,
    Object? trend = null,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      availabilityRate: null == availabilityRate
          ? _value.availabilityRate
          : availabilityRate // ignore: cast_nullable_to_non_nullable
              as double,
      mttr: null == mttr
          ? _value.mttr
          : mttr // ignore: cast_nullable_to_non_nullable
              as double,
      utilization: null == utilization
          ? _value.utilization
          : utilization // ignore: cast_nullable_to_non_nullable
              as double,
      dailyDistance: null == dailyDistance
          ? _value.dailyDistance
          : dailyDistance // ignore: cast_nullable_to_non_nullable
              as double,
      trend: null == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as KpiTrendDirection,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KpiImplCopyWith<$Res> implements $KpiCopyWith<$Res> {
  factory _$$KpiImplCopyWith(_$KpiImpl value, $Res Function(_$KpiImpl) then) =
      __$$KpiImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double availabilityRate,
      double mttr,
      double utilization,
      double dailyDistance,
      KpiTrendDirection trend,
      DateTime lastUpdated});
}

/// @nodoc
class __$$KpiImplCopyWithImpl<$Res> extends _$KpiCopyWithImpl<$Res, _$KpiImpl>
    implements _$$KpiImplCopyWith<$Res> {
  __$$KpiImplCopyWithImpl(_$KpiImpl _value, $Res Function(_$KpiImpl) _then)
      : super(_value, _then);

  /// Create a copy of Kpi
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availabilityRate = null,
    Object? mttr = null,
    Object? utilization = null,
    Object? dailyDistance = null,
    Object? trend = null,
    Object? lastUpdated = null,
  }) {
    return _then(_$KpiImpl(
      availabilityRate: null == availabilityRate
          ? _value.availabilityRate
          : availabilityRate // ignore: cast_nullable_to_non_nullable
              as double,
      mttr: null == mttr
          ? _value.mttr
          : mttr // ignore: cast_nullable_to_non_nullable
              as double,
      utilization: null == utilization
          ? _value.utilization
          : utilization // ignore: cast_nullable_to_non_nullable
              as double,
      dailyDistance: null == dailyDistance
          ? _value.dailyDistance
          : dailyDistance // ignore: cast_nullable_to_non_nullable
              as double,
      trend: null == trend
          ? _value.trend
          : trend // ignore: cast_nullable_to_non_nullable
              as KpiTrendDirection,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KpiImpl implements _Kpi {
  const _$KpiImpl(
      {required this.availabilityRate,
      required this.mttr,
      required this.utilization,
      required this.dailyDistance,
      required this.trend,
      required this.lastUpdated});

  factory _$KpiImpl.fromJson(Map<String, dynamic> json) =>
      _$$KpiImplFromJson(json);

  @override
  final double availabilityRate;
  @override
  final double mttr;
  @override
  final double utilization;
  @override
  final double dailyDistance;
  @override
  final KpiTrendDirection trend;
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'Kpi(availabilityRate: $availabilityRate, mttr: $mttr, utilization: $utilization, dailyDistance: $dailyDistance, trend: $trend, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KpiImpl &&
            (identical(other.availabilityRate, availabilityRate) ||
                other.availabilityRate == availabilityRate) &&
            (identical(other.mttr, mttr) || other.mttr == mttr) &&
            (identical(other.utilization, utilization) ||
                other.utilization == utilization) &&
            (identical(other.dailyDistance, dailyDistance) ||
                other.dailyDistance == dailyDistance) &&
            (identical(other.trend, trend) || other.trend == trend) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, availabilityRate, mttr,
      utilization, dailyDistance, trend, lastUpdated);

  /// Create a copy of Kpi
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KpiImplCopyWith<_$KpiImpl> get copyWith =>
      __$$KpiImplCopyWithImpl<_$KpiImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KpiImplToJson(
      this,
    );
  }
}

abstract class _Kpi implements Kpi {
  const factory _Kpi(
      {required final double availabilityRate,
      required final double mttr,
      required final double utilization,
      required final double dailyDistance,
      required final KpiTrendDirection trend,
      required final DateTime lastUpdated}) = _$KpiImpl;

  factory _Kpi.fromJson(Map<String, dynamic> json) = _$KpiImpl.fromJson;

  @override
  double get availabilityRate;
  @override
  double get mttr;
  @override
  double get utilization;
  @override
  double get dailyDistance;
  @override
  KpiTrendDirection get trend;
  @override
  DateTime get lastUpdated;

  /// Create a copy of Kpi
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KpiImplCopyWith<_$KpiImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

KpiTrend _$KpiTrendFromJson(Map<String, dynamic> json) {
  return _KpiTrend.fromJson(json);
}

/// @nodoc
mixin _$KpiTrend {
  double get availabilityChange => throw _privateConstructorUsedError;
  double get mttrChange => throw _privateConstructorUsedError;
  double get utilizationChange => throw _privateConstructorUsedError;
  double get distanceChange => throw _privateConstructorUsedError;

  /// Serializes this KpiTrend to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KpiTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KpiTrendCopyWith<KpiTrend> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KpiTrendCopyWith<$Res> {
  factory $KpiTrendCopyWith(KpiTrend value, $Res Function(KpiTrend) then) =
      _$KpiTrendCopyWithImpl<$Res, KpiTrend>;
  @useResult
  $Res call(
      {double availabilityChange,
      double mttrChange,
      double utilizationChange,
      double distanceChange});
}

/// @nodoc
class _$KpiTrendCopyWithImpl<$Res, $Val extends KpiTrend>
    implements $KpiTrendCopyWith<$Res> {
  _$KpiTrendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KpiTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availabilityChange = null,
    Object? mttrChange = null,
    Object? utilizationChange = null,
    Object? distanceChange = null,
  }) {
    return _then(_value.copyWith(
      availabilityChange: null == availabilityChange
          ? _value.availabilityChange
          : availabilityChange // ignore: cast_nullable_to_non_nullable
              as double,
      mttrChange: null == mttrChange
          ? _value.mttrChange
          : mttrChange // ignore: cast_nullable_to_non_nullable
              as double,
      utilizationChange: null == utilizationChange
          ? _value.utilizationChange
          : utilizationChange // ignore: cast_nullable_to_non_nullable
              as double,
      distanceChange: null == distanceChange
          ? _value.distanceChange
          : distanceChange // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KpiTrendImplCopyWith<$Res>
    implements $KpiTrendCopyWith<$Res> {
  factory _$$KpiTrendImplCopyWith(
          _$KpiTrendImpl value, $Res Function(_$KpiTrendImpl) then) =
      __$$KpiTrendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double availabilityChange,
      double mttrChange,
      double utilizationChange,
      double distanceChange});
}

/// @nodoc
class __$$KpiTrendImplCopyWithImpl<$Res>
    extends _$KpiTrendCopyWithImpl<$Res, _$KpiTrendImpl>
    implements _$$KpiTrendImplCopyWith<$Res> {
  __$$KpiTrendImplCopyWithImpl(
      _$KpiTrendImpl _value, $Res Function(_$KpiTrendImpl) _then)
      : super(_value, _then);

  /// Create a copy of KpiTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availabilityChange = null,
    Object? mttrChange = null,
    Object? utilizationChange = null,
    Object? distanceChange = null,
  }) {
    return _then(_$KpiTrendImpl(
      availabilityChange: null == availabilityChange
          ? _value.availabilityChange
          : availabilityChange // ignore: cast_nullable_to_non_nullable
              as double,
      mttrChange: null == mttrChange
          ? _value.mttrChange
          : mttrChange // ignore: cast_nullable_to_non_nullable
              as double,
      utilizationChange: null == utilizationChange
          ? _value.utilizationChange
          : utilizationChange // ignore: cast_nullable_to_non_nullable
              as double,
      distanceChange: null == distanceChange
          ? _value.distanceChange
          : distanceChange // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KpiTrendImpl implements _KpiTrend {
  const _$KpiTrendImpl(
      {required this.availabilityChange,
      required this.mttrChange,
      required this.utilizationChange,
      required this.distanceChange});

  factory _$KpiTrendImpl.fromJson(Map<String, dynamic> json) =>
      _$$KpiTrendImplFromJson(json);

  @override
  final double availabilityChange;
  @override
  final double mttrChange;
  @override
  final double utilizationChange;
  @override
  final double distanceChange;

  @override
  String toString() {
    return 'KpiTrend(availabilityChange: $availabilityChange, mttrChange: $mttrChange, utilizationChange: $utilizationChange, distanceChange: $distanceChange)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KpiTrendImpl &&
            (identical(other.availabilityChange, availabilityChange) ||
                other.availabilityChange == availabilityChange) &&
            (identical(other.mttrChange, mttrChange) ||
                other.mttrChange == mttrChange) &&
            (identical(other.utilizationChange, utilizationChange) ||
                other.utilizationChange == utilizationChange) &&
            (identical(other.distanceChange, distanceChange) ||
                other.distanceChange == distanceChange));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, availabilityChange, mttrChange,
      utilizationChange, distanceChange);

  /// Create a copy of KpiTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KpiTrendImplCopyWith<_$KpiTrendImpl> get copyWith =>
      __$$KpiTrendImplCopyWithImpl<_$KpiTrendImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KpiTrendImplToJson(
      this,
    );
  }
}

abstract class _KpiTrend implements KpiTrend {
  const factory _KpiTrend(
      {required final double availabilityChange,
      required final double mttrChange,
      required final double utilizationChange,
      required final double distanceChange}) = _$KpiTrendImpl;

  factory _KpiTrend.fromJson(Map<String, dynamic> json) =
      _$KpiTrendImpl.fromJson;

  @override
  double get availabilityChange;
  @override
  double get mttrChange;
  @override
  double get utilizationChange;
  @override
  double get distanceChange;

  /// Create a copy of KpiTrend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KpiTrendImplCopyWith<_$KpiTrendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
