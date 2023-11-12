import 'package:jackbox_patcher/model/misc/launchers.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/services/launcher/launchers/AbstractPackLauncher.dart';
import 'package:url_launcher/url_launcher.dart';

class EpicPackLauncher implements AbstractPackLauncher {
  @override
  Future<void> launch(UserJackboxPack userPack) async {
    await launchUrl(Uri.parse(
        "com.epicgames.launcher://apps/${userPack.pack.launchersId!.epic!}?action=launch&silent=true"));
  }

  @override
  bool willHandleRequest(UserJackboxPack userPack) {
    if (userPack.origin != null &&
        userPack.origin == LauncherType.EPIC &&
        userPack.pack.launchersId != null &&
        userPack.pack.launchersId!.epic != null) {
      return true;
    }
    return false;
  }
}
