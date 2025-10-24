// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartIssueImpl _$$CartIssueImplFromJson(Map<String, dynamic> json) =>
    _$CartIssueImpl(
      id: json['id'] as String,
      category: $enumDecode(_$IssueCategoryEnumMap, json['category']),
      severity: $enumDecode(_$IssueSeverityEnumMap, json['severity']),
      message: json['message'] as String,
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      actionType: json['actionType'] as String,
      details: json['details'] as String?,
      resolved: json['resolved'] as bool? ?? false,
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
    );

Map<String, dynamic> _$$CartIssueImplToJson(_$CartIssueImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': _$IssueCategoryEnumMap[instance.category]!,
      'severity': _$IssueSeverityEnumMap[instance.severity]!,
      'message': instance.message,
      'occurredAt': instance.occurredAt.toIso8601String(),
      'actionType': instance.actionType,
      'details': instance.details,
      'resolved': instance.resolved,
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
    };

const _$IssueCategoryEnumMap = {
  IssueCategory.operational: 'operational',
  IssueCategory.hardware: 'hardware',
  IssueCategory.workOrder: 'workOrder',
};

const _$IssueSeverityEnumMap = {
  IssueSeverity.critical: 'critical',
  IssueSeverity.warning: 'warning',
  IssueSeverity.info: 'info',
};
