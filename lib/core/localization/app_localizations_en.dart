class AppLocalizationsEn {
  static const Map<String, String> values = {
    // App Name
    'appName': 'AproFleet Manager',

    // Navigation
    'navRealTime': 'LIVE',
    'navCartManagement': 'CARTS',
    'navMaintenance': 'WORK',
    'navAlerts': 'ALERTS',
    'navAnalytics': 'DATA',
    'navSettings': 'SETTINGS',

    // Cart Registration
    'registerCart': 'Register Cart',
    'cartRegistration': 'Cart Registration',
    'vinNumber': 'VIN Number',
    'manufacturer': 'Manufacturer',
    'model': 'Model',
    'year': 'Year',
    'color': 'Color',
    'batteryType': 'Battery Type',
    'voltage': 'Voltage',
    'seating': 'Seating',
    'maxSpeed': 'Max Speed',
    'gpsTrackerId': 'GPS Tracker ID',
    'telemetryDeviceId': 'Telemetry Device ID',
    'componentSerials': 'Component Serials',
    'imagePaths': 'Image Paths',
    'purchaseDate': 'Purchase Date',
    'warrantyExpiry': 'Warranty Expiry',
    'insuranceNumber': 'Insurance Number',
    'odometer': 'Odometer',

    // Work Order Creation
    'createWorkOrder': 'Create Work Order',
    'workOrderCreation': 'Work Order Creation',
    'workOrderType': 'Work Order Type',
    'priority': 'Priority',
    'description': 'Description',
    'technician': 'Technician',
    'parts': 'Parts',
    'location': 'Location',
    'notes': 'Notes',
    'checklist': 'Checklist',
    'scheduledAt': 'Scheduled At',
    'estimatedDuration': 'Estimated Duration',

    // Common
    'search': 'Search',
    'filter': 'Filter',
    'add': 'Add',
    'save': 'Save',
    'cancel': 'Cancel',
    'confirm': 'Confirm',
    'delete': 'Delete',
    'edit': 'Edit',
    'view': 'View',
    'track': 'Track',
    'details': 'Details',
    'service': 'Service',
    'refresh': 'Refresh',
    'export': 'Export',
    'loading': 'Loading...',
    'error': 'Error',
    'success': 'Success',
    'warning': 'Warning',
    'info': 'Info',

    // Cart Status
    'statusActive': 'ACTIVE',
    'statusIdle': 'IDLE',
    'statusCharging': 'CHARGING',
    'statusMaintenance': 'MAINTENANCE',
    'statusOffline': 'OFFLINE',

    // Priority
    'priorityCritical': 'CRITICAL',
    'priorityHigh': 'HIGH',
    'priorityNormal': 'NORMAL',
    'priorityLow': 'LOW',

    // Alert Severity
    'alertCritical': 'Critical',
    'alertWarning': 'Warning',
    'alertInfo': 'Info',
    'alertSuccess': 'Success',

    // Work Order Types
    'woEmergency': 'Emergency Repair',
    'woPreventive': 'Preventive Maintenance',
    'woBattery': 'Battery Service',
    'woTire': 'Tire Service',
    'woSafety': 'Safety Inspection',
    'woOther': 'Other',

    // Manufacturers
    'manufacturerDYInnovate': 'DY Innovate',
    'manufacturerEZGO': 'E-Z-GO',
    'manufacturerClubCar': 'Club Car',
    'manufacturerYamaha': 'Yamaha',
    'manufacturerCushman': 'Cushman',

    // Analytics Dashboard
    'analyticsPeriod': 'PERIOD:',
    'analyticsWeek': 'Week',
    'analyticsMonth': 'Month',
    'analyticsKpiTitle': 'KEY PERFORMANCE INDICATORS',
    'analyticsChartsTitle': 'PERFORMANCE CHARTS',
    'analyticsFleetPerformance': 'Fleet Performance',
    'analyticsBatteryHealth': 'Battery Health Trend',
    'analyticsMaintenanceDistribution': 'Maintenance Distribution',
    'analyticsCostAnalysis': 'Cost Analysis',

    // Units
    'unitPercent': '%',
    'unitMinutes': 'min',
    'unitKilometers': 'km',
    'unitKilometersPerHour': 'km/h',
    'unitVolts': 'V',
    'unitAmperes': 'A',
    'unitCelsius': '°C',

    // Maintenance Distribution
    'maintenancePreventive': 'Preventive',
    'maintenanceBattery': 'Battery',
    'maintenanceTire': 'Tire',
    'maintenanceEmergency': 'Emergency',
    'maintenanceOther': 'Other',

    // Cost Analysis
    'costTotal': 'Total',
    'costLabor': 'Labor',
    'costParts': 'Parts',
    'costOther': 'Other',

    // KPI Labels
    'kpiAvailabilityRate': 'Availability Rate',

    // Settings & Menu (新增)
    'settingsTitle': 'SETTINGS',
    'languageAndRegion': 'LANGUAGE & REGION',
    'account': 'ACCOUNT',
    'appSettings': 'APP SETTINGS',
    'support': 'SUPPORT',
    'profileSettings': 'Profile Settings',
    'managePersonalInfo': 'Manage your personal information',
    'security': 'Security',
    'securityDescription': 'Password, 2FA, and security settings',
    'privacy': 'Privacy',
    'privacyDescription': 'Data usage and privacy controls',
    'notifications': 'Notifications',
    'notificationsDescription': 'Push notifications and alerts',
    'theme': 'Theme',
    'themeDescription': 'Dark mode (always on)',
    'storage': 'Storage',
    'storageDescription': 'Cache and data management',
    'helpFaq': 'Help & FAQ',
    'helpDescription': 'Get help and find answers',
    'reportIssue': 'Report Issue',
    'reportDescription': 'Report bugs or problems',
    'about': 'About',
    'aboutDescription': 'App version and information',
    'signOut': 'Sign Out',
    'signOutConfirm': 'Are you sure you want to sign out?',
    'signedOutSuccess': 'Signed out successfully',

    // Hamburger Menu (新增)
    'quickActions': 'QUICK ACTIONS',
    'dashboard': 'Dashboard',
    'dashboardSubtitle': 'Go to main dashboard',
    'scanQrCode': 'Scan QR Code',
    'scanQrSubtitle': 'Scan cart QR code',
    'refreshData': 'Refresh Data',
    'refreshDataSubtitle': 'Sync latest data',
    'dataRefreshed': 'Data refreshed',
    'language': 'LANGUAGE',
    'english': 'English',
    'korean': 'Korean',
    'japanese': 'Japanese',
    'chineseSimplified': 'Simplified Chinese',
    'chineseTraditional': 'Traditional Chinese',

    // Inventory Stats (新增)
    'total': 'TOTAL',
    'active': 'ACTIVE',
    'charging': 'CHARGING',
    'maintenance': 'MAINTENANCE',
    'offline': 'OFFLINE',

    // Cart Details & Metrics (新增)
    'battery': 'BATTERY',
    'speed': 'SPEED',
    'systemMetrics': 'SYSTEM METRICS',
    'live': 'LIVE',
    'telemetry': 'TELEMETRY',

    // Work Order & Alerts (新增)
    'workOrderStatus': 'Work Order Status',
    'alertRules': 'Alert Rules',
    'escalationPath': 'Escalation Path',
    'estimatedTime': 'Estimated Time',

    // Common UI Elements (新增)
    'comingSoon': 'Coming Soon',
    'ok': 'OK',
    'version': 'Version',
    'product': 'Product',
    'languageChanged': 'Language changed to',

    // Work Order Type Selector (新增)
    'emergency': 'EMERGENCY',
    'preventive': 'PREVENTIVE',
    'tire': 'TIRE',
    'safety': 'SAFETY',
    'other': 'OTHER',

    // Priority Selector (新增)
    'priorityLevel': 'PRIORITY LEVEL',
    'critical': 'CRITICAL',
    'high': 'HIGH',
    'normal': 'NORMAL',
    'low': 'LOW',

    // Alert Summary Cards (新增)
    'alertSummary': 'ALERT SUMMARY',
    'totalAlerts': 'TOTAL ALERTS',
    'resolved': 'RESOLVED',

    // Cart Detail Monitor (新增)
    'primaryTelemetry': 'PRIMARY TELEMETRY',
    'motor': 'MOTOR',
    'main': 'MAIN',
    'daily': 'DAILY',
    'energy': 'ENERGY',
    'alerts': 'ALERTS',
    'remoteControls': 'REMOTE CONTROLS',
    'emergencyControls': 'EMERGENCY CONTROLS',
    'emergencyStop': 'EMERGENCY STOP',
    'stopCart': 'STOP CART',

    // About Dialog (新增)
    'aboutAproFleetManager': 'About AproFleet Manager',
    'versionInfo': 'Version: 1.0.0',
    'manufacturerInfo': 'Manufacturer: DY Innovate',
    'productInfo': 'Product: APRO Golf Cart',

    // Work Order Filters
    'woFilterAll': 'All',
    'woFilterUrgent': 'Urgent',
    'woFilterPending': 'Pending',
    'woFilterInProgress': 'In Progress',
    'woFilterCompleted': 'Completed',
    'woFilterTimeline': 'Timeline',

    // Work Order Stats
    'woStatsUrgent': 'URGENT',
    'woStatsPending': 'PENDING',
    'woStatsInProgress': 'IN PROGRESS',
    'woStatsToday': 'TODAY',

    // Work Order Status
    'woStatusDraft': 'DRAFT',
    'woStatusPending': 'PENDING',
    'woStatusInProgress': 'IN PROGRESS',
    'woStatusOnHold': 'ON HOLD',
    'woStatusCompleted': 'COMPLETED',
    'woStatusCancelled': 'CANCELLED',

    // Priority Levels
    'woPriorityP1': 'P1 (Critical)',
    'woPriorityP2': 'P2 (High)',
    'woPriorityP3': 'P3 (Normal)',
    'woPriorityP4': 'P4 (Low)',

    // Work Order Types
    'woTypeEmergency': 'EMERGENCY REPAIR',
    'woTypePreventive': 'PREVENTIVE',
    'woTypeBattery': 'BATTERY',
    'woTypeTire': 'TIRE',
    'woTypeSafety': 'SAFETY',
    'woTypeOther': 'OTHER',

    // Time Format
    'woTimeDays': 'd',
    'woTimeHours': 'h',
    'woTimeMinutes': 'm',
    'woTimeAgo': 'ago',

    // Messages
    'woNoWorkOrders': 'No work orders found',
    'woErrorLoading': 'Error loading work orders',
    'woRetry': 'Retry',

    // Hamburger Menu
    'menuSettings': 'SETTINGS',
    'menuLanguage': 'LANGUAGE',
    'menuSettingsTitle': 'Settings',
    'menuSettingsSubtitle': 'App preferences and configuration',
    'menuEnglish': 'English',
    'menuKorean': '한국어',
    'menuJapanese': '日本語',
    'menuChineseSimplified': '简体中文',
    'menuChineseTraditional': '繁體中文',
    'menuSignOut': 'SIGN OUT',
    'menuSignOutTitle': 'Sign Out',
    'menuSignOutMessage': 'Are you sure you want to sign out?',
    'menuSignOutSuccess': 'Signed out successfully',

    // Alert Screen
    'alertTabAll': 'All',
    'alertTabUnread': 'Unread',
    'alertTabCart': 'Cart',
    'alertTabBattery': 'Battery',
    'alertTabMaintenance': 'Maintenance',
    'alertTabGeofence': 'Geofence',
    'alertTabSystem': 'System',
    'alertErrorLoading': 'Error loading alerts',
    'alertRetry': 'Retry',
    'alertNoAlerts': 'No alerts found',
    'alertAcknowledge': 'Acknowledge',
    'alertViewCart': 'View Cart',
    'alertCreateWorkOrder': 'Create Work Order',
    'alertTimeJustNow': 'Just now',
    'alertTimeDaysAgo': 'd ago',
    'alertTimeHoursAgo': 'h ago',
    'alertTimeMinutesAgo': 'm ago',

    // Alert Severity
    'alertSeverityCritical': 'Critical',
    'alertSeverityWarning': 'Warning',
    'alertSeverityInfo': 'Info',
    'alertSeveritySuccess': 'Success',

    // Alert Status
    'alertStatusTriggered': 'TRIGGERED',
    'alertStatusNotified': 'NOTIFIED',
    'alertStatusAcknowledged': 'ACKNOWLEDGED',
    'alertStatusEscalated': 'ESCALATED',
    'alertStatusResolved': 'RESOLVED',

    // Alert Source
    'alertSourceEmergency': 'EMERGENCY',
    'alertSourceBattery': 'BATTERY',
    'alertSourceMaintenance': 'MAINTENANCE',
    'alertSourceGeofence': 'GEOFENCE',
    'alertSourceTemperature': 'TEMPERATURE',
    'alertSourceSystem': 'SYSTEM',
  };
}
