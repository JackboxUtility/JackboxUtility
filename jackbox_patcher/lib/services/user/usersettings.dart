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
}
