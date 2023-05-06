import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/services/automaticGameFinder/AutomaticGameFinder.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AutomaticGameFinderDialog extends StatefulWidget {
  AutomaticGameFinderDialog({Key? key}) : super(key: key);

  @override
  State<AutomaticGameFinderDialog> createState() =>
      _AutomaticGameFinderDialogState();
}

class _AutomaticGameFinderDialogState extends State<AutomaticGameFinderDialog> {
  int visibleDialog = 0;
  int gamesFound = 0;

  @override
  Widget build(BuildContext context) {
    return visibleDialog == 0
        ? ContentDialog(
            style: ContentDialogThemeData(
                titlePadding:
                    EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 16),
                padding:
                    EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16)),
            title: SizedBox(
                width: double.maxFinite,
                child: Column(children: [
                  LottieBuilder.asset(
                      "assets/lotties/AutomaticGameFinding.json",
                      width: 150,
                      height: 150,
                      fit: BoxFit.fitWidth),
                  Text(
                    AppLocalizations.of(context)!.automatic_game_finder_title,
                    textAlign: TextAlign.center,
                  )
                ])),
            content: Text(AppLocalizations.of(context)!
                .automatic_game_finder_description),
            actions: [
                HyperlinkButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                HyperlinkButton(
                  onPressed: () async {
                    setState(() {
                      visibleDialog = 1;
                    });
                    int foundGames = await AutomaticGameFinderService.findGames(
                        UserData().packs);
                    setState(() {
                      visibleDialog = 2;
                      gamesFound = foundGames;
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.confirm),
                ),
              ])
        : visibleDialog == 1
            ? inProgressDialog()
            : finishDialog();
  }

  ContentDialog inProgressDialog() {
    return ContentDialog(
        title: Text(AppLocalizations.of(context)!.automatic_game_finder_title),
        content: SizedBox(
            height: 50,
            child: Column(children: [
              Text(AppLocalizations.of(context)!
                  .automatic_game_finder_in_progress),
            ])),
        actions: []);
  }

  ContentDialog finishDialog() {
    return ContentDialog(
        title: Text(AppLocalizations.of(context)!.automatic_game_finder_title),
        content: SizedBox(
            height: 50,
            child: Column(children: [
              Text(AppLocalizations.of(context)!
                  .automatic_game_finder_finish(gamesFound)),
            ])),
        actions: [
          HyperlinkButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ]);
  }
}
