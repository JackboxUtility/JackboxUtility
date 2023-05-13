import 'dart:ui';

import 'package:jackbox_patcher/model/misc/windowInformation.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';
import 'package:window_manager/window_manager.dart';

class WindowManagerService {
  static void updateScreenSizeFromLastOpening() {
    WindowInformation lastWindowInformations =
        UserData().getLastWindowInformations();
    print(lastWindowInformations.x);
    print(lastWindowInformations.y);
    print(lastWindowInformations.width);
    print(lastWindowInformations.height);
    if (lastWindowInformations.x < 0){
      lastWindowInformations.x = 0;
    }
    if (lastWindowInformations.y < 0){
      lastWindowInformations.y = 0;
    }
    if (lastWindowInformations.width < 100){
      lastWindowInformations.width = 1280;
    }
    if (lastWindowInformations.height < 100){
      lastWindowInformations.height = 720;
    }
    print(lastWindowInformations.maximized);
    windowManager.setBounds(Rect.fromLTWH(
        lastWindowInformations.x.toDouble(),
        lastWindowInformations.y.toDouble(),
        lastWindowInformations.width.toDouble(),
        lastWindowInformations.height.toDouble()));
    if (lastWindowInformations.maximized) {
      windowManager.maximize();
    }
  }

  static Future<void> saveCurrentScreenSize() async {
    Size windowSize = await windowManager.getSize();
    Offset windowPosition = await windowManager.getPosition();
    WindowInformation windowInformation = WindowInformation(
        maximized: await windowManager.isMaximized(),
        width: windowSize.width.toInt(),
        height: windowSize.height.toInt(),
        x: windowPosition.dx.toInt(),
        y: windowPosition.dy.toInt());
    UserData().setLastWindowInformations(windowInformation);
    return Future.value();
  }
}
