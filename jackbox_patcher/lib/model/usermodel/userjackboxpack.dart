import 'dart:io';

import 'package:jackbox_patcher/model/jackboxpack.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';

import '../../services/launcher/launcher.dart';

class UserJackboxPack {
  final JackboxPack pack;
  final List<UserJackboxGame> games = [];
  UserJackboxLoader? loader;
  String? path;
  bool owned = false;

  UserJackboxPack({
    required this.pack,
    required this.loader,
    required this.path,
    required this.owned,
  });

  Directory? getPackFolder() {
    if (path == null || path == "") {
      return null;
    }
    return Directory(path!);
  }

  Future<String> getPathStatus() async {
    Directory? folder = getPackFolder();
    if (folder == null) {
      return "INEXISTANT";
    } else {
      if (await folder.exists()) {
          return "FOUND";
      } else {
        return  "NOT_FOUND";
      }
    }
  }

  Future<void> setPath(String p) async {
    this.path = p;
    await UserData().savePack(this);
  }

  Future<void> setOwned(bool o) async {
    this.owned = o;
    await UserData().savePack(this);
  }

  Future<void> launch() async {
    await Launcher.launchPack(this);
  }
}

class UserJackboxLoader {
  JackboxLoader? loader;

  /// The path to the loader on the device
  String? path;

  /// The version of the loader installed on the device
  String? version;

  UserJackboxLoader({
    required this.loader,
    required this.path,
    required this.version,
  });
}
