import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';

import '../../components/dialogs/tipDialog.dart';

enum TipAvailable {
  LAUNCHER_ON_STARTUP
}

class Tip {
  TipAvailable id;
  String title;
  String description;
  List<TipAnswer> answers = [];
  Function(TipAnswer) onTipAnswer;
  int _tryActivating = 0;
  bool Function(Tip, int) shouldActivate;

  Tip(
      {required this.id,
      required this.title,
      required this.description,
      required this.onTipAnswer,
      required this.answers,
      required this.shouldActivate}){
        _tryActivating = UserData().tips.loadTipTryActivating(this);
      }
  
  int get tryActivating => _tryActivating;

  void activate(context){
    _tryActivating++;
    UserData().tips.saveTipTryActivating(this, _tryActivating);
    if (this.shouldActivate(this, _tryActivating)) {
      showDialog(context: context, builder: (context) => TipDialog(tip: this));
    }
  }
}

enum TipAnswer {
  YES,
  NO,
  OK;

  String get name {
    switch (this) {
      case TipAnswer.YES:
        return "Yes";
      case TipAnswer.NO:
        return "No";
      case TipAnswer.OK:
        return "Ok";
    }
  }
}
