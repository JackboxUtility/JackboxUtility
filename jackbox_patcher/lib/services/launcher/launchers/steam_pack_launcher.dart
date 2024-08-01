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
    if (game != null && game.internalName != null && !useLoader(game)) {
      parameters =
          "/-launchTo games%2F${game.internalName}%2F${game.internalName}.swf -jbg.config isBundle=false";
    }
    await launchUrl(Uri.parse(
        "steam://run/${userPack.pack.launchersId!.steam!}/$parameters"));
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

  bool useLoader(JackboxGame? game) {
    if (game != null) {
      return game.launchWithLoaders.steam;
    }
    return false;
  }
}
