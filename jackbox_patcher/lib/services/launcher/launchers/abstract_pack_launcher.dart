import 'package:jackbox_patcher/model/jackbox/jackbox_game.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';

abstract class AbstractPackLauncher {
  bool willHandleRequest(UserJackboxPack userPack);
  Future<void> launch(UserJackboxPack userPack, {JackboxGame? game = null});
}
