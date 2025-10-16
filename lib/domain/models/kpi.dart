import 'package:freezed_annotation/freezed_annotation.dart';

part 'kpi.freezed.dart';
part 'kpi.g.dart';

enum AnalyticsRange {
  @JsonValue('week')
  week,
  @JsonValue('month')
  month,
}

extension AnalyticsRangeExtension on AnalyticsRange {
  String get displayName {
    switch (this) {
      case AnalyticsRange.week:
        return 'Week';
      case AnalyticsRange.month:
        return 'Month';
    }
  }
}

@freezed
class Kpi with _$Kpi {
  const factory Kpi({
    required double availabilityRate,
    required double mttr,
    required double utilization,
    required double dailyDistance,
    required KpiTrendDirection trend,
    required DateTime lastUpdated,
  }) = _Kpi;

  factory Kpi.fromJson(Map<String, dynamic> json) => _$KpiFromJson(json);
}

enum KpiTrendDirection {
  @JsonValue('up')
  up,
  @JsonValue('down')
  down,
  @JsonValue('stable')
  stable,
}

extension KpiTrendDirectionExtension on KpiTrendDirection {
  String get displayName {
    switch (this) {
      case KpiTrendDirection.up:
        return 'UP';
      case KpiTrendDirection.down:
        return 'DOWN';
      case KpiTrendDirection.stable:
        return 'STABLE';
    }
  }
}

@freezed
class KpiTrend with _$KpiTrend {
  const factory KpiTrend({
    required double availabilityChange,
    required double mttrChange,
    required double utilizationChange,
    required double distanceChange,
  }) = _KpiTrend;

  factory KpiTrend.fromJson(Map<String, dynamic> json) =>
      _$KpiTrendFromJson(json);
}
