class News {
  final String id;
  final String title;
  final String? content;
  final bool? shadow;
  final String? link;
  final String image;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.shadow,
    required this.link,
    required this.image,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      shadow: json['shadow'] != null ? json['shadow'] : true,
      link: json['link'],
      image: json['image'],
    );
  }
}
