import 'dart:io';

import 'package:dart_discord_rpc/dart_discord_rpc_native.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:jackbox_patcher/app_configuration.dart';
import 'package:jackbox_patcher/main.dart';
import 'package:media_kit/media_kit.dart';
import 'package:window_manager/window_manager.dart';

import 'services/logger/logger.dart';

void initRetrievingErrors(){
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
      JULogger()
          .e(details.toString(), details.exception.toString(), details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
     bool ifIsOverflowError =
        error.toString().contains("A RenderFlex overflowed by");

    if (!ifIsOverflowError) JULogger().e(error.toString(), "", stack);
    return true;
  };
}

void main() async {
  FlavorConfig(name: "RELEASE", color: Colors.orange, variables: {
    "masterServerUrl":MAIN_SERVER_URL["RELEASE_SERVER_URL"]
  });

  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (!Platform.isLinux) MediaKit.ensureInitialized();
  DiscordRPC.initialize();
  
  initRetrievingErrors();
  runApp(const MyApp());
}
