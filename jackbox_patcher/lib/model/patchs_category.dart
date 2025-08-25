import 'package:jackbox_patcher/model/user_model/user_jackbox_game.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game_patch.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack_patch.dart';

class PatchCategory {
  String id;
  String name;
  String smallDescription;
  List<UserJackboxPackPatch> packPatches;
  List<UserJackboxGamePatch> gamePatches;
  List<String> patchsIncluded;

  PatchCategory(
      {required this.id,
      required this.name,
      required this.smallDescription,
      required this.packPatches,
      required this.gamePatches,
      required this.patchsIncluded});

  factory PatchCategory.fromJson(Map<String, dynamic> json) {
    return PatchCategory(
        id: json['id'],
        name: json['name'],
        smallDescription: json['smallDescription'],
        packPatches: [],
        gamePatches: [],
        patchsIncluded: (json["patchs"] as List<dynamic>).map((e) => e.toString()).toList());
  }

  void addPatchs(List<UserJackboxPack> packs) {
    for (String patchId in patchsIncluded) {
      for (UserJackboxPack pack in packs) {
        for (UserJackboxPackPatch packPatch in pack.patches) {
          if (packPatch.patch.id == patchId) {
            packPatches.add(packPatch);
          }
        }
        for (UserJackboxGame game in pack.games) {
          for (UserJackboxGamePatch gamePatch in game.patches) {
            if (gamePatch.patch.id == patchId) {
              gamePatches.add(gamePatch);
            }
          }
        }
      }
    }
  }

  UserInstalledPatchStatus getInstalledStatus() {
    UserInstalledPatchStatus status = UserInstalledPatchStatus.INSTALLED;
    for (UserJackboxPackPatch packPatch in packPatches) {
      if (packPatch.getInstalledStatus() == UserInstalledPatchStatus.NOT_INSTALLED) {
        return UserInstalledPatchStatus.NOT_INSTALLED;
      }
      if (packPatch.getInstalledStatus() == UserInstalledPatchStatus.INSTALLED_OUTDATED) {
        status = UserInstalledPatchStatus.INSTALLED_OUTDATED;
      }
    }
    for (UserJackboxGamePatch gamePatch in gamePatches) {
      if (gamePatch.getInstalledStatus() == UserInstalledPatchStatus.NOT_INSTALLED) {
        return UserInstalledPatchStatus.NOT_INSTALLED;
      }
      if (gamePatch.getInstalledStatus() == UserInstalledPatchStatus.INSTALLED_OUTDATED) {
        status = UserInstalledPatchStatus.INSTALLED_OUTDATED;
      }
    }
    return status;
  }

  List<PackAvailablePatchs> getAvailablePatchs() {
    List<PackAvailablePatchs> availablePatchs = [];
    for (UserJackboxPackPatch packPatch in packPatches) {
      UserJackboxPack pack = packPatch.getPack();
      if (availablePatchs.where((element) => element.pack.pack.id == pack.pack.id).isEmpty) {
        availablePatchs.add(PackAvailablePatchs(pack: pack, packPatchs: [], gamePatchs: []));
      }
      PackAvailablePatchs packAvailablePatchs =
          availablePatchs.firstWhere((element) => element.pack.pack.id == pack.pack.id);
      if (pack.patches.contains(packPatch) == false) continue;
      packAvailablePatchs.packPatchs.add(packPatch);
    }
    for (UserJackboxGamePatch gamePatch in gamePatches) {
      UserJackboxPack pack = gamePatch.getPack();
      if (availablePatchs.where((element) => element.pack.pack.id == pack.pack.id).isEmpty) {
        availablePatchs.add(PackAvailablePatchs(pack: pack, packPatchs: [], gamePatchs: []));
      }
      PackAvailablePatchs packAvailablePatchs =
          availablePatchs.firstWhere((element) => element.pack.pack.id == pack.pack.id);
      packAvailablePatchs.gamePatchs.add(gamePatch);
    }
    return availablePatchs;
  }
}

class PackAvailablePatchs {
  UserJackboxPack pack;
  List<UserJackboxPackPatch> packPatchs;
  List<UserJackboxGamePatch> gamePatchs;

  PackAvailablePatchs({required this.pack, required this.packPatchs, required this.gamePatchs});

  UserInstalledPatchStatus installedStatus() {
    if (!pack.owned) {
      return UserInstalledPatchStatus.INEXISTANT;
    }
    UserInstalledPatchStatus status = UserInstalledPatchStatus.NOT_INSTALLED;
    for (var patch in packPatchs) {
      if (patch.getInstalledStatus() == UserInstalledPatchStatus.NOT_INSTALLED) {
        return UserInstalledPatchStatus.NOT_INSTALLED;
      }
      if (patch.getInstalledStatus() == UserInstalledPatchStatus.INEXISTANT) {
        return UserInstalledPatchStatus.INEXISTANT;
      }
      if (patch.getInstalledStatus() == UserInstalledPatchStatus.INSTALLED_OUTDATED) {
        status = UserInstalledPatchStatus.INSTALLED_OUTDATED;
      }
      if (patch.getInstalledStatus() == UserInstalledPatchStatus.INSTALLED &&
          status != UserInstalledPatchStatus.INSTALLED_OUTDATED) {
        status = UserInstalledPatchStatus.INSTALLED;
      }
    }

    for (var patch in gamePatchs) {
      if (patch.getInstalledStatus() == UserInstalledPatchStatus.INSTALLED_OUTDATED) {
        status = UserInstalledPatchStatus.INSTALLED_OUTDATED;
      }
      if (patch.getInstalledStatus() == UserInstalledPatchStatus.INSTALLED &&
          status != UserInstalledPatchStatus.INSTALLED_OUTDATED) {
        status = UserInstalledPatchStatus.INSTALLED;
      }
    }
    return status;
  }
}
