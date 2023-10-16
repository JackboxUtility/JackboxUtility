class Extension {
  final String name;
  final String id;

  Extension({required this.id, required this.name});

  factory Extension.fromJson(Map<String, dynamic> json) {
    return Extension(
      id: json['id'],
      name: json['name']
    );
  }
}