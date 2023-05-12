import 'dart:convert';
import 'dart:io';

import 'package:jackbox_patcher/model/jackbox/jackboxpack.dart';
import 'package:jackbox_patcher/model/misc/windowInformation.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgamepatch.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/misc/launchers.dart';
import '../../model/usermodel/userjackboxgame.dart';
import '../../model/usermodel/userjackboxpack.dart';
import '../../model/usermodel/userjackboxpackpatch.dart';

class UserData {
  static final UserData _instance = UserData._internal();
  late SharedPreferences preferences;

  factory UserData() {
    return _instance;
  }

  UserData._internal();

  List<UserJackboxPack> packs = [];

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<void> syncInfo() async {
    await APIService().recoverServerInfo(getSelectedServer()!);
  }

  /// Sync every pack on the server.
  ///
  /// Every pack available will be added to the list of packs (UserData().packs).
  Future<void> syncPacks() async {
    await APIService().recoverPacksAndTags();
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
      final LauncherType packOrigin =
          LauncherType.fromName(preferences.getString("${pack.id}_origin")??"");
      UserJackboxPack userPack = UserJackboxPack(
          pack: pack,
          loader: loader,
          path: packPath,
          owned: packOwned,
          origin: packOrigin);
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

        UserJackboxGame currentGame =
            UserJackboxGame(game: game, loader: gameLoader);
        userPack.games.add(currentGame);
        for (var patch in game.patches) {
          final String? patchVersionInstalled =
              preferences.getString("${patch.id}_version");
          currentGame.patches.add(UserJackboxGamePatch(
              patch: patch, installedVersion: patchVersionInstalled));
        }
      }

      // Load every patches in the pack
      for (var patch in pack.patches) {
        final String? patchVersionInstalled;
        if (pack.configuration != null && userPack.path != null) {
          File configurationFile =
              File("${userPack.path!}/${pack.configuration!.file}");
          if (configurationFile.existsSync()) {
            patchVersionInstalled =
                jsonDecode(configurationFile.readAsStringSync())[
                        pack.configuration!.versionProperty]
                    .replaceAll("Build:", "")
                    .trim();
          } else {
            patchVersionInstalled = null;
          }
        } else {
          patchVersionInstalled = null;
        }
        userPack.patches.add(UserJackboxPackPatch(
            patch: patch, installedVersion: patchVersionInstalled));
      }
    }

    for (var element in APIService().cachedCategories) {
      element.addPatchs(packs);
    }
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
    await preferences.setString("${pack.pack.id}_origin", pack.origin!.toName());
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
  }

  /// Save a patch (mostly used when a patch is downloaded)
  Future<void> savePatch(UserJackboxGamePatch patch) async {
    if (patch.installedVersion != null) {
      await preferences.setString(
          "${patch.patch.id}_version", patch.installedVersion!);
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

  /// Write logs (mostly used when a patch is not downloaded properly)
  Future<void> writeLogs(String logs) async {
    File logFile = File("./logs.txt");
    await logFile.writeAsString("[${DateTime.now()}]\n$logs",
        mode: FileMode.append);
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

  WindowInformation getLastWindowInformations() {
    WindowInformation lastWindowInformations = WindowInformation(
      maximized: preferences.getBool("last_window_maximize") ?? false,
      width: preferences.getInt("last_window_width") ?? 1280,
      height: preferences.getInt("last_window_height") ?? 720,
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

  Future<void> setLastWindowInformations(
      WindowInformation windowInformation) async {
    await preferences.setBool(
        "last_window_maximize", windowInformation.maximized);
    await preferences.setInt("last_window_width", windowInformation.width);
    await preferences.setInt("last_window_height", windowInformation.height);
    await preferences.setInt("last_window_x", windowInformation.x);
    await preferences.setInt("last_window_y", windowInformation.y);
  }
}
