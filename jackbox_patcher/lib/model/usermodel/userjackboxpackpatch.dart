import 'package:archive/archive_io.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/jackboxpackpatch.dart';
import 'package:jackbox_patcher/services/translations/translationsHelper.dart';

import '../../services/api/api_service.dart';
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

  Future<void> downloadPatch(String patchUri, String gameUri,
      void Function(String, String, double) callback) async {
    try {
      
      //File(filePath).deleteSync(recursive: true);
    } on Exception catch (e) {
      callback(TranslationsHelper().appLocalizations!.unknown_error,
          TranslationsHelper().appLocalizations!.contact_error, 0);
      UserData().writeLogs(e.toString());
    }
  }
}

enum UserInstalledPatchStatus {
  INEXISTANT,
  NOT_INSTALLED,
  INSTALLED,
  INSTALLED_OUTDATED
}

extension UserInstalledPatchStatusExtension on UserInstalledPatchStatus {
  Color get color {
    switch (this) {
      case UserInstalledPatchStatus.INEXISTANT:
        return Colors.grey;
      case UserInstalledPatchStatus.NOT_INSTALLED:
        return Colors.red;
      case UserInstalledPatchStatus.INSTALLED:
        return Colors.green;
      case UserInstalledPatchStatus.INSTALLED_OUTDATED:
        return Colors.orange;
    }
  }

  String get info {
    switch (this) {
      case UserInstalledPatchStatus.INEXISTANT:
        return TranslationsHelper().appLocalizations!.game_patch_unavailable;
      case UserInstalledPatchStatus.NOT_INSTALLED:
        return TranslationsHelper().appLocalizations!.game_patch_available;
      case UserInstalledPatchStatus.INSTALLED:
        return TranslationsHelper().appLocalizations!.game_patch_installed;
      case UserInstalledPatchStatus.INSTALLED_OUTDATED:
        return TranslationsHelper().appLocalizations!.game_patch_outdated;
    }
  }
}
