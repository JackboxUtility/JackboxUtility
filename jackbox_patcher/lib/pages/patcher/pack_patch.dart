import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jackbox_patcher/components/dialogs/download_patch_dialog.dart';
import 'package:jackbox_patcher/model/jackbox/jackbox_pack_patch.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game_patch.dart';
import 'package:jackbox_patcher/pages/patcher/game_patch.dart';

import '../../model/user_model/user_jackbox_pack.dart';
import '../../model/user_model/user_jackbox_pack_patch.dart';

import '../../services/translations/translations_helper.dart';

class PackPatch extends StatefulWidget {
  const PackPatch({Key? key, required this.pack, required this.patch})
      : super(key: key);

  final UserJackboxPack pack;
  final UserJackboxPackPatch patch;

  @override
  State<PackPatch> createState() => _PackPatchState();
}

class _PackPatchState extends State<PackPatch> {
  List<Widget> gamesIncluded = [];
  String buttonText = "";
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
      Row(
        children: [
          FilledButton(
              onPressed: !installButtonDisabled
                  ? () async {
                      await showDialog(
                          dismissWithEsc: false,
                          context: context,
                          builder: (context) {
                            return DownloadPatchDialogComponent(
                                localPaths: [widget.pack.path!],
                                patchs: [widget.patch]);
                          });
                      setState(() {});
                    }
                  : null,
              child: Text(buttonText)),
              SizedBox(width: 10),
          widget.patch.getInstalledStatus() == UserInstalledPatchStatus.INSTALLED || widget.patch.getInstalledStatus() == UserInstalledPatchStatus.INSTALLED_OUTDATED?
            Text(TranslationsHelper().appLocalizations!.installed_version +": ${widget.patch.installedVersion}"):SizedBox.shrink(),
        ],
      ),
      const SizedBox(height: 20),
      Container(
          child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                      color: Color.fromARGB(255, 43, 43, 43),
                        padding: const EdgeInsets.only(bottom: 12, top: 12),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(widget.patch.patch.name,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 25)),
                                          const SizedBox(width: 20),
                                          Text(
                                              "${TranslationsHelper().appLocalizations!.version} ${widget.patch.patch.latestVersion}",
                                              style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.7)))
                                        ],
                                      ),
                                      Text(
                                        widget.patch.patch.smallDescription,
                                      ),
                                      const SizedBox(height: 10),
                                      gamesIncluded.isNotEmpty
                                          ? StaggeredGrid.count(
                                              mainAxisSpacing: 20,
                                              crossAxisSpacing: 20,
                                              crossAxisCount: 3,
                                              children: gamesIncluded)
                                          : Container(),
                                    ]),
                              )),
                            ])),
                  )),
        ],
      )),
      const SizedBox(height: 40)
    ]);
  }

  _getPatchStatus() {
    switch (widget.patch.getInstalledStatus()) {
      case UserInstalledPatchStatus.INEXISTANT:
        buttonText = TranslationsHelper().appLocalizations!.patch_unavailable;
        installButtonDisabled = true;
        break;
      case UserInstalledPatchStatus.INSTALLED:
        buttonText = TranslationsHelper().appLocalizations!.patch_installed(1);
        installButtonDisabled = true;
        break;
      case UserInstalledPatchStatus.INSTALLED_OUTDATED:
        buttonText = TranslationsHelper().appLocalizations!.patch_outdated(1);
        break;
      case UserInstalledPatchStatus.NOT_INSTALLED:
        buttonText =
            TranslationsHelper().appLocalizations!.patch_not_installed(1);
        break;
      default:
    }
    setState(() {});
  }
}
