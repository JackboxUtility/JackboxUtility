class JackboxGame {
  final String name;
  final String description;
  final String icon;
  final String latestVersion;
  

  JackboxGame({
    required this.name,
    required this.description,
    required this.icon,
    required this.latestVersion,
  });

  factory JackboxGame.fromJson(Map<String, dynamic> json) {
    return JackboxGame(
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      latestVersion: json['version'],
    );
  }
}
