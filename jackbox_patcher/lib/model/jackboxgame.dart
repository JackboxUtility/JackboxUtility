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
  final String description;
  final String smallDescription;
  final String length;
  final String type;
  final String translation;
  final List<String> tags;
  final List<String> images;
  final JackboxGamePlayersInfo players;

  JackboxGameInfo({
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
      description: json['description'],
      smallDescription: json['small_description'],
      length: json['length'],
      type: json['type'],
      translation: json['translation'],
      images:
          (json['images'] as List<dynamic>).map((e) => e.toString()).toList(),
      tags: (json['tags'] as List<dynamic>).map((e) => e.toString()).toList(),
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
