import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum FilterValue {
  FAMILY_FRIENDLY_AVAILABLE,
  FAMILY_FRIENDLY_UNAVAILABLE,
  AUDIENCE_AVAILABLE,
  AUDIENCE_UNAVAILABLE,
  STREAM_FRIENDLY_PLAYABLE,
  STREAM_FRIENDLY_MIDLY_PLAYABLE,
  STREAM_FRIENDLY_NOT_PLAYABLE,
  MODERATION_FULL_MODERATION,
  MODERATION_CENSORING,
  MODERATION_NO_MODERATION,
  SUBTITLES_AVAILABLE,
  SUBTITLES_UNAVAILABLE;
}

extension FilterValueExtension on FilterValue {
  String get name {
    switch (this) {
      case FilterValue.FAMILY_FRIENDLY_AVAILABLE:
        return 'Available';
      case FilterValue.FAMILY_FRIENDLY_UNAVAILABLE:
        return 'Unavailable';
      case FilterValue.AUDIENCE_AVAILABLE:
        return 'Available';
      case FilterValue.AUDIENCE_UNAVAILABLE:
        return 'Unavailable';
      case FilterValue.STREAM_FRIENDLY_PLAYABLE:
        return 'Playable';
      case FilterValue.STREAM_FRIENDLY_MIDLY_PLAYABLE:
        return 'Mildly Playable';
      case FilterValue.STREAM_FRIENDLY_NOT_PLAYABLE:
        return 'Not Playable';
      case FilterValue.MODERATION_FULL_MODERATION:
        return 'Full Moderation';
      case FilterValue.MODERATION_CENSORING:
        return 'Censoring';
      case FilterValue.MODERATION_NO_MODERATION:
        return 'No Moderation';
      case FilterValue.SUBTITLES_AVAILABLE:
        return 'Available';
      case FilterValue.SUBTITLES_UNAVAILABLE:
        return 'Unavailable';
      default:
        throw Exception('Unknown FilterValue');
    }
  }

  Color get color{
    switch (this) {
      case FilterValue.FAMILY_FRIENDLY_AVAILABLE:
        return Colors.green;
      case FilterValue.FAMILY_FRIENDLY_UNAVAILABLE:
        return Colors.red;
      case FilterValue.AUDIENCE_AVAILABLE:
        return Colors.green;
      case FilterValue.AUDIENCE_UNAVAILABLE:
        return Colors.red;
      case FilterValue.STREAM_FRIENDLY_PLAYABLE:
        return Colors.green;
      case FilterValue.STREAM_FRIENDLY_MIDLY_PLAYABLE:
        return Colors.orange;
      case FilterValue.STREAM_FRIENDLY_NOT_PLAYABLE:
        return Colors.red;
      case FilterValue.MODERATION_FULL_MODERATION:
        return Colors.green;
      case FilterValue.MODERATION_CENSORING:
        return Colors.orange;
      case FilterValue.MODERATION_NO_MODERATION:
        return Colors.red;
      case FilterValue.SUBTITLES_AVAILABLE:
        return Colors.green;
      case FilterValue.SUBTITLES_UNAVAILABLE:
        return Colors.red;
      default:
        throw Exception('Unknown FilterValue');
    }
  }
}

enum FilterType {
  FAMILY_FRIENDLY,
  AUDIENCE,
  STREAM_FRIENDLY,
  MODERATION,
  SUBTITLES
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
        return [
          FilterValue.FAMILY_FRIENDLY_AVAILABLE,
          FilterValue.FAMILY_FRIENDLY_UNAVAILABLE
        ];
      case FilterType.AUDIENCE:
        return [
          FilterValue.AUDIENCE_AVAILABLE,
          FilterValue.AUDIENCE_UNAVAILABLE
        ];
      case FilterType.STREAM_FRIENDLY:
        return [
          FilterValue.STREAM_FRIENDLY_PLAYABLE,
          FilterValue.STREAM_FRIENDLY_MIDLY_PLAYABLE,
          FilterValue.STREAM_FRIENDLY_NOT_PLAYABLE
        ];
      case FilterType.MODERATION:
        return [
          FilterValue.MODERATION_FULL_MODERATION,
          FilterValue.MODERATION_CENSORING,
          FilterValue.MODERATION_NO_MODERATION
        ];
      case FilterType.SUBTITLES:
        return [
          FilterValue.SUBTITLES_AVAILABLE,
          FilterValue.SUBTITLES_UNAVAILABLE
        ];
      default:
        throw Exception('Unknown FilterType');
    }
  }
}
