import 'package:jackbox_patcher/model/gametag.dart';
import 'package:jackbox_patcher/model/jackboxpack.dart';
import 'package:jackbox_patcher/model/jackboxpatch.dart';

class JackboxGame {
  final String id;
  final String name;
  final String background;
  final JackboxLoader? loader;
  final String? path;
  final List<JackboxPatch> patches;
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
          .map((e) => JackboxPatch.fromJson(e))
          .toList(),
      info: JackboxGameInfo.fromJson(json['game_info']),
    );
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
  final JackboxGamePlayersInfo players;

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
      players: JackboxGamePlayersInfo.fromJson(json['players']),
    );
  }
}

class JackboxGamePlayersInfo {
  final int min;
  final int max;

  JackboxGamePlayersInfo({
    required this.min,
    required this.max,
  });

  factory JackboxGamePlayersInfo.fromJson(Map<String, dynamic> json) {
    return JackboxGamePlayersInfo(
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
        return 'Chacun pour soi';
      case JackboxGameType.COOP:
        return 'Coopération';
      case JackboxGameType.TEAM:
        return 'En équipe';
    }
  }

  String get description {
    switch (this) {
      case JackboxGameType.VERSUS:
        return 'Dans ces jeux, chaque joueur joue pour lui-même et doit battre les autres joueurs.';
      case JackboxGameType.COOP:
        return 'Dans ces jeux, les joueurs doivent travailler ensemble pour gagner.';
      case JackboxGameType.TEAM:
        return 'Dans ces jeux, les joueurs sont divisés en équipes et doivent travailler ensemble pour gagner.';
    }
  }
}


enum JackboxGameTranslation {
  FRENCH,
  FRENCH_JBFR,
  ENGLISH;

  static JackboxGameTranslation fromString(String translation) {
    switch (translation) {
      case 'FRENCH':
        return JackboxGameTranslation.FRENCH;
      case 'FRENCH_JBFR':
        return JackboxGameTranslation.FRENCH_JBFR;
      case 'ENGLISH':
        return JackboxGameTranslation.ENGLISH;
      default:
        return JackboxGameTranslation.ENGLISH;
    }
  }

  String get name {
    switch (this) {
      case JackboxGameTranslation.FRENCH:
        return 'Traduit en français';
      case JackboxGameTranslation.FRENCH_JBFR:
        return 'Traduit par la communauté';
      case JackboxGameTranslation.ENGLISH:
        return 'En Anglais';
    }
  }

  String get description {
    switch (this) {
      case JackboxGameTranslation.FRENCH:
        return 'Ces jeux sont traduits nativement en français.';
      case JackboxGameTranslation.FRENCH_JBFR:
        return 'Ces jeux sont traduits par la communauté française Jackbox France et Jackbox International';
      case JackboxGameTranslation.ENGLISH:
        return 'Ces jeux sont en Anglais.';
    }
  }
}
