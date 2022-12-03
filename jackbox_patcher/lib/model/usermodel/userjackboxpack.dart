import 'package:jackbox_patcher/model/jackboxpack.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';

class UserJackboxPack {
  final JackboxPack pack;
  final List<UserJackboxGame> games = [];
  String? path;

  UserJackboxPack({
    required this.pack,
    required this.path,
  });
}
