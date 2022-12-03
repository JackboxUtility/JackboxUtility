class JackboxGame {
  final String id;
  final String name;
  final String description;
  final String background;
  final String latestVersion;
  final String? patchPath;
  final String? path;

  JackboxGame({
    required this.id,
    required this.name,
    required this.description,
    required this.background,
    required this.latestVersion,
    required this.patchPath,
    required this.path,
  });

  factory JackboxGame.fromJson(Map<String, dynamic> json) {
    return JackboxGame(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      background: json['background'],
      latestVersion: json['version'],
      patchPath: json['patch'],
      path: json['path'],
    );
  }
}
