import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/dialogs/download_patch_dialog.dart';
import 'package:jackbox_patcher/model/jackbox/jackbox_game.dart';
import 'package:jackbox_patcher/model/jackbox/jackbox_game_patch.dart';
import 'package:jackbox_patcher/model/jackbox/jackbox_pack_patch.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game_patch.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack_patch.dart';
import 'package:jackbox_patcher/services/error/error.dart';
import 'package:jackbox_patcher/services/launcher/launcher.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../model/user_model/user_jackbox_game.dart';
import '../../model/user_model/user_jackbox_pack.dart';
import '../../services/api_utility/api_service.dart';
import '../../services/translations/translations_helper.dart';

void _openPatchInfo(context, dynamic data, JackboxGame? relatedGame) {
  showDialog(
      context: context,
      builder: (context) {
        return ContentDialog(
          style: const ContentDialogThemeData(
              bodyPadding: EdgeInsets.all(12), padding: EdgeInsets.all(0)),
          title: Column(children: [
            relatedGame != null
                ? Row(children: [
                    Expanded(
                        child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8)),
                            child: SizedBox(
                                height: 100,
                                child: CachedNetworkImage(
                                  imageUrl: APIService()
                                      .assetLink(relatedGame.background),
                                  height: 100,
                                  memCacheHeight: 100,
                                  fit: BoxFit.fitWidth,
                                ))))
                  ])
                : Container(),
            Text(
              data.name,
              textAlign: TextAlign.center,
            ),
            /*
            Column(children: [
             relatedGame!=null? Row(children: [
                  Expanded(
                      child:ClipRRect(
        borderRadius: BorderRadius.only(topLeft:Radius.circular(8), topRight: Radius.circular(8)),
        child: Stack(children: [SizedBox(height: 150, width:double.maxFinite,child: CachedNetworkImage(
                    imageUrl:
                        APIService().assetLink(relatedGame.background),
                    fit: BoxFit.fitWidth,
                  )), 
                  Container(
                    width: double.maxFinite,
              height: 150,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Color.fromRGBO(39, 39, 39, 0),
                        Color.fromRGBO(39, 39, 39, 1)
                      ],
                      stops: [
                        0.0,
                        1.0
                      ])),
                      child:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [Text(data.name), SizedBox(height: 10,)]),
            ),
            ])))
                ]):Container(),
          ])*/
          ]),
          content: ListView(children: [
            data.description != null && data.description != ""
                ? Text(TranslationsHelper().appLocalizations!.description,
                    style: const TextStyle(fontSize: 20))
                : Container(),
            data.description != null && data.description != ""
                ? Text(data.description)
                : Container(),
            data.description != null && data.description != ""
                ? const SizedBox(height: 10)
                : Container(),
            Text(TranslationsHelper().appLocalizations!.patch_modification,
                style: const TextStyle(fontSize: 20)),
            Text(TranslationsHelper()
                .appLocalizations!
                .patch_modification_description),
            data.patchType!.gameText
                ? Text(
                    "- ${TranslationsHelper().appLocalizations!.patch_modification_content_text}")
                : const SizedBox(),
            data.patchType!.gameAssets
                ? Text(
                    "- ${TranslationsHelper().appLocalizations!.patch_modification_content_internal}")
                : const SizedBox(),
            data.patchType!.gameSubtitles
                ? Text(
                    "- ${TranslationsHelper().appLocalizations!.patch_modification_content_subtitles}")
                : const SizedBox(),
            data.patchType!.website
                ? Text(
                    "- ${TranslationsHelper().appLocalizations!.patch_modification_content_website(APIService().cachedSelectedServer!.controllerUrl != null ? APIService().cachedSelectedServer!.controllerUrl! : "jackbox.tv")}")
                : const SizedBox(),
            data.patchType!.audios
                ? Text(
                    "- ${TranslationsHelper().appLocalizations!.patch_modification_content_audios}")
                : const SizedBox(),
            const SizedBox(
              height: 20,
            ),
            data is JackboxGamePatch
                ? Text(TranslationsHelper().appLocalizations!.version,
                    style: const TextStyle(fontSize: 20))
                : Container(),
            data is JackboxGamePatch ? Text(data.latestVersion) : Container(),
            const SizedBox(
              height: 20,
            ),
            data.authors != null && data.authors != ""
                ? Text(TranslationsHelper().appLocalizations!.authors,
                    style: const TextStyle(fontSize: 20))
                : Container(),
            data.authors != null && data.authors != ""
                ? Text(data.authors!)
                : Container(),
          ]),
          actions: [
            HyperlinkButton(
              onPressed: () => Navigator.pop(context),
              child: Text(TranslationsHelper().appLocalizations!.close),
            ),
          ],
        );
      });
}

class GameInPatchCard extends StatefulWidget {
  const GameInPatchCard(
      {Key? key,
      required this.pack,
      required this.patch,
      required this.game,
      required this.gamePatchIncluded})
      : super(key: key);

  final UserJackboxPack pack;
  final UserJackboxPackPatch patch;
  final UserJackboxGame? game;
  final JackboxPackPatchComponent gamePatchIncluded;
  @override
  State<GameInPatchCard> createState() => _GameInPatchCardState();
}

class _GameInPatchCardState extends State<GameInPatchCard> {
  Color? backgroundColor;

  @override
  void initState() {
    _loadBackgroundColor();
    super.initState();
  }

  void _loadBackgroundColor() {
    // PaletteGenerator.fromImageProvider(CachedNetworkImageProvider(
    //         APIService().assetLink(widget.pack.pack.background)))
    //     .then((value) {
    //   setState(() {
    //     backgroundColor = value.dominantColor?.color;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            height: 150,
            margin: const EdgeInsets.only(top: 25),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Acrylic(
                    shadowColor: backgroundColor,
                    blurAmount: 1,
                    tintAlpha: 1,
                    tint: const Color.fromARGB(255, 48, 48, 48),
                    child: Stack(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        IconButton(
                            icon: const Icon(FluentIcons.info),
                            onPressed: () {
                              _openPatchInfo(
                                  context,
                                  widget.gamePatchIncluded,
                                  widget.game != null
                                      ? widget.game!.game
                                      : null);
                            })
                      ]),
                      Container(
                          padding: const EdgeInsets.only(bottom: 12),
                          margin: const EdgeInsets.only(top: 50),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Column(children: [
                                    Text(widget.gamePatchIncluded.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 25)),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget
                                          .gamePatchIncluded.smallDescription!,
                                    ),
                                  ]),
                                ))
                              ])),
                    ])))),
        widget.game != null
            ? GameImageWithOpener(pack: widget.pack, game: widget.game!)
            : Container()
      ],
    ));
  }
}

class GamePatchCard extends StatefulWidget {
  const GamePatchCard(
      {Key? key, required this.pack, required this.game, required this.patch})
      : super(key: key);

  final UserJackboxPack pack;
  final UserJackboxGame game;
  final UserJackboxGamePatch patch;
  @override
  State<GamePatchCard> createState() => _GamePatchCardState();
}

class _GamePatchCardState extends State<GamePatchCard> {
  Color? backgroundColor;
  int downloadingProgress = 0;
  String status = "";
  double progression = 0;
  String substatus = "";
  FlyoutController controller = FlyoutController();

  @override
  void initState() {
    //_loadBackgroundColor();
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
            margin: const EdgeInsets.only(top: 30, left: 5),
            child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: widget.patch.getInstalledStatus().color,
                  shape: BoxShape.circle,
                ))),
        Container(
            height: 200,
            margin: const EdgeInsets.only(top: 25),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Acrylic(
                    shadowColor: backgroundColor,
                    blurAmount: 1,
                    tintAlpha: 1,
                    tint: const Color.fromARGB(255, 48, 48, 48),
                    child: Stack(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        IconButton(
                            icon: const Icon(FluentIcons.info),
                            onPressed: () {
                              _openPatchInfo(context, widget.patch.patch,
                                  widget.game.game);
                            })
                      ]),
                      Container(
                          padding: const EdgeInsets.only(bottom: 12),
                          margin: const EdgeInsets.only(top: 50),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Column(children: [
                                    Text(widget.patch.patch.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 25)),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.patch.patch.smallDescription!,
                                    ),
                                    const Expanded(child: SizedBox()),
                                    _buildRowButtons()
                                  ]),
                                ))
                              ])),
                    ])))),
        GameImageWithOpener(pack: widget.pack, game: widget.game),
        Container(
            margin: const EdgeInsets.only(top: 35, left: 10),
            child: Tooltip(
                message: widget.patch.getInstalledStatus().info,
                child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: widget.patch.getInstalledStatus().color,
                      shape: BoxShape.circle,
                    )))),
      ],
    ));
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
    UserInstalledPatchStatus patchStatus = widget.patch.getInstalledStatus();
    if (patchStatus == UserInstalledPatchStatus.INEXISTANT ||
        patchStatus == UserInstalledPatchStatus.INSTALLED) {
      onPressFunction = null;
    } else {
      onPressFunction = () => showDialog(
          dismissWithEsc: false,
          context: context,
          builder: (context) {
            return DownloadPatchDialogComponent(
                localPaths: ["${widget.pack.path!}/${widget.game.game.path!}"],
                patchs: [widget.patch]);
          }).then((value) => setState(
            () {},
          ));
    }

    switch (patchStatus) {
      case UserInstalledPatchStatus.INEXISTANT:
        buttonText = TranslationsHelper().appLocalizations!.patch_unavailable;
        break;
      case UserInstalledPatchStatus.INSTALLED:
        buttonText = TranslationsHelper().appLocalizations!.patch_installed(1);
        removePatchButtonVisible = true;
        break;
      case UserInstalledPatchStatus.INSTALLED_OUTDATED:
        buttonText = TranslationsHelper().appLocalizations!.patch_outdated(1);
        removePatchButtonVisible = true;
        break;
      case UserInstalledPatchStatus.NOT_INSTALLED:
        buttonText =
            TranslationsHelper().appLocalizations!.patch_not_installed(1);
        break;
      default:
    }

    return Row(children: [
      Expanded(
          child: Button(onPressed: onPressFunction, child: Text(buttonText))),
      removePatchButtonVisible ? const SizedBox(width: 10) : const SizedBox(),
      removePatchButtonVisible
          ? IconButton(
              icon: const Icon(FluentIcons.remove),
              onPressed: () {
                _removePatchDialog();
              })
          : const SizedBox(),
    ]);
  }

  void _removePatchDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return ContentDialog(
            title: Text(TranslationsHelper().appLocalizations!.delete_version),
            content: Text(TranslationsHelper()
                .appLocalizations!
                .delete_version_description),
            actions: [
              HyperlinkButton(
                onPressed: () => Navigator.pop(context),
                child: Text(TranslationsHelper().appLocalizations!.cancel),
              ),
              HyperlinkButton(
                onPressed: () async {
                  await widget.patch.removePatch();
                  Navigator.pop(context);
                  setState(() {});
                },
                child: Text(TranslationsHelper().appLocalizations!.confirm),
              ),
            ],
          );
        });
  }
}

class GameImageWithOpener extends StatefulWidget {
  GameImageWithOpener({Key? key, required this.pack, required this.game})
      : super(key: key);
  final UserJackboxPack pack;
  final UserJackboxGame game;
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
            padding: const EdgeInsets.all(8),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: IntrinsicWidth(
                      child: GestureDetector(
                          onSecondaryTap: () async {
                            Launcher.launchGame(widget.pack, widget.game)
                                .then((value) => setState(() {}))
                                .catchError((e) => InfoBarService.showError(
                                    context, e.toString()));
                          },
                          onTap: () => Navigator.pushNamed(context, "/game",
                              arguments: [widget.pack, widget.game, true]),
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
                                  height: 100,
                                  memCacheHeight: 100,
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(
                                        playButtonVisible ? 0.9 : 0),
                                  ),
                                  child: TweenAnimationBuilder<double>(
                                      tween: Tween<double>(
                                        begin: playButtonVisible ? 0 : 1,
                                        end: playButtonVisible ? 1 : 0,
                                      ),
                                      duration:
                                          const Duration(milliseconds: 200),
                                      builder: (BuildContext context,
                                          double opacity, Widget? child) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              FluentIcons.info,
                                              color: Colors.white
                                                  .withOpacity(opacity),
                                            ),
                                            Text(
                                              TranslationsHelper()
                                                  .appLocalizations!
                                                  .small_description,
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
                              ])))))
            ])));
  }
}
