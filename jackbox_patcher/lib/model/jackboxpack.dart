import 'jackboxgame.dart';

class JackboxPack {
  final String name;
  final String description;
  final String icon;
  final List<JackboxGame> games;
  final String background;

  JackboxPack({
    required this.name,
    required this.description,
    required this.icon,
    required this.background,
    required this.games,
  });

  factory JackboxPack.fromJson(Map<String, dynamic> json) {
    return JackboxPack(
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      background: json['background'],
      games: (json['games'] as List<dynamic>)
          .map((e) => JackboxGame.fromJson(e))
          .toList(),
    );
  }

  static List<JackboxPack> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => JackboxPack.fromJson(json)).toList();
  }
}
