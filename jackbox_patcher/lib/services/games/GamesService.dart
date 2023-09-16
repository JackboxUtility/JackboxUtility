import 'dart:math';

import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';

import '../user/userdata.dart';

class GamesService {
  static final GamesService _instance = GamesService._internal();

  factory GamesService() {
    return _instance;
  }

  List<UserJackboxGame> cachedGames = [];

  // Build internal
  GamesService._internal();

  UserJackboxGame chooseRandomGame(
      Function(UserJackboxPack, UserJackboxGame) filter) {
    List<UserJackboxGame> games = [];
    for (UserJackboxPack pack in UserData().packs) {
      for (UserJackboxGame game in pack.games) {
        if (filter(pack, game)) games.add(game);
      }
    }
    // Select random game
    if (games.isNotEmpty) {
      return games[Random().nextInt(games.length)];
    } else {
      throw Exception("No games found");
    }
  }

  UserJackboxGame? getUserJackboxGameById(String id) {
    for (UserJackboxPack pack in UserData().packs) {
      for (UserJackboxGame game in pack.games) {
        if (game.game.id == id) return game;
      }
    }
    return null;
  }
}
