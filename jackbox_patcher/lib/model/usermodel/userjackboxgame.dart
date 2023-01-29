import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/jackboxgame.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpatch.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';

import '../../services/api/api_service.dart';

class UserJackboxGame {
  final JackboxGame game;
  final List<UserJackboxPatch> patches = [];
  final UserJackboxLoader? loader;

  UserJackboxGame({
    required this.game,
    required this.loader,
  });
}


