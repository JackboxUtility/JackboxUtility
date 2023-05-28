import 'package:fluent_ui/fluent_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ResetPackDialog extends StatefulWidget {
  ResetPackDialog({Key? key, required this.appId}) : super(key: key);

  final String appId;

  @override
  State<ResetPackDialog> createState() => _ResetPackDialogState();
}

class _ResetPackDialogState extends State<ResetPackDialog> {
  @override
  Widget build(BuildContext context) {
    return ContentDialog(
        title: SizedBox(
            width: double.maxFinite,
            child: Column(children: [
              LottieBuilder.asset("assets/lotties/TriviaMurder.json",
                  width: 100, height: 100, fit: BoxFit.fitWidth),
              Text(
                AppLocalizations.of(context)!.game_reset,
                textAlign: TextAlign.center,
              )
            ])),
        content: Text(
            AppLocalizations.of(context)!.game_reset_description),
        actions: [
          HyperlinkButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          HyperlinkButton(
            onPressed: () async {
              launchUrl(Uri.parse(
                  "steam://validate/${widget.appId}"));
              Navigator.pop(context, true);
            },
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ]);
  }
}
