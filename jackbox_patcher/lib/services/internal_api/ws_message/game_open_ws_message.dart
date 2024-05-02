import 'package:jackbox_patcher/model/jackbox/jackbox_game.dart';
import 'package:jackbox_patcher/services/internal_api/rest_api_scopes.dart';
import 'package:jackbox_patcher/services/internal_api/ws_message/abstract_ws_message.dart';

class GameOpenWsMessage extends AbstractWsMessage {
  JackboxGame game;

  GameOpenWsMessage(this.game)
      : super("game_open", RestApiScopes.NAVIGATION);

  @override
  Map<String, dynamic> toJson() {
    var baseJson = super.toJson();
    baseJson["data"] = game.toJson();
    return baseJson;
  }
}
