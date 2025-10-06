import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/api_utility/api_service.dart';
import 'package:jackbox_patcher/model/user_model/interface/installable_patch.dart';
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
  double? progression;
  CancelToken cancelToken = CancelToken();
  bool downloadCancelled = false;
  String error = "Unknown error";

  DownloadPatchDialogState downloadingProgress =
      DownloadPatchDialogState.WAITING;
  int currentPatchDownloading = 0;

  @override
  void initState() {
    _startDownload(false);
    super.initState();
  }

  void _startDownload(bool resume) async {
    downloadingProgress = DownloadPatchDialogState.DOWNLOADING;
    setState(() {});
    if (Platform.isWindows) {
      WindowsTaskbar.setProgressMode(TaskbarProgressMode.indeterminate);
    }

    try {
      while (currentPatchDownloading < widget.patchs.length) {
        InstallablePatch patch = widget.patchs[currentPatchDownloading];
        if (!downloadCancelled) {
          await patch.downloadPatch(widget.localPaths[currentPatchDownloading],
              (stat, substat, progress) async {
            status = stat;
            substatus = substat;
            if (Platform.isWindows && progress != null) {
              if (progression == null ||
                  progression!.toInt() != progress.toInt()) {
                WindowsTaskbar.setProgress(
                    progress.ceil() + currentPatchDownloading * 100,
                    100 * widget.patchs.length);
              }
            }
            progression = progress;
            setState(() {});
          }, cancelToken, resume);
          currentPatchDownloading++;
        }
      }
      downloadingProgress = DownloadPatchDialogState.FINISH;
      setState(() {});
    } catch (e) {
      if (e is DioError && e.type == DioErrorType.cancel) {
        downloadCancelled = true;
      } else {
        print(e);
        downloadingProgress = DownloadPatchDialogState.ERROR;
        error = e.toString();
        setState(() {});
      }
    }
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
      String status, String substatus, double? progression) {
    InstallablePatch currentPatch = widget.patchs[currentPatchDownloading];
    String currentPatchName = currentPatch.getName();
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
                SizedBox(
                    height: 50,
                    width: 50,
                    child: Column(children: [
                      Expanded(
                          child: Stack(
                              alignment: Alignment.center,
                              fit: StackFit.expand,
                              children: [
                            ProgressRing(value: progression),
                            Center(
                                child: progression != null
                                    ? Text("${progression.round()}%",
                                        style: const TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center)
                                    : null)
                          ]))
                    ])),
                const SizedBox(height: 10),
                Text(currentPatchName, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                Text(status, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 2),
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
                  if (downloadCancelled == false) {
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
            _startDownload(true);
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
                const SizedBox(height: 20),
                SizedBox(
                    height: 200,
                    child: SingleChildScrollView(
                        child: SelectableText(error,
                            style: TextStyle(
                                fontSize: 16, color: Colors.red.normal)))),
              ]))),
    );
  }

  ContentDialog buildFinishDialog() {
    // Check server-side configuration to decide whether to show the thank-you button
    String? thankYouUrl = APIService()
            .cachedConfigurations
            ?.getConfiguration("DOWNLOAD", "THANK_YOU_URL");

    List<Widget> actions = [
      HyperlinkButton(
        onPressed: () {
          if (Platform.isWindows) {
            WindowsTaskbar.setProgressMode(TaskbarProgressMode.noProgress);
          }
          Navigator.pop(context);
        },
        child: Text(TranslationsHelper().appLocalizations!.close),
      ),
    ];

    if (thankYouUrl != null) {
      actions.insert(
          0,
          HyperlinkButton(
              onPressed: () async {
                try {
                  await launchUrl(Uri.parse(thankYouUrl!));
                } catch (e) {
                  // ignore launch errors
                }
              },
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Image.asset('assets/logos/kofi_symbol.png', height: 16),
                const SizedBox(width: 8),
                Text(TranslationsHelper().appLocalizations!.thank_the_team_button)
              ])));
    }

    return ContentDialog(
      actions: actions,
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
                if (showThankYou) ...[
                  const SizedBox(height: 12),
                  Text(TranslationsHelper().appLocalizations!.thank_the_team_description,
                      style: const TextStyle(fontSize: 14))
                ]
              ]))),
    );
  }
}
