import 'dart:io';

import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/services/launcher/launchers/AbstractPackLauncher.dart';

class NativePackLauncher implements AbstractPackLauncher {
  @override
  Future<void> launch(UserJackboxPack userPack) async {
    await Process.run("${userPack.path!}/${userPack.pack.executable}", [],
            workingDirectory: userPack.path);
  }

  @override
  bool willHandleRequest(UserJackboxPack userPack) {
    return true;
  }
}
