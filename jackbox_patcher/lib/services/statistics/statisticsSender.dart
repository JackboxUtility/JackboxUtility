import 'package:jackbox_patcher/services/api_utility/api_service.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';

import '../../model/patchserver.dart';

class StatisticsSender {
  static Future<void> sendOpenApp() async{
    if (UserData().settings.isAnonymousDataActivated == false){
      return;
    }
    try {
      PatchServer selectedServer = APIService().cachedSelectedServer!;
      await APIService().sendAppOpenData(selectedServer.name, selectedServer.infoUrl);
    }catch(e){
    }
  }
}