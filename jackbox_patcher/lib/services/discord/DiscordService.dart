import 'package:dart_discord_rpc/dart_discord_rpc.dart';
import 'package:jackbox_patcher/services/logger/logger.dart';

class DiscordService {
  static final DiscordService _instance = DiscordService._internal();
  DiscordRPC? rpc;
  factory DiscordService() {
    return _instance;
  }

  // Build internal
  DiscordService._internal();

  void init() {
    rpc = DiscordRPC(applicationId: "1112049780777037855");
    rpc!.start(autoRegister: true);
    launchMenuPresence();
  }

  void updatePresence(String details, String state, String largeImageKey,
      String largeImageText, String smallImageKey, String smallImageText) {
    if (rpc != null) {
      rpc!.updatePresence(DiscordPresence(
        details: details,
        state: state,
        largeImageKey: largeImageKey,
        largeImageText: largeImageText,
        smallImageKey: smallImageKey,
        smallImageText: smallImageText,
      ));
    }
  }

  void launchMenuPresence() {
    updatePresence("Just started the application", "In the menu",
        "jackboxutility", "Jackbox Utility", "", "");
  }

  void launchGameMenuPresence() {
    updatePresence("Choosing a game", "In the game list", "jackboxutility",
        "Jackbox Utility", "play", "Choosing a game");
  }

  void launchGameInfoPresence(String gameName) {
    updatePresence("Reading the information of a game", gameName,
        "jackboxutility", "Jackbox Utility", "play", "Choosing a game");
  }

  void launchPatchingPresence() {
    updatePresence("Patching a game", "In the patch list", "jackboxutility",
        "Jackbox Utility", "downloading", "Patching a game");
  }

  void launchSettingsPresence() {
    updatePresence("Tweaking the app", "In the settings", "jackboxutility",
        "Jackbox Utility", "settings", "Tweaking the app");
  }

  void stopRichPresence() {
    rpc!.clearPresence();
    rpc!.shutDown();
  }
}
