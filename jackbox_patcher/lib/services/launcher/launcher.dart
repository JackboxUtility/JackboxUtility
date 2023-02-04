import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';

import '../user/userdata.dart';

class Launcher {
  static Future<void> launchPack(UserJackboxPack pack) async {
    if (pack.path == null) {
      throw Exception("Pack path is null");
    } else {
      // If the loader is not already installed or need update, download it
      if (pack.loader!.path == null ||
          pack.loader!.version != pack.pack.loader!.version ||
          !File(pack.loader!.path!).existsSync()) {
        pack.loader!.path =
            await APIService().downloadPackLoader(pack.pack, (p0, p1) {});
        pack.loader!.version = pack.pack.loader!.version;
        await UserData().savePack(pack);
      }

      // Extracting into game file
      String packFolder = pack.path!;
      await extractFileToDisk(pack.loader!.path!, packFolder);
      await Process.run("${pack.path}/${pack.pack.executable}", []);
    }
  }

  static Future<void> launchGame(
      UserJackboxPack pack, UserJackboxGame game) async {
    if (pack.path == null) {
      throw Exception("Pack path is null");
    } else {
      print(game);
      // If the loader is not already installed or need update, download it
      if (game.loader!.path == null ||
          game.loader!.version != game.game.loader!.version ||
          !File(game.loader!.path!).existsSync()) {
        game.loader!.path =
            await APIService().downloadGameLoader(pack.pack, game.game, (p0, p1) {});
        game.loader!.version = pack.pack.loader!.version;
        await UserData().savePack(pack);
      }

      // Extracting into game file
      String packFolder = pack.path!;
      await extractFileToDisk(game.loader!.path!, packFolder);
      await Process.run("${pack.path}/${pack.pack.executable}", []);
    }
  }
}
