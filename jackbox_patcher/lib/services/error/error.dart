import 'package:fluent_ui/fluent_ui.dart';

class ErrorService {
  static showError(BuildContext context, errorMessage) {
    displayInfoBar(context, builder: (context, close) {
      return InfoBar(isLong: true, severity: InfoBarSeverity.error, title: Text("Une erreur est survenue"), content: Text(errorMessage));
    }, duration: Duration(seconds: 10));
  }
}
