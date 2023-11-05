import 'package:jackbox_patcher/model/jackbox/jackboxgame.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgamepatch.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpackpatch.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';

import '../base/patchinformation.dart';

class UserJackboxGame {
  final JackboxGame game;
  final List<UserJackboxGamePatch> patches = [];
  int _stars = 0;
  bool _hidden = false;
  final UserJackboxLoader? loader;

  UserJackboxGame({
    required this.game,
    stars = 0,
    hidden = false,
    required this.loader,
  }) {
    _stars = stars;
    _hidden = hidden;
  }

  ///
  /// Retrieving the installed patch for this game
  ///
  PatchInformation? getInstalledPatch() {
    UserJackboxPack pack = getPack();
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

  UserJackboxPack getPack() {
    return UserData().packs.firstWhere((pack) =>
        pack.games.where((packGame) => packGame.game.id == game.id).isNotEmpty);
  }

  static int countHiddenGames(List<UserJackboxPack> packs) {
    int hiddenGames = 0;
    packs.forEach((element) {
      element.games.forEach((game) {
        if (game.hidden) {
          hiddenGames++;
        }
      });
    });
    return hiddenGames;
  }

  set hidden(bool hiddenValue) {
    _hidden = hiddenValue;
    UserData().saveGame(this);
  }

  bool get hidden {
    return _hidden;
  }

  set stars(int s) {
    _stars = s;
    UserData().saveGame(this);
  }

  int get stars {
    return _stars;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": game.id,
      "patches": List<dynamic>.from(patches.map((x) => x.toJson())),
      "stars": _stars,
      "hidden": _hidden,
      "loader": loader?.toJson(),
    };
  }
}
