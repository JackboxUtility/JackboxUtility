import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/fixes/gameFixAvailable.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpackpatch.dart';

class FixesAvailableToDownloadDialog extends StatefulWidget {
  FixesAvailableToDownloadDialog({Key? key, required this.fixesAvailable}) : super(key: key);

  final List<({UserJackboxPackPatch fix, UserJackboxPack pack})> fixesAvailable;

  @override
  State<FixesAvailableToDownloadDialog> createState() => _FixesAvailableToDownloadDialogState();
}

class _FixesAvailableToDownloadDialogState extends State<FixesAvailableToDownloadDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text("Fixes available"),
      content: SizedBox(
        height:200,
        child: ListView(
          children: [
            Text("There are several fixes available to download for your games. Do you want to download them now?"),
            SizedBox(height: 10),
            for (var fix in widget.fixesAvailable)
              GameFixAvailableComponent(fix: fix.fix)
          ],
        ),
      ),
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