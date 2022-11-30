class JackboxPack {
  final String name;
  final String description;
  final String image;

  JackboxPack({
    required this.name,
    required this.description,
    required this.image,
  });

  factory JackboxPack.fromJson(Map<String, dynamic> json) {
    return JackboxPack(
      name: json['name'],
      description: json['description'],
      image: json['image'],
    );
  }

  static List<JackboxPack> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => JackboxPack.fromJson(json)).toList();
  }
}
