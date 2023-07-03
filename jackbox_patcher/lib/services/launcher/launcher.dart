import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:jackbox_patcher/model/misc/launchers.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:jackbox_patcher/services/audio/SFXService.dart';
import 'package:jackbox_patcher/services/logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/misc/audio/SFXEnum.dart';
import '../user/userdata.dart';

class Launcher {
  static List<UserJackboxPack> _openedLaunchers = [];

  /// This function will launch the [pack]
  static Future<void> launchPack(UserJackboxPack pack) async {
    if (pack.path == null) {
      throw Exception("Pack path is null");
    } else {
      
      SFXService().playSFX(SFX.GAME_LAUNCHED);
      // If the loader is not already installed or need update, download it
      if (pack.loader != null) {
        if (pack.loader!.path == null ||
            pack.loader!.version != pack.pack.loader!.version ||
            !File(pack.loader!.path!).existsSync()) {
          pack.loader!.path =
              await APIService().downloadPackLoader(pack.pack, (p0, p1) {});
          pack.loader!.version = pack.pack.loader!.version;
          await UserData().savePack(pack);
        }
        String packFolder = pack.path!;
        await extractFileToDisk(pack.loader!.path!, packFolder);
      }
      if (pack.origin != null &&
          pack.origin == LauncherType.STEAM &&
          pack.pack.launchersId != null &&
          pack.pack.launchersId!.steam != null) {
        try {
          await launchUrl(
              Uri.parse("steam://rungameid/${pack.pack.launchersId!.steam!}"));
        } catch (e) {
          JULogger().e(e);
        }
      } else {
        await Process.run("${pack.path!}/${pack.pack.executable}", [],
            workingDirectory: pack.path);
      }
    }
  }

  /// This function will launch the [game] from the [pack]
  static Future<void> launchGame(
      UserJackboxPack pack, UserJackboxGame game) async {
    if (pack.path == null) {
      throw Exception("Pack path is null");
    } else {
      if (game.loader == null) {
        return await launchPack(pack);
      }
      
      SFXService().playSFX(SFX.GAME_LAUNCHED);
      // If the original loader is not already installed or need update, download it
      if (pack.loader != null) {
        if (pack.loader!.path == null ||
            pack.loader!.version != pack.pack.loader!.version ||
            !File(pack.loader!.path!).existsSync()) {
          pack.loader!.path =
              await APIService().downloadPackLoader(pack.pack, (p0, p1) {});
          pack.loader!.version = pack.pack.loader!.version;
          await UserData().savePack(pack);
        }
        String packFolder = pack.path!;
        await extractFileToDisk(pack.loader!.path!, packFolder);
      }

      // If the loader is not already installed or need update, download it
      if (game.loader!.path == null ||
          game.loader!.version != game.game.loader!.version ||
          !File(game.loader!.path!).existsSync()) {
        game.loader!.path = await APIService()
            .downloadGameLoader(pack.pack, game.game, (p0, p1) {});
        game.loader!.version = pack.pack.loader!.version;
        await UserData().savePack(pack);
      }

      // Extracting into game file
      String packFolder = pack.path!;
      await extractFileToDisk(game.loader!.path!, packFolder);
      if (pack.origin != null &&
          pack.origin == LauncherType.STEAM &&
          pack.pack.launchersId != null &&
          pack.pack.launchersId!.steam != null) {
        await launchUrl(
            Uri.parse("steam://rungameid/${pack.pack.launchersId!.steam!}"));
      } else {
        await Process.run("${pack.path!}/${pack.pack.executable}", [],
            workingDirectory: pack.path);
      }
      SFXService().playSFX(SFX.GAME_LAUNCHED);
      _openedLaunchers.add(pack);
    }
  }

  static Future<void> restoreOldLaunchers() async {
    for (UserJackboxPack pack in _openedLaunchers) {
      // Extracting back files
      String packFolder = pack.path!;
      await extractFileToDisk(pack.loader!.path!, packFolder);
    }
    ;
  }
}
