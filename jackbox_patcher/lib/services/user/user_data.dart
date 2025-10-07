import 'dart:convert';
import 'dart:io';

import 'package:jackbox_patcher/model/jackbox/jackbox_pack.dart';
import 'package:jackbox_patcher/model/misc/window_information.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game_patch.dart';
import 'package:jackbox_patcher/services/api_utility/api_service.dart';
import 'package:jackbox_patcher/services/logger/logger.dart';
import 'package:jackbox_patcher/services/user/user_game_list.dart';
import 'package:jackbox_patcher/services/user/user_settings.dart';
import 'package:jackbox_patcher/services/user/user_tip.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/misc/launchers.dart';
import '../../model/user_model/user_jackbox_game.dart';
import '../../model/user_model/user_jackbox_pack.dart';
import '../../model/user_model/user_jackbox_pack_patch.dart';

class UserData {
  static final UserData _instance = UserData._internal();
  late SharedPreferences preferences;
  late UserSettings settings;
  late UserGameList gameList;
  late UserTips tips;

  factory UserData() {
    return _instance;
  }

  UserData._internal();

  List<UserJackboxPack> packs = [];

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
    gameList = UserGameList(preferences: preferences);
    tips = UserTips(preferences: preferences);
    tips.init();
  }

  Future<void> syncSettings() async {
    settings = UserSettings(preferences: preferences);
  }

  Future<void> syncInfo() async {
    await APIService().recoverServerInfo(getSelectedServer()!);
  }

  /// Sync every pack on the server.
  ///
  /// Every pack available will be added to the list of packs (UserData().packs).
  Future<void> syncPacks(Function(double) callback) async {
    bool somethingChanged = await APIService().recoverPacksAndTags((callback));
    if (somethingChanged) {
      packs = [];
      List<JackboxPack> networkPacks = APIService().getPacks();
      for (var pack in networkPacks) {
        // Load the pack loader
        UserJackboxLoader? loader;
        if (pack.loader != null) {
          loader = UserJackboxLoader(
              loader: pack.loader!,
              path: preferences.getString("${pack.id}_loader_path"),
              version: preferences.getString("${pack.id}_loader_version"));
        }

        final String? packPath = preferences.getString("${pack.id}_path");
        final bool packOwned = preferences.getBool("${pack.id}_owned") ?? false;
        final LauncherType packLauncher = LauncherType.fromName(preferences.getString("${pack.id}_origin") ?? "");
        UserJackboxPack userPack =
            UserJackboxPack(pack: pack, loader: loader, path: packPath, owned: packOwned, origin: packLauncher);
        packs.add(userPack);

        // Load every games in the pack
        for (var game in pack.games) {
          UserJackboxLoader? gameLoader;
          if (game.loader != null) {
            gameLoader = UserJackboxLoader(
                loader: game.loader!,
                path: preferences.getString("${game.id}_loader_path"),
                version: preferences.getString("${game.id}_loader_version"));
          }

          UserJackboxGame currentGame = UserJackboxGame(
              game: game,
              stars: preferences.getInt("${game.id}_stars") ?? 0,
              hidden: preferences.getBool("${game.id}_hidden") ?? false,
              loader: gameLoader);
          userPack.games.add(currentGame);
          for (var patch in game.patches) {
            final String? patchVersionInstalled = preferences.getString("${patch.id}_version");
            currentGame.patches.add(UserJackboxGamePatch(patch: patch, installedVersion: patchVersionInstalled));
          }
        }

        String? patchVersionInstalled = getInstalledVersion(userPack);

        // Load every patches in the pack
        for (var patch in pack.patches) {
          userPack.addPatch(UserJackboxPackPatch(patch: patch, installedVersion: patchVersionInstalled));
        }

        // Do the same for the fixes
        for (var patch in pack.fixes) {
          userPack.fixes.add(UserJackboxPackPatch(patch: patch, installedVersion: patchVersionInstalled));
        }
      }

      for (var element in APIService().cachedCategories) {
        element.addPatchs(packs);
      }
      APIService().internalCache.notifyListeners();
    }
  }

  void updateDownloadedPackPatchVersion() {
    List<UserJackboxPack> availablePacks = packs.where((element) => element.owned).toList();
    for (var pack in availablePacks) {
      /// Get the installed version of the pack
      String? patchVersionInstalled = getInstalledVersion(pack);

      for (var patch in pack.patches) {
        patch.installedVersion = patchVersionInstalled;
      }
      for (var patch in pack.fixes) {
        patch.installedVersion = patchVersionInstalled;
      }
    }
  }

  String? getInstalledVersion(UserJackboxPack userPack) {
    String? patchVersionInstalled;
    if (userPack.pack.configuration == null) {
      return null;
    }
    String versionFile;
    if (Platform.isMacOS) {
      //stupid mac app file structure
      versionFile =
          "${userPack.pack.name}.app/Contents/Resources/macos/${userPack.pack.configuration!.versionFile.fromLauncher(userPack.origin)}";
    } else {
      versionFile = userPack.pack.configuration!.versionFile.fromLauncher(userPack.origin);
    }
    JULogger().i("Version file detected for pack ${userPack.pack.name} with origin ${userPack.origin} : $versionFile");
    if (userPack.path == null) {
      return null;
    }
    File configurationFile = File("${userPack.path!}${Platform.pathSeparator}$versionFile");
    JULogger().i("Configuration file path : ${userPack.path!}${Platform.pathSeparator}${configurationFile.path}");
    if (configurationFile.existsSync()) {
      patchVersionInstalled =
          jsonDecode(configurationFile.readAsStringSync())[userPack.pack.configuration!.versionProperty]
              .replaceAll("Build:", "")
              .trim();
      JULogger().i("Version installed for pack ${userPack.pack.name} : $patchVersionInstalled");
    } else {
      JULogger().i("Configuration file not found for pack ${userPack.pack.name}");
      patchVersionInstalled = null;
    }
    return patchVersionInstalled;
  }

  /// Sync the welcome message from the server
  Future<void> syncWelcomeMessage() async {
    await APIService().recoverNewsAndLinks();
  }

  /// Save pack (mostly used when the path parameter is changed)
  Future<void> savePack(UserJackboxPack pack) async {
    if (pack.path != null) {
      await preferences.setString("${pack.pack.id}_path", pack.path!);
    } else {
      await preferences.remove("${pack.pack.id}_path");
    }
    await preferences.setBool("${pack.pack.id}_owned", pack.owned);
    if (pack.origin != null) {
      await preferences.setString("${pack.pack.id}_origin", pack.origin!.toName());
    } else {
      await preferences.remove("${pack.pack.id}_origin");
    }
    for (var game in pack.games) {
      await saveGame(game);
    }
    if (pack.loader != null) {
      await saveLoader(pack.loader!, pack.pack.id);
    }
  }

  /// Save a game
  Future<void> saveGame(UserJackboxGame game) async {
    for (var patch in game.patches) {
      savePatch(patch);
    }
    if (game.loader != null) {
      await saveLoader(game.loader!, game.game.id);
    }
    await preferences.setInt("${game.game.id}_stars", game.stars);
    await preferences.setBool("${game.game.id}_hidden", game.hidden);
  }

  /// Save a patch (mostly used when a patch is downloaded)
  Future<void> savePatch(UserJackboxGamePatch patch) async {
    if (patch.installedVersion != null) {
      await preferences.setString("${patch.patch.id}_version", patch.installedVersion!);
    } else {
      await preferences.remove("${patch.patch.id}_version");
    }
  }

  /// Save a loader path (mostly used when a loader is downloaded)
  Future<void> saveLoader(UserJackboxLoader loader, String id) async {
    if (loader.path != null) {
      await preferences.setString("${id}_loader_path", loader.path!);
      await preferences.setString("${id}_loader_version", loader.version!);
    }
  }

  String? getLastNewsReaden() {
    return preferences.getString("last_news_readen");
  }

  void setLastNewsReaden(String lastNewsReadenId) {
    preferences.setString("last_news_readen", lastNewsReadenId);
  }

  String? getSelectedServer() {
    return preferences.getString("selected_server");
  }

  bool getFixPromptDiscard(UserJackboxPackPatch fix) {
    return preferences.getBool("${fix.patch.id}_fix_prompt_discard") ?? false;
  }

  void setFixPromptDiscard(UserJackboxPackPatch fix, bool value) {
    preferences.setBool("${fix.patch.id}_fix_prompt_discard", value);
  }

  WindowInformation getLastWindowInformations() {
    WindowInformation lastWindowInformations = WindowInformation(
      maximized: preferences.getBool("last_window_maximize") ?? false,
      width: preferences.getInt("last_window_width") ?? 1300,
      height: preferences.getInt("last_window_height") ?? 750,
      x: preferences.getInt("last_window_x") ?? 10,
      y: preferences.getInt("last_window_y") ?? 10,
    );
    return lastWindowInformations;
  }

  Future<void> setSelectedServer(String? server) async {
    if (server == null) {
      await preferences.remove("selected_server");
    } else {
      await preferences.setString("selected_server", server);
    }
  }

  Future<void> setLastWindowInformations(WindowInformation windowInformation) async {
    await preferences.setBool("last_window_maximize", windowInformation.maximized);
    await preferences.setInt("last_window_width", windowInformation.width);
    await preferences.setInt("last_window_height", windowInformation.height);
    await preferences.setInt("last_window_x", windowInformation.x);
    await preferences.setInt("last_window_y", windowInformation.y);
  }

  bool isFirstTimeEverOpeningTheApp() {
    return preferences.getBool("first_time_opening_app") ?? true;
  }

  void setFirstTimeEverOpeningTheApp(bool value) {
    preferences.setBool("first_time_opening_app", value);
  }

  void resetStars() {
    for (var pack in packs) {
      for (var game in pack.games) {
        game.stars = 0;
      }
    }
  }

  void resetHiddenGames() {
    for (var pack in packs) {
      for (var game in pack.games) {
        game.hidden = false;
      }
    }
  }

  UserJackboxPack? getUserPackById(String id) {
    if (packs.where((element) => element.pack.id == id).length == 0) {
      return null;
    }
    return packs.firstWhere((element) => element.pack.id == id);
  }
}
