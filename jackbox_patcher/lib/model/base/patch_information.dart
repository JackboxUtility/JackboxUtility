
class PatchInformation {
  final String id;
  final String name;
  final String? authors;
  final String? description;
  final String? smallDescription;
  final PatchType? patchType;

  PatchInformation({
    required this.id,
    required this.name,
    required this.description,
    required this.authors,
    required this.smallDescription,
    required this.patchType,
  });
}

class PatchType {
  bool gameText = false;
  bool gameAssets = false;
  bool gameSubtitles = false;
  bool website = false;
  bool audios = false;

  PatchType({
    required this.gameText,
    required this.gameAssets,
    required this.gameSubtitles,
    required this.website,
    required this.audios,
  });

  factory PatchType.fromJson(Map<String, dynamic> json) {
    return PatchType(
      gameText: json['game_text'],
      gameAssets: json['game_assets'],
      gameSubtitles: json['game_subtitles'],
      website: json['website'],
      audios: json['audios'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'game_text': gameText,
      'game_assets': gameAssets,
      'game_subtitles': gameSubtitles,
      'website': website,
      'audios': audios,
    };
  }
}
