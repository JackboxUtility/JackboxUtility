import 'dart:ui';

import 'package:jackbox_patcher/model/misc/windowInformation.dart';
import 'package:jackbox_patcher/services/logger/logger.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';
import 'package:window_manager/window_manager.dart';

class WindowManagerService {
  static Future<void> updateScreenSizeFromLastOpening() async {
    try {
      JULogger().d("Updating screen size from last opening");
      WindowInformation lastWindowInformations =
          UserData().getLastWindowInformations();
      if (lastWindowInformations.x < 0) {
        lastWindowInformations.x = 0;
      }
      if (lastWindowInformations.y < 0) {
        lastWindowInformations.y = 0;
      }
      if (lastWindowInformations.width < 100) {
        lastWindowInformations.width = 1300;
      }
      if (lastWindowInformations.height < 100) {
        lastWindowInformations.height = 750;
      }
      Future.delayed(Duration(milliseconds: 100), () async {
        if (lastWindowInformations.maximized) {
          await windowManager.maximize();
        } else {
          await windowManager.setBounds(Rect.fromLTWH(
              lastWindowInformations.x.toDouble(),
              lastWindowInformations.y.toDouble(),
              lastWindowInformations.width.toDouble(),
              lastWindowInformations.height.toDouble()));
        }
      });
    } catch (e) {
      JULogger().e(e.toString());
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
  }
}
