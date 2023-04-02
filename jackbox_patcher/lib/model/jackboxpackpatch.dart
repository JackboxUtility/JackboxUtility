import 'package:jackbox_patcher/model/jackboxgamepatch.dart';

class JackboxPackPatch {
  final String id;
  final String name;
  final String smallDescription;
  final String description;
  final String latestVersion;
  final List<JackboxPackPatchGameIncluded> gamesIncluded;

  JackboxPackPatch({
    required this.id,
    required this.name,
    required this.smallDescription,
    required this.description,
    required this.latestVersion,
    required this.gamesIncluded,
  });

  factory JackboxPackPatch.fromJson(Map<String, dynamic> json) {
    return JackboxPackPatch(
      id: json['id'],
      name: json['name'],
      smallDescription: json['smallDescription'],
      description: json['description'],
      latestVersion: json['latestVersion'],
      gamesIncluded: json['gamesIncluded'] == null
          ? []
          : List<JackboxPackPatchGameIncluded>.from(
              json['gamesIncluded'].map((x) => JackboxPackPatchGameIncluded.fromJson(x))),
    );
  }
}

class JackboxPackPatchGameIncluded {
  final String id;
  final String name;
  final String? authors;
  final String description;
  final String? smallDescription;
  final PatchType? patchType;

  JackboxPackPatchGameIncluded({
    required this.id,
    required this.name,
    required this.description,
    required this.authors,
    required this.smallDescription,
    required this.patchType,
  });

  factory JackboxPackPatchGameIncluded.fromJson(Map<String, dynamic> json) {
    return JackboxPackPatchGameIncluded(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      authors: json['authors'],
      smallDescription: json['small_description'],
      patchType: json['patch_type'] == null ? null : PatchType.fromJson(json['patch_type']),
    );
  }

}
