import 'package:jackbox_patcher/model/jackboxgame.dart';

class UserJackboxGame {
  final JackboxGame game;
  final bool installed;
  final String installedVersion;

  UserJackboxGame({
    required this.game,
    required this.installed,
    required this.installedVersion,
  });


}