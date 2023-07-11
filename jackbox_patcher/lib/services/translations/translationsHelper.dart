import 'dart:ui';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jackbox_patcher/app_configuration.dart';

/// Translations helper class used to access translations from anywhere (without the context)
class TranslationsHelper {
  static List<String> availableLanguages = APP_LANGUAGES;
  static Locale currentLanguage = const Locale(DEFAULT_APP_LANGUAGE);
  static final TranslationsHelper _instance = TranslationsHelper._internal();

  factory TranslationsHelper() {
    return _instance;
  }

  void changeLocale(Locale locale) {
    if (availableLanguages.contains(locale.toLanguageTag())){
      currentLanguage = locale;
      appLocalizations = lookupAppLocalizations(locale);
    }else{
      currentLanguage = const Locale(DEFAULT_APP_LANGUAGE);
      appLocalizations = lookupAppLocalizations(const Locale(DEFAULT_APP_LANGUAGE));
    }
  }

  AppLocalizations? appLocalizations;
  TranslationsHelper._internal();
}
