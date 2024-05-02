class UrlBlurHash {
  String url;
  String? blurHash;
  int width;
  int height;

  UrlBlurHash({required this.url, this.blurHash, required this.width, required this.height});

  UrlBlurHash.fromJson(Map<String, dynamic> json) : 
    url = json['url'],
    blurHash = json['blurHash'],
    width = json['width'],
    height = json['height'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['blurHash'] = blurHash;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}
