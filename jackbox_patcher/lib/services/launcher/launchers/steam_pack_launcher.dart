import 'package:jackbox_patcher/model/jackbox/jackbox_game.dart';
import 'package:jackbox_patcher/model/misc/launchers.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';
import 'package:jackbox_patcher/services/launcher/launchers/abstract_pack_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class SteamPackLauncher implements AbstractPackLauncher {
  @override
  Future<void> launch(UserJackboxPack userPack,
      {JackboxGame? game = null}) async {
    String parameters = "";
    if (game != null && game.internalName != null) {
      parameters = "/-launchTo games%2F${game.internalName}%2F${game.internalName}.swf";
    }
    print("steam://run/${userPack.pack.launchersId!.steam!}/$parameters");
    await launchUrl(
        Uri.parse("steam://run/${userPack.pack.launchersId!.steam!}/$parameters"));
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
