import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jackbox_patcher/components/dialogs/downloadPatchDialog.dart';
import 'package:jackbox_patcher/model/jackboxpackpatch.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgamepatch.dart';
import 'package:jackbox_patcher/pages/patcher/gamePatch.dart';

import '../../model/usermodel/userjackboxgame.dart';
import '../../model/usermodel/userjackboxpack.dart';
import '../../model/usermodel/userjackboxpackpatch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PackPatch extends StatefulWidget {
  PackPatch({Key? key, required this.pack, required this.patch})
      : super(key: key);

  final UserJackboxPack pack;
  final UserJackboxPackPatch patch;

  @override
  State<PackPatch> createState() => _PackPatchState();
}

class _PackPatchState extends State<PackPatch> {
  List<Widget> gamesIncluded = [];
  String buttonText  ="";
  bool installButtonDisabled = false;

  @override
  void initState() {
    for (JackboxPackPatchComponent g in widget.patch.patch.components) {
      gamesIncluded.add(GameInPatchCard(
        pack: widget.pack,
        patch: widget.patch,
        game: g.linkedGame != ""
            ? widget.pack.games
                .firstWhere((element) => element.game.id == g.linkedGame)
            : null,
        gamePatchIncluded: g,
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getPatchStatus();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      FilledButton(
          child: Text(buttonText),
          onPressed: !installButtonDisabled? () {
            showDialog(
                context: context,
                builder: (context) {
                  return DownloadPatchDialogComponent(
                      localPaths: [widget.pack.path!], patchs: [widget.patch]);
                });
          }:null),
      SizedBox(height: 20),
      Container(
          child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Acrylic(
                      shadowColor: Colors.black,
                      blurAmount: 1,
                      tintAlpha: 1,
                      tint: Color.fromARGB(255, 48, 48, 48),
                      child: Stack(children: [
                        Container(
                            padding: EdgeInsets.all(12),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(AppLocalizations.of(context)!.version +
                                      widget.patch.patch.latestVersion)
                                ])),
                        Container(
                            padding: EdgeInsets.only(bottom: 12, top: 12),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(widget.patch.patch.name,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 25)),
                                          Text(
                                            widget
                                                .patch.patch.smallDescription,
                                          ),
                                          SizedBox(height: 10),
                                          gamesIncluded.length != 0
                                              ? StaggeredGrid.count(
                                                  mainAxisSpacing: 20,
                                                  crossAxisSpacing: 20,
                                                  crossAxisCount: 3,
                                                  children: gamesIncluded)
                                              : Container(),
                                        ]),
                                  )),
                                ])),
                      ])))),
        ],
      ))
    ]);
  }

  _getPatchStatus() {
    switch (widget.patch.getInstalledStatus()) {
      case UserInstalledPatchStatus.INEXISTANT:
        buttonText = AppLocalizations.of(context)!.patch_unavailable;
        installButtonDisabled = true;
        break;
      case UserInstalledPatchStatus.INSTALLED:
        buttonText = AppLocalizations.of(context)!.patch_installed;
        installButtonDisabled = true;
        break;
      case UserInstalledPatchStatus.INSTALLED_OUTDATED:
        buttonText = AppLocalizations.of(context)!.patch_outdated;
        break;
      case UserInstalledPatchStatus.NOT_INSTALLED:
        buttonText = AppLocalizations.of(context)!.patch_not_installed;
        break;
      default:
    }
    setState(() {
      
    });
  }
}
