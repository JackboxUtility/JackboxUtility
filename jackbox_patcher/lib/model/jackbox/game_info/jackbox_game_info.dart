import 'package:jackbox_patcher/model/game_tag.dart';
import 'package:jackbox_patcher/model/jackbox/game_info/family_friendly.dart';
import 'package:jackbox_patcher/model/jackbox/game_info/jackbox_game_min_max_info.dart';
import 'package:jackbox_patcher/model/jackbox/game_info/jackbox_game_type.dart';
import 'package:jackbox_patcher/model/jackbox/game_info/moderation.dart';
import 'package:jackbox_patcher/model/jackbox/game_info/stream_friendly.dart';
import 'package:jackbox_patcher/model/jackbox/game_info/translation.dart';
import 'package:jackbox_patcher/model/jackbox/jackbox_pack_patch.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack_patch.dart';
import 'package:jackbox_patcher/services/games/games_service.dart';

class JackboxGameInfo {
  final String internalGameId;
  final String tagline;
  final String description;
  final String smallDescription;
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

  factory JackboxGameInfo.fromJson(String gameId, Map<String, dynamic> json) {
    return JackboxGameInfo(
      internalGameId: gameId,
      tagline: json['tagline'],
      description: json['description'],
      smallDescription: json['small_description'],
      type: JackboxGameType.fromString(json['type']),
      internalTranslation: GameInfoTranslation.fromString(json['translation']),
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
    if (internalTranslation == GameInfoTranslation.COMMUNITY_TRANSLATED ||
        internalTranslation == GameInfoTranslation.NATIVELY_TRANSLATED) {
      UserJackboxGame? correspondingUserGame =
          GamesService().getUserJackboxGameById(this.internalGameId);
      if (correspondingUserGame == null) {
        return internalTranslation;
      }
      for (UserJackboxPackPatch patch
          in correspondingUserGame.getPack().patches) {
        JackboxPackPatchComponent? component =
            patch.patch.getComponentByGameId(this.internalGameId);
        if (component != null && component.patchType!.audios) {
          return GameInfoTranslation.COMMUNITY_DUBBED;
        }
      }
    }
    return internalTranslation;
  }

  Map<String, dynamic> toJson() {
    return {
      "tagline": tagline,
      "description": description,
      "small_description": smallDescription,
      "type": type.toString().split('.').last,
      "translation": internalTranslation.toString().split('.').last,
      "tags": tags.map((e) => e.id).toList(),
      "images": images,
      "players": players.toJson(),
      "playtime": playtime.toJson(),
      "family_friendly": familyFriendly.name,
      "audience": audience,
      "audience_description": audienceDescription,
      "stream_friendly": streamFriendly.name,
      "stream_friendly_description": streamFriendlyDescription,
      "moderation": moderation.name,
      "moderation_description": moderationDescription,
      "subtitles": subtitles,
    };
  }
}
