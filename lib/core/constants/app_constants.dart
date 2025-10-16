import 'package:flutter/material.dart';
import '../../domain/models/alert.dart';
import '../../domain/models/cart.dart';
import '../../domain/models/work_order.dart';

class AppConstants {
  // App Info
  static const String appName = 'AproFleet Manager';
  static const String cartName = 'APRO';
  static const String defaultManufacturer = 'DY Innovate';

  // Code Formats
  static const String cartIdPrefix = 'APRO';
  static const String workOrderPrefix = 'WO';
  static const String alertPrefix = 'ALT';
  static const String incidentPrefix = 'INC';
  static const String maintenancePrefix = 'MNT';

  // Priority Colors
  static const Map<Priority, Color> priorityColors = {
    Priority.p1: Color(0xFFEF4444), // Red
    Priority.p2: Color(0xFFF97316), // Orange
    Priority.p3: Color(0xFF3B82F6), // Blue
    Priority.p4: Color(0xFF22C55E), // Green
  };

  // Status Colors
  static const Map<CartStatus, Color> statusColors = {
    CartStatus.active: Color(0xFF22C55E), // Green
    CartStatus.idle: Color(0xFFF97316), // Orange
    CartStatus.charging: Color(0xFF3B82F6), // Blue
    CartStatus.maintenance: Color(0xFFEF4444), // Red
    CartStatus.offline: Color(0xFF666666), // Gray
  };

  // Alert Severity Colors
  static const Map<AlertSeverity, Color> alertColors = {
    AlertSeverity.critical: Color(0xFFEF4444), // Red
    AlertSeverity.warning: Color(0xFFF97316), // Orange
    AlertSeverity.info: Color(0xFF3B82F6), // Blue
    AlertSeverity.success: Color(0xFF22C55E), // Green
  };

  // Manufacturers
  static const List<String> manufacturers = [
    'DY Innovate',
    'E-Z-GO',
    'Club Car',
    'Yamaha',
    'Cushman',
  ];

  // Models by Manufacturer
  static const Map<String, List<String>> modelsByManufacturer = {
    'DY Innovate': ['APRO-100', 'APRO-200', 'APRO-300'],
    'E-Z-GO': ['RXV', 'TXT', 'Express'],
    'Club Car': ['Onward', 'Precedent', 'Tempo'],
    'Yamaha': ['Drive2', 'G29', 'G22'],
    'Cushman': ['Hauler', 'Shuttle', 'Titan'],
  };

  // Battery Types
  static const List<String> batteryTypes = [
    'Lead Acid',
    'Lithium Ion',
    'AGM',
  ];

  // Voltage Options
  static const List<int> voltageOptions = [36, 48, 72];

  // Seating Options
  static const List<int> seatingOptions = [2, 4, 6, 8];

  // Work Order Types
  static const List<String> workOrderTypes = [
    'Emergency Repair',
    'Preventive Maintenance',
    'Battery Service',
    'Tire Service',
    'Safety Inspection',
    'Other',
  ];

  // Technicians
  static const List<Map<String, dynamic>> technicians = [
    {'name': 'John Smith', 'skill': 'Senior', 'available': true},
    {'name': 'Sarah Johnson', 'skill': 'Intermediate', 'available': true},
    {'name': 'Mike Chen', 'skill': 'Senior', 'available': false},
    {'name': 'Lisa Wang', 'skill': 'Junior', 'available': true},
    {'name': 'David Kim', 'skill': 'Intermediate', 'available': true},
  ];

  // Parts
  static const List<Map<String, dynamic>> parts = [
    {'id': 'BAT-001', 'name': 'Battery Pack 48V', 'category': 'Battery'},
    {'id': 'TIR-001', 'name': 'Front Tire 18x8.5', 'category': 'Tire'},
    {'id': 'TIR-002', 'name': 'Rear Tire 18x8.5', 'category': 'Tire'},
    {'id': 'BRK-001', 'name': 'Brake Pad Set', 'category': 'Brake'},
    {'id': 'MOT-001', 'name': 'Motor Controller', 'category': 'Motor'},
    {'id': 'GPS-001', 'name': 'GPS Module', 'category': 'Electronics'},
  ];

  // Simulation Intervals (in seconds)
  static const int telemetryInterval = 1;
  static const int positionInterval = 3;
  static const int alertInterval = 10;
  static const int kpiInterval = 30;

  // Thresholds
  static const double batteryWarningThreshold = 50.0;
  static const double batteryCriticalThreshold = 20.0;
  static const double temperatureWarningThreshold = 60.0;
  static const double speedLimitThreshold = 25.0;

  // Map Settings
  static const double mapZoomMin = 1.0;
  static const double mapZoomMax = 2.5;
  static const double mapZoomDefault = 1.5;

  // Golf Course Layout (9 holes)
  static const List<Map<String, dynamic>> golfHoles = [
    {'id': 1, 'par': 4, 'distance': 350},
    {'id': 2, 'par': 3, 'distance': 120},
    {'id': 3, 'par': 5, 'distance': 520},
    {'id': 4, 'par': 4, 'distance': 380},
    {'id': 5, 'par': 3, 'distance': 150},
    {'id': 6, 'par': 4, 'distance': 420},
    {'id': 7, 'par': 5, 'distance': 480},
    {'id': 8, 'par': 3, 'distance': 140},
    {'id': 9, 'par': 4, 'distance': 360},
  ];
}
