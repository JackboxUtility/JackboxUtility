import 'package:jackbox_patcher/model/jackboxpatch.dart';

class JackboxGame {
  final String id;
  final String name;
  final String description;
  final String? smallDescription;
  final String background;
  final String? path;
  final List<JackboxPatch> patches = [];

  JackboxGame({
    required this.id,
    required this.name,
    required this.description,
    required this.background,
    required this.path,
    this.smallDescription,
  });

  factory JackboxGame.fromJson(Map<String, dynamic> json) {
    return JackboxGame(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      background: json['background'],
      path: json['path'],
      smallDescription: json['small_description'],
    );
  }
}

