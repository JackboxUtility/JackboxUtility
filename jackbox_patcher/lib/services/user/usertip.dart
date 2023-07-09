import 'package:jackbox_patcher/services/translations/translationsHelper.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/misc/tip.dart';

class UserTips {
  final SharedPreferences preferences;

  final List<Tip> availableTips = [];

  UserTips({required this.preferences});

  void init() {
    availableTips.clear();
    availableTips.add(Tip(
        id: TipAvailable.LAUNCHER_ON_STARTUP,
        title: TranslationsHelper().appLocalizations!.open_launcher_on_startup_title_tip,
        description:
            TranslationsHelper().appLocalizations!.open_launcher_on_startup_description_tip,
        answers: [TipAnswer.NO,TipAnswer.YES],
        onTipAnswer: (answer) {
          if (answer == TipAnswer.YES) {
            UserData().settings.setOpenLauncherOnStartup(true);
          }
        },
        shouldActivate: (tip, int tipTry) {
          if (tipTry == 2 &&
              UserData().settings.isOpenLauncherOnStartupActivated == false) {
            return true;
          }
          return false;
        }));
  }

  Tip getTip(TipAvailable id) {
    return availableTips.firstWhere((element) => element.id == id);
  }

  int loadTipTryActivating(Tip tip) {
    int tipTry = preferences.getInt("tip_" + tip.id.toString() + "_try") ?? 0;
    return tipTry;
  }

  void saveTipTryActivating(Tip tip, int tipTry) {
    preferences.setInt("tip_" + tip.id.toString() + "_try", tipTry);
  }
}
