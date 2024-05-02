import 'package:jackbox_patcher/model/enums/platforms.dart';
import 'package:jackbox_patcher/model/jackbox/gameinfo/jackboxgame.dart';
import 'package:jackbox_patcher/model/jackbox/jackboxpack.dart';
import 'package:jackbox_patcher/model/jackbox/jackboxgamepatch.dart';

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
    List<JackboxGamePatch> patches = _getGamePatchesFromJson(json);
    return JackboxGame(
      id: json['id'],
      name: json['name'],
      background: json['background'],
      loader: json['loader'] != null
          ? JackboxLoader.fromJson(json['loader'])
          : null,
      path: json['path'],
      patches: patches,
      info: JackboxGameInfo.fromJson(json["id"], json['game_info']),
    );
  }

  String get filteredName {
    return this.name.replaceAll(RegExp("[^a-zA-Z0-9 ]"), "");
  }

  static List<JackboxGamePatch> _getGamePatchesFromJson(
      Map<String, dynamic> json) {
    List<JackboxGamePatch> patches = json['patchs'] != null
        ? (json['patchs'] as List<dynamic>)
            .map((e) => JackboxGamePatch.fromJson(e))
            .toList()
        : [];
    patches = patches
        .where((element) => element.supportedPlatforms.currentPlatformInclude())
        .toList();
    return patches;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "background": background,
      "loader": loader?.toJson(),
      "path": path,
      "patchs": patches.map((e) => e.toJson()).toList(),
      "game_info": info.toJson(),
    };
  }
}