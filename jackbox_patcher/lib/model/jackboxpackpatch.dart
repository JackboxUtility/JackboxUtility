import 'package:jackbox_patcher/model/jackboxgame.dart';
import 'package:jackbox_patcher/model/jackboxgamepatch.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';

class JackboxPackPatch {
  final String id;
  final String name;
  final String smallDescription;
  final String description;
  final String latestVersion;
  final String patchPath;
  final List<JackboxPackPatchComponent> components;

  JackboxPackPatch({
    required this.id,
    required this.name,
    required this.smallDescription,
    required this.description,
    required this.latestVersion,
    required this.patchPath,
    required this.components,
  });

  factory JackboxPackPatch.fromJson(Map<String, dynamic> json) {
    return JackboxPackPatch(
      id: json['id'],
      name: json['name'],
      smallDescription: json['small_description'],
      description: json['description'],
      latestVersion: json['version'],
      patchPath: json['patch_path'],
      components: json['components'] == null
          ? []
          : List<JackboxPackPatchComponent>.from(json['components']
              .map((x) => JackboxPackPatchComponent.fromJson(x))),
    );
  }
}

class JackboxPackPatchComponent {
  final String id;
  final String? linkedGame;
  final String name;
  final String? authors;
  final String? description;
  final String? smallDescription;
  final PatchType? patchType;

  JackboxPackPatchComponent({
    required this.id,
    required this.linkedGame,
    required this.name,
    required this.description,
    required this.authors,
    required this.smallDescription,
    required this.patchType,
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
}
