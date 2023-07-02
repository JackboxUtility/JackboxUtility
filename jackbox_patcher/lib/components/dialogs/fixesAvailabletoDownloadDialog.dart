import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/fixes/gameFixAvailable.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpackpatch.dart';
import 'package:jackbox_patcher/services/translations/translationsHelper.dart';

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
      title: Text(TranslationsHelper().appLocalizations!.fixes_available),
      content: SizedBox(
        height:200,
        child: ListView(
          children: [
            Text(TranslationsHelper().appLocalizations!.fixes_available_description),
            SizedBox(height: 10),
            for (var fix in widget.fixesAvailable)
              GameFixAvailableComponent(fix: fix.fix)
          ],
        ),
      ),
      actions: [
        Button(
          child: Text(TranslationsHelper().appLocalizations!.yes),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        Button(
          child: Text(TranslationsHelper().appLocalizations!.no),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ],
    );
  }
}