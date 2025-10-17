import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Language settings controller
class LanguageController extends StateNotifier<Locale> {
  LanguageController() : super(const Locale('en'));

  void setLanguage(Locale locale) {
    state = locale;
  }

  void setLanguageByCode(String languageCode) {
    switch (languageCode) {
      case 'ko':
        state = const Locale('ko');
        break;
      case 'ja':
        state = const Locale('ja');
        break;
      default:
        state = const Locale('en');
    }
  }

  String get currentLanguageCode => state.languageCode;

  String get currentLanguageName {
    switch (state.languageCode) {
      case 'ko':
        return '한국어';
      case 'ja':
        return '日本語';
      default:
        return 'English';
    }
  }
}

/// Language controller provider
final languageControllerProvider =
    StateNotifierProvider<LanguageController, Locale>((ref) {
  return LanguageController();
});

/// Supported languages
class SupportedLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const SupportedLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}

/// List of supported languages
const List<SupportedLanguage> supportedLanguages = [
  SupportedLanguage(
    code: 'en',
    name: 'English',
    nativeName: 'English',
    flag: '🇺🇸',
  ),
  SupportedLanguage(
    code: 'ko',
    name: 'Korean',
    nativeName: '한국어',
    flag: '🇰🇷',
  ),
  SupportedLanguage(
    code: 'ja',
    name: 'Japanese',
    nativeName: '日本語',
    flag: '🇯🇵',
  ),
];
