class GameTag {
  final String id;
  final String name;
  final String description;
  final String icon;

  GameTag({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });

  factory GameTag.fromJson(Map<String, dynamic> json) {
    return GameTag(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}
