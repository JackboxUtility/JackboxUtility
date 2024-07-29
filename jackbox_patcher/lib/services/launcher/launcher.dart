import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/jackbox/jackbox_game.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';
import 'package:jackbox_patcher/services/api_utility/api_service.dart';
import 'package:jackbox_patcher/services/audio/sfx_service.dart';
import 'package:jackbox_patcher/services/discord/discord_service.dart';
import 'package:jackbox_patcher/services/downloader/downloader_service.dart';
import 'package:jackbox_patcher/services/internal_api/rest_api_router.dart';
import 'package:jackbox_patcher/services/internal_api/ws_message/game_close_ws_message.dart';
import 'package:jackbox_patcher/services/internal_api/ws_message/game_open_ws_message.dart';
import 'package:jackbox_patcher/services/launcher/launchers/abstract_pack_launcher.dart';
import 'package:jackbox_patcher/services/launcher/launchers/epic_pack_launcher.dart';
import 'package:jackbox_patcher/services/launcher/launchers/native_pack_launcher.dart';
import 'package:jackbox_patcher/services/launcher/launchers/steam_pack_launcher.dart';
import 'package:jackbox_patcher/services/launcher/process_helper.dart';
import 'package:jackbox_patcher/services/logger/logger.dart';
import 'package:jackbox_patcher/services/translations/translations_helper.dart';

import '../../model/misc/audio/SFXEnum.dart';
import '../user/user_data.dart';

class Launcher {
  static final List<UserJackboxPack> _openedPacks = [];
  static final List<AbstractPackLauncher> _availablePackLaunchers = [
    SteamPackLauncher(),
    EpicPackLauncher(),
    NativePackLauncher()
  ];

  static Future<bool> _initForRawLaunch() async {
    TranslationsHelper().changeLocale(Locale("en"));
    await UserData().init();
    String? selectedServer = UserData().getSelectedServer();
    if (selectedServer == null) {
      return false;
    }
    await APIService().recoverServerInfo(selectedServer);
    await UserData().syncPacks((p0) => null);
    return true;
  }

  /// Launch pack already saved into the [UserData]
  static Future<bool> launchRawPack(String pack) async {
    if (await _initForRawLaunch() == false) {
      return false;
    }
    // Checking if the pack is owned
    UserJackboxPack? packFound = UserData().packs.getPackById(pack);
    if (packFound == null) {
      return false;
    }
    await launchPack(packFound, true);
    return true;
  }

  /// Launch game already saved into the [UserData]
  static Future<bool> launchRawGame(String game) async {
    if (await _initForRawLaunch() == false) {
      return false;
    }
    // Checking if the game is owned
    UserJackboxGame? gameFound = UserData().packs.getGameById(game);
    if (gameFound == null) {
      return false;
    }
    UserJackboxPack packFound = gameFound.getPack();
    await launchGame(packFound, gameFound);
    return true;
  }

  /// This function will launch the [pack]
  static Future<void> launchPack(UserJackboxPack pack,
      [bool windowLess = false]) async {
    if (pack.path == null) {
      throw Exception("Pack path is null");
    } else {
      if (!windowLess) SFXService().playSFX(SFX.GAME_LAUNCHED);
      // If the loader is not already installed or need update, download it
      // if (pack.loader != null) {
      //   if (pack.loader!.path == null ||
      //       pack.loader!.version != pack.pack.loader!.version ||
      //       !File(pack.loader!.path!).existsSync()) {
      //     pack.loader!.path =
      //         await APIService().downloadPackLoader(pack.pack, (p0, p1) {});
      //     pack.loader!.version = pack.pack.loader!.version;
      //     await UserData().savePack(pack);
      //   }
      //   await extractPackLoader(pack);
      // }
      await handlePackLaunch(pack);
      checkLaunchedPack(pack);
    }
  }

  /// This function will launch the [game] from the [pack]
  static Future<void> launchGame(
      UserJackboxPack pack, UserJackboxGame game) async {
    if (pack.path == null) {
      throw Exception("Pack path is null");
    } else {
      if (game.loader == null) {
        return await launchPack(pack, false);
      }

      SFXService().playSFX(SFX.GAME_LAUNCHED);
      // // If the original loader is not already installed or need update, download it
      // if (pack.loader != null) {
      //   if (pack.loader!.path == null ||
      //       pack.loader!.version != pack.pack.loader!.version ||
      //       !File(pack.loader!.path!).existsSync()) {
      //     pack.loader!.path =
      //         await APIService().downloadPackLoader(pack.pack, (p0, p1) {});
      //     pack.loader!.version = pack.pack.loader!.version;
      //     await UserData().savePack(pack);
      //   }
      //   await extractPackLoader(pack);
      // }

      // // If the loader is not already installed or need update, download it
      // if (game.loader!.path == null ||
      //     game.loader!.version != game.game.loader!.version ||
      //     !File(game.loader!.path!).existsSync()) {
      //   game.loader!.path = await APIService()
      //       .downloadGameLoader(pack.pack, game.game, (p0, p1) {});
      //   game.loader!.version = pack.pack.loader!.version;
      //   await UserData().savePack(pack);
      // }

      // Extracting into game file
      // await extractGameLoader(pack, game);
      await handlePackLaunch(pack, game: game.game);
      // _openedPacks.add(pack);
      checkLaunchedPack(pack, game);
    }
  }

  static Future<void> handlePackLaunch(UserJackboxPack pack,
      {JackboxGame? game = null}) async {
    for (AbstractPackLauncher launcher in _availablePackLaunchers) {
      if (launcher.willHandleRequest(pack)) {
        await launcher.launch(pack, game: game);
        return;
      }
    }
  }

  static Future<void> restoreOldLaunchers() async {
    for (UserJackboxPack pack in _openedPacks) {
      // Extracting back files
      await extractPackLoader(pack);
    }
  }

  static Future<void> extractPackLoader(UserJackboxPack pack) async {
    if (pack.loader != null) {
      String packFolder = pack.path!;
      if (pack.pack.resourceLocation != null) {
        packFolder = packFolder + "/" + pack.pack.resourceLocation!;
      }
      await DownloaderService.extractFileToDisk(
          pack.loader!.path!, packFolder, (p1, p2, p3) {});
    }
  }

  static Future<void> extractGameLoader(
      UserJackboxPack pack, UserJackboxGame game) async {
    if (pack.loader != null) {
      String packFolder = pack.path!;
      if (pack.pack.resourceLocation != null) {
        packFolder = packFolder + "/" + pack.pack.resourceLocation!;
      }
      await DownloaderService.extractFileToDisk(
          game.loader!.path!, packFolder, (p1, p2, p3) {});
    }
  }

  // This function will check if a pack is still launched and will update the Discord Rich Presence system
  static Future<void> checkLaunchedPack(UserJackboxPack pack,
      [UserJackboxGame? game]) async {
    String commandToRun = "";
    List<String> arguments = [];
    if (Platform.isWindows) {
      commandToRun = "tasklist";
      arguments = ["/FO", "LIST"];
    } else if (Platform.isMacOS) {
      commandToRun = "ps -ax";
    } else if (Platform.isLinux) {
      commandToRun = "ps aux";
    }
    if (commandToRun != "") {
      // Checking if the pack is launched
      bool packIsLaunched = false;
      while (!packIsLaunched) {
        await Future.delayed(Duration(seconds: 5));
        String result =
            await ProcessHelper.runAndGetOutput(commandToRun, arguments);
        if (result.contains(pack.pack.executable!)) {
          packIsLaunched = true;
        }
      }
      JULogger().i("[LAUNCHER] Pack ${pack.pack.name} is launched");

      if (game != null) {
        RestApiRouter().sendMessage(GameOpenWsMessage(game.game));
      }
      // Updating Discord Rich Presence while the pack is launched
      while (packIsLaunched) {
        JULogger().i("[LAUNCHER] Updating Discord Rich Presence");
        DiscordService().launchPackLaunchedPresence(pack);
        await Future.delayed(Duration(seconds: 20));
        String result =
            await ProcessHelper.runAndGetOutput(commandToRun, arguments);
        if (!result.contains(pack.pack.executable!)) {
          packIsLaunched = false;
        }
      }
      if (game != null) {
        RestApiRouter().sendMessage(GameCloseWsMessage(game.game));
      }
      DiscordService().launchOldPresence();
      JULogger().i("[LAUNCHER] Pack ${pack.pack.name} is not launched anymore");
    }
  }
}
