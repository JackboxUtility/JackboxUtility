import 'dart:io';

import 'package:jackbox_patcher/model/jackbox/jackboxpack.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgamepatch.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpackpatch.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';

import '../../services/launcher/launcher.dart';
import '../misc/launchers.dart';

class UserJackboxPack {
  final JackboxPack pack;
  final List<UserJackboxGame> games = [];
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
              (await File("${folder.path}/${pack.executable!}").exists()) || (origin != null && origin == LauncherType.STEAM))) {
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

  setLauncher(LauncherType launcher) {
    origin = launcher;
    UserData().savePack(this);
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
}
