// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WoPart _$WoPartFromJson(Map<String, dynamic> json) {
  return _WoPart.fromJson(json);
}

/// @nodoc
mixin _$WoPart {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this WoPart to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WoPart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WoPartCopyWith<WoPart> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WoPartCopyWith<$Res> {
  factory $WoPartCopyWith(WoPart value, $Res Function(WoPart) then) =
      _$WoPartCopyWithImpl<$Res, WoPart>;
  @useResult
  $Res call({String id, String name, int quantity, String? notes});
}

/// @nodoc
class _$WoPartCopyWithImpl<$Res, $Val extends WoPart>
    implements $WoPartCopyWith<$Res> {
  _$WoPartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WoPart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? quantity = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WoPartImplCopyWith<$Res> implements $WoPartCopyWith<$Res> {
  factory _$$WoPartImplCopyWith(
          _$WoPartImpl value, $Res Function(_$WoPartImpl) then) =
      __$$WoPartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, int quantity, String? notes});
}

/// @nodoc
class __$$WoPartImplCopyWithImpl<$Res>
    extends _$WoPartCopyWithImpl<$Res, _$WoPartImpl>
    implements _$$WoPartImplCopyWith<$Res> {
  __$$WoPartImplCopyWithImpl(
      _$WoPartImpl _value, $Res Function(_$WoPartImpl) _then)
      : super(_value, _then);

  /// Create a copy of WoPart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? quantity = null,
    Object? notes = freezed,
  }) {
    return _then(_$WoPartImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WoPartImpl implements _WoPart {
  const _$WoPartImpl(
      {required this.id,
      required this.name,
      required this.quantity,
      this.notes});

  factory _$WoPartImpl.fromJson(Map<String, dynamic> json) =>
      _$$WoPartImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int quantity;
  @override
  final String? notes;

  @override
  String toString() {
    return 'WoPart(id: $id, name: $name, quantity: $quantity, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WoPartImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, quantity, notes);

  /// Create a copy of WoPart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WoPartImplCopyWith<_$WoPartImpl> get copyWith =>
      __$$WoPartImplCopyWithImpl<_$WoPartImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WoPartImplToJson(
      this,
    );
  }
}

abstract class _WoPart implements WoPart {
  const factory _WoPart(
      {required final String id,
      required final String name,
      required final int quantity,
      final String? notes}) = _$WoPartImpl;

  factory _WoPart.fromJson(Map<String, dynamic> json) = _$WoPartImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get quantity;
  @override
  String? get notes;

  /// Create a copy of WoPart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WoPartImplCopyWith<_$WoPartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkOrder _$WorkOrderFromJson(Map<String, dynamic> json) {
  return _WorkOrder.fromJson(json);
}

/// @nodoc
mixin _$WorkOrder {
  String get id => throw _privateConstructorUsedError;
  WorkOrderType get type => throw _privateConstructorUsedError;
  Priority get priority => throw _privateConstructorUsedError;
  String get cartId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  WorkOrderStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String? get technician => throw _privateConstructorUsedError;
  List<WoPart>? get parts => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this WorkOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkOrderCopyWith<WorkOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkOrderCopyWith<$Res> {
  factory $WorkOrderCopyWith(WorkOrder value, $Res Function(WorkOrder) then) =
      _$WorkOrderCopyWithImpl<$Res, WorkOrder>;
  @useResult
  $Res call(
      {String id,
      WorkOrderType type,
      Priority priority,
      String cartId,
      String description,
      WorkOrderStatus status,
      DateTime createdAt,
      DateTime? startedAt,
      DateTime? completedAt,
      String? technician,
      List<WoPart>? parts,
      String? location,
      String? notes});
}

/// @nodoc
class _$WorkOrderCopyWithImpl<$Res, $Val extends WorkOrder>
    implements $WorkOrderCopyWith<$Res> {
  _$WorkOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? priority = null,
    Object? cartId = null,
    Object? description = null,
    Object? status = null,
    Object? createdAt = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? technician = freezed,
    Object? parts = freezed,
    Object? location = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as WorkOrderType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as Priority,
      cartId: null == cartId
          ? _value.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as WorkOrderStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      technician: freezed == technician
          ? _value.technician
          : technician // ignore: cast_nullable_to_non_nullable
              as String?,
      parts: freezed == parts
          ? _value.parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<WoPart>?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkOrderImplCopyWith<$Res>
    implements $WorkOrderCopyWith<$Res> {
  factory _$$WorkOrderImplCopyWith(
          _$WorkOrderImpl value, $Res Function(_$WorkOrderImpl) then) =
      __$$WorkOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      WorkOrderType type,
      Priority priority,
      String cartId,
      String description,
      WorkOrderStatus status,
      DateTime createdAt,
      DateTime? startedAt,
      DateTime? completedAt,
      String? technician,
      List<WoPart>? parts,
      String? location,
      String? notes});
}

/// @nodoc
class __$$WorkOrderImplCopyWithImpl<$Res>
    extends _$WorkOrderCopyWithImpl<$Res, _$WorkOrderImpl>
    implements _$$WorkOrderImplCopyWith<$Res> {
  __$$WorkOrderImplCopyWithImpl(
      _$WorkOrderImpl _value, $Res Function(_$WorkOrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? priority = null,
    Object? cartId = null,
    Object? description = null,
    Object? status = null,
    Object? createdAt = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? technician = freezed,
    Object? parts = freezed,
    Object? location = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$WorkOrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as WorkOrderType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as Priority,
      cartId: null == cartId
          ? _value.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as WorkOrderStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      technician: freezed == technician
          ? _value.technician
          : technician // ignore: cast_nullable_to_non_nullable
              as String?,
      parts: freezed == parts
          ? _value._parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<WoPart>?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkOrderImpl implements _WorkOrder {
  const _$WorkOrderImpl(
      {required this.id,
      required this.type,
      required this.priority,
      required this.cartId,
      required this.description,
      required this.status,
      required this.createdAt,
      this.startedAt,
      this.completedAt,
      this.technician,
      final List<WoPart>? parts,
      this.location,
      this.notes})
      : _parts = parts;

  factory _$WorkOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkOrderImplFromJson(json);

  @override
  final String id;
  @override
  final WorkOrderType type;
  @override
  final Priority priority;
  @override
  final String cartId;
  @override
  final String description;
  @override
  final WorkOrderStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? completedAt;
  @override
  final String? technician;
  final List<WoPart>? _parts;
  @override
  List<WoPart>? get parts {
    final value = _parts;
    if (value == null) return null;
    if (_parts is EqualUnmodifiableListView) return _parts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? location;
  @override
  final String? notes;

  @override
  String toString() {
    return 'WorkOrder(id: $id, type: $type, priority: $priority, cartId: $cartId, description: $description, status: $status, createdAt: $createdAt, startedAt: $startedAt, completedAt: $completedAt, technician: $technician, parts: $parts, location: $location, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkOrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.cartId, cartId) || other.cartId == cartId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.technician, technician) ||
                other.technician == technician) &&
            const DeepCollectionEquality().equals(other._parts, _parts) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      priority,
      cartId,
      description,
      status,
      createdAt,
      startedAt,
      completedAt,
      technician,
      const DeepCollectionEquality().hash(_parts),
      location,
      notes);

  /// Create a copy of WorkOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkOrderImplCopyWith<_$WorkOrderImpl> get copyWith =>
      __$$WorkOrderImplCopyWithImpl<_$WorkOrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkOrderImplToJson(
      this,
    );
  }
}

abstract class _WorkOrder implements WorkOrder {
  const factory _WorkOrder(
      {required final String id,
      required final WorkOrderType type,
      required final Priority priority,
      required final String cartId,
      required final String description,
      required final WorkOrderStatus status,
      required final DateTime createdAt,
      final DateTime? startedAt,
      final DateTime? completedAt,
      final String? technician,
      final List<WoPart>? parts,
      final String? location,
      final String? notes}) = _$WorkOrderImpl;

  factory _WorkOrder.fromJson(Map<String, dynamic> json) =
      _$WorkOrderImpl.fromJson;

  @override
  String get id;
  @override
  WorkOrderType get type;
  @override
  Priority get priority;
  @override
  String get cartId;
  @override
  String get description;
  @override
  WorkOrderStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get startedAt;
  @override
  DateTime? get completedAt;
  @override
  String? get technician;
  @override
  List<WoPart>? get parts;
  @override
  String? get location;
  @override
  String? get notes;

  /// Create a copy of WorkOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkOrderImplCopyWith<_$WorkOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkOrderDraft _$WorkOrderDraftFromJson(Map<String, dynamic> json) {
  return _WorkOrderDraft.fromJson(json);
}

/// @nodoc
mixin _$WorkOrderDraft {
  WorkOrderType get type => throw _privateConstructorUsedError;
  Priority get priority => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get cartId => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  DateTime? get scheduledAt => throw _privateConstructorUsedError;
  Duration? get estimatedDuration => throw _privateConstructorUsedError;
  String? get technician => throw _privateConstructorUsedError;
  List<WoPart>? get parts => throw _privateConstructorUsedError;
  Map<String, bool>? get checklist => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this WorkOrderDraft to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkOrderDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkOrderDraftCopyWith<WorkOrderDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkOrderDraftCopyWith<$Res> {
  factory $WorkOrderDraftCopyWith(
          WorkOrderDraft value, $Res Function(WorkOrderDraft) then) =
      _$WorkOrderDraftCopyWithImpl<$Res, WorkOrderDraft>;
  @useResult
  $Res call(
      {WorkOrderType type,
      Priority priority,
      String description,
      String cartId,
      String? location,
      DateTime? scheduledAt,
      Duration? estimatedDuration,
      String? technician,
      List<WoPart>? parts,
      Map<String, bool>? checklist,
      String? notes});
}

/// @nodoc
class _$WorkOrderDraftCopyWithImpl<$Res, $Val extends WorkOrderDraft>
    implements $WorkOrderDraftCopyWith<$Res> {
  _$WorkOrderDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkOrderDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? priority = null,
    Object? description = null,
    Object? cartId = null,
    Object? location = freezed,
    Object? scheduledAt = freezed,
    Object? estimatedDuration = freezed,
    Object? technician = freezed,
    Object? parts = freezed,
    Object? checklist = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as WorkOrderType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as Priority,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      cartId: null == cartId
          ? _value.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      estimatedDuration: freezed == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      technician: freezed == technician
          ? _value.technician
          : technician // ignore: cast_nullable_to_non_nullable
              as String?,
      parts: freezed == parts
          ? _value.parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<WoPart>?,
      checklist: freezed == checklist
          ? _value.checklist
          : checklist // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkOrderDraftImplCopyWith<$Res>
    implements $WorkOrderDraftCopyWith<$Res> {
  factory _$$WorkOrderDraftImplCopyWith(_$WorkOrderDraftImpl value,
          $Res Function(_$WorkOrderDraftImpl) then) =
      __$$WorkOrderDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {WorkOrderType type,
      Priority priority,
      String description,
      String cartId,
      String? location,
      DateTime? scheduledAt,
      Duration? estimatedDuration,
      String? technician,
      List<WoPart>? parts,
      Map<String, bool>? checklist,
      String? notes});
}

/// @nodoc
class __$$WorkOrderDraftImplCopyWithImpl<$Res>
    extends _$WorkOrderDraftCopyWithImpl<$Res, _$WorkOrderDraftImpl>
    implements _$$WorkOrderDraftImplCopyWith<$Res> {
  __$$WorkOrderDraftImplCopyWithImpl(
      _$WorkOrderDraftImpl _value, $Res Function(_$WorkOrderDraftImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkOrderDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? priority = null,
    Object? description = null,
    Object? cartId = null,
    Object? location = freezed,
    Object? scheduledAt = freezed,
    Object? estimatedDuration = freezed,
    Object? technician = freezed,
    Object? parts = freezed,
    Object? checklist = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$WorkOrderDraftImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as WorkOrderType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as Priority,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      cartId: null == cartId
          ? _value.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      estimatedDuration: freezed == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      technician: freezed == technician
          ? _value.technician
          : technician // ignore: cast_nullable_to_non_nullable
              as String?,
      parts: freezed == parts
          ? _value._parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<WoPart>?,
      checklist: freezed == checklist
          ? _value._checklist
          : checklist // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkOrderDraftImpl implements _WorkOrderDraft {
  const _$WorkOrderDraftImpl(
      {required this.type,
      required this.priority,
      required this.description,
      required this.cartId,
      this.location,
      this.scheduledAt,
      this.estimatedDuration,
      this.technician,
      final List<WoPart>? parts,
      final Map<String, bool>? checklist,
      this.notes})
      : _parts = parts,
        _checklist = checklist;

  factory _$WorkOrderDraftImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkOrderDraftImplFromJson(json);

  @override
  final WorkOrderType type;
  @override
  final Priority priority;
  @override
  final String description;
  @override
  final String cartId;
  @override
  final String? location;
  @override
  final DateTime? scheduledAt;
  @override
  final Duration? estimatedDuration;
  @override
  final String? technician;
  final List<WoPart>? _parts;
  @override
  List<WoPart>? get parts {
    final value = _parts;
    if (value == null) return null;
    if (_parts is EqualUnmodifiableListView) return _parts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, bool>? _checklist;
  @override
  Map<String, bool>? get checklist {
    final value = _checklist;
    if (value == null) return null;
    if (_checklist is EqualUnmodifiableMapView) return _checklist;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? notes;

  @override
  String toString() {
    return 'WorkOrderDraft(type: $type, priority: $priority, description: $description, cartId: $cartId, location: $location, scheduledAt: $scheduledAt, estimatedDuration: $estimatedDuration, technician: $technician, parts: $parts, checklist: $checklist, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkOrderDraftImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.cartId, cartId) || other.cartId == cartId) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.estimatedDuration, estimatedDuration) ||
                other.estimatedDuration == estimatedDuration) &&
            (identical(other.technician, technician) ||
                other.technician == technician) &&
            const DeepCollectionEquality().equals(other._parts, _parts) &&
            const DeepCollectionEquality()
                .equals(other._checklist, _checklist) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      priority,
      description,
      cartId,
      location,
      scheduledAt,
      estimatedDuration,
      technician,
      const DeepCollectionEquality().hash(_parts),
      const DeepCollectionEquality().hash(_checklist),
      notes);

  /// Create a copy of WorkOrderDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkOrderDraftImplCopyWith<_$WorkOrderDraftImpl> get copyWith =>
      __$$WorkOrderDraftImplCopyWithImpl<_$WorkOrderDraftImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkOrderDraftImplToJson(
      this,
    );
  }
}

abstract class _WorkOrderDraft implements WorkOrderDraft {
  const factory _WorkOrderDraft(
      {required final WorkOrderType type,
      required final Priority priority,
      required final String description,
      required final String cartId,
      final String? location,
      final DateTime? scheduledAt,
      final Duration? estimatedDuration,
      final String? technician,
      final List<WoPart>? parts,
      final Map<String, bool>? checklist,
      final String? notes}) = _$WorkOrderDraftImpl;

  factory _WorkOrderDraft.fromJson(Map<String, dynamic> json) =
      _$WorkOrderDraftImpl.fromJson;

  @override
  WorkOrderType get type;
  @override
  Priority get priority;
  @override
  String get description;
  @override
  String get cartId;
  @override
  String? get location;
  @override
  DateTime? get scheduledAt;
  @override
  Duration? get estimatedDuration;
  @override
  String? get technician;
  @override
  List<WoPart>? get parts;
  @override
  Map<String, bool>? get checklist;
  @override
  String? get notes;

  /// Create a copy of WorkOrderDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkOrderDraftImplCopyWith<_$WorkOrderDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkOrderFilter _$WorkOrderFilterFromJson(Map<String, dynamic> json) {
  return _WorkOrderFilter.fromJson(json);
}

/// @nodoc
mixin _$WorkOrderFilter {
  Set<WorkOrderStatus>? get statuses => throw _privateConstructorUsedError;
  Set<Priority>? get priorities => throw _privateConstructorUsedError;
  Set<WorkOrderType>? get types => throw _privateConstructorUsedError;
  String? get cartId => throw _privateConstructorUsedError;
  String? get technician => throw _privateConstructorUsedError;
  DateTime? get fromDate => throw _privateConstructorUsedError;
  DateTime? get toDate => throw _privateConstructorUsedError;

  /// Serializes this WorkOrderFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkOrderFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkOrderFilterCopyWith<WorkOrderFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkOrderFilterCopyWith<$Res> {
  factory $WorkOrderFilterCopyWith(
          WorkOrderFilter value, $Res Function(WorkOrderFilter) then) =
      _$WorkOrderFilterCopyWithImpl<$Res, WorkOrderFilter>;
  @useResult
  $Res call(
      {Set<WorkOrderStatus>? statuses,
      Set<Priority>? priorities,
      Set<WorkOrderType>? types,
      String? cartId,
      String? technician,
      DateTime? fromDate,
      DateTime? toDate});
}

/// @nodoc
class _$WorkOrderFilterCopyWithImpl<$Res, $Val extends WorkOrderFilter>
    implements $WorkOrderFilterCopyWith<$Res> {
  _$WorkOrderFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkOrderFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statuses = freezed,
    Object? priorities = freezed,
    Object? types = freezed,
    Object? cartId = freezed,
    Object? technician = freezed,
    Object? fromDate = freezed,
    Object? toDate = freezed,
  }) {
    return _then(_value.copyWith(
      statuses: freezed == statuses
          ? _value.statuses
          : statuses // ignore: cast_nullable_to_non_nullable
              as Set<WorkOrderStatus>?,
      priorities: freezed == priorities
          ? _value.priorities
          : priorities // ignore: cast_nullable_to_non_nullable
              as Set<Priority>?,
      types: freezed == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as Set<WorkOrderType>?,
      cartId: freezed == cartId
          ? _value.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as String?,
      technician: freezed == technician
          ? _value.technician
          : technician // ignore: cast_nullable_to_non_nullable
              as String?,
      fromDate: freezed == fromDate
          ? _value.fromDate
          : fromDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      toDate: freezed == toDate
          ? _value.toDate
          : toDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkOrderFilterImplCopyWith<$Res>
    implements $WorkOrderFilterCopyWith<$Res> {
  factory _$$WorkOrderFilterImplCopyWith(_$WorkOrderFilterImpl value,
          $Res Function(_$WorkOrderFilterImpl) then) =
      __$$WorkOrderFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Set<WorkOrderStatus>? statuses,
      Set<Priority>? priorities,
      Set<WorkOrderType>? types,
      String? cartId,
      String? technician,
      DateTime? fromDate,
      DateTime? toDate});
}

/// @nodoc
class __$$WorkOrderFilterImplCopyWithImpl<$Res>
    extends _$WorkOrderFilterCopyWithImpl<$Res, _$WorkOrderFilterImpl>
    implements _$$WorkOrderFilterImplCopyWith<$Res> {
  __$$WorkOrderFilterImplCopyWithImpl(
      _$WorkOrderFilterImpl _value, $Res Function(_$WorkOrderFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkOrderFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statuses = freezed,
    Object? priorities = freezed,
    Object? types = freezed,
    Object? cartId = freezed,
    Object? technician = freezed,
    Object? fromDate = freezed,
    Object? toDate = freezed,
  }) {
    return _then(_$WorkOrderFilterImpl(
      statuses: freezed == statuses
          ? _value._statuses
          : statuses // ignore: cast_nullable_to_non_nullable
              as Set<WorkOrderStatus>?,
      priorities: freezed == priorities
          ? _value._priorities
          : priorities // ignore: cast_nullable_to_non_nullable
              as Set<Priority>?,
      types: freezed == types
          ? _value._types
          : types // ignore: cast_nullable_to_non_nullable
              as Set<WorkOrderType>?,
      cartId: freezed == cartId
          ? _value.cartId
          : cartId // ignore: cast_nullable_to_non_nullable
              as String?,
      technician: freezed == technician
          ? _value.technician
          : technician // ignore: cast_nullable_to_non_nullable
              as String?,
      fromDate: freezed == fromDate
          ? _value.fromDate
          : fromDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      toDate: freezed == toDate
          ? _value.toDate
          : toDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkOrderFilterImpl implements _WorkOrderFilter {
  const _$WorkOrderFilterImpl(
      {final Set<WorkOrderStatus>? statuses,
      final Set<Priority>? priorities,
      final Set<WorkOrderType>? types,
      this.cartId,
      this.technician,
      this.fromDate,
      this.toDate})
      : _statuses = statuses,
        _priorities = priorities,
        _types = types;

  factory _$WorkOrderFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkOrderFilterImplFromJson(json);

  final Set<WorkOrderStatus>? _statuses;
  @override
  Set<WorkOrderStatus>? get statuses {
    final value = _statuses;
    if (value == null) return null;
    if (_statuses is EqualUnmodifiableSetView) return _statuses;
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

  final Set<WorkOrderType>? _types;
  @override
  Set<WorkOrderType>? get types {
    final value = _types;
    if (value == null) return null;
    if (_types is EqualUnmodifiableSetView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(value);
  }

  @override
  final String? cartId;
  @override
  final String? technician;
  @override
  final DateTime? fromDate;
  @override
  final DateTime? toDate;

  @override
  String toString() {
    return 'WorkOrderFilter(statuses: $statuses, priorities: $priorities, types: $types, cartId: $cartId, technician: $technician, fromDate: $fromDate, toDate: $toDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkOrderFilterImpl &&
            const DeepCollectionEquality().equals(other._statuses, _statuses) &&
            const DeepCollectionEquality()
                .equals(other._priorities, _priorities) &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            (identical(other.cartId, cartId) || other.cartId == cartId) &&
            (identical(other.technician, technician) ||
                other.technician == technician) &&
            (identical(other.fromDate, fromDate) ||
                other.fromDate == fromDate) &&
            (identical(other.toDate, toDate) || other.toDate == toDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_statuses),
      const DeepCollectionEquality().hash(_priorities),
      const DeepCollectionEquality().hash(_types),
      cartId,
      technician,
      fromDate,
      toDate);

  /// Create a copy of WorkOrderFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkOrderFilterImplCopyWith<_$WorkOrderFilterImpl> get copyWith =>
      __$$WorkOrderFilterImplCopyWithImpl<_$WorkOrderFilterImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkOrderFilterImplToJson(
      this,
    );
  }
}

abstract class _WorkOrderFilter implements WorkOrderFilter {
  const factory _WorkOrderFilter(
      {final Set<WorkOrderStatus>? statuses,
      final Set<Priority>? priorities,
      final Set<WorkOrderType>? types,
      final String? cartId,
      final String? technician,
      final DateTime? fromDate,
      final DateTime? toDate}) = _$WorkOrderFilterImpl;

  factory _WorkOrderFilter.fromJson(Map<String, dynamic> json) =
      _$WorkOrderFilterImpl.fromJson;

  @override
  Set<WorkOrderStatus>? get statuses;
  @override
  Set<Priority>? get priorities;
  @override
  Set<WorkOrderType>? get types;
  @override
  String? get cartId;
  @override
  String? get technician;
  @override
  DateTime? get fromDate;
  @override
  DateTime? get toDate;

  /// Create a copy of WorkOrderFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkOrderFilterImplCopyWith<_$WorkOrderFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
