import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:jackbox_patcher/model/jackboxpackpatch.dart';
import 'package:jackbox_patcher/services/launcher/launcher.dart';

import 'jackboxgame.dart';

class JackboxPack {
  final String id;
  final String name;
  final String description;
  final String icon;
  final JackboxLoader? loader;
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
      required this.background,
      required this.games,
      required this.patches,
      required this.configuration,
      required this.executable});

  factory JackboxPack.fromJson(Map<String, dynamic> json) {
    print(json);
    return JackboxPack(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        icon: json['icon'],
        loader: json['loader'] != null
            ? JackboxLoader.fromJson(json['loader'])
            : null,
        background: json['background'],
        games: (json['games'] as List<dynamic>)
            .map((e) => JackboxGame.fromJson(e))
            .toList(),
        patches: json['patchs'] != null
            ? (json['patchs'] as List<dynamic>)
                .map((e) => JackboxPackPatch.fromJson(e))
                .toList()
            : [],
        configuration: json['configuration'] != null
            ? PackConfiguration.fromJson(json['configuration'])
            : null,
        executable:
            JackboxPack.generateExecutableFromJson(json['executables']));
  }

  static List<JackboxPack> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => JackboxPack.fromJson(json)).toList();
  }

  static String? generateExecutableFromJson(json) {
    print(json);
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

class PackConfiguration {
  final String file;
  final String versionProperty;

  PackConfiguration({required this.file, required this.versionProperty});

  factory PackConfiguration.fromJson(Map<String, dynamic> json) {
    return PackConfiguration(
        file: json['file'], versionProperty: json['version_property']);
  }
}
