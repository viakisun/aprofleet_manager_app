/// Utility class for formatting numbers and measurements
class NumberFormatter {
  /// Format battery percentage with one decimal place
  static String formatBatteryPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }

  /// Format speed in km/h with one decimal place
  static String formatSpeed(double speedKph) {
    return '${speedKph.toStringAsFixed(1)} km/h';
  }

  /// Format distance with appropriate unit (km or m)
  static String formatDistance(double distanceKm) {
    if (distanceKm >= 1.0) {
      return '${distanceKm.toStringAsFixed(1)} km';
    } else {
      return '${(distanceKm * 1000).toStringAsFixed(0)} m';
    }
  }

  /// Format temperature in Celsius
  static String formatTemperature(double celsius) {
    return '${celsius.toStringAsFixed(1)}°C';
  }

  /// Format voltage with appropriate precision
  static String formatVoltage(double voltage) {
    return '${voltage.toStringAsFixed(1)}V';
  }

  /// Format current in Amperes
  static String formatCurrent(double current) {
    return '${current.toStringAsFixed(2)}A';
  }

  /// Format power in Watts
  static String formatPower(double power) {
    if (power >= 1000) {
      return '${(power / 1000).toStringAsFixed(1)}kW';
    } else {
      return '${power.toStringAsFixed(0)}W';
    }
  }

  /// Format large numbers with K, M suffixes
  static String formatLargeNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  /// Format currency amount
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  /// Format percentage with specified decimal places
  static String formatPercentage(double percentage, {int decimals = 1}) {
    return '${percentage.toStringAsFixed(decimals)}%';
  }

  /// Format count with proper pluralization
  static String formatCount(int count, String singular, {String? plural}) {
    final pluralForm = plural ?? '${singular}s';
    return count == 1 ? '$count $singular' : '$count $pluralForm';
  }
}
