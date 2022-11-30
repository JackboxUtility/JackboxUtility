class JackboxPack {
  final String name;
  final String description;
  final String icon;

  JackboxPack({
    required this.name,
    required this.description,
    required this.icon,
  });

  factory JackboxPack.fromJson(Map<String, dynamic> json) {
    return JackboxPack(
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  static List<JackboxPack> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => JackboxPack.fromJson(json)).toList();
  }
}
