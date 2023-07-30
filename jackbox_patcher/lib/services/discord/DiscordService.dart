import 'package:dart_discord_rpc/dart_discord_rpc.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/services/translations/translationsHelper.dart';

class DiscordService {
  static final DiscordService _instance = DiscordService._internal();
  DiscordRPC? rpc;
  DiscordPresence oldPresence = DiscordPresence();
  DiscordPresence currentPresence = DiscordPresence();
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

  void updatePresence(String? details, String? state, String? largeImageKey,
      String? largeImageText, String? smallImageKey, String? smallImageText) {
    if (rpc != null) {
      if (currentPresence.details != details ||
          currentPresence.state != state ||
          currentPresence.largeImageKey != largeImageKey ||
          currentPresence.largeImageText != largeImageText ||
          currentPresence.smallImageKey != smallImageKey ||
          currentPresence.smallImageText != smallImageText) {
        oldPresence = currentPresence;
        currentPresence = DiscordPresence(
          details: details,
          state: state,
          largeImageKey: largeImageKey,
          largeImageText: largeImageText,
          smallImageKey: smallImageKey,
          smallImageText: smallImageText,
        );
      }
      rpc!.updatePresence(currentPresence);
    }
  }

  void launchMenuPresence() {
    updatePresence(
        TranslationsHelper()
            .appLocalizations!
            .rich_presence_application_start_details,
        TranslationsHelper()
            .appLocalizations!
            .rich_presence_application_start_state,
        "jackboxutility",
        TranslationsHelper().appLocalizations!.jackbox_utility,
        "",
        "");
  }

  void launchGameMenuPresence() {
    updatePresence(
        TranslationsHelper().appLocalizations!.rich_presence_game_menu_details,
        TranslationsHelper().appLocalizations!.rich_presence_game_menu_state,
        "jackboxutility",
        TranslationsHelper().appLocalizations!.jackbox_utility,
        "play",
        TranslationsHelper().appLocalizations!.rich_presence_game_menu_details);
  }

  void launchGameInfoPresence(String gameName) {
    updatePresence(
        TranslationsHelper()
            .appLocalizations!
            .rich_presence_game_information_details,
        gameName,
        "jackboxutility",
        TranslationsHelper().appLocalizations!.jackbox_utility,
        "play",
        TranslationsHelper()
            .appLocalizations!
            .rich_presence_game_information_state);
  }

  void launchPatchingPresence() {
    updatePresence(
        TranslationsHelper().appLocalizations!.rich_presence_patcher_details,
        TranslationsHelper().appLocalizations!.rich_presence_patcher_state,
        "jackboxutility",
        TranslationsHelper().appLocalizations!.jackbox_utility,
        "downloading",
        TranslationsHelper().appLocalizations!.rich_presence_patcher_details);
  }

  void launchSettingsPresence() {
    updatePresence(
        TranslationsHelper().appLocalizations!.rich_presence_settings_details,
        TranslationsHelper().appLocalizations!.rich_presence_settings_state,
        "jackboxutility",
        TranslationsHelper().appLocalizations!.jackbox_utility,
        "settings",
        TranslationsHelper().appLocalizations!.rich_presence_settings_details);
  }

  void launchPackLaunchedPresence(UserJackboxPack pack) {
    updatePresence(
        TranslationsHelper().appLocalizations!.rich_presence_in_game_details,
        pack.pack.name,
        pack.pack.id,
        pack.pack.name,
        "play",
        TranslationsHelper().appLocalizations!.rich_presence_in_game_details);
  }

  void launchOldPresence(){
    updatePresence(oldPresence.details, oldPresence.state, oldPresence.largeImageKey, oldPresence.largeImageText, oldPresence.smallImageKey, oldPresence.smallImageText);
  }

  void stopRichPresence() {
    rpc!.clearPresence();
    rpc!.shutDown();
  }
}
