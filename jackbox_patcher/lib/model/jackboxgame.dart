class JackboxGame {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String latestVersion;

  JackboxGame({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.latestVersion,
  });

  factory JackboxGame.fromJson(Map<String, dynamic> json) {
    return JackboxGame(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      latestVersion: json['version'],
    );
  }
}
