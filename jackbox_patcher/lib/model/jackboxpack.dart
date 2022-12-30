import 'dart:io';

import 'jackboxgame.dart';

class JackboxPack {
  final String id;
  final String name;
  final String description;
  final String icon;
  final List<JackboxGame> games;
  final String background;
  final String? executable;

  JackboxPack(
      {required this.id,
      required this.name,
      required this.description,
      required this.icon,
      required this.background,
      required this.games,
      required this.executable});

  factory JackboxPack.fromJson(Map<String, dynamic> json) {
    return JackboxPack(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        icon: json['icon'],
        background: json['background'],
        games: (json['games'] as List<dynamic>)
            .map((e) => JackboxGame.fromJson(e))
            .toList(),
        executable: JackboxPack.generateExecutableFromJson(json['executable']));
  }

  static List<JackboxPack> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => JackboxPack.fromJson(json)).toList();
  }

  static String? generateExecutableFromJson(json) {
    if (json == null) {
      return null;
    } else {
      if (Platform.isWindows) {
        return json['windows'];
      } else {
        if (Platform.isMacOS) {
          return json['mac'];
        }else{
          return json['linux'];
        }
      }
    }
  }
}
