import 'dart:io';

import 'package:jackbox_patcher/model/jackbox/jackbox_game.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';
import 'package:jackbox_patcher/services/launcher/launchers/abstract_pack_launcher.dart';

class NativePackLauncher implements AbstractPackLauncher {
  @override
  Future<void> launch(UserJackboxPack userPack,
      {JackboxGame? game = null}) async {
    await Process.run("${userPack.path!}/${userPack.pack.executable}", [],
        workingDirectory: userPack.path);
  }

  @override
  bool willHandleRequest(UserJackboxPack userPack) {
    return true;
  }
}
