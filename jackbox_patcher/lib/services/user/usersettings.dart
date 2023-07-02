import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../discord/DiscordService.dart';

class UserSettings {
  final SharedPreferences preferences;

  UserSettings({required this.preferences});

  bool get isDiscordRPCActivated => preferences.getBool("discord_rpc") ?? true;

  Future<void> setDiscordRPC(bool activation ) async{
    await preferences.setBool("discord_rpc", activation);
    activation ? DiscordService().init() : DiscordService().stopRichPresence();
  }

  bool get isOpenLauncherOnStartupActivated =>
      preferences.getBool("open_launcher_on_startup") ?? false;
    
  Future<void> setOpenLauncherOnStartup(bool activation) async {
    await preferences.setBool("open_launcher_on_startup", activation);
  }

  bool get isAudioActivated => preferences.getBool("audio") ?? (APIService().cachedConfigurations!.getConfiguration("SETTINGS", "AUDIO_ENABLE_BY_DEFAULT")??false); 

  Future<void> setAudio(bool activation) async {
    await preferences.setBool("audio", activation);
  }
}
