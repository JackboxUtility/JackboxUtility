import 'dart:convert';
import 'dart:io';

import '../api/api_service.dart';
import '../translations/translationsHelper.dart';
import '../user/userdata.dart';

class DownloaderService {
  static bool isDownloading = false;

  /// Downloads a patch from [patchUrl] and extracts it to [uri]
  static Future<void> downloadPatch(String uri, String patchUrl,
      void Function(String, String, double) callback) async {
    try {
      isDownloading = true;
      callback("${TranslationsHelper().appLocalizations!.downloading}",
          TranslationsHelper().appLocalizations!.starting, 0);
      String filePath = await APIService().downloadPatch(patchUrl,
          (double progress, double max) {
        callback(
            "${TranslationsHelper().appLocalizations!.downloading}",
            "${(progress / 1000000).toInt()} MB / ${(max / 1000000).toInt()} MB",
            (progress / max) * 75);
      });
      callback("${TranslationsHelper().appLocalizations!.extracting}", "", 75);

      await extractFileToDisk(filePath, uri, callback);
      callback(TranslationsHelper().appLocalizations!.finalizing + "", "", 100);
      isDownloading = false;
      //File(filePath).deleteSync(recursive: true);
    } on Exception catch (e) {
      callback(TranslationsHelper().appLocalizations!.unknown_error,
          TranslationsHelper().appLocalizations!.contact_error, 0);
      UserData().writeLogs(e.toString());
      isDownloading = false;
      rethrow;
    }
  }

  static Future<void> extractFileToDisk(
      filePath, uri, void Function(String, String, double) callback) async {
    if (Platform.isWindows) {
      await extractFileToDiskWindows(filePath, uri, callback);
    } else {
      await extractFileToDiskUnix(filePath, uri, callback);
    }
  }

  static Future<void> extractFileToDiskUnix(
      filePath, uri, void Function(String, String, double) callback) async {
    ProcessResult listProcess = await Process.run("unzip", ["-l", filePath]);
    int files = 0;
    files = listProcess.stdout.split("\n").length;
    await listProcess.exitCode;
    Process process = await Process.start("unzip", ["-o", filePath, "-d", uri]);
    int currentFiles = 0;
    process.stdout.listen((data) {
      print(data);
      currentFiles += utf8.decode(data).split("\n").length - 1;
      callback("${TranslationsHelper().appLocalizations!.extracting}",
          "${currentFiles}/${files}", 75 + ((currentFiles / files) * 25));
    });
    await process.exitCode;
    return;
  }

  static Future<void> extractFileToDiskWindows(
      filePath, uri, void Function(String, String, double) callback) async {
    ProcessResult listProcess = await Process.run("tar", ["-tf", "$filePath"]);
    int files = 0;
    files = listProcess.stdout.split("\n").length;
    await listProcess.exitCode;
    Process process =
        await Process.start("tar", ["-xf", '$filePath', "-C", '$uri', "-v"]);
    int currentFiles = 0;
    process.stdout.listen((data) {});
    process.stderr.listen((data) {
      currentFiles += utf8.decode(data).split("\n").length - 1;
      callback("${TranslationsHelper().appLocalizations!.extracting}",
          "${currentFiles}/${files}", 75 + ((currentFiles / files) * 25));
    });
    await process.exitCode;
    return;
  }
}
