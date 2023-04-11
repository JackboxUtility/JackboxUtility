import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgamepatch.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpackpatch.dart';

class PatchCategory {
  String id;
  String name;
  String smallDescription;
  List<UserJackboxPackPatch> packPatches;
  List<UserJackboxGamePatch> gamePatches;

  PatchCategory(
      {required this.id,
      required this.name,
      required this.smallDescription,
      required this.packPatches,
      required this.gamePatches});

  factory PatchCategory.fromJson(
      Map<String, dynamic> json, List<UserJackboxPack> packs) {
    List<String> patchsIncluded = json["patchs"];
    List<UserJackboxPackPatch> packPatches = [];
    List<UserJackboxGamePatch> gamePatches = [];
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

    return PatchCategory(
        id: json['id'],
        name: json['name'],
        smallDescription: json['smallDescription'],
        packPatches: packPatches,
        gamePatches: gamePatches);
  }
}
