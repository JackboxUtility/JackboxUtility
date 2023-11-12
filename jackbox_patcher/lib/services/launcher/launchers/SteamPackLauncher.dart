import 'package:jackbox_patcher/model/misc/launchers.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/services/launcher/launchers/AbstractPackLauncher.dart';
import 'package:url_launcher/url_launcher.dart';

class SteamPackLauncher implements AbstractPackLauncher {
  @override
  Future<void> launch(UserJackboxPack userPack) async {
    await launchUrl(
            Uri.parse("steam://rungameid/${userPack.pack.launchersId!.steam!}"));
  }

  @override
  bool willHandleRequest(UserJackboxPack userPack) {
    if (userPack.origin != null &&
        userPack.origin == LauncherType.STEAM &&
        userPack.pack.launchersId != null &&
        userPack.pack.launchersId!.steam != null) {
      return true;
    }
    return false;
  }
  
}