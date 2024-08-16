import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/services/translations/translations_helper.dart';

class PatchAvailableDialog extends StatefulWidget {
  const PatchAvailableDialog({super.key});

  @override
  State<PatchAvailableDialog> createState() => _PatchAvailableDialogState();
}

class _PatchAvailableDialogState extends State<PatchAvailableDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(TranslationsHelper().appLocalizations!.patch_missing_before_launching_title),
      content: Text(TranslationsHelper().appLocalizations!.patch_missing_before_launching_description),
      actions: [
        HyperlinkButton(
          child: Text(TranslationsHelper().appLocalizations!.patch_missing_before_launching_install),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        HyperlinkButton(
          child: Text(TranslationsHelper().appLocalizations!.patch_missing_before_launching_launch),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ],
    );
  }
}
