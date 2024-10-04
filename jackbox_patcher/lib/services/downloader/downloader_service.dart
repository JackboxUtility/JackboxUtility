import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jackbox_patcher/model/user_model/interface/installable_patch.dart';
import 'package:jackbox_patcher/services/logger/logger.dart';

import '../api_utility/api_service.dart';
import '../translations/translations_helper.dart';

class DownloaderService {
  static bool isDownloading = false;

  /// Fetches the patch file size
  static Future<int> getPatchSize(patchUrl) {
    return APIService().fetchFileSize(patchUrl);
  }

  /// Downloads a patch from [patchUrl] and extracts it to [uri]
  static Future<void> downloadPatch(
      InstallablePatch patch,
      String uri,
      String patchUrl,
      void Function(String, String, double?) callback,
      CancelToken cancelToken,
      bool resume) async {
    JULogger()
        .i("[DownloaderService] Downloading patch from $patchUrl to $uri");
    isDownloading = true;
    String filePath = "";
    try {
      callback(TranslationsHelper().appLocalizations!.downloading,
          TranslationsHelper().appLocalizations!.starting, null);
      filePath = await APIService().downloadPatch(patch, patchUrl,
          (double progress, double max) {
        callback(
            TranslationsHelper().appLocalizations!.downloading,
            "${(progress / (1000 * 1000)).toStringAsFixed(2)} MB / ${(max / (1000 * 1000)).toStringAsFixed(2)} MB",
            (progress / max) * 75);
      }, cancelToken, resume);
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) {
        JULogger().i("[DownloaderService] Patch download cancelled");
      } else {
        JULogger().e("[DownloaderService] Patch download failed: $e");
      }
      isDownloading = false;
      rethrow;
    } catch (e) {
      JULogger().e("[DownloaderService] Patch download failed: $e");
      isDownloading = false;
      rethrow;
    }
    try {
      JULogger()
          .i("[DownloaderService] Extracting patch from $filePath to $uri");
      callback(TranslationsHelper().appLocalizations!.extracting, "", 75);

      await extractFileToDisk(filePath, uri, callback);
      callback(TranslationsHelper().appLocalizations!.finalizing, "", 100);
    } catch (e) {
      JULogger().e("[DownloaderService] Patch extraction failed: $e");
      rethrow;
    } finally {
      isDownloading = false;
    }
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
    process.stderr.listen((data) {
      try {
        currentFiles += utf8.decode(data).split("\n").length - 1;
        callback(TranslationsHelper().appLocalizations!.extracting,
            "$currentFiles/$files", 75 + ((currentFiles / files) * 25));
      } catch (e) {
        JULogger().e("[DownloaderService] $e");
      }
    });
    await process.exitCode;
    return;
  }
}
