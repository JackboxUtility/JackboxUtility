import 'dart:io';

import 'package:jackbox_patcher/model/jackbox/jackbox_game.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';
import 'package:jackbox_patcher/services/launcher/launchers/abstract_pack_launcher.dart';
import 'package:jackbox_patcher/services/user/user_data.dart';

class NativePackLauncher implements AbstractPackLauncher {
  @override
  Future<void> launch(
    UserJackboxPack userPack, {
    JackboxGame? game = null,
  }) async {
    List<String> arguments = [];
    String? customServerUrl = UserData().settings.customServerUrl;

    if (game != null && game.internalName != null && !useLoader(game)) {
      String jbgConfig = "isBundle=false";
      if (customServerUrl != null && customServerUrl.isNotEmpty) {
        jbgConfig += ",serverUrl=$customServerUrl";
      }
      arguments = [
        "-launchTo",
        "games%2F${game.internalName}%2F${game.internalName}.swf",
        "-jbg.config",
        jbgConfig
      ];
    } else if (customServerUrl != null && customServerUrl.isNotEmpty) {
      // Добавляем serverUrl даже при запуске пака без конкретной игры
      arguments = ["-jbg.config", "serverUrl=$customServerUrl"];
    }

    String executable = "${userPack.path!}/${userPack.pack.executable}";

    await Process.run(
      executable,
      arguments,
      workingDirectory: userPack.path,
    );
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
