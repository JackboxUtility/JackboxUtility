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
        final String? gamePath = preferences.getString("${game.id}_path");
        userPack.games.add(UserJackboxGame(game: game, installed:true, installedVersion: "1.0.0"));
      }
    }
  }
}
