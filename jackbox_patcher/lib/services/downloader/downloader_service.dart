import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jackbox_patcher/services/logger/logger.dart';

import '../api/api_service.dart';
import '../translations/translationsHelper.dart';

class DownloaderService {
  static bool isDownloading = false;

  /// Downloads a patch from [patchUrl] and extracts it to [uri]
  static Future<void> downloadPatch(String uri, String patchUrl,
      void Function(String, String, double) callback, CancelToken cancelToken) async {
    JULogger().i("Downloading patch from $patchUrl to $uri");
    isDownloading = true;
    String filePath = "";
    try {
      callback(TranslationsHelper().appLocalizations!.downloading,
          TranslationsHelper().appLocalizations!.starting, 0);
      filePath = await APIService().downloadPatch(patchUrl,
          (double progress, double max) {
        callback(
            TranslationsHelper().appLocalizations!.downloading,
            "${progress ~/ 1000000} MB / ${max ~/ 1000000} MB",
            (progress / max) * 75);
      }, cancelToken);
    } catch (e) {
      callback(TranslationsHelper().appLocalizations!.download_error,
          TranslationsHelper().appLocalizations!.download_error_description, 0);
      JULogger().e(e);
      isDownloading = false;
      rethrow;
    }
    try {
      JULogger().i("Extracting patch from $filePath to $uri");
      callback(TranslationsHelper().appLocalizations!.extracting, "", 75);

      await extractFileToDisk(filePath, uri, callback);
      callback(TranslationsHelper().appLocalizations!.finalizing, "", 100);
    } catch (e) {
      
      callback(
          TranslationsHelper().appLocalizations!.extracting_error,
          TranslationsHelper().appLocalizations!.extracting_error_description,
          0);
      JULogger().e(e);
      isDownloading = false;
      rethrow;
    }
    isDownloading = false;
    //File(filePath).deleteSync(recursive: true);
  }

  /// Extracts a file from [filePath] to [uri]
  static Future<void> extractFileToDisk(
      filePath, uri, void Function(String, String, double) callback) async {
    if (Platform.isWindows) {
      await extractFileToDiskWindows(filePath, uri, callback);
    } else {
      await extractFileToDiskUnix(filePath, uri, callback);
    }
  }

  /// Extracts a file from [filePath] to [uri] on Linux
  static Future<void> extractFileToDiskUnix(
      filePath, uri, void Function(String, String, double) callback) async {
    ProcessResult listProcess = await Process.run("unzip", ["-l", filePath]);
    int files = 0;
    files = listProcess.stdout.split("\n").length;
    listProcess.exitCode;
    Process process = await Process.start("unzip", ["-o", filePath, "-d", uri]);
    int currentFiles = 0;
    process.stdout.listen((data) {
      print(data);
      currentFiles += utf8.decode(data).split("\n").length - 1;
      callback(TranslationsHelper().appLocalizations!.extracting,
          "$currentFiles/$files", 75 + ((currentFiles / files) * 25));
    });
    await process.exitCode;
    return;
  }

  /// Extracts a file from [filePath] to [uri] on Windows
  static Future<void> extractFileToDiskWindows(
      filePath, uri, void Function(String, String, double) callback) async {
    ProcessResult listProcess = await Process.run("tar", ["-tf", "$filePath"]);
    int files = 0;
    files = listProcess.stdout.split("\n").length;
    listProcess.exitCode;
    Process process =
        await Process.start("tar", ["-xf", '$filePath', "-C", '$uri', "-v"]);
    int currentFiles = 0;
    process.stdout.listen((data) {});
    process.stderr.listen((data) {
      currentFiles += utf8.decode(data).split("\n").length - 1;
      callback(TranslationsHelper().appLocalizations!.extracting,
          "$currentFiles/$files", 75 + ((currentFiles / files) * 25));
    });
    await process.exitCode;
    return;
  }
}
