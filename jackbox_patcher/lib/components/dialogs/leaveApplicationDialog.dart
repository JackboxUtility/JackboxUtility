import 'package:fluent_ui/fluent_ui.dart';

import '../../services/translations/translationsHelper.dart';

class LeaveApplicationDialog extends StatefulWidget {
  const LeaveApplicationDialog({Key? key}) : super(key: key);

  @override
  State<LeaveApplicationDialog> createState() => _LeaveApplicationDialogState();
}

class _LeaveApplicationDialogState extends State<LeaveApplicationDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
        title: Text(TranslationsHelper()
            .appLocalizations!
            .quit_while_downloading_title),
        content: Text(TranslationsHelper()
            .appLocalizations!
            .quit_while_downloading_description),
        actions: [
          HyperlinkButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(TranslationsHelper().appLocalizations!.cancel),
          ),
          HyperlinkButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(TranslationsHelper().appLocalizations!.quit),
          ),
        ]);
  }
}
