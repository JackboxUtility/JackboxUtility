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
      final String? packPath = preferences.getString("${pack.id}_path");
      UserJackboxPack userPack = UserJackboxPack(pack: pack, path: packPath);
      packs.add(userPack);
      for (var game in pack.games) {
        final String? gameVersionInstalled =
            preferences.getString("${game.id}_version");
        userPack.games.add(UserJackboxGame(
            game: game, installedVersion: gameVersionInstalled));
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
      if (game.installedVersion != null) {
        await preferences.setString(
            "${game.game.id}_version", game.installedVersion!);
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

  /// Write logs (mostly used when a patch is not downloaded properly)
  Future<void> writeLogs(String logs) async {
    File logFile = File("./logs.txt");
    await logFile.writeAsString(logs);
  }
}
