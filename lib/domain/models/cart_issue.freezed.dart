// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_issue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CartIssue _$CartIssueFromJson(Map<String, dynamic> json) {
  return _CartIssue.fromJson(json);
}

/// @nodoc
mixin _$CartIssue {
  /// 이슈 고유 ID
  String get id => throw _privateConstructorUsedError;

  /// 이슈 카테고리
  IssueCategory get category => throw _privateConstructorUsedError;

  /// 심각도
  IssueSeverity get severity => throw _privateConstructorUsedError;

  /// 문제 설명 메시지
  String get message => throw _privateConstructorUsedError;

  /// 발생 시각
  DateTime get occurredAt => throw _privateConstructorUsedError;

  /// 권장 조치 타입
  /// 예: "현장 확인", "점검 요청", "긴급 정비", "펌웨어 업데이트" 등
  String get actionType => throw _privateConstructorUsedError;

  /// 추가 상세 정보 (선택)
  String? get details => throw _privateConstructorUsedError;

  /// 해결 여부
  bool get resolved => throw _privateConstructorUsedError;

  /// 해결 시각 (선택)
  DateTime? get resolvedAt => throw _privateConstructorUsedError;

  /// Serializes this CartIssue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartIssue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartIssueCopyWith<CartIssue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartIssueCopyWith<$Res> {
  factory $CartIssueCopyWith(CartIssue value, $Res Function(CartIssue) then) =
      _$CartIssueCopyWithImpl<$Res, CartIssue>;
  @useResult
  $Res call(
      {String id,
      IssueCategory category,
      IssueSeverity severity,
      String message,
      DateTime occurredAt,
      String actionType,
      String? details,
      bool resolved,
      DateTime? resolvedAt});
}

/// @nodoc
class _$CartIssueCopyWithImpl<$Res, $Val extends CartIssue>
    implements $CartIssueCopyWith<$Res> {
  _$CartIssueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartIssue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? severity = null,
    Object? message = null,
    Object? occurredAt = null,
    Object? actionType = null,
    Object? details = freezed,
    Object? resolved = null,
    Object? resolvedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as IssueCategory,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as IssueSeverity,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      occurredAt: null == occurredAt
          ? _value.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
      resolved: null == resolved
          ? _value.resolved
          : resolved // ignore: cast_nullable_to_non_nullable
              as bool,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartIssueImplCopyWith<$Res>
    implements $CartIssueCopyWith<$Res> {
  factory _$$CartIssueImplCopyWith(
          _$CartIssueImpl value, $Res Function(_$CartIssueImpl) then) =
      __$$CartIssueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      IssueCategory category,
      IssueSeverity severity,
      String message,
      DateTime occurredAt,
      String actionType,
      String? details,
      bool resolved,
      DateTime? resolvedAt});
}

/// @nodoc
class __$$CartIssueImplCopyWithImpl<$Res>
    extends _$CartIssueCopyWithImpl<$Res, _$CartIssueImpl>
    implements _$$CartIssueImplCopyWith<$Res> {
  __$$CartIssueImplCopyWithImpl(
      _$CartIssueImpl _value, $Res Function(_$CartIssueImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartIssue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? severity = null,
    Object? message = null,
    Object? occurredAt = null,
    Object? actionType = null,
    Object? details = freezed,
    Object? resolved = null,
    Object? resolvedAt = freezed,
  }) {
    return _then(_$CartIssueImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as IssueCategory,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as IssueSeverity,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      occurredAt: null == occurredAt
          ? _value.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
      resolved: null == resolved
          ? _value.resolved
          : resolved // ignore: cast_nullable_to_non_nullable
              as bool,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CartIssueImpl implements _CartIssue {
  const _$CartIssueImpl(
      {required this.id,
      required this.category,
      required this.severity,
      required this.message,
      required this.occurredAt,
      required this.actionType,
      this.details,
      this.resolved = false,
      this.resolvedAt});

  factory _$CartIssueImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartIssueImplFromJson(json);

  /// 이슈 고유 ID
  @override
  final String id;

  /// 이슈 카테고리
  @override
  final IssueCategory category;

  /// 심각도
  @override
  final IssueSeverity severity;

  /// 문제 설명 메시지
  @override
  final String message;

  /// 발생 시각
  @override
  final DateTime occurredAt;

  /// 권장 조치 타입
  /// 예: "현장 확인", "점검 요청", "긴급 정비", "펌웨어 업데이트" 등
  @override
  final String actionType;

  /// 추가 상세 정보 (선택)
  @override
  final String? details;

  /// 해결 여부
  @override
  @JsonKey()
  final bool resolved;

  /// 해결 시각 (선택)
  @override
  final DateTime? resolvedAt;

  @override
  String toString() {
    return 'CartIssue(id: $id, category: $category, severity: $severity, message: $message, occurredAt: $occurredAt, actionType: $actionType, details: $details, resolved: $resolved, resolvedAt: $resolvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartIssueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            (identical(other.details, details) || other.details == details) &&
            (identical(other.resolved, resolved) ||
                other.resolved == resolved) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, category, severity, message,
      occurredAt, actionType, details, resolved, resolvedAt);

  /// Create a copy of CartIssue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartIssueImplCopyWith<_$CartIssueImpl> get copyWith =>
      __$$CartIssueImplCopyWithImpl<_$CartIssueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartIssueImplToJson(
      this,
    );
  }
}

abstract class _CartIssue implements CartIssue {
  const factory _CartIssue(
      {required final String id,
      required final IssueCategory category,
      required final IssueSeverity severity,
      required final String message,
      required final DateTime occurredAt,
      required final String actionType,
      final String? details,
      final bool resolved,
      final DateTime? resolvedAt}) = _$CartIssueImpl;

  factory _CartIssue.fromJson(Map<String, dynamic> json) =
      _$CartIssueImpl.fromJson;

  /// 이슈 고유 ID
  @override
  String get id;

  /// 이슈 카테고리
  @override
  IssueCategory get category;

  /// 심각도
  @override
  IssueSeverity get severity;

  /// 문제 설명 메시지
  @override
  String get message;

  /// 발생 시각
  @override
  DateTime get occurredAt;

  /// 권장 조치 타입
  /// 예: "현장 확인", "점검 요청", "긴급 정비", "펌웨어 업데이트" 등
  @override
  String get actionType;

  /// 추가 상세 정보 (선택)
  @override
  String? get details;

  /// 해결 여부
  @override
  bool get resolved;

  /// 해결 시각 (선택)
  @override
  DateTime? get resolvedAt;

  /// Create a copy of CartIssue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartIssueImplCopyWith<_$CartIssueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
