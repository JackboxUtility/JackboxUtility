import 'package:fluent_ui/fluent_ui.dart';

class FixesAvailableToDownloadDialog extends StatefulWidget {
  FixesAvailableToDownloadDialog({Key? key}) : super(key: key);

  @override
  State<FixesAvailableToDownloadDialog> createState() => _FixesAvailableToDownloadDialogState();
}

class _FixesAvailableToDownloadDialogState extends State<FixesAvailableToDownloadDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text("Fixes available to download"),
      content: Text("There are fixes available to download for this game. Do you want to download them now?"),
      actions: [
        Button(
          child: Text("Yes"),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        Button(
          child: Text("No"),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ],
    );
  }
}