import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/user_model/interface/installable_patch.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';
import 'package:jackbox_patcher/services/downloader/downloader_service.dart';
import 'package:jackbox_patcher/services/translations/translations_helper.dart';

import '../../services/user/user_data.dart';
import '../jackbox/jackbox_game_patch.dart';

class UserJackboxGamePatch extends InstallablePatch{
  final JackboxGamePatch patch;
  String? installedVersion;

  UserJackboxGamePatch({
    required this.patch,
    required this.installedVersion,
  });

  UserInstalledPatchStatus getInstalledStatus() {
    String? packPath = getPack().path;
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

  UserJackboxPack getPack() {
    return UserData().packs.firstWhere((pack) => pack.games.where((game) => game.patches.where((p) => p.patch.id == patch.id).isNotEmpty).isNotEmpty);
  }

  UserJackboxGame getGame(){
    return getPack().games.firstWhere((game) => game.patches.where((p) => p.patch.id == patch.id).isNotEmpty);
  }

  Future<void> downloadPatch(String patchUri,
      void Function(String, String, double) callback, CancelToken cancelToken) async {
    String patchUriWithOverride = patchUri;
    if (getPack().pack.resourceLocation != null){
      patchUriWithOverride = "$patchUriWithOverride/${getPack().pack.resourceLocation!}";
    }
    await DownloaderService.downloadPatch(patchUriWithOverride, patch.patchPath!, callback, cancelToken);
    installedVersion = patch.latestVersion;
      await UserData().savePatch(this);
  }

  Future<void> removePatch() async {
    installedVersion = null;
    await UserData().savePatch(this);
  }

  Map<String, dynamic> toJson() {
    return {
      "patch": patch.toJson(),
      "installedVersion": installedVersion,
    };
  }
}

enum UserInstalledPatchStatus {
  INEXISTANT,
  INSTALLED_OUTDATED,
  NOT_INSTALLED,
  INSTALLED
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
