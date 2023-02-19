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

  /// Sync every pack on the server.
  ///
  /// Every pack available will be added to the list of packs (UserData().packs).
  Future<void> syncPacks() async {
    await APIService().recoverPacksAndTags();
    List<JackboxPack> networkPacks = APIService().getPacks();
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
      final bool packOwned = preferences.getBool("${pack.id}_owned") ?? false;
      UserJackboxPack userPack = UserJackboxPack(
          pack: pack, loader: loader, path: packPath, owned: packOwned);
      packs.add(userPack);
      for (var game in pack.games) {
        UserJackboxLoader? gameLoader = null;
        if (game.loader != null) {
          print("LOADER FOUND");
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
          currentGame.patches.add(UserJackboxPatch(
              patch: patch, installedVersion: patchVersionInstalled));
        }
      }
    }
  }

  /// Sync the welcome message from the server
  Future<void> syncWelcomeMessage() async {
    await APIService().recoverNewsAndLinks();
  }

  /// Save pack (mostly used when the path parameter is changed)
  Future<void> savePack(UserJackboxPack pack) async {
    if (pack.path != null){
      await preferences.setString("${pack.pack.id}_path", pack.path!);
    } else {
      await preferences.remove("${pack.pack.id}_path");
    }
    await preferences.setBool("${pack.pack.id}_owned", pack.owned);
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
  Future<void> savePatch(UserJackboxPatch patch) async {
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

  String? getLastNewsReaden(){
    return preferences.getString("last_news_readen");
  }

  void setLastNewsReaden(String lastNewsReadenId){
    preferences.setString("last_news_readen",lastNewsReadenId);
  }
}
