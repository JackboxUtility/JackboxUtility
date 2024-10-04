import 'package:dio/dio.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game_patch.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack_patch.dart';

abstract class InstallablePatch {
  Future<void> downloadPatch(
      String patchUri,
      void Function(String, String, double?) callback,
      CancelToken cancelToken,
      bool resume);
  UserJackboxPack getPack();
  String getName() {
    if (this is UserJackboxGamePatch) {
      return (this as UserJackboxGamePatch).getGame().game.name;
    } else if (this is UserJackboxPackPatch) {
      return getPack().pack.name;
    } else {
      return getPack().pack.name;
    }
  }
}
