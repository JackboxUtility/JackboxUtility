import 'dart:convert';

import 'package:jackbox_patcher/model/user_model/user_jackbox_game.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';
import 'package:jackbox_patcher/services/internal_api/rest_api_scopes.dart';
import 'package:jackbox_patcher/services/internal_api/api_handlers/abstract_handler.dart';
import 'package:jackbox_patcher/services/launcher/launcher.dart';
import 'package:jackbox_patcher/services/user/user_data.dart';
import 'package:shelf/shelf.dart';

class OpenGameHandler extends AbstractHandler {
  OpenGameHandler()
      : super(
            url: "/games/open/<game>",
            method: RestApiMethods.POST,
            scopes: [RestApiScopes.GAME_OPEN_CLOSE]);

  @override
  Function get handle {
    return (Request req, String game) async {
      if (super.hasAccess(req) != null) {
        return hasAccess(req);
      }
      UserJackboxGame? gameFound = UserData().packs.getGameById(game);
      if (gameFound == null) {
        return Response.notFound(
            jsonEncode({"error": "Game not found", "status": "error"}));
      }
      await Launcher.launchGame(gameFound.getPack(), gameFound);
      return Response.ok(jsonEncode({"status": "ok"}));
    };
  }
}
