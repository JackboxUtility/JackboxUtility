import 'package:dio/dio.dart';
import 'package:jackbox_patcher/model/jackbox/jackbox_pack_patch.dart';
import 'package:jackbox_patcher/model/user_model/interface/installable_patch.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game_patch.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';

import '../../services/downloader/downloader_service.dart';
import '../../services/user/user_data.dart';

class UserJackboxPackPatch extends InstallablePatch {
  final JackboxPackPatch patch;
  String? installedVersion;

  UserJackboxPackPatch({
    required this.patch,
    required this.installedVersion,
  });

  UserInstalledPatchStatus getInstalledStatus() {
    UserJackboxPack pack = getPack();
    String? packPath = pack.path;
    bool owned = pack.owned;
    if (patch.latestVersion != "" && packPath != null && packPath != "" && owned) {
      if (installedVersion != null && installedVersion != "") {
        if (installedVersion == patch.latestVersion) {
          return UserInstalledPatchStatus.INSTALLED;
        } else {
          if (installedVersion!.split("-").length > 1 &&
              installedVersion!.split("-")[1] == patch.latestVersion.split("-")[1]) {
            return UserInstalledPatchStatus.INSTALLED_OUTDATED;
          } else {
            return UserInstalledPatchStatus.NOT_INSTALLED;
          }
        }
      } else {
        return UserInstalledPatchStatus.NOT_INSTALLED;
      }
    } else {
      return UserInstalledPatchStatus.INEXISTANT;
    }
  }

  /// Overrided callback to call the main callback
  _downloadPatchCallbackMultiplePatches(void Function(String, String, double) callback, String title,
      String description, double progression, int currentPatch) {
    if (patch.patchPaths.length == 1) {
      callback(title, description, progression);
    } else {
      String titleText = "[${currentPatch + 1}/${patch.patchPaths.length}] $title";

      callback(titleText, description, (progression + currentPatch * 100) / patch.patchPaths.length);
    }
  }

  /// Download the patches
  ///
  /// [patchUri] is the location of the game,
  /// [callback] is the function to call when the download is progressing (title, description, progression),
  /// [cancelToken] is the token to cancel the download
  Future<void> downloadPatch(
      String patchUri, void Function(String, String, double) callback, CancelToken cancelToken) async {
    String patchUriWithOverride = patchUri;
    if (getPack().pack.resourceLocation != null) {
      patchUriWithOverride = "$patchUriWithOverride/${getPack().pack.resourceLocation!}";
    }

    int currentPatch = 0;

    for (String patchPath in patch.patchPaths) {
      await DownloaderService.downloadPatch(
          patchUriWithOverride,
          patchPath,
          (String t, String d, double p) => _downloadPatchCallbackMultiplePatches(callback, t, d, p, currentPatch),
          cancelToken);
      currentPatch++;
    }
    installedVersion = patch.latestVersion;
  }

  UserJackboxPack getPack() {
    List<UserJackboxPack> dataFound = UserData()
        .packs
        .where((pack) => pack.patches.where((element) => element.patch.id == patch.id).isNotEmpty)
        .toList();
    if (dataFound.length > 0) {
      return dataFound[0];
    } else {
      return UserData()
          .packs
          .firstWhere((pack) => pack.fixes.where((element) => element.patch.id == patch.id).isNotEmpty);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "patch": patch.toJson(),
      "installed_version": installedVersion,
    };
  }
}
