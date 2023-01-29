import 'dart:io';

import 'package:jackbox_patcher/model/jackboxpack.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpatch.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/usermodel/userjackboxgame.dart';
import '../../model/usermodel/userjackboxpack.dart';

class UserData {
  static final UserData _instance = UserData._internal();
  late SharedPreferences preferences;

  factory UserData() {
    return _instance;
  }

  UserData._internal() {
    SharedPreferences.getInstance().then((value) => preferences = value);
  }

  List<UserJackboxPack> packs = [];
  String welcomeMessage = "";

  /// Sync every pack on the server.
  ///
  /// Every pack available will be added to the list of packs (UserData().packs).
  Future<void> syncPacks() async {
    List<JackboxPack> networkPacks = await APIService().getPacks();
    for (var pack in networkPacks) {
      // Load the pack loader
      UserJackboxLoader? loader = null;
      if (pack.loader != null) {
        loader = UserJackboxLoader(
            loader: pack.loader!,
            path: preferences.getString("${pack.id}_loader_path"),
            version: preferences.getString("${pack.id}_loader_version"));
      }

      final String? packPath = preferences.getString("${pack.id}_path");
      UserJackboxPack userPack =
          UserJackboxPack(pack: pack, loader: loader, path: packPath);
      packs.add(userPack);
      for (var game in pack.games) {
        UserJackboxLoader? loader = null;
        if (game.loader != null) {
          UserJackboxLoader loader = UserJackboxLoader(
              loader: game.loader!,
              path: preferences.getString("${game.id}_loader_path"),
              version: preferences.getString("${game.id}_loader_version"));
        }

        UserJackboxGame currentGame =
            UserJackboxGame(game: game, loader: loader);
        userPack.games.add(currentGame);
        for (var patch in game.patches) {
          final String? patchVersionInstalled =
              preferences.getString("${patch.id}_version");
          currentGame.patches.add(UserJackboxPatch(
              patch: patch, installedVersion: patchVersionInstalled));
        }
      }
    }
  }

  /// Sync the welcome message from the server
  Future<void> syncWelcomeMessage() async {
    welcomeMessage = await APIService().getWelcome();
  }

  /// Save pack (mostly used when the path parameter is changed)
  Future<void> savePack(UserJackboxPack pack) async {
    await preferences.setString("${pack.pack.id}_path", pack.path!);
    for (var game in pack.games) {
      for (var patch in game.patches) {
        if (patch.installedVersion != null) {
          await preferences.setString(
              "${patch.patch.id}_version", patch.installedVersion!);
        }
      }
    }
  }

  /// Save a game (mostly used when a patch is downloaded)
  Future<void> saveGame(UserJackboxPatch patch) async {
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
    await logFile.writeAsString(logs);
  }
}
