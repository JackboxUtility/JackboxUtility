import 'package:jackbox_patcher/model/jackbox/jackbox_game.dart';
import 'package:jackbox_patcher/model/misc/launchers.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';
import 'package:jackbox_patcher/services/launcher/launchers/abstract_pack_launcher.dart';
import 'package:jackbox_patcher/services/user/user_data.dart';
import 'package:url_launcher/url_launcher.dart';

class EpicPackLauncher implements AbstractPackLauncher {
  @override
  Future<void> launch(
    UserJackboxPack userPack, {
    JackboxGame? game = null,
  }) async {
    String parameters = "";
    String? customServerUrl = UserData().settings.customServerUrl;

    if (game != null && game.internalName != null && !useLoader(game)) {
      String jbgConfig = "isBundle=false";
      if (customServerUrl != null && customServerUrl.isNotEmpty) {
        jbgConfig += ",serverUrl=$customServerUrl";
      }
      parameters =
          " -launchTo games%2F${game.internalName}%2F${game.internalName}.swf -jbg.config $jbgConfig";
    } else if (customServerUrl != null && customServerUrl.isNotEmpty) {
      parameters = " -jbg.config serverUrl=$customServerUrl";
    }
    await launchUrl(
      Uri.parse(
        "com.epicgames.launcher://apps/${userPack.pack.launchersId!.epic!}?action=launch&silent=true${parameters}",
      ),
    );
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

  bool useLoader(JackboxGame? game) {
    if (game != null) {
      return game.launchWithLoaders.epicGames;
    }
    return true;
  }
}
