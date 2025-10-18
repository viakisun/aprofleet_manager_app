import '../../constants/app_constants.dart';

/// Utility class for formatting codes and identifiers
class CodeFormatter {
  /// Format cart ID with prefix and zero padding
  static String formatCartId(int number) {
    return '${AppConstants.cartIdPrefix}-${number.toString().padLeft(3, '0')}';
  }

  /// Format work order ID with year and zero padding
  static String formatWorkOrderId(int number, int year) {
    return '${AppConstants.workOrderPrefix}-$year-${number.toString().padLeft(4, '0')}';
  }

  /// Format alert code with year and zero padding
  static String formatAlertCode(int number, int year) {
    return '${AppConstants.alertPrefix}-$year-${number.toString().padLeft(4, '0')}';
  }

  /// Format incident code with year and zero padding
  static String formatIncidentCode(int number, int year) {
    return '${AppConstants.incidentPrefix}-$year-${number.toString().padLeft(4, '0')}';
  }

  /// Format maintenance code with year and zero padding
  static String formatMaintenanceCode(int number, int year) {
    return '${AppConstants.maintenancePrefix}-$year-${number.toString().padLeft(4, '0')}';
  }

  /// Format serial number with prefix and zero padding
  static String formatSerialNumber(String prefix, int number) {
    return '$prefix-${number.toString().padLeft(5, '0')}';
  }

  /// Generate next available ID based on existing IDs
  static String generateNextId(List<String> existingIds, String prefix) {
    final numbers = existingIds
        .where((id) => id.startsWith(prefix))
        .map((id) {
          final parts = id.split('-');
          if (parts.length >= 2) {
            return int.tryParse(parts.last) ?? 0;
          }
          return 0;
        })
        .toList();

    final nextNumber = numbers.isEmpty ? 1 : (numbers.reduce((a, b) => a > b ? a : b) + 1);
    return '$prefix-${nextNumber.toString().padLeft(3, '0')}';
  }

  /// Validate ID format
  static bool isValidId(String id, String expectedPrefix) {
    final parts = id.split('-');
    if (parts.length < 2) return false;
    if (parts.first != expectedPrefix) return false;
    
    // Check if the last part is a number
    final numberPart = parts.last;
    return int.tryParse(numberPart) != null;
  }

  /// Extract number from ID
  static int? extractNumberFromId(String id) {
    final parts = id.split('-');
    if (parts.isEmpty) return null;
    return int.tryParse(parts.last);
  }

  /// Extract prefix from ID
  static String? extractPrefixFromId(String id) {
    final parts = id.split('-');
    if (parts.isEmpty) return null;
    return parts.first;
  }
}
