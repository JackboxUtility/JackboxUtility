class JackboxGame {
  final String id;
  final String name;
  final String description;
  final String background;
  final String latestVersion;

  JackboxGame({
    required this.id,
    required this.name,
    required this.description,
    required this.background,
    required this.latestVersion,
  });

  factory JackboxGame.fromJson(Map<String, dynamic> json) {
    return JackboxGame(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      background: json['background'],
      latestVersion: json['version'],
    );
  }
}
