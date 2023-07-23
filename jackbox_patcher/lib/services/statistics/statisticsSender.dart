import 'package:jackbox_patcher/services/api/api_service.dart';

import '../../model/patchserver.dart';

class StatisticsSender {
  static Future<void> sendOpenApp() async{
    try {
      PatchServer selectedServer = APIService().cachedSelectedServer!;
      await APIService().sendAppOpenData(selectedServer.name, selectedServer.infoUrl);
    }catch(e){
    }
  }
}