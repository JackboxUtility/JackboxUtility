import 'dart:ui';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Translations helper class used to access translations from anywhere (without the context)
class TranslationsHelper {
  static Locale currentLanguage = Locale("en", "US");
  static final TranslationsHelper _instance = TranslationsHelper._internal();

  factory TranslationsHelper() {
    return _instance;
  }

  void changeLocale(Locale locale) {
    currentLanguage = locale;
    appLocalizations = lookupAppLocalizations(locale);
  }

  AppLocalizations? appLocalizations;
  TranslationsHelper._internal();
}
