import 'package:archive/archive_io.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/jackboxpackpatch.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgamepatch.dart';
import 'package:jackbox_patcher/services/translations/translationsHelper.dart';

import '../../services/api/api_service.dart';
import '../../services/downloader/downloader_service.dart';
import '../../services/user/userdata.dart';
import '../jackboxgamepatch.dart';

class UserJackboxPackPatch {
  final JackboxPackPatch patch;
  String? installedVersion;

  UserJackboxPackPatch({
    required this.patch,
    required this.installedVersion,
  });

  UserInstalledPatchStatus getInstalledStatus(String? packPath) {
    if (patch.latestVersion != "" && packPath != null && packPath != "") {
      if (installedVersion != null && installedVersion != "") {
        if (installedVersion == patch.latestVersion) {
          return UserInstalledPatchStatus.INSTALLED;
        } else {
          return UserInstalledPatchStatus.INSTALLED_OUTDATED;
        }
      } else {
        return UserInstalledPatchStatus.NOT_INSTALLED;
      }
    } else {
      return UserInstalledPatchStatus.INEXISTANT;
    }
  }

  Future<void> downloadPatch(String patchUri,
      void Function(String, String, double) callback) async {
    await DownloaderService.downloadPatch(patchUri, patch.patchPath, callback);
    installedVersion = patch.latestVersion;
  }
}
