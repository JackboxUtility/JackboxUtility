import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:win32_registry/win32_registry.dart';
import 'package:crc32_checksum/crc32_checksum.dart';

class SteamService {
  static final NUL = String.fromCharCodes([0]);
  static final SOH = String.fromCharCodes([1]);
  static final STX = String.fromCharCodes([2]);
  static final BS = String.fromCharCodes([8]);

  static addAsNonSteamGame() {
    String? steamLocation = _getSteamLocation();
    if (steamLocation != null) {
      final userFiles = Directory(steamLocation + "/userdata");
      final userFolders = userFiles.listSync();
      for (var userFolder in userFolders) {
        if (userFolder is Directory) {
          final userShorctuts = File(userFolder.path + "/config/shortcuts.vdf");
          if (!userShorctuts.existsSync()) {
            userShorctuts.createSync();
          }
          List<String> fileContents = userShorctuts.readAsLinesSync(
              encoding: Utf8Codec(allowMalformed: true));
          String fileContent = fileContents.join("");
          if (!fileContent.contains("shortcuts")) {
            fileContent = buildDefaultShortcutFile();
          }
          final finalContentFile = addJackboxUtility(fileContent);
        }
      }
    }
  }

  static String buildDefaultShortcutFile() {
    return NUL + "shortcuts" + NUL + BS;
  }

  static String addJackboxUtility(String fileContent) {
    // Going before the last BS to add the steam game
    final lastBSIndex = fileContent.lastIndexOf(BS);
    final beforeLastBS = fileContent.substring(0, lastBSIndex);
    final afterLastBS = fileContent.substring(lastBSIndex);
    // Retrieve the latest game number
    int latestAdeddGame = retrievingLatestAddedGameNumber(fileContent);
    // Add the game
    final newGame = buildJackboxUtilityGame(latestAdeddGame, beforeLastBS);
    return '';
  }

  static int retrievingLatestAddedGameNumber(String fileContent) {
    // We must find the greatest x formatted like NUL + x + NUL
    final xRegex = RegExp(r"\x00[0-9]+\x00");
    final xMatches = xRegex.allMatches(fileContent);
    final xMatchesStrings = xMatches.map((e) => e.group(0)).toList();
    final xMatchesInts =
        xMatchesStrings.map((e) => int.parse(e!.replaceAll(NUL, ""))).toList();
    print(xMatchesInts);
    if (xMatchesInts.isEmpty) {
      return -1;
    }
    final lastX = xMatchesInts
        .reduce((value, element) => value > element ? value : element);
    return lastX;
  }

  static void buildJackboxUtilityGame(int latestAdeddGame, String content) {
    final newGame = NUL + (latestAdeddGame + 1).toString() + NUL;
    String appIdNotTransformed = [
      "\"C:\\Users\\alexi\\Documents\\JackboxUtility_Windows\\JackboxUtility.exe\"",
      "JackboxUtility"
    ].join("");
    var data = Crc32.calculate(utf8.encode(appIdNotTransformed), 0x04C11DB7) |
        0x80000000;
    var full_64 = (data << 32) | 0x02000000;
    print(data);
    print(full_64);
  }

  static String? _getSteamLocation() {
    try {
      if (Platform.isWindows) {
        final key = Registry.openPath(RegistryHive.localMachine,
            path: 'SOFTWARE\\WOW6432Node\\Valve\\Steam');
        final steamLocation = key.getValueAsString("InstallPath");
        return steamLocation;
      } else {
        return Platform.environment["HOME"]! + "/.steam/steam";
      }
    } catch (e) {
      return null;
    }
  }
}
