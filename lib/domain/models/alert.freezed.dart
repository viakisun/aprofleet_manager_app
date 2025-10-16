// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Alert _$AlertFromJson(Map<String, dynamic> json) {
  return _Alert.fromJson(json);
}

/// @nodoc
mixin _$Alert {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  AlertSeverity get severity => throw _privateConstructorUsedError;
  Priority get priority => throw _privateConstructorUsedError;
  AlertState get state => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get cartId => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<AlertAction>? get actions => throw _privateConstructorUsedError;
  int? get escalationLevel => throw _privateConstructorUsedError;
  DateTime? get acknowledgedAt => throw _privateConstructorUsedError;
  String? get acknowledgedBy => throw _privateConstructorUsedError;
  String? get resolvedBy => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this Alert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertCopyWith<Alert> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertCopyWith<$Res> {
  factory $AlertCopyWith(Alert value, $Res Function(Alert) then) =
      _$AlertCopyWithImpl<$Res, Alert>;
  @useResult
  $Res call(
      {String id,
      String code,
      AlertSeverity severity,
      Priority priority,
      AlertState state,
      String title,
      String message,
      String? cartId,
      String? location,
      DateTime createdAt,
      DateTime updatedAt,
      List<AlertAction>? actions,
      int? escalationLevel,
      DateTime? acknowledgedAt,
      String? acknowledgedBy,
      String? resolvedBy,
      DateTime? resolvedAt,
      String? notes});
}

/// @nodoc
class _$AlertCopyWithImpl<$Res, $Val extends Alert>
    implements $AlertCopyWith<$Res> {
  _$AlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? severity = null,
    Object? priority = null,
    Object? state = null,
    Object? title = null,
    Object? message = null,
    Object? cartId = freezed,
    Object? location = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? actions = freezed,
    Object? escalationLevel = freezed,
    Object? acknowledgedAt = freezed,
    Object? acknowledgedBy = freezed,
    Object? resolvedBy = freezed,
    Object? resolvedAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as AlertSeverity,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as Priority,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as AlertState,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      cartId: freezed == cartId
          ? _value.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actions: freezed == actions
          ? _value.actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<AlertAction>?,
      escalationLevel: freezed == escalationLevel
          ? _value.escalationLevel
          : escalationLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      acknowledgedAt: freezed == acknowledgedAt
          ? _value.acknowledgedAt
          : acknowledgedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      acknowledgedBy: freezed == acknowledgedBy
          ? _value.acknowledgedBy
          : acknowledgedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      resolvedBy: freezed == resolvedBy
          ? _value.resolvedBy
          : resolvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlertImplCopyWith<$Res> implements $AlertCopyWith<$Res> {
  factory _$$AlertImplCopyWith(
          _$AlertImpl value, $Res Function(_$AlertImpl) then) =
      __$$AlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String code,
      AlertSeverity severity,
      Priority priority,
      AlertState state,
      String title,
      String message,
      String? cartId,
      String? location,
      DateTime createdAt,
      DateTime updatedAt,
      List<AlertAction>? actions,
      int? escalationLevel,
      DateTime? acknowledgedAt,
      String? acknowledgedBy,
      String? resolvedBy,
      DateTime? resolvedAt,
      String? notes});
}

/// @nodoc
class __$$AlertImplCopyWithImpl<$Res>
    extends _$AlertCopyWithImpl<$Res, _$AlertImpl>
    implements _$$AlertImplCopyWith<$Res> {
  __$$AlertImplCopyWithImpl(
      _$AlertImpl _value, $Res Function(_$AlertImpl) _then)
      : super(_value, _then);

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? severity = null,
    Object? priority = null,
    Object? state = null,
    Object? title = null,
    Object? message = null,
    Object? cartId = freezed,
    Object? location = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? actions = freezed,
    Object? escalationLevel = freezed,
    Object? acknowledgedAt = freezed,
    Object? acknowledgedBy = freezed,
    Object? resolvedBy = freezed,
    Object? resolvedAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$AlertImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as AlertSeverity,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as Priority,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as AlertState,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      cartId: freezed == cartId
          ? _value.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actions: freezed == actions
          ? _value._actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<AlertAction>?,
      escalationLevel: freezed == escalationLevel
          ? _value.escalationLevel
          : escalationLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      acknowledgedAt: freezed == acknowledgedAt
          ? _value.acknowledgedAt
          : acknowledgedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      acknowledgedBy: freezed == acknowledgedBy
          ? _value.acknowledgedBy
          : acknowledgedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      resolvedBy: freezed == resolvedBy
          ? _value.resolvedBy
          : resolvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertImpl implements _Alert {
  const _$AlertImpl(
      {required this.id,
      required this.code,
      required this.severity,
      required this.priority,
      required this.state,
      required this.title,
      required this.message,
      this.cartId,
      this.location,
      required this.createdAt,
      required this.updatedAt,
      final List<AlertAction>? actions,
      this.escalationLevel,
      this.acknowledgedAt,
      this.acknowledgedBy,
      this.resolvedBy,
      this.resolvedAt,
      this.notes})
      : _actions = actions;

  factory _$AlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final AlertSeverity severity;
  @override
  final Priority priority;
  @override
  final AlertState state;
  @override
  final String title;
  @override
  final String message;
  @override
  final String? cartId;
  @override
  final String? location;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<AlertAction>? _actions;
  @override
  List<AlertAction>? get actions {
    final value = _actions;
    if (value == null) return null;
    if (_actions is EqualUnmodifiableListView) return _actions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? escalationLevel;
  @override
  final DateTime? acknowledgedAt;
  @override
  final String? acknowledgedBy;
  @override
  final String? resolvedBy;
  @override
  final DateTime? resolvedAt;
  @override
  final String? notes;

  @override
  String toString() {
    return 'Alert(id: $id, code: $code, severity: $severity, priority: $priority, state: $state, title: $title, message: $message, cartId: $cartId, location: $location, createdAt: $createdAt, updatedAt: $updatedAt, actions: $actions, escalationLevel: $escalationLevel, acknowledgedAt: $acknowledgedAt, acknowledgedBy: $acknowledgedBy, resolvedBy: $resolvedBy, resolvedAt: $resolvedAt, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.cartId, cartId) || other.cartId == cartId) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._actions, _actions) &&
            (identical(other.escalationLevel, escalationLevel) ||
                other.escalationLevel == escalationLevel) &&
            (identical(other.acknowledgedAt, acknowledgedAt) ||
                other.acknowledgedAt == acknowledgedAt) &&
            (identical(other.acknowledgedBy, acknowledgedBy) ||
                other.acknowledgedBy == acknowledgedBy) &&
            (identical(other.resolvedBy, resolvedBy) ||
                other.resolvedBy == resolvedBy) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      code,
      severity,
      priority,
      state,
      title,
      message,
      cartId,
      location,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_actions),
      escalationLevel,
      acknowledgedAt,
      acknowledgedBy,
      resolvedBy,
      resolvedAt,
      notes);

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertImplCopyWith<_$AlertImpl> get copyWith =>
      __$$AlertImplCopyWithImpl<_$AlertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertImplToJson(
      this,
    );
  }
}

abstract class _Alert implements Alert {
  const factory _Alert(
      {required final String id,
      required final String code,
      required final AlertSeverity severity,
      required final Priority priority,
      required final AlertState state,
      required final String title,
      required final String message,
      final String? cartId,
      final String? location,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final List<AlertAction>? actions,
      final int? escalationLevel,
      final DateTime? acknowledgedAt,
      final String? acknowledgedBy,
      final String? resolvedBy,
      final DateTime? resolvedAt,
      final String? notes}) = _$AlertImpl;

  factory _Alert.fromJson(Map<String, dynamic> json) = _$AlertImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  AlertSeverity get severity;
  @override
  Priority get priority;
  @override
  AlertState get state;
  @override
  String get title;
  @override
  String get message;
  @override
  String? get cartId;
  @override
  String? get location;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  List<AlertAction>? get actions;
  @override
  int? get escalationLevel;
  @override
  DateTime? get acknowledgedAt;
  @override
  String? get acknowledgedBy;
  @override
  String? get resolvedBy;
  @override
  DateTime? get resolvedAt;
  @override
  String? get notes;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertImplCopyWith<_$AlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AlertAction _$AlertActionFromJson(Map<String, dynamic> json) {
  return _AlertAction.fromJson(json);
}

/// @nodoc
mixin _$AlertAction {
  String get type => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this AlertAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlertAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertActionCopyWith<AlertAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertActionCopyWith<$Res> {
  factory $AlertActionCopyWith(
          AlertAction value, $Res Function(AlertAction) then) =
      _$AlertActionCopyWithImpl<$Res, AlertAction>;
  @useResult
  $Res call(
      {String type,
      DateTime timestamp,
      String? userId,
      String? note,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$AlertActionCopyWithImpl<$Res, $Val extends AlertAction>
    implements $AlertActionCopyWith<$Res> {
  _$AlertActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? timestamp = null,
    Object? userId = freezed,
    Object? note = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlertActionImplCopyWith<$Res>
    implements $AlertActionCopyWith<$Res> {
  factory _$$AlertActionImplCopyWith(
          _$AlertActionImpl value, $Res Function(_$AlertActionImpl) then) =
      __$$AlertActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      DateTime timestamp,
      String? userId,
      String? note,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$AlertActionImplCopyWithImpl<$Res>
    extends _$AlertActionCopyWithImpl<$Res, _$AlertActionImpl>
    implements _$$AlertActionImplCopyWith<$Res> {
  __$$AlertActionImplCopyWithImpl(
      _$AlertActionImpl _value, $Res Function(_$AlertActionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AlertAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? timestamp = null,
    Object? userId = freezed,
    Object? note = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$AlertActionImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertActionImpl implements _AlertAction {
  const _$AlertActionImpl(
      {required this.type,
      required this.timestamp,
      this.userId,
      this.note,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$AlertActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertActionImplFromJson(json);

  @override
  final String type;
  @override
  final DateTime timestamp;
  @override
  final String? userId;
  @override
  final String? note;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'AlertAction(type: $type, timestamp: $timestamp, userId: $userId, note: $note, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertActionImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.note, note) || other.note == note) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, timestamp, userId, note,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of AlertAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertActionImplCopyWith<_$AlertActionImpl> get copyWith =>
      __$$AlertActionImplCopyWithImpl<_$AlertActionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertActionImplToJson(
      this,
    );
  }
}

abstract class _AlertAction implements AlertAction {
  const factory _AlertAction(
      {required final String type,
      required final DateTime timestamp,
      final String? userId,
      final String? note,
      final Map<String, dynamic>? metadata}) = _$AlertActionImpl;

  factory _AlertAction.fromJson(Map<String, dynamic> json) =
      _$AlertActionImpl.fromJson;

  @override
  String get type;
  @override
  DateTime get timestamp;
  @override
  String? get userId;
  @override
  String? get note;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of AlertAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertActionImplCopyWith<_$AlertActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AlertFilter _$AlertFilterFromJson(Map<String, dynamic> json) {
  return _AlertFilter.fromJson(json);
}

/// @nodoc
mixin _$AlertFilter {
  Set<AlertSeverity>? get severities => throw _privateConstructorUsedError;
  Set<AlertState>? get states => throw _privateConstructorUsedError;
  Set<Priority>? get priorities => throw _privateConstructorUsedError;
  Set<AlertSource>? get sources => throw _privateConstructorUsedError;
  String? get cartId => throw _privateConstructorUsedError;
  DateTime? get fromDate => throw _privateConstructorUsedError;
  DateTime? get toDate => throw _privateConstructorUsedError;
  bool? get unreadOnly => throw _privateConstructorUsedError;

  /// Serializes this AlertFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlertFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertFilterCopyWith<AlertFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertFilterCopyWith<$Res> {
  factory $AlertFilterCopyWith(
          AlertFilter value, $Res Function(AlertFilter) then) =
      _$AlertFilterCopyWithImpl<$Res, AlertFilter>;
  @useResult
  $Res call(
      {Set<AlertSeverity>? severities,
      Set<AlertState>? states,
      Set<Priority>? priorities,
      Set<AlertSource>? sources,
      String? cartId,
      DateTime? fromDate,
      DateTime? toDate,
      bool? unreadOnly});
}

/// @nodoc
class _$AlertFilterCopyWithImpl<$Res, $Val extends AlertFilter>
    implements $AlertFilterCopyWith<$Res> {
  _$AlertFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? severities = freezed,
    Object? states = freezed,
    Object? priorities = freezed,
    Object? sources = freezed,
    Object? cartId = freezed,
    Object? fromDate = freezed,
    Object? toDate = freezed,
    Object? unreadOnly = freezed,
  }) {
    return _then(_value.copyWith(
      severities: freezed == severities
          ? _value.severities
          : severities // ignore: cast_nullable_to_non_nullable
              as Set<AlertSeverity>?,
      states: freezed == states
          ? _value.states
          : states // ignore: cast_nullable_to_non_nullable
              as Set<AlertState>?,
      priorities: freezed == priorities
          ? _value.priorities
          : priorities // ignore: cast_nullable_to_non_nullable
              as Set<Priority>?,
      sources: freezed == sources
          ? _value.sources
          : sources // ignore: cast_nullable_to_non_nullable
              as Set<AlertSource>?,
      cartId: freezed == cartId
          ? _value.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as String?,
      fromDate: freezed == fromDate
          ? _value.fromDate
          : fromDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      toDate: freezed == toDate
          ? _value.toDate
          : toDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unreadOnly: freezed == unreadOnly
          ? _value.unreadOnly
          : unreadOnly // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlertFilterImplCopyWith<$Res>
    implements $AlertFilterCopyWith<$Res> {
  factory _$$AlertFilterImplCopyWith(
          _$AlertFilterImpl value, $Res Function(_$AlertFilterImpl) then) =
      __$$AlertFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Set<AlertSeverity>? severities,
      Set<AlertState>? states,
      Set<Priority>? priorities,
      Set<AlertSource>? sources,
      String? cartId,
      DateTime? fromDate,
      DateTime? toDate,
      bool? unreadOnly});
}

/// @nodoc
class __$$AlertFilterImplCopyWithImpl<$Res>
    extends _$AlertFilterCopyWithImpl<$Res, _$AlertFilterImpl>
    implements _$$AlertFilterImplCopyWith<$Res> {
  __$$AlertFilterImplCopyWithImpl(
      _$AlertFilterImpl _value, $Res Function(_$AlertFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of AlertFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? severities = freezed,
    Object? states = freezed,
    Object? priorities = freezed,
    Object? sources = freezed,
    Object? cartId = freezed,
    Object? fromDate = freezed,
    Object? toDate = freezed,
    Object? unreadOnly = freezed,
  }) {
    return _then(_$AlertFilterImpl(
      severities: freezed == severities
          ? _value._severities
          : severities // ignore: cast_nullable_to_non_nullable
              as Set<AlertSeverity>?,
      states: freezed == states
          ? _value._states
          : states // ignore: cast_nullable_to_non_nullable
              as Set<AlertState>?,
      priorities: freezed == priorities
          ? _value._priorities
          : priorities // ignore: cast_nullable_to_non_nullable
              as Set<Priority>?,
      sources: freezed == sources
          ? _value._sources
          : sources // ignore: cast_nullable_to_non_nullable
              as Set<AlertSource>?,
      cartId: freezed == cartId
          ? _value.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as String?,
      fromDate: freezed == fromDate
          ? _value.fromDate
          : fromDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      toDate: freezed == toDate
          ? _value.toDate
          : toDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unreadOnly: freezed == unreadOnly
          ? _value.unreadOnly
          : unreadOnly // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertFilterImpl implements _AlertFilter {
  const _$AlertFilterImpl(
      {final Set<AlertSeverity>? severities,
      final Set<AlertState>? states,
      final Set<Priority>? priorities,
      final Set<AlertSource>? sources,
      this.cartId,
      this.fromDate,
      this.toDate,
      this.unreadOnly})
      : _severities = severities,
        _states = states,
        _priorities = priorities,
        _sources = sources;

  factory _$AlertFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertFilterImplFromJson(json);

  final Set<AlertSeverity>? _severities;
  @override
  Set<AlertSeverity>? get severities {
    final value = _severities;
    if (value == null) return null;
    if (_severities is EqualUnmodifiableSetView) return _severities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(value);
  }

  final Set<AlertState>? _states;
  @override
  Set<AlertState>? get states {
    final value = _states;
    if (value == null) return null;
    if (_states is EqualUnmodifiableSetView) return _states;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(value);
  }

  final Set<Priority>? _priorities;
  @override
  Set<Priority>? get priorities {
    final value = _priorities;
    if (value == null) return null;
    if (_priorities is EqualUnmodifiableSetView) return _priorities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(value);
  }

  final Set<AlertSource>? _sources;
  @override
  Set<AlertSource>? get sources {
    final value = _sources;
    if (value == null) return null;
    if (_sources is EqualUnmodifiableSetView) return _sources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(value);
  }

  @override
  final String? cartId;
  @override
  final DateTime? fromDate;
  @override
  final DateTime? toDate;
  @override
  final bool? unreadOnly;

  @override
  String toString() {
    return 'AlertFilter(severities: $severities, states: $states, priorities: $priorities, sources: $sources, cartId: $cartId, fromDate: $fromDate, toDate: $toDate, unreadOnly: $unreadOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertFilterImpl &&
            const DeepCollectionEquality()
                .equals(other._severities, _severities) &&
            const DeepCollectionEquality().equals(other._states, _states) &&
            const DeepCollectionEquality()
                .equals(other._priorities, _priorities) &&
            const DeepCollectionEquality().equals(other._sources, _sources) &&
            (identical(other.cartId, cartId) || other.cartId == cartId) &&
            (identical(other.fromDate, fromDate) ||
                other.fromDate == fromDate) &&
            (identical(other.toDate, toDate) || other.toDate == toDate) &&
            (identical(other.unreadOnly, unreadOnly) ||
                other.unreadOnly == unreadOnly));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_severities),
      const DeepCollectionEquality().hash(_states),
      const DeepCollectionEquality().hash(_priorities),
      const DeepCollectionEquality().hash(_sources),
      cartId,
      fromDate,
      toDate,
      unreadOnly);

  /// Create a copy of AlertFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertFilterImplCopyWith<_$AlertFilterImpl> get copyWith =>
      __$$AlertFilterImplCopyWithImpl<_$AlertFilterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertFilterImplToJson(
      this,
    );
  }
}

abstract class _AlertFilter implements AlertFilter {
  const factory _AlertFilter(
      {final Set<AlertSeverity>? severities,
      final Set<AlertState>? states,
      final Set<Priority>? priorities,
      final Set<AlertSource>? sources,
      final String? cartId,
      final DateTime? fromDate,
      final DateTime? toDate,
      final bool? unreadOnly}) = _$AlertFilterImpl;

  factory _AlertFilter.fromJson(Map<String, dynamic> json) =
      _$AlertFilterImpl.fromJson;

  @override
  Set<AlertSeverity>? get severities;
  @override
  Set<AlertState>? get states;
  @override
  Set<Priority>? get priorities;
  @override
  Set<AlertSource>? get sources;
  @override
  String? get cartId;
  @override
  DateTime? get fromDate;
  @override
  DateTime? get toDate;
  @override
  bool? get unreadOnly;

  /// Create a copy of AlertFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertFilterImplCopyWith<_$AlertFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AlertRules _$AlertRulesFromJson(Map<String, dynamic> json) {
  return _AlertRules.fromJson(json);
}

/// @nodoc
mixin _$AlertRules {
  Map<AlertSource, AlertRule> get rules => throw _privateConstructorUsedError;
  bool get notificationsEnabled => throw _privateConstructorUsedError;
  Map<Priority, Duration> get slaResponse => throw _privateConstructorUsedError;
  Map<Priority, Duration> get slaResolution =>
      throw _privateConstructorUsedError;

  /// Serializes this AlertRules to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlertRules
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertRulesCopyWith<AlertRules> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertRulesCopyWith<$Res> {
  factory $AlertRulesCopyWith(
          AlertRules value, $Res Function(AlertRules) then) =
      _$AlertRulesCopyWithImpl<$Res, AlertRules>;
  @useResult
  $Res call(
      {Map<AlertSource, AlertRule> rules,
      bool notificationsEnabled,
      Map<Priority, Duration> slaResponse,
      Map<Priority, Duration> slaResolution});
}

/// @nodoc
class _$AlertRulesCopyWithImpl<$Res, $Val extends AlertRules>
    implements $AlertRulesCopyWith<$Res> {
  _$AlertRulesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertRules
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rules = null,
    Object? notificationsEnabled = null,
    Object? slaResponse = null,
    Object? slaResolution = null,
  }) {
    return _then(_value.copyWith(
      rules: null == rules
          ? _value.rules
          : rules // ignore: cast_nullable_to_non_nullable
              as Map<AlertSource, AlertRule>,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      slaResponse: null == slaResponse
          ? _value.slaResponse
          : slaResponse // ignore: cast_nullable_to_non_nullable
              as Map<Priority, Duration>,
      slaResolution: null == slaResolution
          ? _value.slaResolution
          : slaResolution // ignore: cast_nullable_to_non_nullable
              as Map<Priority, Duration>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlertRulesImplCopyWith<$Res>
    implements $AlertRulesCopyWith<$Res> {
  factory _$$AlertRulesImplCopyWith(
          _$AlertRulesImpl value, $Res Function(_$AlertRulesImpl) then) =
      __$$AlertRulesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<AlertSource, AlertRule> rules,
      bool notificationsEnabled,
      Map<Priority, Duration> slaResponse,
      Map<Priority, Duration> slaResolution});
}

/// @nodoc
class __$$AlertRulesImplCopyWithImpl<$Res>
    extends _$AlertRulesCopyWithImpl<$Res, _$AlertRulesImpl>
    implements _$$AlertRulesImplCopyWith<$Res> {
  __$$AlertRulesImplCopyWithImpl(
      _$AlertRulesImpl _value, $Res Function(_$AlertRulesImpl) _then)
      : super(_value, _then);

  /// Create a copy of AlertRules
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rules = null,
    Object? notificationsEnabled = null,
    Object? slaResponse = null,
    Object? slaResolution = null,
  }) {
    return _then(_$AlertRulesImpl(
      rules: null == rules
          ? _value._rules
          : rules // ignore: cast_nullable_to_non_nullable
              as Map<AlertSource, AlertRule>,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      slaResponse: null == slaResponse
          ? _value._slaResponse
          : slaResponse // ignore: cast_nullable_to_non_nullable
              as Map<Priority, Duration>,
      slaResolution: null == slaResolution
          ? _value._slaResolution
          : slaResolution // ignore: cast_nullable_to_non_nullable
              as Map<Priority, Duration>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertRulesImpl implements _AlertRules {
  const _$AlertRulesImpl(
      {required final Map<AlertSource, AlertRule> rules,
      required this.notificationsEnabled,
      required final Map<Priority, Duration> slaResponse,
      required final Map<Priority, Duration> slaResolution})
      : _rules = rules,
        _slaResponse = slaResponse,
        _slaResolution = slaResolution;

  factory _$AlertRulesImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertRulesImplFromJson(json);

  final Map<AlertSource, AlertRule> _rules;
  @override
  Map<AlertSource, AlertRule> get rules {
    if (_rules is EqualUnmodifiableMapView) return _rules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_rules);
  }

  @override
  final bool notificationsEnabled;
  final Map<Priority, Duration> _slaResponse;
  @override
  Map<Priority, Duration> get slaResponse {
    if (_slaResponse is EqualUnmodifiableMapView) return _slaResponse;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_slaResponse);
  }

  final Map<Priority, Duration> _slaResolution;
  @override
  Map<Priority, Duration> get slaResolution {
    if (_slaResolution is EqualUnmodifiableMapView) return _slaResolution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_slaResolution);
  }

  @override
  String toString() {
    return 'AlertRules(rules: $rules, notificationsEnabled: $notificationsEnabled, slaResponse: $slaResponse, slaResolution: $slaResolution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertRulesImpl &&
            const DeepCollectionEquality().equals(other._rules, _rules) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            const DeepCollectionEquality()
                .equals(other._slaResponse, _slaResponse) &&
            const DeepCollectionEquality()
                .equals(other._slaResolution, _slaResolution));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_rules),
      notificationsEnabled,
      const DeepCollectionEquality().hash(_slaResponse),
      const DeepCollectionEquality().hash(_slaResolution));

  /// Create a copy of AlertRules
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertRulesImplCopyWith<_$AlertRulesImpl> get copyWith =>
      __$$AlertRulesImplCopyWithImpl<_$AlertRulesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertRulesImplToJson(
      this,
    );
  }
}

abstract class _AlertRules implements AlertRules {
  const factory _AlertRules(
      {required final Map<AlertSource, AlertRule> rules,
      required final bool notificationsEnabled,
      required final Map<Priority, Duration> slaResponse,
      required final Map<Priority, Duration> slaResolution}) = _$AlertRulesImpl;

  factory _AlertRules.fromJson(Map<String, dynamic> json) =
      _$AlertRulesImpl.fromJson;

  @override
  Map<AlertSource, AlertRule> get rules;
  @override
  bool get notificationsEnabled;
  @override
  Map<Priority, Duration> get slaResponse;
  @override
  Map<Priority, Duration> get slaResolution;

  /// Create a copy of AlertRules
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertRulesImplCopyWith<_$AlertRulesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AlertRule _$AlertRuleFromJson(Map<String, dynamic> json) {
  return _AlertRule.fromJson(json);
}

/// @nodoc
mixin _$AlertRule {
  bool get enabled => throw _privateConstructorUsedError;
  double get threshold => throw _privateConstructorUsedError;
  AlertSeverity get severity => throw _privateConstructorUsedError;
  Priority get priority => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this AlertRule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlertRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertRuleCopyWith<AlertRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertRuleCopyWith<$Res> {
  factory $AlertRuleCopyWith(AlertRule value, $Res Function(AlertRule) then) =
      _$AlertRuleCopyWithImpl<$Res, AlertRule>;
  @useResult
  $Res call(
      {bool enabled,
      double threshold,
      AlertSeverity severity,
      Priority priority,
      String? message});
}

/// @nodoc
class _$AlertRuleCopyWithImpl<$Res, $Val extends AlertRule>
    implements $AlertRuleCopyWith<$Res> {
  _$AlertRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlertRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? threshold = null,
    Object? severity = null,
    Object? priority = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      threshold: null == threshold
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as double,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as AlertSeverity,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as Priority,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlertRuleImplCopyWith<$Res>
    implements $AlertRuleCopyWith<$Res> {
  factory _$$AlertRuleImplCopyWith(
          _$AlertRuleImpl value, $Res Function(_$AlertRuleImpl) then) =
      __$$AlertRuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enabled,
      double threshold,
      AlertSeverity severity,
      Priority priority,
      String? message});
}

/// @nodoc
class __$$AlertRuleImplCopyWithImpl<$Res>
    extends _$AlertRuleCopyWithImpl<$Res, _$AlertRuleImpl>
    implements _$$AlertRuleImplCopyWith<$Res> {
  __$$AlertRuleImplCopyWithImpl(
      _$AlertRuleImpl _value, $Res Function(_$AlertRuleImpl) _then)
      : super(_value, _then);

  /// Create a copy of AlertRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? threshold = null,
    Object? severity = null,
    Object? priority = null,
    Object? message = freezed,
  }) {
    return _then(_$AlertRuleImpl(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      threshold: null == threshold
          ? _value.threshold
          : threshold // ignore: cast_nullable_to_non_nullable
              as double,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as AlertSeverity,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as Priority,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertRuleImpl implements _AlertRule {
  const _$AlertRuleImpl(
      {required this.enabled,
      required this.threshold,
      required this.severity,
      required this.priority,
      this.message});

  factory _$AlertRuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertRuleImplFromJson(json);

  @override
  final bool enabled;
  @override
  final double threshold;
  @override
  final AlertSeverity severity;
  @override
  final Priority priority;
  @override
  final String? message;

  @override
  String toString() {
    return 'AlertRule(enabled: $enabled, threshold: $threshold, severity: $severity, priority: $priority, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertRuleImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, enabled, threshold, severity, priority, message);

  /// Create a copy of AlertRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertRuleImplCopyWith<_$AlertRuleImpl> get copyWith =>
      __$$AlertRuleImplCopyWithImpl<_$AlertRuleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertRuleImplToJson(
      this,
    );
  }
}

abstract class _AlertRule implements AlertRule {
  const factory _AlertRule(
      {required final bool enabled,
      required final double threshold,
      required final AlertSeverity severity,
      required final Priority priority,
      final String? message}) = _$AlertRuleImpl;

  factory _AlertRule.fromJson(Map<String, dynamic> json) =
      _$AlertRuleImpl.fromJson;

  @override
  bool get enabled;
  @override
  double get threshold;
  @override
  AlertSeverity get severity;
  @override
  Priority get priority;
  @override
  String? get message;

  /// Create a copy of AlertRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertRuleImplCopyWith<_$AlertRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
