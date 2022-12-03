import 'dart:io';

import 'package:jackbox_patcher/model/jackboxpack.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';

class UserJackboxPack {
  final JackboxPack pack;
  final List<UserJackboxGame> games = [];
  String? path;

  UserJackboxPack({
    required this.pack,
    required this.path,
  });

  Directory? getPackFolder(){
    if (path == null || path == ""){
      return null;
    }
    return Directory(path!);
  }

  Future<void> setPath(String p) async{
    this.path = p;
    await UserData().savePack(this);
  } 
}
