import 'package:archive/archive_io.dart';

import '../api/api_service.dart';
import '../translations/translationsHelper.dart';
import '../user/userdata.dart';

class DownloaderService {
  /// Downloads a patch from [patchUrl] and extracts it to [uri]
  static Future<void> downloadPatch(String uri, String patchUrl,
      void Function(String, String, double) callback) async {
    print("Starting download : " + patchUrl);
    try {
      callback("${TranslationsHelper().appLocalizations!.downloading} (1/3)",
          TranslationsHelper().appLocalizations!.starting, 0);
      String filePath = await APIService().downloadPatch(patchUrl,
          (double progress, double max) {
        callback(
            "${TranslationsHelper().appLocalizations!.downloading} (1/3)",
            "${(progress / 1000000).toInt()} MB /${(max / 1000000).toInt()} MB",
            (progress / max) * 100);
      });
      callback("${TranslationsHelper().appLocalizations!.extracting} (2/3)", "",
          100);
      await extractFileToDisk(filePath, uri, asyncWrite: false);
      callback(TranslationsHelper().appLocalizations!.finalizing + " (3/3)", "",
          100);
      //File(filePath).deleteSync(recursive: true);
    } on Exception catch (e) {
      callback(TranslationsHelper().appLocalizations!.unknown_error,
          TranslationsHelper().appLocalizations!.contact_error, 0);
      UserData().writeLogs(e.toString());
      rethrow;
    }
  }
}
