import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/jackboxgame.dart';

import '../../services/api/api_service.dart';

class UserJackboxGame {
  final JackboxGame game;
  final String? installedVersion;

  UserJackboxGame({
    required this.game,
    required this.installedVersion,
  });

  UserInstalledPatchStatus getInstalledStatus(String? packPath) {
    if (packPath != null && packPath != "") {
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

  Future<void> downloadPatch() async {
    await APIService().downloadPatch(game);
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
        return "Chemin du jeu introuvable";
      case UserInstalledPatchStatus.NOT_INSTALLED:
        return "Un patch est disponible";
      case UserInstalledPatchStatus.INSTALLED:
        return "Ce jeu est à jour";
      case UserInstalledPatchStatus.INSTALLED_OUTDATED:
        return "Une mise à jour du patch est disponible";
    }
  }
}
