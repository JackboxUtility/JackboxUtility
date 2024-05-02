import 'package:jackbox_patcher/model/enums/platforms.dart';
import 'package:jackbox_patcher/model/jackbox/jackbox_game.dart';
import 'package:jackbox_patcher/services/api_utility/api_service.dart';
import 'package:jackbox_patcher/services/logger/logger.dart';

import '../base/patch_information.dart';
import 'jackbox_pack.dart';

class JackboxPackPatch {
  final String id;
  final String name;
  final String smallDescription;
  String latestVersion;
  final List<String> patchPaths;
  final PatchConfiguration? configuration;
  final List<JackboxPackPatchComponent> components;
  final List<AppPlatform> supportedPlatforms;

  JackboxPackPatch({
    required this.id,
    required this.name,
    required this.smallDescription,
    required this.latestVersion,
    required this.patchPaths,
    required this.configuration,
    required this.components,
    required this.supportedPlatforms,
  });

  factory JackboxPackPatch.fromJson(Map<String, dynamic> json) {
    List<String> patchPaths = [];
    if (json['patch_paths'] is List) {
      for (var path in json['patch_paths']) {
        patchPaths.add(path);
      }
    }else{
      if (json['patch_path'] is String) {
        patchPaths.add(json['patch_path']);
      }
    }

    JULogger().i("PatchPaths: $patchPaths");

    return JackboxPackPatch(
      id: json['id'],
      name: json['name'],
      smallDescription: json['small_description'],
      latestVersion: json['version'] != null
          ? json['version'].replaceAll("Build:", "").trim()
          : "",
      patchPaths: patchPaths,
      configuration: json['configuration'] == null
          ? null
          : PatchConfiguration.fromJson(json['configuration']),
      components: json['components'] == null
          ? []
          : List<JackboxPackPatchComponent>.from(json['components']
              .map((x) => JackboxPackPatchComponent.fromJson(x))),
      supportedPlatforms: json['supported_platforms'] == null
          ? [AppPlatform.LINUX, AppPlatform.WINDOWS]
          : List<AppPlatform>.from(json['supported_platforms']
              .map((x) => AppPlatformExtension.fromString(x))),
    );
  }

  JackboxPackPatchComponent? getComponentByGameId(String id) {
    List<JackboxPackPatchComponent> componentsFound =
        components.where((element) => element.linkedGame == id).toList();
    if (componentsFound.isNotEmpty) return componentsFound.first;
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "small_description": smallDescription,
      "version": latestVersion,
      "patch_paths": patchPaths,
      "configuration": configuration?.toJson(),
      "components": List<dynamic>.from(components.map((x) => x.toJson())),
    };
  }
}

class JackboxPackPatchComponent extends PatchInformation {
  final String? linkedGame;

  JackboxPackPatchComponent({
    required super.id,
    required this.linkedGame,
    required super.name,
    required super.description,
    required super.authors,
    required super.smallDescription,
    required super.patchType,
  });

  factory JackboxPackPatchComponent.fromJson(Map<String, dynamic> json) {
    return JackboxPackPatchComponent(
      id: json['id'],
      linkedGame: json['linked_game'],
      name: json['name'],
      description: json['description'],
      authors: json['authors'],
      smallDescription: json['small_description'],
      patchType: json['patch_type'] == null
          ? null
          : PatchType.fromJson(json['patch_type']),
    );
  }

  JackboxGame? getLinkedGame() {
    if (linkedGame == null) return null;
    for (JackboxPack pack in APIService().cachedPacks) {
      var gamesFound = pack.games.where((game) => game.id == linkedGame);
      if (gamesFound.isNotEmpty) return gamesFound.first;
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "linked_game": linkedGame,
      "name": name,
      "description": description,
      "authors": authors,
      "small_description": smallDescription,
      "patch_type": patchType?.toJson(),
    };
  }
}

class PatchConfiguration {
  final OnlineVersionOrigin versionOrigin;
  final String versionFile;
  final String versionProperty;

  PatchConfiguration(
      {required this.versionOrigin,
      required this.versionFile,
      required this.versionProperty});

  factory PatchConfiguration.fromJson(Map<String, dynamic> json) {
    return PatchConfiguration(
        versionOrigin: OnlineVersionOrigin.fromString(json['version_origin']),
        versionFile: json['version_file'],
        versionProperty: json['version_property']);
  }

  Map<String, dynamic> toJson() {
    return {
      'version_origin': versionOrigin.toString().split(".").last.toLowerCase(),
      'version_file': versionFile,
      'version_property': versionProperty,
    };
  }
}

enum OnlineVersionOrigin {
  APP,
  REPO_FILE,
  REPO_RELEASE;

  static OnlineVersionOrigin fromString(String value) {
    switch (value) {
      case "app":
        return OnlineVersionOrigin.APP;
      case "repo_file":
        return OnlineVersionOrigin.REPO_FILE;
      case "repo_release":
        return OnlineVersionOrigin.REPO_RELEASE;
      default:
        throw Exception("Invalid VersionOrigin");
    }
  }
}
