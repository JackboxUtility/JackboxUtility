import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/services/api_utility/api_service.dart';
import 'package:jackbox_patcher/services/audio/SFXService.dart';
import 'package:jackbox_patcher/services/discord/DiscordService.dart';
import 'package:jackbox_patcher/services/internal_api/RestApiRouter.dart';
import 'package:jackbox_patcher/services/internal_api/ws_message/GameCloseWsMessage.dart';
import 'package:jackbox_patcher/services/internal_api/ws_message/GameOpenWsMessage.dart';
import 'package:jackbox_patcher/services/launcher/launchers/AbstractPackLauncher.dart';
import 'package:jackbox_patcher/services/launcher/launchers/EpicPackLauncher.dart';
import 'package:jackbox_patcher/services/launcher/launchers/NativePackLauncher.dart';
import 'package:jackbox_patcher/services/launcher/launchers/SteamPackLauncher.dart';
import 'package:jackbox_patcher/services/launcher/processHelper.dart';
import 'package:jackbox_patcher/services/logger/logger.dart';
import 'package:jackbox_patcher/services/translations/translationsHelper.dart';

import '../../model/misc/audio/SFXEnum.dart';
import '../user/userdata.dart';

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
      await handlePackLaunch(pack);
      _openedPacks.add(pack);
      checkLaunchedPack(pack, game);
    }
  }

  static Future<void> handlePackLaunch(UserJackboxPack pack) async {
    for (AbstractPackLauncher launcher in _availablePackLaunchers) {
      if (launcher.willHandleRequest(pack)) {
        await launcher.launch(pack);
        return;
      }
    }
  }

  static Future<void> restoreOldLaunchers() async {
    for (UserJackboxPack pack in _openedPacks) {
      // Extracting back files
      String packFolder = pack.path!;
      await extractFileToDisk(pack.loader!.path!, packFolder);
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
      JULogger().i("Pack ${pack.pack.name} is launched");

      if (game != null) {
        RestApiRouter().sendMessage(GameOpenWsMessage(game.game));
      }
      // Updating Discord Rich Presence while the pack is launched
      while (packIsLaunched) {
        JULogger().i("Updating Discord Rich Presence");
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
      JULogger().i("Pack ${pack.pack.name} is not launched anymore");
    }
  }
}
