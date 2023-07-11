import 'dart:ui';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Translations helper class used to access translations from anywhere (without the context)
class TranslationsHelper {
  static List<String> availableLanguages = ["en", "fr", "es", "de", "uk", "be"];
  static Locale currentLanguage = Locale("en", "US");
  static final TranslationsHelper _instance = TranslationsHelper._internal();

  factory TranslationsHelper() {
    return _instance;
  }

  void changeLocale(Locale locale) {
    if (availableLanguages.contains(locale.toLanguageTag())){
      currentLanguage = locale;
      appLocalizations = lookupAppLocalizations(locale);
    }else{
      currentLanguage = Locale("en", "US");
      appLocalizations = lookupAppLocalizations(Locale("en", "US"));
    }
  }

  AppLocalizations? appLocalizations;
  TranslationsHelper._internal();
}
