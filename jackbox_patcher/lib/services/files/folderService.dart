import 'package:jackbox_patcher/model/enums/platforms.dart';

import 'package:path_provider/path_provider.dart';

class FolderService {
  String downloadPath = "";
  String logPath = "";

  static final FolderService _instance = FolderService._internal();

  factory FolderService() {
    return _instance;
  }

  FolderService._internal();

  Future<void> init() async{
    downloadPath = await getDownloadPath();
    logPath = await getLogPath();
  }

  Future<String> getDownloadPath() async {
    return (await getApplicationSupportDirectory()).path + "/Downloads";
  }

  Future<String> getLogPath() async {
    return (await getApplicationSupportDirectory()).path + "/Logs/log.txt";
  }
}
