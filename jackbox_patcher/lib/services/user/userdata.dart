import 'package:jackbox_patcher/model/jackboxpack.dart';
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

  Future<void> savePack(UserJackboxPack pack) async {
    await preferences.setString("${pack.pack.id}_path", pack.path!);
    for (var game in pack.games) {
      if (game.installedVersion != null) {
        await preferences.setString(
            "${game.game.id}_version", game.installedVersion!);
      }
    }
  }

  Future<void> saveGame(UserJackboxGame game) async {
    await preferences.setString("${game.game.id}_version", game.installedVersion!);
  }
}
