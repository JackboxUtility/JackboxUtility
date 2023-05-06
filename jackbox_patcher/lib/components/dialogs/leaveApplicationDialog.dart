import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LeaveApplicationDialog extends StatefulWidget {
  LeaveApplicationDialog({Key? key}) : super(key: key);

  @override
  State<LeaveApplicationDialog> createState() => _LeaveApplicationDialogState();
}

class _LeaveApplicationDialogState extends State<LeaveApplicationDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
        title: Text(AppLocalizations.of(context)!.quit_while_downloading_title),
        content: Text(
            AppLocalizations.of(context)!.quit_while_downloading_description),
        actions: [
          HyperlinkButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          HyperlinkButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.quit),
          ),
        ]);
  }
}
