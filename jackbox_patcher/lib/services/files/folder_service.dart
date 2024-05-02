import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FolderService {
  String downloadPath = "";
  String logPath = "";

  static final FolderService _instance = FolderService._internal();

  factory FolderService() {
    return _instance;
  }

  FolderService._internal();

  Future<void> init() async {
    await initFolders();
    downloadPath = await getDownloadPath();
    logPath = await getLogPath();
  }

  Future<void> initFolders() async {
    List<String> pathToCreate = [
      "/Downloads",
      "/Logs",
    ];
    Directory directory = await getApplicationSupportDirectory();
    if (!await Directory(directory.path).exists()) {
      await Directory(directory.path).create();
    }
    for (String path in pathToCreate) {
      if (!await Directory(directory.path + path).exists()) {
        await Directory(directory.path + path).create();
      }
    }
    if (!await File(directory.path + "/Logs/log.txt").exists()){
      await File(directory.path + "/Logs/log.txt").create();
    }
  }

  Future<String> getDownloadPath() async {
    return (await getApplicationSupportDirectory()).path + "/Downloads";
  }

  Future<String> getLogPath() async {
    return (await getApplicationSupportDirectory()).path + "/Logs/log.txt";
  }
}
