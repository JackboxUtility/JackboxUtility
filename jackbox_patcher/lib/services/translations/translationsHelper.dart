import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TranslationsHelper {
  static final TranslationsHelper _instance = TranslationsHelper._internal();

  factory TranslationsHelper() {
    return _instance;
  }

  AppLocalizations? appLocalizations;
  TranslationsHelper._internal();
}
