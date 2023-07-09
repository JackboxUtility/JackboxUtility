// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/patchserver.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:jackbox_patcher/services/automaticGameFinder/AutomaticGameFinder.dart';
import 'package:jackbox_patcher/services/discord/DiscordService.dart';
import 'package:jackbox_patcher/services/downloader/precache_service.dart';
import 'package:jackbox_patcher/services/error/error.dart';
import 'package:jackbox_patcher/services/translations/translationsHelper.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';
import 'package:window_manager/window_manager.dart';

import '../../components/dialogs/downloadPatchDialog.dart';
import '../../components/dialogs/fixesAvailabletoDownloadDialog.dart';
import '../../model/usermodel/userjackboxgamepatch.dart';
import '../../model/usermodel/userjackboxpackpatch.dart';
import '../windowManager/windowsManagerService.dart';

class InitialLoad {
  static Future<void> init(BuildContext context, bool isFirstTimeOpening,
      bool automaticallyChooseBestServer) async {
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
    }
    try {
      await _loadSettings();
      await _loadInfo();
      await _loadWelcome();
      await _loadPacks();
      await _loadBlurHashes();
      await _loadServerConfigurations();

      // Changing locale
      TranslationsHelper().changeLocale(
          Locale(APIService().cachedSelectedServer!.languages[0]));

      // Reloading every tips with the new language
      UserData().tips.init();

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
      await detectFixesAvailable(context);
      if (isFirstTimeOpening &&
          UserData().settings.isOpenLauncherOnStartupActivated) {
        openLauncher(context);
      }
    } catch (e) {
      InfoBarService.showError(context,
          TranslationsHelper().appLocalizations!.connection_to_server_failed,
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
            TranslationsHelper()
                .appLocalizations!
                .automatic_server_finder_found,
            TranslationsHelper()
                .appLocalizations!
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
    print(gamesFound);
    if (gamesFound > 0) {
      UserData().updateDownloadedPackPatchVersion();
    }
    if (showNotification && gamesFound > 0) {
      InfoBarService.showInfo(
          context,
          TranslationsHelper().appLocalizations!.automatic_game_finder_title,
          TranslationsHelper()
              .appLocalizations!
              .automatic_game_finder_finish(gamesFound));
    }
  }

  static Future<void> detectFixesAvailable(context) async {
    List<({UserJackboxPackPatch fix, UserJackboxPack pack})> fixesNotInstalled =
        [];
    for (UserJackboxPack pack in UserData().packs) {
      for (var fix in pack.fixes) {
        if (fix.getInstalledStatus() ==
                UserInstalledPatchStatus.NOT_INSTALLED &&
            UserData().getFixPromptDiscard(fix) == false &&
            await pack.getPathStatus() == "FOUND" &&
            pack.owned) {
          fixesNotInstalled.add((fix: fix, pack: pack));
        }
      }
    }
    if (fixesNotInstalled.length >= 1) {
      bool dataReceived = await showDialog(
          dismissWithEsc: false,
          barrierDismissible: false,
          context: context,
          builder: ((context) {
            return FixesAvailableToDownloadDialog(
                fixesAvailable: fixesNotInstalled);
          })) as bool;
      if (dataReceived) {
        List<String> localPaths = [];
        List<UserJackboxPackPatch> patchs = [];
        fixesNotInstalled.forEach((fix) {
          localPaths.add(fix.pack.path!);
          patchs.add(fix.fix);
        });
        await showDialog(
            dismissWithEsc: false,
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return DownloadPatchDialogComponent(
                  localPaths: localPaths, patchs: patchs);
            });
      } else {
        fixesNotInstalled.forEach((fix) {
          UserData().setFixPromptDiscard(fix.fix, true);
        });
      }
    }
  }
}
