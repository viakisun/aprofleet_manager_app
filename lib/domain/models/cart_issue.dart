import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_issue.freezed.dart';
part 'cart_issue.g.dart';

/// 카트 문제/이슈 카테고리
/// - operational: 운행 관련 이슈 (실시간 운행 상태 문제)
/// - hardware: 하드웨어/시스템 이슈 (센서, GPS, 카메라 등)
/// - workOrder: 워크오더 상태 (정비 및 작업 추적)
enum IssueCategory {
  @JsonValue('operational')
  operational,

  @JsonValue('hardware')
  hardware,

  @JsonValue('workOrder')
  workOrder,
}

/// 문제 심각도 레벨
/// - critical: 🔴 즉시 조치 필요 (안전, 배터리 위험)
/// - warning: 🟠 주의 필요 (센서 오류, 통신 문제)
/// - info: 🟡 정보성 (정비 예정, 업데이트 권장)
enum IssueSeverity {
  @JsonValue('critical')
  critical,

  @JsonValue('warning')
  warning,

  @JsonValue('info')
  info,
}

/// 카트 문제/이슈 모델
/// 골프카트 현장 관리자를 위한 문제 추적 및 조치 정보
@freezed
class CartIssue with _$CartIssue {
  const factory CartIssue({
    /// 이슈 고유 ID
    required String id,

    /// 이슈 카테고리
    required IssueCategory category,

    /// 심각도
    required IssueSeverity severity,

    /// 문제 설명 메시지
    required String message,

    /// 발생 시각
    required DateTime occurredAt,

    /// 권장 조치 타입
    /// 예: "현장 확인", "점검 요청", "긴급 정비", "펌웨어 업데이트" 등
    required String actionType,

    /// 추가 상세 정보 (선택)
    String? details,

    /// 해결 여부
    @Default(false) bool resolved,

    /// 해결 시각 (선택)
    DateTime? resolvedAt,
  }) = _CartIssue;

  factory CartIssue.fromJson(Map<String, dynamic> json) => _$CartIssueFromJson(json);
}

/// 이슈 카테고리별 한글 이름
extension IssueCategoryExtension on IssueCategory {
  String get displayName {
    switch (this) {
      case IssueCategory.operational:
        return '운행 관련';
      case IssueCategory.hardware:
        return '하드웨어/시스템';
      case IssueCategory.workOrder:
        return '워크오더';
    }
  }

  String get displayNameEn {
    switch (this) {
      case IssueCategory.operational:
        return 'OPERATIONAL';
      case IssueCategory.hardware:
        return 'HARDWARE/SYSTEM';
      case IssueCategory.workOrder:
        return 'WORK ORDER';
    }
  }
}

/// 심각도별 색상 및 아이콘
extension IssueSeverityExtension on IssueSeverity {
  String get displayName {
    switch (this) {
      case IssueSeverity.critical:
        return '긴급';
      case IssueSeverity.warning:
        return '주의';
      case IssueSeverity.info:
        return '정보';
    }
  }

  String get displayNameEn {
    switch (this) {
      case IssueSeverity.critical:
        return 'CRITICAL';
      case IssueSeverity.warning:
        return 'WARNING';
      case IssueSeverity.info:
        return 'INFO';
    }
  }

  String get emoji {
    switch (this) {
      case IssueSeverity.critical:
        return '🔴';
      case IssueSeverity.warning:
        return '🟠';
      case IssueSeverity.info:
        return '🟡';
    }
  }

  /// Priority order for sorting (lower = higher priority)
  int get priorityOrder {
    switch (this) {
      case IssueSeverity.critical:
        return 0;
      case IssueSeverity.warning:
        return 1;
      case IssueSeverity.info:
        return 2;
    }
  }
}
