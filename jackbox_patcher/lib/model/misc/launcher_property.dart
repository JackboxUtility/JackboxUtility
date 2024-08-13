import 'package:jackbox_patcher/model/misc/launchers.dart';

class LauncherProperty {
  final String steamValue;
  final String epicValue;
  final String unknownValue;

  LauncherProperty({required this.steamValue, required this.epicValue, required this.unknownValue});

  factory LauncherProperty.fromDefault(String defaultValue) {
    return LauncherProperty(steamValue: defaultValue, epicValue: defaultValue, unknownValue: defaultValue);
  }

  factory LauncherProperty.fromData(dynamic data) {
    if (data is String) {
      return LauncherProperty.fromDefault(data);
    } else {
      return LauncherProperty.fromJson(data);
    }
  }

  factory LauncherProperty.fromJson(Map<String, dynamic> json, {String defaultValue = ""}) {
    return LauncherProperty(
      steamValue: json['steam'] != null ? json['steam'] as String : defaultValue,
      epicValue: json['epic_games'] != null ? json['epic_games'] as String : defaultValue,
      unknownValue: json['native'] != null ? json['native'] as String : defaultValue,
    );
  }

  fromLauncher(LauncherType? packLauncher) {
    switch (packLauncher) {
      case LauncherType.STEAM:
        return steamValue;
      case LauncherType.EPIC:
        return epicValue;
      default:
        return unknownValue;
    }
  }
}
