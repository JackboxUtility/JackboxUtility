import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/user_model/interface/installable_patch.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game_patch.dart';
import 'package:windows_taskbar/windows_taskbar.dart';

import '../../services/translations/translations_helper.dart';

enum DownloadPatchDialogState {
  WAITING,
  DOWNLOADING,
  ERROR,
  FINISH,
}

class DownloadPatchDialogComponent extends StatefulWidget {
  const DownloadPatchDialogComponent(
      {Key? key, required this.localPaths, required this.patchs})
      : super(key: key);

  final List<String> localPaths;
  final List<InstallablePatch> patchs;

  @override
  State<DownloadPatchDialogComponent> createState() =>
      _DownloadPatchDialogComponentState();
}

class _DownloadPatchDialogComponentState
    extends State<DownloadPatchDialogComponent> {
  String status = "";
  String substatus = "";
  double progression = 0;
  CancelToken cancelToken = CancelToken();
  bool downloadCancelled = false;
  String error = "Unknown error";

  DownloadPatchDialogState downloadingProgress =
      DownloadPatchDialogState.WAITING;
  int currentPatchDownloading = 0;

  @override
  void initState() {
    _startDownload();
    super.initState();
  }

  void _startDownload() async {
    downloadingProgress = DownloadPatchDialogState.DOWNLOADING;
    setState(() {});

    try {
      for (var patch in widget.patchs) {
        if (!downloadCancelled) {
          await patch.downloadPatch(widget.localPaths[currentPatchDownloading],
              (stat, substat, progress) async {
            status = stat;
            substatus = substat;
            if (progression.toInt() != progress.toInt()) {
              if (Platform.isWindows) {
                WindowsTaskbar.setProgress(
                    progress.toInt() + (currentPatchDownloading) * 100,
                    100 * widget.patchs.length);
              }
            }
            progression = progress;
            setState(() {});
          }, cancelToken);
          currentPatchDownloading++;
        }
      }
    } catch (e) {
      print(e);
      downloadingProgress = DownloadPatchDialogState.ERROR;
      error = e.toString();
      setState(() {});
      rethrow;
    }
    downloadingProgress = DownloadPatchDialogState.FINISH;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return switch (downloadingProgress) {
      DownloadPatchDialogState.WAITING => buildWaitingPatchDialog(),
      DownloadPatchDialogState.DOWNLOADING =>
        buildDownloadingPatchDialog(status, substatus, progression),
      DownloadPatchDialogState.ERROR => buildErrorPatchDialog(),
      DownloadPatchDialogState.FINISH => buildFinishDialog()
    };
  }

  ContentDialog buildWaitingPatchDialog() {
    return ContentDialog(
      title: Text(TranslationsHelper().appLocalizations!.installing_a_patch),
      content: Text(TranslationsHelper()
          .appLocalizations!
          .installing_a_patch_description),
      actions: [
        HyperlinkButton(
          onPressed: () => Navigator.pop(context),
          child: Text(TranslationsHelper().appLocalizations!.cancel),
        ),
        HyperlinkButton(
          onPressed: () async {},
          child: Text(TranslationsHelper().appLocalizations!.page_continue),
        ),
      ],
    );
  }

  ContentDialog buildDownloadingPatchDialog(
      String status, String substatus, double progression) {
    InstallablePatch currentPatch = widget.patchs[currentPatchDownloading];
    String currentPatchName = currentPatch is UserJackboxGamePatch
        ? (currentPatch as UserJackboxGamePatch).getGame().game.name
        : currentPatch.getPack().pack.name;
    if (widget.patchs.length > 1) {
      currentPatchName =
          "[${currentPatchDownloading + 1}/${widget.patchs.length}] $currentPatchName";
    }
    return ContentDialog(
      title: Text(TranslationsHelper().appLocalizations!.installing_a_patch),
      content: SizedBox(
          height: 200,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                ProgressRing(value: progression),
                const SizedBox(height: 10),
                Text(currentPatchName, style: const TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text(status, style: const TextStyle(fontSize: 20)),
                SizedBox(height: 2),
                Text(substatus, style: const TextStyle(fontSize: 16)),
              ]))),
      actions: progression == 0 ||
              status != TranslationsHelper().appLocalizations!.extracting
          ? [
              HyperlinkButton(
                onPressed: () {
                  if (Platform.isWindows) {
                    WindowsTaskbar.setProgressMode(
                        TaskbarProgressMode.noProgress);
                  }
                  if (progression != 0) {
                    cancelToken.cancel();
                    downloadCancelled = true;
                  }
                  Navigator.pop(context);
                },
                child: Text(TranslationsHelper().appLocalizations!.cancel),
              ),
            ]
          : null,
    );
  }

  ContentDialog buildErrorPatchDialog() {
    return ContentDialog(
      actions: [
        HyperlinkButton(
          onPressed: () {
            if (Platform.isWindows) {
              WindowsTaskbar.setProgressMode(TaskbarProgressMode.noProgress);
            }
            Navigator.pop(context);
          },
          child: Text(TranslationsHelper().appLocalizations!.close),
        ),
        HyperlinkButton(
          onPressed: () {
            if (Platform.isWindows) {
              WindowsTaskbar.setProgressMode(TaskbarProgressMode.noProgress);
            }
            _startDownload();
          },
          child: Text(TranslationsHelper().appLocalizations!.loading_try_again),
        ),
      ],
      title: Text(TranslationsHelper().appLocalizations!.installing_a_patch),
      content: SizedBox(
          height: 400,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                const Icon(FluentIcons.error),
                const SizedBox(height: 20),
                Text(TranslationsHelper().appLocalizations!.download_error,
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                Text(
                    TranslationsHelper()
                        .appLocalizations!
                        .download_error_description,
                    style: const TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                SizedBox(
                    height: 200,
                    child: SingleChildScrollView(
                        child: SelectableText(error,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.red.normal)))),
              ]))),
    );
  }

  ContentDialog buildFinishDialog() {
    return ContentDialog(
      actions: [
        HyperlinkButton(
          onPressed: () {
            if (Platform.isWindows) {
              WindowsTaskbar.setProgressMode(TaskbarProgressMode.noProgress);
            }
            Navigator.pop(context);
          },
          child: Text(TranslationsHelper().appLocalizations!.close),
        ),
      ],
      title: Text(TranslationsHelper().appLocalizations!.installing_a_patch),
      content: SizedBox(
          height: 200,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                const Icon(FluentIcons.check_mark),
                const SizedBox(height: 10),
                Text(
                    TranslationsHelper()
                        .appLocalizations!
                        .installing_a_patch_end,
                    style: const TextStyle(fontSize: 20)),
                Text(TranslationsHelper().appLocalizations!.can_close_popup,
                    style: const TextStyle(fontSize: 16)),
              ]))),
    );
  }
}
