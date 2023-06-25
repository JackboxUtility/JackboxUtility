import 'package:flutter/foundation.dart';
import 'package:jackbox_patcher/model/jackbox/jackboxpackpatch.dart';

import 'jackboxgame.dart';

class JackboxPack {
  final String id;
  final String name;
  final String description;
  final String icon;
  final JackboxLoader? loader;
  final LaunchersId? launchersId;
  final List<JackboxGame> games;
  final List<JackboxPackPatch> patches;
  final PackConfiguration? configuration;
  final String background;
  final String? executable;

  JackboxPack(
      {required this.id,
      required this.name,
      required this.description,
      required this.icon,
      required this.loader,
      required this.launchersId,
      required this.background,
      required this.games,
      required this.patches,
      required this.configuration,
      required this.executable});

  factory JackboxPack.fromJson(Map<String, dynamic> json) {
    List<JackboxPackPatch> patches = json['patchs'] != null
        ? (json['patchs'] as List<dynamic>)
            .map((e) => JackboxPackPatch.fromJson(e))
            .toList()
        : [];
    
    return JackboxPack(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        icon: json['icon'],
        loader: json['loader'] != null
            ? JackboxLoader.fromJson(json['loader'])
            : null,
        launchersId: json["launchers_id"] != null
            ? LaunchersId.fromJson(json['launchers_id'])
            : null,
        background: json['background'],
        games: (json['games'] as List<dynamic>)
            .map((e) => JackboxGame.fromJson(e, isGameDubbedByPackPatch(patches, e["id"])))
            .toList(),
        patches: patches,
        configuration: json['configuration'] != null
            ? PackConfiguration.fromJson(json['configuration'])
            : null,
        executable:
            JackboxPack.generateExecutableFromJson(json['executables']));
  }

  static isGameDubbedByPackPatch(List<JackboxPackPatch> patches, String gameId) {
    for (var patch in patches) {
      for (var game in patch.components){
        if (game.linkedGame == gameId && game.patchType!.audios) {
          return true;
        }
      }
    }
    return false;
  }

  static List<JackboxPack> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => JackboxPack.fromJson(json)).toList();
  }

  static String? generateExecutableFromJson(json) {
    if (json == null) {
      return null;
    } else {
      if (defaultTargetPlatform == TargetPlatform.windows) {
        return json['windows'];
      } else {
        if (defaultTargetPlatform == TargetPlatform.macOS) {
          return json['mac'];
        } else {
          return json['linux'];
        }
      }
    }
  }
}

class JackboxLoader {
  final String path;
  final String version;

  JackboxLoader({required this.path, required this.version});

  factory JackboxLoader.fromJson(Map<String, dynamic> json) {
    return JackboxLoader(path: json['path'], version: json['version']);
  }
}

class LaunchersId {
  final String? steam;
  final String? epic;

  LaunchersId({required this.steam, required this.epic});

  factory LaunchersId.fromJson(Map<String, dynamic> json) {
    print("launcherId");
    return LaunchersId(steam: json['steam'], epic: json['epic']);
  }
}

class PackConfiguration {
  final LocalVersionOrigin versionOrigin;
  final String versionFile;
  final String versionProperty;

  PackConfiguration(
      {required this.versionOrigin,
      required this.versionFile,
      required this.versionProperty});

  factory PackConfiguration.fromJson(Map<String, dynamic> json) {
    return PackConfiguration(
        versionOrigin: LocalVersionOrigin.fromString(json['version_origin']),
        versionFile: json['version_file'],
        versionProperty: json['version_property']);
  }
}

enum LocalVersionOrigin {
  APP,
  GAME_FILE;

  static LocalVersionOrigin fromString(String value) {
    switch (value) {
      case "app":
        return LocalVersionOrigin.APP;
      case "game_file":
        return LocalVersionOrigin.GAME_FILE;
      default:
        throw Exception("Invalid VersionOrigin");
    }
  }
}
