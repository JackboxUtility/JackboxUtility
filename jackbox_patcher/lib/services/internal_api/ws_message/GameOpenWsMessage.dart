import 'package:jackbox_patcher/model/jackbox/jackboxgame.dart';
import 'package:jackbox_patcher/services/internal_api/Scopes.dart';
import 'package:jackbox_patcher/services/internal_api/ws_message/AbstractWsMessage.dart';

class GamePageOpenWsMessage extends AbstractWsMessage {
  JackboxGame game;

  GamePageOpenWsMessage(this.game)
      : super("game_page_open", RestApiScopes.GAMES);

  @override
  Map<String, dynamic> toJson() {
    var baseJson = super.toJson();
    baseJson["data"] = game.toJson();
    return baseJson;
  }
}
