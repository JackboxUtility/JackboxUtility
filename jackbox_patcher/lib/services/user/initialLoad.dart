import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/patchserver.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:jackbox_patcher/services/automaticGameFinder/AutomaticGameFinder.dart';
import 'package:jackbox_patcher/services/discord/DiscordService.dart';
import 'package:jackbox_patcher/services/downloader/precache_service.dart';
import 'package:jackbox_patcher/services/error/error.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';
import 'package:window_manager/window_manager.dart';

import '../windowManager/windowsManagerService.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InitialLoad {
  static Future<void> init(BuildContext context, bool isFirstTimeOpening,
      bool automaticallyChooseBestServer) async {
    bool changedServer = false;
    bool automaticGameFindNotificationAvailable = false;
    if (isFirstTimeOpening) {
      await windowManager.setPreventClose(true);
      await UserData().init();
      WindowManagerService.updateScreenSizeFromLastOpening();
    }
    UserData().packs = [];
    APIService().resetCache();
    if (UserData().getSelectedServer() == null) {
      if (automaticallyChooseBestServer) {
        await findBestServer(context);
      } else {
        await Navigator.pushNamed(context, "/serverSelect");
        automaticGameFindNotificationAvailable = true;
      }
      changedServer = true;
    }
    try {
      await _loadSettings();
      await _loadInfo();
      await _loadWelcome();
      await _loadPacks();
      await _loadBlurHashes();
      await _loadServerConfigurations();
      if (UserData().settings.isDiscordRPCActivated) {
        DiscordService().init();
      }
      await precacheImage(
          Image.network(APIService()
                  .assetLink(APIService().cachedSelectedServer!.image))
              .image,
          context);
      _precacheImages(context);
      if (isFirstTimeOpening) {
        await _launchAutomaticGameFinder(
            context, automaticGameFindNotificationAvailable);
      }
      if (isFirstTimeOpening &&
          UserData().settings.isOpenLauncherOnStartupActivated) {
        openLauncher(context);
      }
    } catch (e) {
      InfoBarService.showError(
          context, AppLocalizations.of(context)!.connection_to_server_failed,
          duration: const Duration(minutes: 5));
      rethrow;
    }
  }

  static Future<void> findBestServer(context) async {
    String locale = Platform.localeName;
    await APIService().recoverAvailableServers();
    List<PatchServer> servers = APIService().cachedServers;
    for (var server in servers) {
      if (server.languages.where((e) => locale.startsWith(e)).isNotEmpty) {
        await UserData().setSelectedServer(server.infoUrl);
        InfoBarService.showInfo(
            context,
            AppLocalizations.of(context)!.automatic_server_finder_found,
            AppLocalizations.of(context)!
                .automatic_server_finder_found_description(server.name));
        return;
      }
    }
    await Navigator.pushNamed(context, "/serverSelect");
  }

  static void openLauncher(context) {
    Navigator.pushNamed(context, "/searchMenu");
  }

  static Future<void> _precacheImages(context) async {
    await PrecacheService().precacheAll(context);
  }

  static Future<void> _loadSettings() async {
    await UserData().syncSettings();
  }

  static Future<void> _loadInfo() async {
    await UserData().syncInfo();
  }

  static Future<void> _loadWelcome() async {
    await UserData().syncWelcomeMessage();
  }

  static Future<void> _loadPacks() async {
    await UserData().syncPacks();
  }

  static Future<void> _loadBlurHashes() async {
    await APIService().recoverBlurHashes();
  }

  static Future<void> _loadServerConfigurations() async {
    await APIService().recoverConfigurations();
  }

  static Future<void> _launchAutomaticGameFinder(
      context, bool showNotification) async {
    int gamesFound =
        await AutomaticGameFinderService.findGames(UserData().packs);
    if (gamesFound > 0) {
      UserData().updateDownloadedPackPatchVersion();
    }
    if (showNotification && gamesFound > 0) {
      InfoBarService.showInfo(
          context,
          AppLocalizations.of(context)!.automatic_game_finder_title,
          AppLocalizations.of(context)!
              .automatic_game_finder_finish(gamesFound));
    }
  }
}
