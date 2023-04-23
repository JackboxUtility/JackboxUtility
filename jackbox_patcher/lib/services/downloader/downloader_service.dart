import 'package:archive/archive_io.dart';

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
            (progress / max) * 90);
      });
      callback("${TranslationsHelper().appLocalizations!.extracting}", "",
          95);
      await extractFileToDisk(filePath, uri, asyncWrite: true);
      callback(TranslationsHelper().appLocalizations!.finalizing + "", "",
          100);
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
}
