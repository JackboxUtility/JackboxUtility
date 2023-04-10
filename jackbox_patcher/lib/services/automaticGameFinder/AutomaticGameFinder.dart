import 'dart:io';

import 'package:jackbox_patcher/model/jackboxpack.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:win32_registry/win32_registry.dart';

import '../../model/usermodel/userjackboxgame.dart';

class AutomaticGameFinderService {
  static Future<int> findGames(List<UserJackboxPack> packs) async {
    return await _findSteamGames(packs);
  }

  static Future<int> _findSteamGames(List<UserJackboxPack> packs) async {
    int numberGamesFound = 0;
    if (Platform.isWindows) {
      final steamLocation = _getSteamLocation();
      if (steamLocation != null) {
        Map<String, List<String>> steamFolderWithAppId =
            _getSteamFoldersWithAppId(steamLocation);
        numberGamesFound = await linkFolderWithPack(steamFolderWithAppId, packs);
      }
    }
    return numberGamesFound;
  }

  static String? _getSteamLocation() {
    final key = Registry.openPath(RegistryHive.localMachine,
        path: 'SOFTWARE\\WOW6432Node\\Valve\\Steam');
    final steamLocation = key.getValueAsString("InstallPath");
    return steamLocation;
  }

  static Map<String, List<String>> _getSteamFoldersWithAppId(
      String steamLocation) {
    Map<String, List<String>> folderWithApps = {};
    final file = File(steamLocation + "\\steamapps\\libraryfolders.vdf");
    final fileLines = file.readAsLinesSync();
    final pathLines = fileLines.where((element) => element.contains('"path"'));
    for (var line in pathLines) {
      List<String> thisFolderApps = fileLines
          .join("||")
          .split(line)[1]
          .split('"apps"')[1]
          .split("{")[1]
          .split("}")[0]
          .replaceAll("\t", "")
          .split('||')
          .where((element) => element.trim() != "")
          .map((e) => e.split('"')[1])
          .toList();
      folderWithApps[line.split('"')[3].replaceAll("\\\\", "\\")] =
          thisFolderApps;
      print(thisFolderApps);
    }
    return folderWithApps;
  }

  static _getSteamGamePathFromFolderAndAppId(String folder, String appId) {
    final file = File(folder + "\\steamapps\\appmanifest_" + appId + ".acf");
    final fileLines = file.readAsLinesSync();
    final pathLines =
        fileLines.where((element) => element.contains('"installdir"'));
    return folder + "\\steamapps\\common\\" + pathLines.first.split('"')[3];
  }

  static Future<int> linkFolderWithPack(
      Map<String, List<String>> steamFoldersWithAppId,
      List<UserJackboxPack> userPacks) async {
    int numberGamesFound = 0;
    for (UserJackboxPack userPack in userPacks) {
      print("userpack");
      if (userPack.pack.launchersId != null &&
          userPack.pack.launchersId!.steam != null) {
        print("Find one pack available on steam");
        for (var folder in steamFoldersWithAppId.keys) {
          if (steamFoldersWithAppId[folder]!
              .contains(userPack.pack.launchersId!.steam)) {
            numberGamesFound++;
            await userPack.setOwned(true);
            await userPack.setPath(_getSteamGamePathFromFolderAndAppId(
                folder, userPack.pack.launchersId!.steam!));
          }
        }
      }
    }
    return numberGamesFound;
  }
}
