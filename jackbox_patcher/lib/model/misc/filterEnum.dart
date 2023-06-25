import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';

import '../jackbox/gameinfo/familyfriendly.dart';
import '../jackbox/gameinfo/moderation.dart';
import '../jackbox/gameinfo/streamfriendly.dart';
import '../jackbox/gameinfo/translation.dart';
import '../jackbox/jackboxgame.dart';

enum FilterValue {
  FAMILY_FRIENDLY_AVAILABLE,
  AUDIENCE_AVAILABLE,
  STREAM_FRIENDLY_PLAYABLE,
  STREAM_FRIENDLY_MIDLY_PLAYABLE,
  STREAM_FRIENDLY_BOTH,
  MODERATION_FULL_MODERATION,
  MODERATION_CENSORING,
  MODERATION_BOTH,
  SUBTITLES_AVAILABLE,
  TRANSLATION_DUBBED,
  TRANSLATION_TRANSLATED;
}

extension FilterValueExtension on FilterValue {
  String get name {
    switch (this) {
      case FilterValue.FAMILY_FRIENDLY_AVAILABLE:
        return 'Available';
      case FilterValue.AUDIENCE_AVAILABLE:
        return 'Available';
      case FilterValue.STREAM_FRIENDLY_PLAYABLE:
        return 'Fully Playable';
      case FilterValue.STREAM_FRIENDLY_MIDLY_PLAYABLE:
        return 'Midly Playable';
      case FilterValue.STREAM_FRIENDLY_BOTH:
        return 'Playable';
      case FilterValue.MODERATION_FULL_MODERATION:
        return 'Full Moderation';
      case FilterValue.MODERATION_CENSORING:
        return 'Censoring';
      case FilterValue.MODERATION_BOTH:
        return 'Mod. & Censoring';
      case FilterValue.SUBTITLES_AVAILABLE:
        return 'Available';
      case FilterValue.TRANSLATION_DUBBED:
        return 'Dubbed';
      case FilterValue.TRANSLATION_TRANSLATED:
        return 'Translated';
      default:
        throw Exception('Unknown FilterValue');
    }
  }

  Color get color {
    switch (this) {
      case FilterValue.FAMILY_FRIENDLY_AVAILABLE:
        return Colors.green;
      case FilterValue.AUDIENCE_AVAILABLE:
        return Colors.green;
      case FilterValue.STREAM_FRIENDLY_PLAYABLE:
        return Colors.green;
      case FilterValue.STREAM_FRIENDLY_MIDLY_PLAYABLE:
        return Colors.orange;
      case FilterValue.STREAM_FRIENDLY_BOTH:
        return Colors.blue;
      case FilterValue.MODERATION_FULL_MODERATION:
        return Colors.green;
      case FilterValue.MODERATION_CENSORING:
        return Colors.orange;
      case FilterValue.MODERATION_BOTH:
        return Colors.blue;
      case FilterValue.SUBTITLES_AVAILABLE:
        return Colors.green;
      case FilterValue.TRANSLATION_DUBBED:
        return Colors.blue;
      case FilterValue.TRANSLATION_TRANSLATED:
        return Colors.green;
      default:
        throw Exception('Unknown FilterValue');
    }
  }

  List<dynamic> get linkedGameInfo {
    switch (this) {
      case FilterValue.FAMILY_FRIENDLY_AVAILABLE:
        return [
          GameInfoFamilyFriendly.FAMILY_FRIENDLY,
          GameInfoFamilyFriendly.OPTIONAL
        ];
      case FilterValue.AUDIENCE_AVAILABLE:
        return [true];
      case FilterValue.STREAM_FRIENDLY_PLAYABLE:
        return [GameInfoStreamFriendly.PLAYABLE];
      case FilterValue.STREAM_FRIENDLY_MIDLY_PLAYABLE:
        return [GameInfoStreamFriendly.MIDLY_PLAYABLE];
      case FilterValue.STREAM_FRIENDLY_BOTH:
        return [
          GameInfoStreamFriendly.PLAYABLE,
          GameInfoStreamFriendly.MIDLY_PLAYABLE
        ];
      case FilterValue.MODERATION_FULL_MODERATION:
        return [GameInfoModeration.FULL_MODERATION];
      case FilterValue.MODERATION_CENSORING:
        return [GameInfoModeration.CENSORING];
      case FilterValue.MODERATION_BOTH:
        return [
          GameInfoModeration.FULL_MODERATION,
          GameInfoModeration.CENSORING
        ];
      case FilterValue.SUBTITLES_AVAILABLE:
        return [true];
      case FilterValue.TRANSLATION_DUBBED:
        return [GameInfoTranslation.NATIVELY_TRANSLATED, GameInfoTranslation.COMMUNITY_DUBBED];
      case FilterValue.TRANSLATION_TRANSLATED:
        return [GameInfoTranslation.NATIVELY_TRANSLATED, GameInfoTranslation.COMMUNITY_DUBBED,  GameInfoTranslation.COMMUNITY_TRANSLATED];
      default:
        throw Exception('Unknown FilterValue');
    }
  }

  FilterType get type {
    switch (this) {
      case FilterValue.FAMILY_FRIENDLY_AVAILABLE:
        return FilterType.FAMILY_FRIENDLY;
      case FilterValue.AUDIENCE_AVAILABLE:
        return FilterType.AUDIENCE;
      case FilterValue.STREAM_FRIENDLY_PLAYABLE:
        return FilterType.STREAM_FRIENDLY;
      case FilterValue.STREAM_FRIENDLY_MIDLY_PLAYABLE:
        return FilterType.STREAM_FRIENDLY;
      case FilterValue.STREAM_FRIENDLY_BOTH:
        return FilterType.STREAM_FRIENDLY;
      case FilterValue.MODERATION_FULL_MODERATION:
        return FilterType.MODERATION;
      case FilterValue.MODERATION_CENSORING:
        return FilterType.MODERATION;
      case FilterValue.MODERATION_BOTH:
        return FilterType.MODERATION;
      case FilterValue.SUBTITLES_AVAILABLE:
        return FilterType.SUBTITLES;
      case FilterValue.TRANSLATION_DUBBED:
        return FilterType.TRANSLATION;
      case FilterValue.TRANSLATION_TRANSLATED:
        return FilterType.TRANSLATION;
      default:
        throw Exception('Unknown FilterValue');
    }
  }

/**
 * Returns true if the game is valid with this filter
 */
  bool isValidWithThisFilter(JackboxGame game) {
    switch (this.type) {
      case FilterType.FAMILY_FRIENDLY:
        return this.linkedGameInfo.contains(game.info.familyFriendly);
      case FilterType.AUDIENCE:
        return this.linkedGameInfo.contains(game.info.audience);
      case FilterType.STREAM_FRIENDLY:
        return this.linkedGameInfo.contains(game.info.streamFriendly);
      case FilterType.MODERATION:
        return this.linkedGameInfo.contains(game.info.moderation);
      case FilterType.SUBTITLES:
        return this.linkedGameInfo.contains(game.info.subtitles);
      case FilterType.TRANSLATION:
        return this.linkedGameInfo.contains(game.info.translation);
    }
  }
}

enum FilterType {
  FAMILY_FRIENDLY,
  SUBTITLES,
  AUDIENCE,
  STREAM_FRIENDLY,
  MODERATION,
  TRANSLATION
}

extension FilterTypeExtension on FilterType {
  String get name {
    switch (this) {
      case FilterType.FAMILY_FRIENDLY:
        return 'Family Friendly';
      case FilterType.AUDIENCE:
        return 'Audience';
      case FilterType.STREAM_FRIENDLY:
        return 'Stream Friendly';
      case FilterType.MODERATION:
        return 'Moderation';
      case FilterType.SUBTITLES:
        return 'Subtitles';
      case FilterType.TRANSLATION:
        return 'Translation';
      default:
        throw Exception('Unknown FilterType');
    }
  }

  IconData get icon {
    switch (this) {
      case FilterType.FAMILY_FRIENDLY:
        return FontAwesomeIcons.child;
      case FilterType.AUDIENCE:
        return FontAwesomeIcons.userPlus;
      case FilterType.STREAM_FRIENDLY:
        return FontAwesomeIcons.twitch;
      case FilterType.MODERATION:
        return FontAwesomeIcons.userShield;
      case FilterType.SUBTITLES:
        return FontAwesomeIcons.closedCaptioning;
      case FilterType.TRANSLATION:
        return FontAwesomeIcons.language;
      default:
        throw Exception('Unknown FilterType');
    }
  }

  List<FilterValue> get values {
    switch (this) {
      case FilterType.FAMILY_FRIENDLY:
        return [FilterValue.FAMILY_FRIENDLY_AVAILABLE];
      case FilterType.AUDIENCE:
        return [FilterValue.AUDIENCE_AVAILABLE];
      case FilterType.STREAM_FRIENDLY:
        return [
          FilterValue.STREAM_FRIENDLY_BOTH,
          FilterValue.STREAM_FRIENDLY_PLAYABLE,
          FilterValue.STREAM_FRIENDLY_MIDLY_PLAYABLE
        ];
      case FilterType.MODERATION:
        return [
          FilterValue.MODERATION_BOTH,
          FilterValue.MODERATION_FULL_MODERATION,
          FilterValue.MODERATION_CENSORING
        ];
      case FilterType.SUBTITLES:
        return [FilterValue.SUBTITLES_AVAILABLE];
      case FilterType.TRANSLATION:
        return APIService().cachedConfigurations?.getConfiguration("LAUNCHER", "HIDE_DUBBED") == true?[
          FilterValue.TRANSLATION_TRANSLATED
        ]: [
          FilterValue.TRANSLATION_TRANSLATED,
          FilterValue.TRANSLATION_DUBBED
        ];
      default:
        throw Exception('Unknown FilterType');
    }
  }
}
