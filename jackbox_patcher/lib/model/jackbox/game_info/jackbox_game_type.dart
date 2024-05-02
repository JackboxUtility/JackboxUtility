import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/services/translations/translations_helper.dart';

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

  IconData get icon {
    switch (this) {
      case JackboxGameType.VERSUS:
        return FontAwesomeIcons.users;
      case JackboxGameType.COOP:
        return FontAwesomeIcons.handshake;
      case JackboxGameType.TEAM:
        return FontAwesomeIcons.peopleGroup;
    }
  }
}
