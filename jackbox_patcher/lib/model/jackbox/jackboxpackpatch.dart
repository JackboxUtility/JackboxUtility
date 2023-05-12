import 'package:jackbox_patcher/model/jackbox/jackboxgame.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';

import '../base/patchinformation.dart';
import 'jackboxpack.dart';

class JackboxPackPatch {
  final String id;
  final String name;
  final String smallDescription;
  final String latestVersion;
  final String patchPath;
  final List<JackboxPackPatchComponent> components;

  JackboxPackPatch({
    required this.id,
    required this.name,
    required this.smallDescription,
    required this.latestVersion,
    required this.patchPath,
    required this.components,
  });

  factory JackboxPackPatch.fromJson(Map<String, dynamic> json) {
    return JackboxPackPatch(
      id: json['id'],
      name: json['name'],
      smallDescription: json['small_description'],
      latestVersion: json['version'].replaceAll("Build:", "").trim(),
      patchPath: json['patch_path'],
      components: json['components'] == null
          ? []
          : List<JackboxPackPatchComponent>.from(json['components']
              .map((x) => JackboxPackPatchComponent.fromJson(x))),
    );
  }
}

class JackboxPackPatchComponent extends PatchInformation {
  final String? linkedGame;

  JackboxPackPatchComponent({
    required super.id,
    required this.linkedGame,
    required super.name,
    required super.description,
    required super.authors,
    required super.smallDescription,
    required super.patchType,
  });

  factory JackboxPackPatchComponent.fromJson(Map<String, dynamic> json) {
    return JackboxPackPatchComponent(
      id: json['id'],
      linkedGame: json['linked_game'],
      name: json['name'],
      description: json['description'],
      authors: json['authors'],
      smallDescription: json['small_description'],
      patchType: json['patch_type'] == null
          ? null
          : PatchType.fromJson(json['patch_type']),
    );
  }

  JackboxGame? getLinkedGame() {
    if (linkedGame == null) return null;
    for (JackboxPack pack in APIService().cachedPacks) {
      var gamesFound = pack.games.where((game) => game.id == linkedGame);
      if (gamesFound.isNotEmpty) return gamesFound.first;
    }
    return null;
  }
}
