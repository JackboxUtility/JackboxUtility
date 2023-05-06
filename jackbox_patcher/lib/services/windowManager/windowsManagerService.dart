import 'dart:ui';

import 'package:jackbox_patcher/model/misc/windowInformation.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';
import 'package:window_manager/window_manager.dart';

class WindowManagerService {
  static void updateScreenSizeFromLastOpening() {
    WindowInformation lastWindowInformations =
        UserData().getLastWindowInformations();
    windowManager.setBounds(Rect.fromLTWH(
        lastWindowInformations.x.toDouble(),
        lastWindowInformations.y.toDouble(),
        lastWindowInformations.width.toDouble(),
        lastWindowInformations.height.toDouble()));
    if (lastWindowInformations.maximized) {
      windowManager.maximize();
    }
  }

  static Future<void> saveCurrentScreenSize() async{
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
