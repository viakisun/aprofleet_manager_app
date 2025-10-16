import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class CodeFormatters {
  static String formatCartId(int number) {
    return '${AppConstants.cartIdPrefix}-${number.toString().padLeft(3, '0')}';
  }

  static String formatWorkOrderId(int number, int year) {
    return '${AppConstants.workOrderPrefix}-$year-${number.toString().padLeft(4, '0')}';
  }

  static String formatAlertCode(int number, int year) {
    return '${AppConstants.alertPrefix}-$year-${number.toString().padLeft(4, '0')}';
  }

  static String formatIncidentCode(int number, int year) {
    return '${AppConstants.incidentPrefix}-$year-${number.toString().padLeft(4, '0')}';
  }

  static String formatMaintenanceCode(int number, int year) {
    return '${AppConstants.maintenancePrefix}-$year-${number.toString().padLeft(4, '0')}';
  }

  static String formatSerialNumber(String prefix, int number) {
    return '$prefix-${number.toString().padLeft(5, '0')}';
  }

  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  static String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  static String formatBatteryPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }

  static String formatSpeed(double speedKph) {
    return '${speedKph.toStringAsFixed(1)} km/h';
  }

  static String formatDistance(double distanceKm) {
    if (distanceKm >= 1.0) {
      return '${distanceKm.toStringAsFixed(1)} km';
    } else {
      return '${(distanceKm * 1000).toStringAsFixed(0)} m';
    }
  }

  static String formatTemperature(double celsius) {
    return '${celsius.toStringAsFixed(1)}°C';
  }

  static String formatVoltage(double voltage) {
    return '${voltage.toStringAsFixed(1)}V';
  }

  static String formatCurrent(double current) {
    return '${current.toStringAsFixed(1)}A';
  }
}
