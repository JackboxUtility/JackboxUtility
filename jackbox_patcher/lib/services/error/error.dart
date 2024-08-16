import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/mvvm/observer.dart';

import '../translations/translations_helper.dart';

class InfoBarService {
  static showError(BuildContext context, String errorMessage,
      {Duration duration = const Duration(seconds: 10)}) {
    displayInfoBar(context, builder: (context, close) {
      return InfoBar(
          isLong: true,
          severity: InfoBarSeverity.error,
          title: Text(TranslationsHelper().appLocalizations!.error_happened),
          content: Text(errorMessage));
    }, duration: duration);
  }

  static showInfo(BuildContext context, String title, String content,
      {Duration duration = const Duration(seconds: 10)}) {
    displayInfoBar(context, builder: (context, close) {
      return
        Container(
          child: InfoBar(
          style: InfoBarThemeData(
            decoration: (severity) {
              return BoxDecoration(
                  color: FluentTheme.of(context)
                      .inactiveBackgroundColor
                      .withOpacity(1),
                  borderRadius: BorderRadius.circular(4));
            },
          ),
          isLong: true,
          severity: InfoBarSeverity.info,
          title: Text(title),
          content: Text(content)));
    }, duration: duration);
  }
}

class InfoBarEvent extends ViewEvent {
  final String message;

  InfoBarEvent(this.message) : super('');
}
