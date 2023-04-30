import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/base/PatchInformation.dart';
import 'package:jackbox_patcher/model/jackbox/jackboxgame.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgamepatch.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpackpatch.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';

import '../../services/api/api_service.dart';

class UserJackboxGame {
  final JackboxGame game;
  final List<UserJackboxGamePatch> patches = [];
  final UserJackboxLoader? loader;

  UserJackboxGame({
    required this.game,
    required this.loader,
  });

  ///
  /// Retrieving the installed patch for this game
  ///
  PatchInformation? getInstalledPatch() {
    UserJackboxPack pack = getUserJackboxPack();
    UserJackboxPackPatch? installedPatch = pack.getInstalledPackPatch();
    if (installedPatch != null &&
        installedPatch.patch.components
            .where((element) => element.linkedGame == game.id)
            .isNotEmpty) {
      return installedPatch.patch.components
          .firstWhere((element) => element.linkedGame == game.id);
    } else {
      Iterable<UserJackboxGamePatch> installedGamePatches = patches.where(
          (element) =>
              element.getInstalledStatus() ==
                  UserInstalledPatchStatus.INSTALLED ||
              element.getInstalledStatus() ==
                  UserInstalledPatchStatus.INSTALLED_OUTDATED);
      if (installedGamePatches.isNotEmpty) {
        return installedGamePatches.first.patch;
      }
    }
    return null;
  }

  UserJackboxPack getUserJackboxPack() {
    return UserData().packs.firstWhere((pack) =>
        pack.games.where((packGame) => packGame.game.id == game.id).isNotEmpty);
  }
}
