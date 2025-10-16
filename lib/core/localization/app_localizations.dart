import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
  ];

  // App Name
  String get appName => _getLocalizedValue('appName');

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

  String _getLocalizedValue(String key) {
    switch (locale.languageCode) {
      case 'ja':
        return AppLocalizationsJa.values[key] ??
            AppLocalizationsEn.values[key]!;
      case 'ko':
        return AppLocalizationsKo.values[key] ??
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
    return ['en', 'ja', 'ko'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
