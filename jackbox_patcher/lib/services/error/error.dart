import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfoBarService {
  static showError(BuildContext context, String errorMessage,
      {Duration duration = const Duration(seconds: 10)}) {
    displayInfoBar(context, builder: (context, close) {
      return InfoBar(
          isLong: true,
          severity: InfoBarSeverity.error,
          title: Text(AppLocalizations.of(context)!.error_happened),
          content: Text(errorMessage));
    }, duration: duration);
  }

  static showInfo(BuildContext context, String title, String content,
      {Duration duration = const Duration(seconds: 10)}) {
    displayInfoBar(context, builder: (context, close) {
      return InfoBar(
          isLong: true,
          severity: InfoBarSeverity.info,
          title: Text(title),
          content: Text(content));
    }, duration: duration);
  }
}
