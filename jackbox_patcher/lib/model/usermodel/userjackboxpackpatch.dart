import 'package:dio/dio.dart';
import 'package:jackbox_patcher/model/jackbox/jackboxpackpatch.dart';
import 'package:jackbox_patcher/model/usermodel/interface/InstallablePatch.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgamepatch.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';

import '../../services/downloader/downloader_service.dart';
import '../../services/user/userdata.dart';

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
    if (patch.latestVersion != "" &&
        packPath != null &&
        packPath != "" &&
        owned) {
      if (installedVersion != null && installedVersion != "") {
        if (installedVersion == patch.latestVersion) {
          return UserInstalledPatchStatus.INSTALLED;
        } else {
          if (installedVersion!.split("-").length > 1 &&
              installedVersion!.split("-")[1] ==
                  patch.latestVersion.split("-")[1]) {
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

  Future<void> downloadPatch(
      String patchUri, void Function(String, String, double) callback, CancelToken cancelToken) async {
    String patchUriWithOverride = patchUri;
    if (getPack().pack.resourceLocation != null){
      patchUriWithOverride = "$patchUriWithOverride/${getPack().pack.resourceLocation!}";
    }
    await DownloaderService.downloadPatch(patchUriWithOverride, patch.patchPath, callback, cancelToken);
    installedVersion = patch.latestVersion;
  }

  UserJackboxPack getPack() {
    List<UserJackboxPack> dataFound = UserData()
        .packs
        .where((pack) => pack.patches
            .where((element) => element.patch.id == patch.id)
            .isNotEmpty)
        .toList();
    if (dataFound.length > 0) {
      return dataFound[0];
    } else {
      return UserData().packs.firstWhere((pack) => pack.fixes
          .where((element) => element.patch.id == patch.id)
          .isNotEmpty);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "patch": patch.toJson(),
      "installed_version": installedVersion,
    };
  }
}
