import 'dart:async';

import 'package:jackbox_patcher/services/api_utility/api_service.dart';
import 'package:jackbox_patcher/services/user/initialLoad.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';

class AutomaticReload {
  static startAutomaticReload() {
    Timer.periodic(Duration(seconds: 30), (timer) async {
      if (APIService().cachedSelectedServer != null) {
        await APIService().recoverNewsAndLinks();
        await UserData().syncPacks((double percent) {});
        await APIService().recoverCustomComponent();
      }
    });
  }
}
