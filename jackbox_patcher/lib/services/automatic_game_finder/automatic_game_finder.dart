import 'dart:convert';
import 'dart:io';

import 'package:jackbox_patcher/app_configuration.dart';
import 'package:jackbox_patcher/model/misc/launchers.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';
import 'package:jackbox_patcher/services/logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:win32_registry/win32_registry.dart';

/// This service is used to automatically find games installed on the user's computer
class AutomaticGameFinderService {
  /// This function will find games installed on the user's computer and link them to the packs
  static Future<int> findGames(List<UserJackboxPack> packs) async {
    for (UserJackboxPack pack in packs) {
      if (pack.origin == LauncherType.STEAM || pack.origin == LauncherType.EPIC) {
        pack.origin = null;
        await pack.setOwned(false);
      }
    }
    try {
      int gameFound = 0;
      try {
        gameFound += await _findSteamGames(packs);
      } catch (e) {
        JULogger().e("[AutomaticGameFinderService] $e");
      }
      try {
        gameFound += await _findEpicGamesGames(packs);
      } catch (e) {
        JULogger().e("[AutomaticGameFinderService] $e");
      }
      return gameFound;
    } catch (e) {
      JULogger().e("[AutomaticGameFinderService] $e");
      rethrow;
    }
  }

  static Future<int> findGamesInFolderRelative(List<UserJackboxPack> packs, String rootPath) async {
    final root = Directory(rootPath);
    if (!await root.exists()) {
      return 0;
    }

    final Map<String, List<UserJackboxPack>> packsByExecutable = {};
    for (final pack in packs) {
      final executable = pack.pack.executable;
      if (executable == null || executable.trim().isEmpty) continue;
      final executableName = _fileName(executable).toLowerCase();
      packsByExecutable.putIfAbsent(executableName, () => <UserJackboxPack>[]).add(pack);
    }

    final Set<String> foundPackIds = {};
    var numberGamesFound = 0;

    await for (final entity in root.list(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      final fileName = _fileName(entity.path).toLowerCase();
      final matchingPacks = packsByExecutable[fileName];
      if (matchingPacks == null || matchingPacks.isEmpty) continue;

      final gameFolderPath = entity.parent.path;
      for (final pack in matchingPacks) {
        if (foundPackIds.contains(pack.pack.id)) continue;
        foundPackIds.add(pack.pack.id);
        numberGamesFound++;
        await pack.setOwned(true);
        await pack.setPath(gameFolderPath, forceRelativeStorage: true);
        await pack.setLauncher(LauncherType.UNKNOWN);
      }
    }

    return numberGamesFound;
  }

  static String _fileName(String path) {
    final parts = path.split(RegExp(r'[\\/]'));
    return parts.isEmpty ? path : parts.last;
  }

  static Future<int> _findSteamGames(List<UserJackboxPack> packs) async {
    JULogger().i("[AutomaticGameFinderService] Looking for Steam games");
    int numberGamesFound = 0;
    String? steamLocation = await _getSteamLocation();
    JULogger().i("[AutomaticGameFinderService] Steam location: $steamLocation");
    if (steamLocation != null) {
      Map<String, List<String>> steamFolderWithAppId = _getSteamFoldersWithAppId(steamLocation);
      JULogger().i("[AutomaticGameFinderService] Steam folders: $steamFolderWithAppId");
      numberGamesFound = await _linkSteamFolderWithPack(steamFolderWithAppId, packs);
      JULogger().i("[AutomaticGameFinderService] Steam games found: $numberGamesFound");
    }
    return numberGamesFound;
  }

  static Future<int> _findEpicGamesGames(List<UserJackboxPack> packs) async {
    int numberGamesFound = 0;
    String? epicLocation = await _getEpicLocation();
    if (epicLocation != null) {
      List<dynamic> epicApps = await _getEpicInstalledApps(epicLocation);
      numberGamesFound = await _linkEpicAppsWithPacks(epicApps, packs);
    }
    return numberGamesFound;
  }

  static Future<String?> _getSteamLocation() async {
    switch (Platform.operatingSystem) {
      case "windows":
        return _getSteamLocationWindows();
      case "macos":
        return _getSteamLocationMacos();
      case "linux":
        return _getSteamLocationLinux();
      default:
        return null;
    }
  }

  static Future<String?> _getSteamLocationMacos() async {
    try {
      final appSupportDir = await getApplicationSupportDirectory();
      return "${appSupportDir.parent.path}/Steam";
    } catch (e) {
      JULogger().e("[AutomaticGameFinderService] $e");
    }
    JULogger().i(
        "[AutomaticGameFinderService] Failed to get Steam location from Application Support directory. Trying HOME environment variable...");
    if (Platform.environment.containsKey("HOME")) {
      return "${Platform.environment["HOME"]}/Library/Application Support/Steam";
    }
    return null;
  }

  static Future<String?> _getSteamLocationWindows() async {
    try {
      final key = Registry.openPath(RegistryHive.localMachine, path: 'SOFTWARE\\WOW6432Node\\Valve\\Steam');
      final steamLocation = key.getValueAsString("InstallPath");
      return steamLocation;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> _getSteamLocationLinux() async {
    for (String location in STEAM_LINUX_LOCATIONS) {
      if (await Directory("${Platform.environment["HOME"]!}$location").exists()) {
        return "${Platform.environment["HOME"]!}$location";
      }
    }
    return null;
  }

  static Map<String, List<String>> _getSteamFoldersWithAppId(String steamLocation) {
    Map<String, List<String>> folderWithApps = {};
    File file;
    if (Platform.isWindows) {
      file = File("$steamLocation\\steamapps\\libraryfolders.vdf");
    } else {
      file = File("$steamLocation/steamapps/libraryfolders.vdf");
    }
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
      folderWithApps[line.split('"')[3].replaceAll("\\\\", "\\")] = thisFolderApps;
    }
    return folderWithApps;
  }

  static String _getSteamGamePathFromFolderAndAppId(String folder, String appId) {
    final file =
        File("$folder" + Platform.pathSeparator + "steamapps" + Platform.pathSeparator + "appmanifest_$appId.acf");
    final fileLines = file.readAsLinesSync();
    final pathLines = fileLines.where((element) => element.contains('"installdir"'));
    return "$folder" +
        Platform.pathSeparator +
        "steamapps" +
        Platform.pathSeparator +
        "common" +
        Platform.pathSeparator +
        "${pathLines.first.split('"')[3]}";
  }

  static Future<int> _linkSteamFolderWithPack(
      Map<String, List<String>> steamFoldersWithAppId, List<UserJackboxPack> userPacks) async {
    int numberGamesFound = 0;
    for (UserJackboxPack userPack in userPacks) {
      if (userPack.pack.launchersId != null && userPack.pack.launchersId!.steam != null) {
        for (var folder in steamFoldersWithAppId.keys) {
          if (await File("$folder" +
                  Platform.pathSeparator +
                  "steamapps" +
                  Platform.pathSeparator +
                  "appmanifest_${userPack.pack.launchersId!.steam!}.acf")
              .exists()) {
            numberGamesFound++;
            await userPack.setOwned(true);
            await userPack.setPath(_getSteamGamePathFromFolderAndAppId(folder, userPack.pack.launchersId!.steam!));
            await userPack.setLauncher(LauncherType.STEAM);
          }
        }
      }
    }
    return numberGamesFound;
  }

  static Future<String?> _getEpicLocation() async {
    switch (Platform.operatingSystem) {
      case "windows":
        return _getEpicLocationWindows();
      case "macos":
        return _getEpicLocationMacos();
      default:
        return null;
    }
  }

  static Future<String?> _getEpicLocationWindows() async {
    try {
      final key =
          Registry.openPath(RegistryHive.localMachine, path: 'SOFTWARE\\WOW6432Node\\Epic Games\\EpicGamesLauncher');
      final epicLocation = key.getValueAsString("AppDataPath");
      return epicLocation;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> _getEpicLocationMacos() async {
    try {
      final appSupportDir = await getApplicationSupportDirectory();
      return "${appSupportDir.parent.path}/Epic";
    } catch (e) {
      JULogger().e("[AutomaticGameFinderService] $e");
    }
    JULogger().i(
        "[AutomaticGameFinderService] Failed to get Epic location from Application Support directory. Trying HOME environment variable...");
    if (Platform.environment.containsKey("HOME")) {
      return "${Platform.environment["HOME"]}/Library/Application Support/Epic";
    }
    return null;
  }

  static Future<List<dynamic>> _getEpicInstalledApps(String epicLocation) async {
    File file;
    if (Platform.isWindows) {
      file = File("$epicLocation\\..\\..\\UnrealEngineLauncher\\LauncherInstalled.dat");
    } else {
      file = File("$epicLocation/UnrealEngineLauncher/LauncherInstalled.dat");
    }
    String fileData = await file.readAsString();
    List<dynamic> installationList = jsonDecode(fileData)["InstallationList"] as List<dynamic>;
    return installationList;
  }

  static Future<int> _linkEpicAppsWithPacks(List<dynamic> apps, List<UserJackboxPack> packs) async {
    int numberGamesFound = 0;
    for (UserJackboxPack userPack in packs) {
      if (userPack.pack.launchersId != null && userPack.pack.launchersId!.epic != null) {
        for (var app in apps) {
          if (app["AppName"] == userPack.pack.launchersId!.epic) {
            numberGamesFound++;
            await userPack.setOwned(true);
            await userPack.setPath(app["InstallLocation"]!);
            await userPack.setLauncher(LauncherType.EPIC);
          }
        }
      }
    }
    return numberGamesFound;
  }

  static Future<LauncherType> detectLauncherFromPath(UserJackboxPack userPack) async {
    // Check steam
    String? steamLocation = await _getSteamLocation();
    if (steamLocation != null) {
      Map<String, List<String>> steamFolderWithAppId = _getSteamFoldersWithAppId(steamLocation);
      for (String folder in steamFolderWithAppId.keys) {
        if (userPack.pack.launchersId != null && userPack.pack.launchersId!.steam != null) {
          for (var folder in steamFolderWithAppId.keys) {
            if (await File("$folder" +
                    Platform.pathSeparator +
                    "steamapps" +
                    Platform.pathSeparator +
                    "appmanifest_${userPack.pack.launchersId!.steam!}.acf")
                .exists()) {
              if (userPack.pack.launchersId?.steam != null) {
                String steamFolder = _getSteamGamePathFromFolderAndAppId(folder, userPack.pack.launchersId!.steam!);
                if (steamFolder == userPack.path) {
                  return LauncherType.STEAM;
                }
              }
            }
          }
        }
      }
    }

    // Check epic
    String? epicLocation = await _getEpicLocation();
    if (epicLocation != null) {
      List<dynamic> epicApps = await _getEpicInstalledApps(epicLocation);
      for (var app in epicApps) {
        if (userPack.pack.launchersId != null && userPack.pack.launchersId!.epic != null) {
          if (app["AppName"] == userPack.pack.launchersId!.epic && app["InstallLocation"]! == userPack.path) {
            return LauncherType.EPIC;
          }
        }
      }
    }
    return LauncherType.UNKNOWN;
  }
}
