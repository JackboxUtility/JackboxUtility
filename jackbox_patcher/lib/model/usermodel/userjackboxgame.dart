import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/jackboxgame.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';

import '../../services/api/api_service.dart';

class UserJackboxGame {
  final JackboxGame game;
  String? installedVersion;

  UserJackboxGame({
    required this.game,
    required this.installedVersion,
  });

  UserInstalledPatchStatus getInstalledStatus(String? packPath) {
    if (game.latestVersion != "" && packPath != null && packPath != "") {
      if (installedVersion != null && installedVersion != "") {
        if (installedVersion == game.latestVersion) {
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

  Future<void> downloadPatch(
      String gameUri, void Function(String, String, double) callback) async {
    try {
      callback("Téléchargement (1/3)", "Démarrage", 0);
      String filePath =
          await APIService().downloadPatch(game, (double progress, double max) {
        callback(
            "Téléchargement (1/3)",
            (progress / 1000000).toString() +
                " MB /" +
                (max / 1000000).toString() +
                " MB",
            (progress / max) * 100);
      });
      callback("Extraction (2/3)", "", 100);
      await extractFileToDisk(filePath, gameUri + "/" + game.path!,
          asyncWrite: false);
      callback("Finalisation (3/3)", "", 100);
      installedVersion = game.latestVersion;
      await UserData().saveGame(this);
      //File(filePath).deleteSync(recursive: true);
    } on Exception catch (e) {
      callback("Erreur iconnue", "Contactez Alexis#1588 sur Discord", 0);
      UserData().writeLogs(e.toString());
    }
  }

  Future<void> removePatch() async {
    installedVersion = null;
    await UserData().saveGame(this);
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
        return "Aucune traduction disponible";
      case UserInstalledPatchStatus.NOT_INSTALLED:
        return "Un patch est disponible";
      case UserInstalledPatchStatus.INSTALLED:
        return "Ce jeu est à jour";
      case UserInstalledPatchStatus.INSTALLED_OUTDATED:
        return "Une mise à jour du patch est disponible";
    }
  }
}
