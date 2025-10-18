/// Utility class for form validation
class FormValidator {
  /// Validate email format
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.trim().length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    return null;
  }

  /// Validate maximum length
  static String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.trim().length > maxLength) {
      return '$fieldName must not exceed $maxLength characters';
    }
    return null;
  }

  /// Validate phone number format
  static String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'Phone number is required';
    }
    
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    if (!phoneRegex.hasMatch(phoneNumber)) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  /// Validate numeric input
  static String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (double.tryParse(value) == null) {
      return '$fieldName must be a valid number';
    }
    
    return null;
  }

  /// Validate positive number
  static String? validatePositiveNumber(String? value, String fieldName) {
    final numericError = validateNumeric(value, fieldName);
    if (numericError != null) return numericError;
    
    final number = double.parse(value!);
    if (number <= 0) {
      return '$fieldName must be greater than 0';
    }
    
    return null;
  }

  /// Validate date is not in the past
  static String? validateFutureDate(DateTime? date, String fieldName) {
    if (date == null) {
      return '$fieldName is required';
    }
    
    if (date.isBefore(DateTime.now())) {
      return '$fieldName cannot be in the past';
    }
    
    return null;
  }

  /// Validate date range
  static String? validateDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return 'Both start and end dates are required';
    }
    
    if (startDate.isAfter(endDate)) {
      return 'Start date cannot be after end date';
    }
    
    return null;
  }

  /// Validate multiple fields at once
  static Map<String, String?> validateFields(Map<String, String?> fields) {
    final errors = <String, String?>{};
    
    for (final entry in fields.entries) {
      final fieldName = entry.key;
      final value = entry.value;
      
      // Basic required validation
      final requiredError = validateRequired(value, fieldName);
      if (requiredError != null) {
        errors[fieldName] = requiredError;
        continue;
      }
      
      // Additional validations based on field name
      switch (fieldName.toLowerCase()) {
        case 'email':
          errors[fieldName] = validateEmail(value);
          break;
        case 'phone':
        case 'phonenumber':
          errors[fieldName] = validatePhoneNumber(value);
          break;
        default:
          // No additional validation needed
          break;
      }
    }
    
    return errors;
  }
}
