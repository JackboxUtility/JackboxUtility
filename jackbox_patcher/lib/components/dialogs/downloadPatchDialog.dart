import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:windows_taskbar/windows_taskbar.dart';

import '../../services/error/error.dart';

class DownloadPatchDialogComponent extends StatefulWidget {
  DownloadPatchDialogComponent(
      {Key? key, required this.localPath, required this.patch})
      : super(key: key);

  final String localPath;
  final dynamic patch;

  @override
  State<DownloadPatchDialogComponent> createState() =>
      _DownloadPatchDialogComponentState();
}

class _DownloadPatchDialogComponentState
    extends State<DownloadPatchDialogComponent> {
  String status = "";
  String substatus = "";
  double progression = 0;

  int downloadingProgress = 0;
  @override
  Widget build(BuildContext context) {
    return downloadingProgress == 0
        ? ContentDialog(
            title: Text(AppLocalizations.of(context)!.installing_a_patch),
            content: Text(
                AppLocalizations.of(context)!.installing_a_patch_description),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              TextButton(
                onPressed: () async {
                  downloadingProgress = 1;
                  setState(() {});
                  widget.patch.downloadPatch(widget.localPath,
                      (stat, substat, progress) async {
                    status = stat;
                    substatus = substat;
                    if (progression.toInt() != progress.toInt()) {
                      WindowsTaskbar.setProgress(progress.toInt(), 100);
                    }
                    progression = progress;
                    setState(() {});
                  }).then((_) {
                    downloadingProgress = 2;
                    setState(() {});
                  }).catchError((error) {
                    InfoBarService.showError(context, error);
                    Navigator.pop(context);
                  });
                },
                child: Text(AppLocalizations.of(context)!.page_continue),
              ),
            ],
          )
        : (downloadingProgress == 1
            ? buildDownloadingPatchDialog(status, substatus, progression)
            : buildFinishDialog());
  }

  ContentDialog buildDownloadingPatchDialog(
      String status, String substatus, double progression) {
    return ContentDialog(
      title: Text(AppLocalizations.of(context)!.installing_a_patch),
      content: SizedBox(
          height: 200,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                ProgressRing(value: progression),
                SizedBox(height: 10),
                Text(status, style: TextStyle(fontSize: 20)),
                Text(substatus, style: TextStyle(fontSize: 16)),
              ]))),
    );
  }

  ContentDialog buildFinishDialog() {
    return ContentDialog(
      actions: [
        TextButton(
          onPressed: () {
            WindowsTaskbar.setProgressMode(TaskbarProgressMode.noProgress);
            Navigator.pop(context);
            downloadingProgress = 0;
            setState(() {});
          },
          child: Text(AppLocalizations.of(context)!.close),
        ),
      ],
      title: Text(AppLocalizations.of(context)!.installing_a_patch),
      content: SizedBox(
          height: 200,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Icon(FluentIcons.check_mark),
                SizedBox(height: 10),
                Text(AppLocalizations.of(context)!.installing_a_patch_end,
                    style: TextStyle(fontSize: 20)),
                Text(AppLocalizations.of(context)!.can_close_popup,
                    style: TextStyle(fontSize: 16)),
              ]))),
    );
  }
}
