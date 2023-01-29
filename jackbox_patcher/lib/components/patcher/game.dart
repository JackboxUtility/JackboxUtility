import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpatch.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../model/usermodel/userjackboxgame.dart';
import '../../model/usermodel/userjackboxpack.dart';
import '../../services/api/api_service.dart';

class PatchCard extends StatefulWidget {
  PatchCard(
      {Key? key, required this.pack, required this.game, required this.patch})
      : super(key: key);

  final UserJackboxPack pack;
  final UserJackboxGame game;
  final UserJackboxPatch patch;
  @override
  State<PatchCard> createState() => _PatchCardState();
}

class _PatchCardState extends State<PatchCard> {
  Color? backgroundColor;
  int downloadingProgress = 0;
  String status = "";
  double progression = 0;
  String substatus = "";
  FlyoutController controller = FlyoutController();

  @override
  void initState() {
    _loadBackgroundColor();
    super.initState();
  }

  void _loadBackgroundColor() {
    PaletteGenerator.fromImageProvider(CachedNetworkImageProvider(
            APIService().assetLink(widget.pack.pack.background)))
        .then((value) {
      setState(() {
        backgroundColor = value.dominantColor?.color;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            margin: EdgeInsets.only(top: 30, left: 5),
            child: Container(
                width: 20,
                height: 20,
                decoration: new BoxDecoration(
                  color:
                      widget.patch.getInstalledStatus(widget.pack.path).color,
                  shape: BoxShape.circle,
                ))),
        Container(
            height: 200,
            margin: EdgeInsets.only(top: 25),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Acrylic(
                    shadowColor: backgroundColor,
                    blurAmount: 1,
                    tintAlpha: 1,
                    tint: Color.fromARGB(255, 48, 48, 48),
                    child: Stack(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        IconButton(
                            icon: Icon(FluentIcons.info),
                            onPressed: () {
                              _openPatchInfo();
                            })
                      ]),
                      Container(
                          padding: EdgeInsets.only(bottom: 12),
                          margin: EdgeInsets.only(top: 50),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Column(children: [
                                    Text(widget.patch.patch.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 25)),
                                    SizedBox(height: 10),
                                    Text(
                                      widget.patch.patch.smallDescription!,
                                    ),
                                    Expanded(child: SizedBox()),
                                    _buildRowButtons()
                                  ]),
                                ))
                              ])),
                    ])))),
        GameImageWithOpener(game: widget.game),
        Container(
            margin: EdgeInsets.only(top: 35, left: 10),
            child: Tooltip(
                child: Container(
                    width: 10,
                    height: 10,
                    decoration: new BoxDecoration(
                      color: widget.patch
                          .getInstalledStatus(widget.pack.path)
                          .color,
                      shape: BoxShape.circle,
                    )),
                message:
                    widget.patch.getInstalledStatus(widget.pack.path).info)),
      ],
    ));
  }

  void _installPatchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return downloadingProgress == 0
              ? ContentDialog(
                  title: Text("Installation du patch"),
                  content: Text(
                      "Vous allez installer le patch. Cette action est irréversible."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Annuler"),
                    ),
                    TextButton(
                      onPressed: () async {
                        downloadingProgress = 1;
                        setState(() {});
                        await widget.patch.downloadPatch(
                            widget.pack.path!, widget.game.game.path!,
                            (String stat, String substat, double progress) {
                          status = stat;
                          substatus = substat;
                          progression = progress;
                          setState(() {});
                        });
                        downloadingProgress = 2;
                        setState(() {});
                      },
                      child: Text("Continuer"),
                    ),
                  ],
                )
              : (downloadingProgress == 1
                  ? buildDownloadingPatchDialog(status, substatus, progression)
                  : buildFinishDialog());
        });
      },
    );
  }

  ContentDialog buildDownloadingPatchDialog(
      String status, String substatus, double progression) {
    return ContentDialog(
      title: Text("Installation du patch"),
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
            Navigator.pop(context);
            downloadingProgress = 0;
            setState(() {});
          },
          child: Text("Fermer"),
        ),
      ],
      title: Text("Installation du patch"),
      content: SizedBox(
          height: 200,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Icon(FluentIcons.check_mark),
                SizedBox(height: 10),
                Text("Installation terminée", style: TextStyle(fontSize: 20)),
                Text("Vous pouvez fermer cette pop-up",
                    style: TextStyle(fontSize: 16)),
              ]))),
    );
  }

  // Widget _buildPatchTypeIcons() {
  //   List<Widget> patchType = [];
  //   if (widget.game.game.patchType!.gameText) {
  //     patchType.add(Icon(FluentIcons.align_left));
  //   }
  //   if (widget.game.game.patchType!.gameAssets) {
  //     patchType.add(SizedBox(width: 10));
  //     patchType.add(Icon(FluentIcons.image_pixel));
  //   }
  //   if (widget.game.game.patchType!.website) {
  //     patchType.add(SizedBox(width: 10));
  //     patchType.add(Icon(FluentIcons.internet_sharing));
  //   }
  //   if (widget.game.game.patchType!.audios) {
  //     patchType.add(SizedBox(width: 10));
  //     patchType.add(Icon(FluentIcons.music_note));
  //   }

  //   return Container(
  //       child: Row(
  //           mainAxisAlignment: MainAxisAlignment.end, children: patchType));
  // }

  Widget _buildRowButtons() {
    void Function()? onPressFunction;
    String buttonText = "";
    bool removePatchButtonVisible = false;
    UserInstalledPatchStatus status =
        widget.patch.getInstalledStatus(widget.pack.path);
    if (status == UserInstalledPatchStatus.INEXISTANT ||
        status == UserInstalledPatchStatus.INSTALLED) {
      onPressFunction = null;
    } else {
      onPressFunction = () => _installPatchDialog();
    }

    switch (status) {
      case UserInstalledPatchStatus.INEXISTANT:
        buttonText = "Patch non disponible";
        break;
      case UserInstalledPatchStatus.INSTALLED:
        buttonText = "Patch installé";
        removePatchButtonVisible = true;
        break;
      case UserInstalledPatchStatus.INSTALLED_OUTDATED:
        buttonText = "Mettre à jour le patch";
        removePatchButtonVisible = true;
        break;
      case UserInstalledPatchStatus.NOT_INSTALLED:
        buttonText = "Installer le patch";
        break;
      default:
    }

    return Row(children: [
      Expanded(
          child: Button(onPressed: onPressFunction, child: Text(buttonText))),
      removePatchButtonVisible ? SizedBox(width: 10) : SizedBox(),
      removePatchButtonVisible
          ? IconButton(
              icon: Icon(FluentIcons.remove),
              onPressed: () {
                _removePatchDialog();
              })
          : SizedBox(),
    ]);
  }

  void _removePatchDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return ContentDialog(
            title: Text("Suppression de la version"),
            content: Text(
                "Si vous avez réinitialisé votre jeu, vous pouvez supprimer la version installée de cette application. Cela vous permettra de réinstaller les patchs."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Annuler"),
              ),
              TextButton(
                onPressed: () async {
                  await widget.patch.removePatch();
                  Navigator.pop(context);
                  setState(() {});
                },
                child: Text("Valider"),
              ),
            ],
          );
        });
  }

  void _openPatchInfo() {
    showDialog(
        context: context,
        builder: (context) {
          return ContentDialog(
            title: Text(widget.patch.patch.name),
            content:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Description", style: TextStyle(fontSize: 20)),
              Text(widget.patch.patch.description),
              SizedBox(height: 20),
              Text("Modification du patch", style: TextStyle(fontSize: 20)),
              Text("Ce patch modifie le jeu de la manière suivante :"),
              widget.patch.patch.patchType!.gameText
                  ? Text("- Modification du contenu textuel du jeu")
                  : SizedBox(),
              widget.patch.patch.patchType!.gameAssets
                  ? Text(
                      "- Modification des fichiers internes du jeu (images, textes...)")
                  : SizedBox(),
              widget.patch.patch.patchType!.gameSubtitles
                  ? Text("- Modification des sous-titres du jeu")
                  : SizedBox(),
              widget.patch.patch.patchType!.website
                  ? Text(
                      "- Modification du contenu textuel du client jackbox (seulement disponible sur laboxdejack.fr)")
                  : SizedBox(),
              widget.patch.patch.patchType!.audios
                  ? Text("- Modification des fichiers audio du jeu")
                  : SizedBox(),
              SizedBox(
                height: 20,
              ),
              Text("Version", style: TextStyle(fontSize: 20)),
              Text("${widget.patch.patch.latestVersion}"),
              SizedBox(
                height: 20,
              ),
              Text("Auteurs", style: TextStyle(fontSize: 20)),
              Text(widget.patch.patch.authors!),
            ]),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Fermer"),
              ),
            ],
          );
        });
  }
}

class GameImageWithOpener extends StatefulWidget {
  GameImageWithOpener({Key? key, required this.game}) : super(key: key);
  UserJackboxGame game;
  @override
  State<GameImageWithOpener> createState() => _GameImageWithOpenerState();
}

class _GameImageWithOpenerState extends State<GameImageWithOpener> {
  bool playButtonVisible = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 75,
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: IntrinsicWidth(
                      child: MouseRegion(
                          onEnter: (a) => setState(() {
                                playButtonVisible = true;
                              }),
                          onExit: (a) => setState(() {
                                playButtonVisible = false;
                              }),
                          child: Stack(children: [
                            CachedNetworkImage(
                              imageUrl: APIService()
                                  .assetLink(widget.game.game.background),
                              fit: BoxFit.contain,
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.green
                                    .withOpacity(playButtonVisible ? 0.9 : 0),
                              ),
                              child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(
                                    begin: playButtonVisible ? 0 : 1,
                                    end: playButtonVisible ? 1 : 0,
                                  ),
                                  duration: Duration(milliseconds: 200),
                                  builder: (BuildContext context,
                                      double opacity, Widget? child) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FluentIcons.play,
                                          color:
                                              Colors.white.withOpacity(opacity),
                                        ),
                                        Text(
                                          "Lancer",
                                          style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(opacity),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    );
                                  }),
                            )
                          ]))))
            ])));
  }
}
