import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:jackbox_patcher/app_configuration.dart';
import 'package:jackbox_patcher/l10n/app_localizations.dart';

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
    localeChanges.value++;
  }

  AppLocalizations? appLocalizations;

  /// Changes each time the language is changed, for the widgets that aren't rebuilt by a page
  final ValueNotifier<int> localeChanges = ValueNotifier(0);
  TranslationsHelper._internal();
}
