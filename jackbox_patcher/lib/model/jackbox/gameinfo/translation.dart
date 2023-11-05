import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/services/api_utility/api_service.dart';
import 'package:jackbox_patcher/services/translations/translationsHelper.dart';

import '../../../services/translations/language_service.dart';

enum GameInfoTranslation {
  NATIVELY_TRANSLATED,
  COMMUNITY_DUBBED,
  COMMUNITY_TRANSLATED,
  ENGLISH;

  static GameInfoTranslation fromString(String translation) {
    switch (translation) {
      case 'NATIVELY_TRANSLATED':
        return GameInfoTranslation.NATIVELY_TRANSLATED;
      case 'COMMUNITY_TRANSLATED':
        return GameInfoTranslation.COMMUNITY_TRANSLATED;
      case 'ENGLISH':
        return GameInfoTranslation.ENGLISH;
      default:
        return GameInfoTranslation.ENGLISH;
    }
  }

  String get name {
    String languageKey = APIService().cachedSelectedServer!.languages[0];
    switch (this) {
      case GameInfoTranslation.NATIVELY_TRANSLATED:
        return languageKey == "en"?  "Translated in other languages":
        TranslationsHelper()
            .appLocalizations!
            .game_translation_translated(
                LanguageService().getLanguageName(languageKey));
      case GameInfoTranslation.COMMUNITY_TRANSLATED:
        return TranslationsHelper()
            .appLocalizations!
            .game_translation_community_translated;
      case GameInfoTranslation.COMMUNITY_DUBBED:
        return TranslationsHelper()
            .appLocalizations!
            .game_community_dubbed;
      case GameInfoTranslation.ENGLISH:
        return TranslationsHelper()
            .appLocalizations!
            .game_translation_not_available;
    }
  }

  String get description {
    String languageKey = APIService().cachedSelectedServer!.languages[0];
    switch (this) {
      case GameInfoTranslation.NATIVELY_TRANSLATED:
        return languageKey == "en"? TranslationsHelper().appLocalizations!.game_translation_translated_description_en:  TranslationsHelper()
            .appLocalizations!
            .game_translation_translated_description(
                LanguageService().getLanguageName(languageKey));
      case GameInfoTranslation.COMMUNITY_TRANSLATED:
        return TranslationsHelper()
            .appLocalizations!
            .game_translation_community_translated_description(
                LanguageService().getLanguageName(languageKey));
      case GameInfoTranslation.COMMUNITY_DUBBED:
        return TranslationsHelper()
            .appLocalizations!
            .game_community_dubbed_description;
      case GameInfoTranslation.ENGLISH:
        return languageKey == "en"? TranslationsHelper().appLocalizations!.game_translation_not_available_description_en: TranslationsHelper()
            .appLocalizations!
            .game_translation_not_available_description(
                LanguageService().getLanguageName(languageKey));
    }
  }

  Color get color {
    switch (this) {
      case GameInfoTranslation.NATIVELY_TRANSLATED:
        return const Color.fromARGB(255, 13, 187, 196);
      case GameInfoTranslation.COMMUNITY_DUBBED:
        return Color.fromARGB(255, 12, 121, 140);
      case GameInfoTranslation.COMMUNITY_TRANSLATED:
        return const Color.fromARGB(255, 20, 140, 12);
      case GameInfoTranslation.ENGLISH:
        return const Color.fromARGB(255, 207, 0, 0);
    }
  }
}