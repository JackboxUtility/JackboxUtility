class News {
  final String id;
  final String title;
  final String content;
  final String smallDescription;
  final String image;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.smallDescription,
    required this.image,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      smallDescription: json['smallDescription'],
      image: json['image'],
    );
  }
}
