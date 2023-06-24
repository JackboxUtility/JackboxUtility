import 'package:dart_discord_rpc/dart_discord_rpc_native.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:jackbox_patcher/main.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  FlavorConfig(name: "BETA", color: Colors.orange, location: BannerLocation.topEnd, variables: {
    "masterServerUrl":
        'https://raw.githubusercontent.com/AlexisL61/JackboxUtility/dev/servers.json'
  });

  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  DiscordRPC.initialize();
  runApp(FlavorBanner(color: Colors.orange, child: const MyApp()));
}
