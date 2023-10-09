import 'package:jackbox_patcher/services/api_utility/api_service.dart';

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

  static GameTag fromId(String id) {
    List<GameTag> tags = APIService().getTags();
    return tags.firstWhere((element) => element.id == id);
  }
}
