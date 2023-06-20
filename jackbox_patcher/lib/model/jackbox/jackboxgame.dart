import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/gametag.dart';
import 'package:jackbox_patcher/model/jackbox/gameinfo/familyfriendly.dart';
import 'package:jackbox_patcher/model/jackbox/jackboxpack.dart';
import 'package:jackbox_patcher/model/jackbox/jackboxgamepatch.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:jackbox_patcher/services/translations/language_service.dart';
import 'package:jackbox_patcher/services/translations/translationsHelper.dart';

import '../usermodel/userjackboxgame.dart';
import '../usermodel/userjackboxpack.dart';
import 'gameinfo/moderation.dart';
import 'gameinfo/streamfriendly.dart';

class JackboxGame {
  final String id;
  final String name;
  final String background;
  final JackboxLoader? loader;
  final String? path;
  final List<JackboxGamePatch> patches;
  final JackboxGameInfo info;

  JackboxGame({
    required this.id,
    required this.name,
    required this.background,
    required this.loader,
    required this.path,
    required this.patches,
    required this.info,
  });

  factory JackboxGame.fromJson(Map<String, dynamic> json) {
    return JackboxGame(
      id: json['id'],
      name: json['name'],
      background: json['background'],
      loader: json['loader'] != null
          ? JackboxLoader.fromJson(json['loader'])
          : null,
      path: json['path'],
      patches: (json['patchs'] as List<dynamic>)
          .map((e) => JackboxGamePatch.fromJson(e))
          .toList(),
      info: JackboxGameInfo.fromJson(json['game_info']),
    );
  }

  String get filteredName {
    return this.name.replaceAll(RegExp("[^a-zA-Z0-9 ]"), "");
  }
}

class JackboxGameInfo {
  final String tagline;
  final String description;
  final String smallDescription;
  final String length;
  final JackboxGameType type;
  final JackboxGameTranslation translation;
  final List<GameTag> tags;
  final List<String> images;
  final JackboxGameMinMaxInfo players;
  final JackboxGameMinMaxInfo playtime;
  final GameInfoFamilyFriendly familyFriendly;
  final bool audience;
  final String? audienceDescription;
  final GameInfoStreamFriendly streamFriendly;
  final String? streamFriendlyDescription;
  final GameInfoModeration moderation;
  final String? moderationDescription;
  final bool subtitles;

  JackboxGameInfo({
    required this.tagline,
    required this.smallDescription,
    required this.description,
    required this.length,
    required this.type,
    required this.translation,
    required this.tags,
    required this.images,
    required this.players,
    required this.playtime,
    required this.familyFriendly,
    required this.audience,
    required this.audienceDescription,
    required this.streamFriendly,
    required this.streamFriendlyDescription,
    required this.moderation,
    required this.moderationDescription,
    required this.subtitles,
  });

  factory JackboxGameInfo.fromJson(Map<String, dynamic> json) {
    return JackboxGameInfo(
      tagline: json['tagline'],
      description: json['description'],
      smallDescription: json['small_description'],
      length: json['length'],
      type: JackboxGameType.fromString(json['type']),
      translation: JackboxGameTranslation.fromString(json['translation']),
      images:
          (json['images'] as List<dynamic>).map((e) => e.toString()).toList(),
      tags: (json['tags'] as List<dynamic>)
          .map((e) => GameTag.fromId(e))
          .toList(),
      players: JackboxGameMinMaxInfo.fromJson(json['players']),
      playtime: JackboxGameMinMaxInfo.fromJson(json['playtime']),
      familyFriendly: GameInfoFamilyFriendlyExtension.fromValue(json['family_friendly']),
      audience: json['audience'],
      audienceDescription: json['audience_description'],
      streamFriendly: GameInfoStreamFriendlyExtension.fromValue(json['stream_friendly']),
      streamFriendlyDescription: json['stream_friendly_description'],
      moderation: GameInfoModerationExtension.fromValue(json['moderation']),
      moderationDescription: json['moderation_description'],
      subtitles: json['subtitles'],
    );
  }
}

class JackboxGameMinMaxInfo {
  final int min;
  final int max;

  JackboxGameMinMaxInfo({
    required this.min,
    required this.max,
  });

  factory JackboxGameMinMaxInfo.fromJson(Map<String, dynamic> json) {
    return JackboxGameMinMaxInfo(
      min: json['min'],
      max: json['max'],
    );
  }
}

enum JackboxGameType {
  VERSUS,
  COOP,
  TEAM;

  static JackboxGameType fromString(String type) {
    switch (type) {
      case 'VERSUS':
        return JackboxGameType.VERSUS;
      case 'COOP':
        return JackboxGameType.COOP;
      case 'TEAM':
        return JackboxGameType.TEAM;
      default:
        return JackboxGameType.VERSUS;
    }
  }

  String get name {
    switch (this) {
      case JackboxGameType.VERSUS:
        return TranslationsHelper().appLocalizations!.game_type_versus;
      case JackboxGameType.COOP:
        return TranslationsHelper().appLocalizations!.game_type_coop;
      case JackboxGameType.TEAM:
        return TranslationsHelper().appLocalizations!.game_type_team;
    }
  }

  String get description {
    switch (this) {
      case JackboxGameType.VERSUS:
        return TranslationsHelper()
            .appLocalizations!
            .game_type_versus_description;
      case JackboxGameType.COOP:
        return TranslationsHelper()
            .appLocalizations!
            .game_type_coop_description;
      case JackboxGameType.TEAM:
        return TranslationsHelper()
            .appLocalizations!
            .game_type_team_description;
    }
  }
}

enum JackboxGameTranslation {
  NATIVELY_TRANSLATED,
  COMMUNITY_TRANSLATED,
  ENGLISH;

  static JackboxGameTranslation fromString(String translation) {
    switch (translation) {
      case 'NATIVELY_TRANSLATED':
        return JackboxGameTranslation.NATIVELY_TRANSLATED;
      case 'COMMUNITY_TRANSLATED':
        return JackboxGameTranslation.COMMUNITY_TRANSLATED;
      case 'ENGLISH':
        return JackboxGameTranslation.ENGLISH;
      default:
        return JackboxGameTranslation.ENGLISH;
    }
  }

  String get name {
    String languageKey = APIService().cachedSelectedServer!.languages[0];
    switch (this) {
      case JackboxGameTranslation.NATIVELY_TRANSLATED:
        return TranslationsHelper()
            .appLocalizations!
            .game_translation_translated(
                LanguageService().getLanguageName(languageKey));
      case JackboxGameTranslation.COMMUNITY_TRANSLATED:
        return TranslationsHelper()
            .appLocalizations!
            .game_translation_community_translated;
      case JackboxGameTranslation.ENGLISH:
        return TranslationsHelper()
            .appLocalizations!
            .game_translation_not_available;
    }
  }

  String get description {
    String languageKey = APIService().cachedSelectedServer!.languages[0];
    switch (this) {
      case JackboxGameTranslation.NATIVELY_TRANSLATED:
        return TranslationsHelper()
            .appLocalizations!
            .game_translation_translated_description(
                LanguageService().getLanguageName(languageKey));
      case JackboxGameTranslation.COMMUNITY_TRANSLATED:
        return TranslationsHelper()
            .appLocalizations!
            .game_translation_community_translated_description;
      case JackboxGameTranslation.ENGLISH:
        return TranslationsHelper()
            .appLocalizations!
            .game_translation_not_available_description(
                LanguageService().getLanguageName(languageKey));
    }
  }

  Color get color {
    switch (this) {
      case JackboxGameTranslation.NATIVELY_TRANSLATED:
        return const Color.fromARGB(255, 13, 187, 196);
      case JackboxGameTranslation.COMMUNITY_TRANSLATED:
        return const Color.fromARGB(255, 20, 140, 12);
      case JackboxGameTranslation.ENGLISH:
        return const Color.fromARGB(255, 207, 0, 0);
    }
  }
}

enum JackboxGameTranslationCategory {
  TRANSLATED,
  NATIVELY_TRANSLATED,
  DUBBED,
  COMMUNITY_DUBBED,
  COMMUNITY_TRANSLATED,
  ENGLISH;

  String get id {
    switch (this) {
      case JackboxGameTranslationCategory.TRANSLATED:
        return 'TRANSLATED';
      case JackboxGameTranslationCategory.NATIVELY_TRANSLATED:
        return 'NATIVELY_TRANSLATED';
      case JackboxGameTranslationCategory.COMMUNITY_DUBBED:
        return 'COMMUNITY_DUBBED';
      case JackboxGameTranslationCategory.DUBBED:
        return 'DUBBED';
      case JackboxGameTranslationCategory.COMMUNITY_TRANSLATED:
        return 'COMMUNITY_TRANSLATED';
      case JackboxGameTranslationCategory.ENGLISH:
        return 'ENGLISH';
    }
  }

  Color get color {
    switch (this) {
      case JackboxGameTranslationCategory.TRANSLATED:
        return const Color.fromARGB(255, 0, 208, 0);
      case JackboxGameTranslationCategory.COMMUNITY_DUBBED:
        return const Color.fromARGB(255, 12, 78, 140);
      case JackboxGameTranslationCategory.DUBBED:
        return const Color.fromARGB(255, 12, 140, 140);
      default:
        return JackboxGameTranslation.fromString(id).color;
    }
  }

  String get name {
    String languageKey = APIService().cachedSelectedServer!.languages[0];
    switch (this) {
      case JackboxGameTranslationCategory.TRANSLATED:
        return TranslationsHelper()
            .appLocalizations!
            .in_language(LanguageService().getLanguageName(languageKey));
      case JackboxGameTranslationCategory.COMMUNITY_DUBBED:
        return TranslationsHelper().appLocalizations!.game_community_dubbed;
      case JackboxGameTranslationCategory.DUBBED:
        return TranslationsHelper()
            .appLocalizations!
            .game_dubbed(LanguageService().getLanguageName(languageKey));
      default:
        return JackboxGameTranslation.fromString(id).name;
    }
  }

  String get description {
    switch (this) {
      case JackboxGameTranslationCategory.TRANSLATED:
        String languageKey = APIService().cachedSelectedServer!.languages[0];
        return TranslationsHelper().appLocalizations!.in_language_description(
            LanguageService().getLanguageName(languageKey));
      case JackboxGameTranslationCategory.COMMUNITY_DUBBED:
        return TranslationsHelper()
            .appLocalizations!
            .game_community_dubbed_description;
      case JackboxGameTranslationCategory.DUBBED:
        return TranslationsHelper().appLocalizations!.game_dubbed_description;
      default:
        return JackboxGameTranslation.fromString(id).description;
    }
  }

  Function(UserJackboxPack pack, UserJackboxGame game) get filter {
    switch (this) {
      case JackboxGameTranslationCategory.TRANSLATED:
        return (UserJackboxPack pack, UserJackboxGame game) {
          return (game.game.info.translation ==
                  JackboxGameTranslation.COMMUNITY_TRANSLATED ||
              game.game.info.translation ==
                  JackboxGameTranslation.NATIVELY_TRANSLATED);
        };
      case JackboxGameTranslationCategory.NATIVELY_TRANSLATED:
        return (UserJackboxPack pack, UserJackboxGame game) {
          return (game.game.info.translation ==
              JackboxGameTranslation.NATIVELY_TRANSLATED);
        };
      case JackboxGameTranslationCategory.COMMUNITY_DUBBED:
        return (UserJackboxPack pack, UserJackboxGame game) {
          return (game.getInstalledPatch() != null &&
              game.getInstalledPatch()!.patchType!.audios);
        };
      case JackboxGameTranslationCategory.DUBBED:
        return (UserJackboxPack pack, UserJackboxGame game) {
          return ((game.getInstalledPatch() != null &&
                  game.getInstalledPatch()!.patchType!.audios) ||
              game.game.info.translation ==
                  JackboxGameTranslation.NATIVELY_TRANSLATED);
        };
      case JackboxGameTranslationCategory.COMMUNITY_TRANSLATED:
        return (UserJackboxPack pack, UserJackboxGame game) {
          return (game.game.info.translation ==
              JackboxGameTranslation.COMMUNITY_TRANSLATED);
        };

      case JackboxGameTranslationCategory.ENGLISH:
        return (UserJackboxPack pack, UserJackboxGame game) {
          return (game.game.info.translation == JackboxGameTranslation.ENGLISH);
        };
    }
  }
}
