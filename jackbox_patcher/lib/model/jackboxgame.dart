import 'package:jackbox_patcher/model/jackboxpack.dart';
import 'package:jackbox_patcher/model/jackboxpatch.dart';

class JackboxGame {
  final String id;
  final String name;
  final String description;
  final String? smallDescription;
  final String background;
  final JackboxLoader? loader;
  final String? path;
  final List<JackboxPatch> patches;

  JackboxGame({
    required this.id,
    required this.name,
    required this.description,
    required this.background,
    required this.loader,
    required this.path,
    required this.patches,
    this.smallDescription,
  });

  factory JackboxGame.fromJson(Map<String, dynamic> json) {
    return JackboxGame(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      background: json['background'],
      loader: json['loader']!=null?JackboxLoader.fromJson(json['loader']):null,
      path: json['path'],
      patches:(json['patchs'] as List<dynamic>)
            .map((e) => JackboxPatch.fromJson(e))
            .toList(),
      smallDescription: json['small_description'],
    );
  }
}

