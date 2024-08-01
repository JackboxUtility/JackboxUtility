import 'dart:io';

import 'package:jackbox_patcher/model/jackbox/jackbox_game.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';
import 'package:jackbox_patcher/services/launcher/launchers/abstract_pack_launcher.dart';

class NativePackLauncher implements AbstractPackLauncher {
  @override
  Future<void> launch(UserJackboxPack userPack,
      {JackboxGame? game = null}) async {
    String parameters = "";
    if (game != null && game.internalName != null && !useLoader(game)) {
      parameters =
          " -launchTo games%2F${game.internalName}%2F${game.internalName}.swf -jbg.config isBundle=false";
    }
    await Process.run("${userPack.path!}/${userPack.pack.executable}$parameters", [],
        workingDirectory: userPack.path);
  }

  @override
  bool willHandleRequest(UserJackboxPack userPack) {
    return true;
  }

  bool useLoader(JackboxGame? game) {
    if (game != null) {
      return game.launchWithLoaders.native;
    }
    return true;
  }
}
