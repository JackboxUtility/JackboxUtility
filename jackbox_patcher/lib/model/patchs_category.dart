import 'package:jackbox_patcher/model/user_model/user_jackbox_game.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game_patch.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack_patch.dart';
import 'package:jackbox_patcher/services/logger/logger.dart';
import 'package:logger/logger.dart';

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
    List<UserJackboxPackPatch> availablePackPatches = packPatches.where((element) => element.getPack().patches.any((patch) => patch.patch == element.patch)).toList();
    for (UserJackboxPackPatch packPatch in availablePackPatches) {
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
      JULogger().i("GET AVAILABLE PATCHS FOR PACK ${pack.pack.name}");
      if (availablePatchs.where((element) => element.pack.pack.id == pack.pack.id).isEmpty) {
        availablePatchs.add(PackAvailablePatchs(pack: pack, packPatchs: [], gamePatchs: []));
      }
      JULogger().i("${pack.pack.name} origin is ${pack.origin}");
      JULogger().i("${pack.pack.name} has ${availablePatchs.length} entries in the patch category");
      JULogger().i("${pack.pack.name} has ${pack.patches.length} pack patches");
      PackAvailablePatchs packAvailablePatchs =
          availablePatchs.firstWhere((element) => element.pack.pack.id == pack.pack.id);
      JULogger().i("${pack.pack.name} has ${packAvailablePatchs.packPatchs.length} available pack patches");
      JULogger().i("Does ${pack.pack.name} contain patch ${packPatch.patch.id} ? ${pack.patches.contains(packPatch)}");
      if (pack.patches.contains(packPatch) == false) continue;
      JULogger().i("Adding patch ${packPatch.patch.name} to pack ${pack.pack.name}");
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
