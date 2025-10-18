import 'package:intl/intl.dart';

/// Utility class for formatting dates and times
class DateFormatter {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _displayDateFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _displayDateTimeFormat = DateFormat('MMM dd, yyyy HH:mm');

  /// Format date to string (yyyy-MM-dd)
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Format datetime to string (yyyy-MM-dd HH:mm)
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  /// Format time to string (HH:mm)
  static String formatTime(DateTime dateTime) {
    return _timeFormat.format(dateTime);
  }

  /// Format date for display (MMM dd, yyyy)
  static String formatDisplayDate(DateTime date) {
    return _displayDateFormat.format(date);
  }

  /// Format datetime for display (MMM dd, yyyy HH:mm)
  static String formatDisplayDateTime(DateTime dateTime) {
    return _displayDateTimeFormat.format(dateTime);
  }

  /// Format duration to human readable string
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  /// Parse date string to DateTime
  static DateTime? parseDate(String dateString) {
    try {
      return _dateFormat.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Parse datetime string to DateTime
  static DateTime? parseDateTime(String dateTimeString) {
    try {
      return _dateTimeFormat.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  /// Get relative time string (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}
