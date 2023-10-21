import 'package:jackbox_patcher/model/jackbox/jackboxgame.dart';
import 'package:jackbox_patcher/services/internal_api/RestApiScopes.dart';
import 'package:jackbox_patcher/services/internal_api/ws_message/AbstractWsMessage.dart';

class GameCloseWsMessage extends AbstractWsMessage {
  JackboxGame game;

  GameCloseWsMessage(this.game)
      : super("game_close", RestApiScopes.NAVIGATION);

  @override
  Map<String, dynamic> toJson() {
    var baseJson = super.toJson();
    baseJson["data"] = game.toJson();
    return baseJson;
  }
}
