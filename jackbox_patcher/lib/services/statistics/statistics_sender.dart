import 'package:jackbox_patcher/services/api_utility/api_service.dart';
import 'package:jackbox_patcher/services/user/user_data.dart';

import '../../model/patch_server.dart';

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