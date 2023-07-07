import 'dart:io';

import 'package:dart_discord_rpc/dart_discord_rpc_native.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:jackbox_patcher/main.dart';
import 'package:media_kit/media_kit.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  FlavorConfig(name: "RELEASE", color: Colors.orange, variables: {
    "masterServerUrl":
        'https://raw.githubusercontent.com/AlexisL61/JackboxUtility/main/servers.json'
  });

  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (!Platform.isLinux)
    MediaKit.ensureInitialized();
  DiscordRPC.initialize();
  runApp(const MyApp());
}
