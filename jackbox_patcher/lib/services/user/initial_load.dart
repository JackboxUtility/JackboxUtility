// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dart_discord_rpc/dart_discord_rpc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/patch_server.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';
import 'package:jackbox_patcher/services/api_utility/api_service.dart';
import 'package:jackbox_patcher/services/api_utility/automatic_reload.dart';
import 'package:jackbox_patcher/services/automatic_game_finder/automatic_game_finder.dart';
import 'package:jackbox_patcher/services/discord/discord_service.dart';
import 'package:jackbox_patcher/services/downloader/precache_service.dart';
import 'package:jackbox_patcher/services/error/error.dart';
import 'package:jackbox_patcher/services/files/folder_service.dart';
import 'package:jackbox_patcher/services/internal_api/rest_api_router.dart';
import 'package:jackbox_patcher/services/libs/media_kit_remover_service.dart';
import 'package:jackbox_patcher/services/statistics/statistics_sender.dart';
import 'package:jackbox_patcher/services/translations/translations_helper.dart';
import 'package:jackbox_patcher/services/user/user_data.dart';
import 'package:window_manager/window_manager.dart';

import '../../components/dialogs/download_patch_dialog.dart';
import '../../components/dialogs/fixes_available_to_download_dialog.dart';
import '../../model/user_model/user_jackbox_game_patch.dart';
import '../../model/user_model/user_jackbox_pack_patch.dart';
import '../windowManager/windows_manager_service.dart';

class InitialLoad {
  static Future<void> preInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    if (Platform.isWindows) {
      // MediaKit.ensureInitialized();
    }
    if (!Platform.isMacOS) {
      DiscordRPC.initialize();
    }
  }

  static Future<void> init(
      BuildContext context,
      bool isFirstTimeOpening,
      bool automaticallyChooseBestServer,
      Function({int? step, double? percent}) callback) async {
    bool automaticGameFindNotificationAvailable = false;
    callback(step: 1, percent: 0.0);
    if (isFirstTimeOpening) {
      await MediaKitRemover.removeMediaKit(context);
      await windowManager.setPreventClose(true);
      await FolderService().init();
      await UserData().init();
      WindowManagerService.updateScreenSizeFromLastOpening();

      /// Give context to the RestApi so it can ask the user if he wants to accept an app
      RestApiRouter().context = context;
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
    callback(step: 2, percent: 0);
    try {
      await _loadSettings();
      await _loadInfo();
      await _loadWelcome();
      await _loadPacks((double percent) {
        callback(step: 2, percent: percent);
      });
      await _loadBlurHashes();
      await _loadServerConfigurations();
      await _loadServerCustomComponent();
      callback(step: 3, percent: 0);

      // Changing locale
      TranslationsHelper().changeLocale(
          Locale(APIService().cachedSelectedServer!.languages[0]));

      // Reloading every tips with the new language
      UserData().tips.init();

      // Sending anonymous statistics
      if (isFirstTimeOpening) {
        StatisticsSender.sendOpenApp();
      }

      if (UserData().settings.isDiscordRPCActivated) {
        DiscordService().init();
      }
      await precacheImage(
          Image.network(APIService()
                  .assetLink(APIService().cachedSelectedServer!.image))
              .image,
          context);
      callback(step: 3, percent: 50);
      _precacheImages(context);
      if (isFirstTimeOpening) {
        await _launchAutomaticGameFinder(
            context, automaticGameFindNotificationAvailable);
        AutomaticReload.startAutomaticReload();
      }
      await detectFixesAvailable(context);
      callback(step: 3, percent: 100);
      if (isFirstTimeOpening &&
          UserData().settings.isOpenLauncherOnStartupActivated) {
        openLauncher(context);
      }

      if (UserData().isFirstTimeEverOpeningTheApp()) {
        UserData().setFirstTimeEverOpeningTheApp(false);
        setIsFirstTimeOpening(context);
      }
    } catch (e) {
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

  static Future<void> _loadPacks(Function(double) callback) async {
    await UserData().syncPacks(callback);
  }

  static Future<void> _loadBlurHashes() async {
    await APIService().recoverBlurHashes();
  }

  static Future<void> _loadServerConfigurations() async {
    await APIService().recoverConfigurations();
  }

  static Future<void> _loadServerCustomComponent() async {
    await APIService().recoverCustomComponent();
  }

  static void setIsFirstTimeOpening(context) {
    InfoBarService.showInfo(
        context,
        TranslationsHelper().appLocalizations!.privacy_info,
        TranslationsHelper().appLocalizations!.privacy_description);
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
