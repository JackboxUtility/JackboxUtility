import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';

abstract class AbstractPackLauncher {
  bool willHandleRequest(UserJackboxPack userPack);
  Future<void> launch(UserJackboxPack userPack);
}
