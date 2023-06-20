import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../jackbox/gameinfo/familyfriendly.dart';
import '../jackbox/gameinfo/moderation.dart';
import '../jackbox/gameinfo/streamfriendly.dart';
import '../jackbox/jackboxgame.dart';

enum FilterValue {
  FAMILY_FRIENDLY_AVAILABLE,
  AUDIENCE_AVAILABLE,
  STREAM_FRIENDLY_PLAYABLE,
  STREAM_FRIENDLY_MIDLY_PLAYABLE,
  MODERATION_FULL_MODERATION,
  MODERATION_CENSORING,
  SUBTITLES_AVAILABLE;
}

extension FilterValueExtension on FilterValue {
  String get name {
    switch (this) {
      case FilterValue.FAMILY_FRIENDLY_AVAILABLE:
        return 'Available';
      case FilterValue.AUDIENCE_AVAILABLE:
        return 'Available';
      case FilterValue.STREAM_FRIENDLY_PLAYABLE:
        return 'Playable';
      case FilterValue.STREAM_FRIENDLY_MIDLY_PLAYABLE:
        return 'Mildly Playable';
      case FilterValue.MODERATION_FULL_MODERATION:
        return 'Full Moderation';
      case FilterValue.MODERATION_CENSORING:
        return 'Censoring';
      case FilterValue.SUBTITLES_AVAILABLE:
        return 'Available';
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
      case FilterValue.MODERATION_FULL_MODERATION:
        return Colors.green;
      case FilterValue.MODERATION_CENSORING:
        return Colors.orange;
      case FilterValue.SUBTITLES_AVAILABLE:
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
      case FilterValue.MODERATION_FULL_MODERATION:
        return [GameInfoModeration.FULL_MODERATION];
      case FilterValue.MODERATION_CENSORING:
        return [GameInfoModeration.CENSORING];
      case FilterValue.SUBTITLES_AVAILABLE:
        return [true];
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
      case FilterValue.MODERATION_FULL_MODERATION:
        return FilterType.MODERATION;
      case FilterValue.MODERATION_CENSORING:
        return FilterType.MODERATION;
      case FilterValue.SUBTITLES_AVAILABLE:
        return FilterType.SUBTITLES;
      default:
        throw Exception('Unknown FilterValue');
    }
  }

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
    }
  }
}

enum FilterType {
  FAMILY_FRIENDLY,
  SUBTITLES,
  AUDIENCE,
  STREAM_FRIENDLY,
  MODERATION
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
      default:
        throw Exception('Unknown FilterType');
    }
  }

  IconData get icon {
    switch (this) {
      case FilterType.FAMILY_FRIENDLY:
        return FontAwesomeIcons.child;
      case FilterType.AUDIENCE:
        return FontAwesomeIcons.users;
      case FilterType.STREAM_FRIENDLY:
        return FontAwesomeIcons.twitch;
      case FilterType.MODERATION:
        return FontAwesomeIcons.userShield;
      case FilterType.SUBTITLES:
        return FontAwesomeIcons.closedCaptioning;
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
          FilterValue.STREAM_FRIENDLY_PLAYABLE,
          FilterValue.STREAM_FRIENDLY_MIDLY_PLAYABLE
        ];
      case FilterType.MODERATION:
        return [
          FilterValue.MODERATION_FULL_MODERATION,
          FilterValue.MODERATION_CENSORING
        ];
      case FilterType.SUBTITLES:
        return [FilterValue.SUBTITLES_AVAILABLE];
      default:
        throw Exception('Unknown FilterType');
    }
  }
}
