import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/model/base/patchinformation.dart';
import 'package:jackbox_patcher/model/gametag.dart';
import 'package:jackbox_patcher/model/jackbox/gameinfo/familyfriendly.dart';
import 'package:jackbox_patcher/model/jackbox/jackboxpack.dart';
import 'package:jackbox_patcher/model/jackbox/jackboxgamepatch.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:jackbox_patcher/services/translations/language_service.dart';
import 'package:jackbox_patcher/services/translations/translationsHelper.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';

import '../usermodel/userjackboxgame.dart';
import '../usermodel/userjackboxpack.dart';
import 'gameinfo/moderation.dart';
import 'gameinfo/streamfriendly.dart';
import 'gameinfo/translation.dart';

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

  factory JackboxGame.fromJson(Map<String, dynamic> json, bool isDubbed) {
    List<JackboxGamePatch> patches = [];
    patches = (json['patchs'] as List<dynamic>)
        .map((e) => JackboxGamePatch.fromJson(e))
        .toList();
    if (!isDubbed &&
        patches.where((element) => element.patchType!.audios).isNotEmpty) {
      isDubbed = true;
    }
    return JackboxGame(
      id: json['id'],
      name: json['name'],
      background: json['background'],
      loader: json['loader'] != null
          ? JackboxLoader.fromJson(json['loader'])
          : null,
      path: json['path'],
      patches: patches,
      info: JackboxGameInfo.fromJson(json["id"], json['game_info'], isDubbed),
    );
  }

  String get filteredName {
    return this.name.replaceAll(RegExp("[^a-zA-Z0-9 ]"), "");
  }
}

class JackboxGameInfo {
  final String internalGameId;
  final String tagline;
  final String description;
  final String smallDescription;
  final String length;
  final JackboxGameType type;
  final GameInfoTranslation internalTranslation;
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
    required this.internalGameId,
    required this.tagline,
    required this.smallDescription,
    required this.description,
    required this.length,
    required this.type,
    required this.internalTranslation,
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

  factory JackboxGameInfo.fromJson(
      String gameId, Map<String, dynamic> json, bool isDubbed) {
    //print(json);
    return JackboxGameInfo(
      internalGameId: gameId,
      tagline: json['tagline'],
      description: json['description'],
      smallDescription: json['small_description'],
      length: json['length'],
      type: JackboxGameType.fromString(json['type']),
      internalTranslation:
          GameInfoTranslation.fromString(json['translation'], isDubbed),
      images:
          (json['images'] as List<dynamic>).map((e) => e.toString()).toList(),
      tags: json['tags'] != null
          ? (json['tags'] as List<dynamic>).map((e) {
              return GameTag.fromId(e);
            }).toList()
          : [],
      players: JackboxGameMinMaxInfo.fromJson(json['players']),
      playtime: JackboxGameMinMaxInfo.fromJson(json['playtime']),
      familyFriendly:
          GameInfoFamilyFriendlyExtension.fromValue(json['family_friendly']),
      audience: json['audience'],
      audienceDescription: json['audience_description'],
      streamFriendly:
          GameInfoStreamFriendlyExtension.fromValue(json['stream_friendly']),
      streamFriendlyDescription: json['stream_friendly_description'],
      moderation: GameInfoModerationExtension.fromValue(json['moderation']),
      moderationDescription: json['moderation_description'],
      subtitles: json['subtitles'],
    );
  }

  get translation {
    if (internalTranslation == GameInfoTranslation.COMMUNITY_DUBBED) {
      UserJackboxGame? correspondingUserGame;
      for (var pack in UserData().packs) {
        for (var game in pack.games) {
          if (game.game.id == this.internalGameId) {
            correspondingUserGame = game;
            break;
          }
        }
      }
      if (correspondingUserGame == null) {
        return GameInfoTranslation.COMMUNITY_TRANSLATED;
      }
      PatchInformation? installedPatch = correspondingUserGame.getInstalledPatch();
      if (installedPatch==null || !installedPatch.patchType!.audios) {
        return GameInfoTranslation.COMMUNITY_TRANSLATED;
      }
    }
    return internalTranslation;
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
