import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Language provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en', '')) {
    _loadLocale();
  }

  static const String _localeKey = 'selected_locale';

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);
    if (localeCode != null) {
      state = Locale(localeCode);
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  Future<void> setLocaleFromCode(String languageCode) async {
    await setLocale(Locale(languageCode));
  }
}

// Supported languages
class SupportedLanguage {
  final String code;
  final String name;
  final String nativeName;

  const SupportedLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
  });
}

final supportedLanguagesProvider = Provider<List<SupportedLanguage>>((ref) {
  return const [
    SupportedLanguage(
      code: 'en',
      name: 'English',
      nativeName: 'English',
    ),
    SupportedLanguage(
      code: 'uk',
      name: 'Ukrainian',
      nativeName: 'Українська',
    ),
    SupportedLanguage(
      code: 'de',
      name: 'German',
      nativeName: 'Deutsch',
    ),
  ];
});

// Current language provider
final currentLanguageProvider = Provider<SupportedLanguage>((ref) {
  final locale = ref.watch(localeProvider);
  final supportedLanguages = ref.watch(supportedLanguagesProvider);
  
  return supportedLanguages.firstWhere(
    (lang) => lang.code == locale.languageCode,
    orElse: () => supportedLanguages.first,
  );
});
