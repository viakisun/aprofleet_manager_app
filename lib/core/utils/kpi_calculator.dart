import '../../domain/models/kpi.dart';

class KpiCalculator {
  static double calculateAvailability({
    required Duration totalUptime,
    required Duration totalDowntime,
  }) {
    final totalTime = totalUptime + totalDowntime;
    if (totalTime.inMilliseconds == 0) return 100.0;

    return (totalUptime.inMilliseconds / totalTime.inMilliseconds) * 100;
  }

  static double calculateMTTR(List<Duration> repairTimes) {
    if (repairTimes.isEmpty) return 0.0;

    final totalRepairTime = repairTimes.fold<Duration>(
      Duration.zero,
      (sum, time) => sum + time,
    );

    return totalRepairTime.inMinutes / repairTimes.length;
  }

  static double calculateUtilization(List<double> dailyDistances) {
    if (dailyDistances.isEmpty) return 0.0;

    return dailyDistances.reduce((sum, distance) => sum + distance);
  }

  static double calculateDailyDistance(List<double> hourlyDistances) {
    return hourlyDistances.reduce((sum, distance) => sum + distance);
  }

  static double calculateEfficiency({
    required double distance,
    required double batteryUsed,
  }) {
    if (batteryUsed == 0) return 0.0;
    return distance / batteryUsed;
  }

  static KpiTrend calculateTrend({
    required Kpi current,
    required Kpi previous,
  }) {
    return KpiTrend(
      availabilityChange: current.availabilityRate - previous.availabilityRate,
      mttrChange: current.mttr - previous.mttr,
      utilizationChange: current.utilization - previous.utilization,
      distanceChange: current.dailyDistance - previous.dailyDistance,
    );
  }

  static String getTrendIcon(double change) {
    if (change > 0) return '↑';
    if (change < 0) return '↓';
    return '→';
  }

  static String getTrendColor(double change, bool isPositive) {
    if (isPositive) {
      return change > 0
          ? 'green'
          : change < 0
              ? 'red'
              : 'gray';
    } else {
      return change < 0
          ? 'green'
          : change > 0
              ? 'red'
              : 'gray';
    }
  }
}
