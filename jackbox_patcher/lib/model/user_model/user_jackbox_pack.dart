import 'dart:io';

import 'package:jackbox_patcher/model/jackbox/jackbox_pack.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game_patch.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack_patch.dart';
import 'package:jackbox_patcher/services/user/user_data.dart';

import '../../services/launcher/launcher.dart';
import '../misc/launchers.dart';

class UserJackboxPack {
  final JackboxPack pack;
  final List<UserJackboxGame> games = [];
  final List<UserJackboxPackPatch> fixes = [];
  final List<UserJackboxPackPatch> patches = [];
  UserJackboxLoader? loader;
  String? path;
  bool owned = false;
  LauncherType? origin;

  UserJackboxPack({
    required this.pack,
    required this.loader,
    required this.path,
    required this.owned,
    required this.origin,
  });

  static int countUnownedPack(List<UserJackboxPack> packs) {
    int unownedPacks = 0;
    packs.forEach((element) {
      if (!element.owned) {
        unownedPacks++;
      }
    });
    return unownedPacks;
  }

  Directory? getPackFolder() {
    if (path == null || path == "") {
      return null;
    }
    return Directory(path!);
  }

  Future<String> getPathStatus() async {
    Directory? folder = getPackFolder();
    if (folder == null) {
      return "INEXISTANT";
    } else {
      if (await folder.exists() &&
          (pack.executable == null ||
              (await File("${folder.path}/${pack.executable!}").exists()) ||
              (origin != null && origin == LauncherType.STEAM))) {
        return "FOUND";
      } else {
        return "NOT_FOUND";
      }
    }
  }

  Future<void> setPath(String p) async {
    path = p;
    await UserData().savePack(this);
  }

  Future<void> setOwned(bool o) async {
    owned = o;
    await UserData().savePack(this);
  }

  Future<void> launch() async {
    await Launcher.launchPack(this);
  }

  UserJackboxPackPatch? getInstalledPackPatch() {
    Iterable<UserJackboxPackPatch> patchesInstalled = patches.where((patch) =>
        patch.getInstalledStatus() == UserInstalledPatchStatus.INSTALLED ||
        patch.getInstalledStatus() ==
            UserInstalledPatchStatus.INSTALLED_OUTDATED);
    if (patchesInstalled.isNotEmpty) {
      return patchesInstalled.first;
    } else {
      return null;
    }
  }

  UserJackboxPackPatch? getInstalledPackFix() {
    Iterable<UserJackboxPackPatch> patchesInstalled = fixes.where((patch) =>
        patch.getInstalledStatus() == UserInstalledPatchStatus.INSTALLED ||
        patch.getInstalledStatus() ==
            UserInstalledPatchStatus.INSTALLED_OUTDATED);
    if (patchesInstalled.isNotEmpty) {
      return patchesInstalled.first;
    } else {
      return null;
    }
  }

  setLauncher(LauncherType launcher) {
    origin = launcher;
    UserData().savePack(this);
  }

  UserJackboxGame? getGameById(String gameId) {
    for (UserJackboxGame game in games) {
      if (game.game.id == gameId) {
        return game;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'pack': pack.toJson(),
      'games': games.map((e) => e.toJson()).toList(),
      'fixes': fixes.map((e) => e.toJson()).toList(),
      'patches': patches.map((e) => e.toJson()).toList(),
      'loader': loader?.toJson(),
      'path': path,
      'owned': owned,
      'origin': origin?.name,
    };
  }
}

class UserJackboxLoader {
  JackboxLoader? loader;

  /// The path to the loader on the device
  String? path;

  /// The version of the loader installed on the device
  String? version;

  UserJackboxLoader({
    required this.loader,
    required this.path,
    required this.version,
  });

  Map<String, dynamic> toJson() {
    return {
      'loader': loader?.toJson(),
      'path': path,
      'version': version,
    };
  }
}

extension UserJackboxPackList on List<UserJackboxPack> {
  UserJackboxGame? getGameById(String id) {
    for (UserJackboxPack pack in this) {
      UserJackboxGame? game = pack.getGameById(id);
      if (game != null) {
        return game;
      }
    }
    return null;
  }

  UserJackboxPack? getPackById(String id) {
    for (UserJackboxPack pack in this) {
      if (pack.pack.id == id) {
        return pack;
      }
    }
    return null;
  }
}
