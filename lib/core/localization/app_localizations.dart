import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh_cn.dart';
import 'app_localizations_zh_tw.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('ja', ''),
    Locale('ko', ''),
    Locale('zh', 'CN'), // 중국어 간체
    Locale('zh', 'TW'), // 중국어 번체
  ];

  // App Name
  String get registerCart => _getLocalizedValue('registerCart');
  String get createWorkOrder => _getLocalizedValue('createWorkOrder');

  // Navigation
  String get navRealTime => _getLocalizedValue('navRealTime');
  String get navCartManagement => _getLocalizedValue('navCartManagement');
  String get navMaintenance => _getLocalizedValue('navMaintenance');
  String get navAlerts => _getLocalizedValue('navAlerts');
  String get navAnalytics => _getLocalizedValue('navAnalytics');
  String get navSettings => _getLocalizedValue('navSettings');

  // Common
  String get search => _getLocalizedValue('search');
  String get filter => _getLocalizedValue('filter');
  String get add => _getLocalizedValue('add');
  String get save => _getLocalizedValue('save');
  String get cancel => _getLocalizedValue('cancel');
  String get confirm => _getLocalizedValue('confirm');
  String get delete => _getLocalizedValue('delete');
  String get edit => _getLocalizedValue('edit');
  String get view => _getLocalizedValue('view');
  String get track => _getLocalizedValue('track');
  String get details => _getLocalizedValue('details');
  String get service => _getLocalizedValue('service');
  String get refresh => _getLocalizedValue('refresh');
  String get export => _getLocalizedValue('export');
  String get loading => _getLocalizedValue('loading');
  String get error => _getLocalizedValue('error');
  String get success => _getLocalizedValue('success');
  String get warning => _getLocalizedValue('warning');
  String get info => _getLocalizedValue('info');

  // Cart Status
  String get statusActive => _getLocalizedValue('statusActive');
  String get statusIdle => _getLocalizedValue('statusIdle');
  String get statusCharging => _getLocalizedValue('statusCharging');
  String get statusMaintenance => _getLocalizedValue('statusMaintenance');
  String get statusOffline => _getLocalizedValue('statusOffline');

  // Priority
  String get priorityCritical => _getLocalizedValue('priorityCritical');
  String get priorityHigh => _getLocalizedValue('priorityHigh');
  String get priorityNormal => _getLocalizedValue('priorityNormal');
  String get priorityLow => _getLocalizedValue('priorityLow');

  // Alert Severity
  String get alertCritical => _getLocalizedValue('alertCritical');
  String get alertWarning => _getLocalizedValue('alertWarning');
  String get alertInfo => _getLocalizedValue('alertInfo');
  String get alertSuccess => _getLocalizedValue('alertSuccess');

  // Work Order Types
  String get woEmergency => _getLocalizedValue('woEmergency');
  String get woPreventive => _getLocalizedValue('woPreventive');
  String get woBattery => _getLocalizedValue('woBattery');
  String get woTire => _getLocalizedValue('woTire');
  String get woSafety => _getLocalizedValue('woSafety');
  String get woOther => _getLocalizedValue('woOther');

  // Manufacturers
  String get manufacturerDYInnovate =>
      _getLocalizedValue('manufacturerDYInnovate');
  String get manufacturerEZGO => _getLocalizedValue('manufacturerEZGO');
  String get manufacturerClubCar => _getLocalizedValue('manufacturerClubCar');
  String get manufacturerYamaha => _getLocalizedValue('manufacturerYamaha');
  String get manufacturerCushman => _getLocalizedValue('manufacturerCushman');

  // KPI Labels
  String get kpiAvailability => _getLocalizedValue('kpiAvailability');
  String get kpiMTTR => _getLocalizedValue('kpiMTTR');
  String get kpiUtilization => _getLocalizedValue('kpiUtilization');
  String get kpiDailyDistance => _getLocalizedValue('kpiDailyDistance');

  // Units
  String get unitPercent => _getLocalizedValue('unitPercent');
  String get unitMinutes => _getLocalizedValue('unitMinutes');
  String get unitKilometers => _getLocalizedValue('unitKilometers');
  String get unitKilometersPerHour =>
      _getLocalizedValue('unitKilometersPerHour');
  String get unitVolts => _getLocalizedValue('unitVolts');
  String get unitAmperes => _getLocalizedValue('unitAmperes');
  String get unitCelsius => _getLocalizedValue('unitCelsius');

  // Settings & Menu (新增)
  String get settingsTitle => _getLocalizedValue('settingsTitle');
  String get languageAndRegion => _getLocalizedValue('languageAndRegion');
  String get account => _getLocalizedValue('account');
  String get appSettings => _getLocalizedValue('appSettings');
  String get support => _getLocalizedValue('support');
  String get profileSettings => _getLocalizedValue('profileSettings');
  String get managePersonalInfo => _getLocalizedValue('managePersonalInfo');
  String get security => _getLocalizedValue('security');
  String get securityDescription => _getLocalizedValue('securityDescription');
  String get privacy => _getLocalizedValue('privacy');
  String get privacyDescription => _getLocalizedValue('privacyDescription');
  String get notifications => _getLocalizedValue('notifications');
  String get notificationsDescription => _getLocalizedValue('notificationsDescription');
  String get theme => _getLocalizedValue('theme');
  String get themeDescription => _getLocalizedValue('themeDescription');
  String get storage => _getLocalizedValue('storage');
  String get storageDescription => _getLocalizedValue('storageDescription');
  String get helpFaq => _getLocalizedValue('helpFaq');
  String get helpDescription => _getLocalizedValue('helpDescription');
  String get reportIssue => _getLocalizedValue('reportIssue');
  String get reportDescription => _getLocalizedValue('reportDescription');
  String get about => _getLocalizedValue('about');
  String get aboutDescription => _getLocalizedValue('aboutDescription');
  String get signOut => _getLocalizedValue('signOut');
  String get signOutConfirm => _getLocalizedValue('signOutConfirm');
  String get signedOutSuccess => _getLocalizedValue('signedOutSuccess');

  // Hamburger Menu (新增)
  String get quickActions => _getLocalizedValue('quickActions');
  String get dashboard => _getLocalizedValue('dashboard');
  String get dashboardSubtitle => _getLocalizedValue('dashboardSubtitle');
  String get scanQrCode => _getLocalizedValue('scanQrCode');
  String get scanQrSubtitle => _getLocalizedValue('scanQrSubtitle');
  String get refreshData => _getLocalizedValue('refreshData');
  String get refreshDataSubtitle => _getLocalizedValue('refreshDataSubtitle');
  String get dataRefreshed => _getLocalizedValue('dataRefreshed');
  String get language => _getLocalizedValue('language');
  String get english => _getLocalizedValue('english');
  String get korean => _getLocalizedValue('korean');
  String get japanese => _getLocalizedValue('japanese');
  String get chineseSimplified => _getLocalizedValue('chineseSimplified');
  String get chineseTraditional => _getLocalizedValue('chineseTraditional');

  // Inventory Stats (新增)
  String get total => _getLocalizedValue('total');
  String get active => _getLocalizedValue('active');
  String get charging => _getLocalizedValue('charging');
  String get maintenance => _getLocalizedValue('maintenance');
  String get offline => _getLocalizedValue('offline');

  // Cart Details & Metrics (新增)
  String get battery => _getLocalizedValue('battery');
  String get speed => _getLocalizedValue('speed');
  String get systemMetrics => _getLocalizedValue('systemMetrics');
  String get live => _getLocalizedValue('live');
  String get telemetry => _getLocalizedValue('telemetry');

  // Work Order & Alerts (新增)
  String get workOrderStatus => _getLocalizedValue('workOrderStatus');
  String get alertRules => _getLocalizedValue('alertRules');
  String get escalationPath => _getLocalizedValue('escalationPath');
  String get technician => _getLocalizedValue('technician');
  String get parts => _getLocalizedValue('parts');
  String get estimatedTime => _getLocalizedValue('estimatedTime');

  // Common UI Elements (新增)
  String get comingSoon => _getLocalizedValue('comingSoon');
  String get ok => _getLocalizedValue('ok');
  String get version => _getLocalizedValue('version');
  String get manufacturer => _getLocalizedValue('manufacturer');
  String get product => _getLocalizedValue('product');
  String get languageChanged => _getLocalizedValue('languageChanged');

  // Work Order Type Selector (新增)
  String get workOrderType => _getLocalizedValue('workOrderType');
  String get emergency => _getLocalizedValue('emergency');
  String get preventive => _getLocalizedValue('preventive');
  String get tire => _getLocalizedValue('tire');
  String get safety => _getLocalizedValue('safety');
  String get other => _getLocalizedValue('other');

  // Priority Selector (新增)
  String get priorityLevel => _getLocalizedValue('priorityLevel');
  String get critical => _getLocalizedValue('critical');
  String get high => _getLocalizedValue('high');
  String get normal => _getLocalizedValue('normal');
  String get low => _getLocalizedValue('low');

  // Alert Summary Cards (新增)
  String get alertSummary => _getLocalizedValue('alertSummary');
  String get totalAlerts => _getLocalizedValue('totalAlerts');
  String get resolved => _getLocalizedValue('resolved');

  // Cart Detail Monitor (新增)
  String get primaryTelemetry => _getLocalizedValue('primaryTelemetry');
  String get motor => _getLocalizedValue('motor');
  String get main => _getLocalizedValue('main');
  String get daily => _getLocalizedValue('daily');
  String get energy => _getLocalizedValue('energy');
  String get alerts => _getLocalizedValue('alerts');
  String get remoteControls => _getLocalizedValue('remoteControls');
  String get emergencyControls => _getLocalizedValue('emergencyControls');
  String get emergencyStop => _getLocalizedValue('emergencyStop');
  String get stopCart => _getLocalizedValue('stopCart');

  // About Dialog (新增)
  String get aboutAproFleetManager => _getLocalizedValue('aboutAproFleetManager');
  String get versionInfo => _getLocalizedValue('versionInfo');
  String get manufacturerInfo => _getLocalizedValue('manufacturerInfo');
  String get productInfo => _getLocalizedValue('productInfo');

  // Work Order Filters
  String get woFilterAll => _getLocalizedValue('woFilterAll');
  String get woFilterUrgent => _getLocalizedValue('woFilterUrgent');
  String get woFilterPending => _getLocalizedValue('woFilterPending');
  String get woFilterInProgress => _getLocalizedValue('woFilterInProgress');
  String get woFilterCompleted => _getLocalizedValue('woFilterCompleted');
  String get woFilterTimeline => _getLocalizedValue('woFilterTimeline');

  // Work Order Stats
  String get woStatsUrgent => _getLocalizedValue('woStatsUrgent');
  String get woStatsPending => _getLocalizedValue('woStatsPending');
  String get woStatsInProgress => _getLocalizedValue('woStatsInProgress');
  String get woStatsToday => _getLocalizedValue('woStatsToday');

  // Work Order Status
  String get woStatusDraft => _getLocalizedValue('woStatusDraft');
  String get woStatusPending => _getLocalizedValue('woStatusPending');
  String get woStatusInProgress => _getLocalizedValue('woStatusInProgress');
  String get woStatusOnHold => _getLocalizedValue('woStatusOnHold');
  String get woStatusCompleted => _getLocalizedValue('woStatusCompleted');
  String get woStatusCancelled => _getLocalizedValue('woStatusCancelled');

  // Priority Levels
  String get woPriorityP1 => _getLocalizedValue('woPriorityP1');
  String get woPriorityP2 => _getLocalizedValue('woPriorityP2');
  String get woPriorityP3 => _getLocalizedValue('woPriorityP3');
  String get woPriorityP4 => _getLocalizedValue('woPriorityP4');

  // Work Order Types
  String get woTypeEmergency => _getLocalizedValue('woTypeEmergency');
  String get woTypePreventive => _getLocalizedValue('woTypePreventive');
  String get woTypeBattery => _getLocalizedValue('woTypeBattery');
  String get woTypeTire => _getLocalizedValue('woTypeTire');
  String get woTypeSafety => _getLocalizedValue('woTypeSafety');
  String get woTypeOther => _getLocalizedValue('woTypeOther');

  // Time Format
  String get woTimeDays => _getLocalizedValue('woTimeDays');
  String get woTimeHours => _getLocalizedValue('woTimeHours');
  String get woTimeMinutes => _getLocalizedValue('woTimeMinutes');
  String get woTimeAgo => _getLocalizedValue('woTimeAgo');

  // Messages
  String get woNoWorkOrders => _getLocalizedValue('woNoWorkOrders');
  String get woErrorLoading => _getLocalizedValue('woErrorLoading');
  String get woRetry => _getLocalizedValue('woRetry');

  // Hamburger Menu
  String get menuSettings => _getLocalizedValue('menuSettings');
  String get menuLanguage => _getLocalizedValue('menuLanguage');
  String get menuSettingsTitle => _getLocalizedValue('menuSettingsTitle');
  String get menuSettingsSubtitle => _getLocalizedValue('menuSettingsSubtitle');
  String get menuEnglish => _getLocalizedValue('menuEnglish');
  String get menuKorean => _getLocalizedValue('menuKorean');
  String get menuJapanese => _getLocalizedValue('menuJapanese');
  String get menuChineseSimplified => _getLocalizedValue('menuChineseSimplified');
  String get menuChineseTraditional => _getLocalizedValue('menuChineseTraditional');
  String get menuSignOut => _getLocalizedValue('menuSignOut');
  String get menuSignOutTitle => _getLocalizedValue('menuSignOutTitle');
  String get menuSignOutMessage => _getLocalizedValue('menuSignOutMessage');
  String get menuSignOutSuccess => _getLocalizedValue('menuSignOutSuccess');

  // Alert Screen
  String get alertTabAll => _getLocalizedValue('alertTabAll');
  String get alertTabUnread => _getLocalizedValue('alertTabUnread');
  String get alertTabCart => _getLocalizedValue('alertTabCart');
  String get alertTabBattery => _getLocalizedValue('alertTabBattery');
  String get alertTabMaintenance => _getLocalizedValue('alertTabMaintenance');
  String get alertTabGeofence => _getLocalizedValue('alertTabGeofence');
  String get alertTabSystem => _getLocalizedValue('alertTabSystem');
  String get alertErrorLoading => _getLocalizedValue('alertErrorLoading');
  String get alertRetry => _getLocalizedValue('alertRetry');
  String get alertNoAlerts => _getLocalizedValue('alertNoAlerts');
  String get alertAcknowledge => _getLocalizedValue('alertAcknowledge');
  String get alertViewCart => _getLocalizedValue('alertViewCart');
  String get alertCreateWorkOrder => _getLocalizedValue('alertCreateWorkOrder');
  String get alertTimeJustNow => _getLocalizedValue('alertTimeJustNow');
  String get alertTimeDaysAgo => _getLocalizedValue('alertTimeDaysAgo');
  String get alertTimeHoursAgo => _getLocalizedValue('alertTimeHoursAgo');
  String get alertTimeMinutesAgo => _getLocalizedValue('alertTimeMinutesAgo');

  // Alert Severity
  String get alertSeverityCritical => _getLocalizedValue('alertSeverityCritical');
  String get alertSeverityWarning => _getLocalizedValue('alertSeverityWarning');
  String get alertSeverityInfo => _getLocalizedValue('alertSeverityInfo');
  String get alertSeveritySuccess => _getLocalizedValue('alertSeveritySuccess');

  // Alert Status
  String get alertStatusTriggered => _getLocalizedValue('alertStatusTriggered');
  String get alertStatusNotified => _getLocalizedValue('alertStatusNotified');
  String get alertStatusAcknowledged => _getLocalizedValue('alertStatusAcknowledged');
  String get alertStatusEscalated => _getLocalizedValue('alertStatusEscalated');
  String get alertStatusResolved => _getLocalizedValue('alertStatusResolved');

  // Alert Source
  String get alertSourceEmergency => _getLocalizedValue('alertSourceEmergency');
  String get alertSourceBattery => _getLocalizedValue('alertSourceBattery');
  String get alertSourceMaintenance => _getLocalizedValue('alertSourceMaintenance');
  String get alertSourceGeofence => _getLocalizedValue('alertSourceGeofence');
  String get alertSourceTemperature => _getLocalizedValue('alertSourceTemperature');
  String get alertSourceSystem => _getLocalizedValue('alertSourceSystem');

  String _getLocalizedValue(String key) {
    switch (locale.languageCode) {
      case 'ja':
        return AppLocalizationsJa.values[key] ??
            AppLocalizationsEn.values[key]!;
      case 'ko':
        return AppLocalizationsKo.values[key] ??
            AppLocalizationsEn.values[key]!;
      case 'zh':
        if (locale.countryCode == 'CN') {
          return AppLocalizationsZhCn.values[key] ??
              AppLocalizationsEn.values[key]!;
        } else if (locale.countryCode == 'TW') {
          return AppLocalizationsZhTw.values[key] ??
              AppLocalizationsEn.values[key]!;
        }
        return AppLocalizationsZhCn.values[key] ??
            AppLocalizationsEn.values[key]!;
      default:
        return AppLocalizationsEn.values[key]!;
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
