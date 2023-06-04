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
      bool showUnownedGames, bool showHiddenGames) {
    List<UserJackboxGame> games = [];
    for (UserJackboxPack pack in UserData().packs) {
      for (UserJackboxGame game in pack.games) {
        if (game.hidden && !showHiddenGames) {
          continue;
        }
        if (!game.getUserJackboxPack().owned && !showUnownedGames) {
          continue;
        }
        games.add(game);
      }
    }
    // Select random game
    if (games.isNotEmpty) {
      return games[Random().nextInt(games.length)];
    } else {
      throw Exception("No games found");
    }
  }
}
