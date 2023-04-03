import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/jackboxgame.dart';
import 'package:jackbox_patcher/model/jackboxgamepatch.dart';
import 'package:jackbox_patcher/model/jackboxpackpatch.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgamepatch.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpackpatch.dart';
import 'package:jackbox_patcher/services/error/error.dart';
import 'package:jackbox_patcher/services/launcher/launcher.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../model/usermodel/userjackboxgame.dart';
import '../../model/usermodel/userjackboxpack.dart';
import '../../services/api/api_service.dart';

void _openPatchInfo(context, dynamic data, JackboxGame? relatedGame) {
  showDialog(
      context: context,
      builder: (context) {
        return ContentDialog(
          style: ContentDialogThemeData(bodyPadding: EdgeInsets.all(12), padding:EdgeInsets.all(0)),
          title: Column(children: [
             relatedGame!=null? Row(children: [
                  Expanded(
                      child:ClipRRect(
        borderRadius: BorderRadius.only(topLeft:Radius.circular(8), topRight: Radius.circular(8)),
        child:SizedBox(height: 100,child: CachedNetworkImage(
                    imageUrl:
                        APIService().assetLink(relatedGame.background),
                    fit: BoxFit.fitWidth,
                  ))))
                ]):Container(),
            Text(data.name),
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
          content:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(AppLocalizations.of(context)!.description,
                style: TextStyle(fontSize: 20)),
            Text(data.description),
            SizedBox(height: 10),
            Text(AppLocalizations.of(context)!.patch_modification,
                style: TextStyle(fontSize: 20)),
            Text(AppLocalizations.of(context)!.patch_modification_description),
            data.patchType!.gameText
                ? Text("- " +
                    AppLocalizations.of(context)!
                        .patch_modification_content_text)
                : SizedBox(),
            data.patchType!.gameAssets
                ? Text("- " +
                    AppLocalizations.of(context)!
                        .patch_modification_content_internal)
                : SizedBox(),
            data.patchType!.gameSubtitles
                ? Text("- " +
                    AppLocalizations.of(context)!
                        .patch_modification_content_subtitles)
                : SizedBox(),
            data.patchType!.website
                ? Text("- " +
                    AppLocalizations.of(context)!
                        .patch_modification_content_website("laboxdejack.fr"))
                : SizedBox(),
            data.patchType!.audios
                ? Text("- " +
                    AppLocalizations.of(context)!
                        .patch_modification_content_audios)
                : SizedBox(),
            SizedBox(
              height: 20,
            ),
            data is JackboxGamePatch ? Text(AppLocalizations.of(context)!.version,
                style: TextStyle(fontSize: 20)):Container(),
            data is JackboxGamePatch ? Text("${data.latestVersion}"):Container(),
            SizedBox(
              height: 20,
            ),
            Text(AppLocalizations.of(context)!.authors,
                style: TextStyle(fontSize: 20)),
            Text(data.authors!),
          ]),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.close),
            ),
          ],
        );
      });
}

class GameInPatchCard extends StatefulWidget {
  GameInPatchCard(
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
            height: 150,
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
                              _openPatchInfo(context, widget.gamePatchIncluded, widget.game!=null?widget.game!.game:null);
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
                                    Text(widget.gamePatchIncluded.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 25)),
                                    SizedBox(height: 10),
                                    Text(
                                      widget.gamePatchIncluded.smallDescription!,
                                    ),
                                  ]),
                                ))
                              ])),
                    ])))),
        widget.game!=null? GameImageWithOpener(pack: widget.pack, game: widget.game!):Container()
      ],
    ));
  }
}

class GamePatchCard extends StatefulWidget {
  GamePatchCard(
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
                              _openPatchInfo(context, widget.patch.patch, widget.game.game);
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
        GameImageWithOpener(pack: widget.pack, game: widget.game),
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
                  title: Text(AppLocalizations.of(context)!.installing_a_patch),
                  content: Text(AppLocalizations.of(context)!
                      .installing_a_patch_description),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    TextButton(
                      onPressed: () async {
                        downloadingProgress = 1;
                        setState(() {});
                        widget.patch.downloadPatch(
                            widget.pack.path!, widget.game.game.path!,
                            (String stat, String substat, double progress) {
                          status = stat;
                          substatus = substat;
                          progression = progress;
                          setState(() {});
                        }).then((_) {
                          downloadingProgress = 2;
                          setState(() {});
                        }).catchError((error) {
                          ErrorService.showError(context, error);
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
        });
      },
    );
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
        buttonText = AppLocalizations.of(context)!.patch_unavailable;
        break;
      case UserInstalledPatchStatus.INSTALLED:
        buttonText = AppLocalizations.of(context)!.patch_installed;
        removePatchButtonVisible = true;
        break;
      case UserInstalledPatchStatus.INSTALLED_OUTDATED:
        buttonText = AppLocalizations.of(context)!.patch_outdated;
        removePatchButtonVisible = true;
        break;
      case UserInstalledPatchStatus.NOT_INSTALLED:
        buttonText = AppLocalizations.of(context)!.patch_not_installed;
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
            title: Text(AppLocalizations.of(context)!.delete_version),
            content:
                Text(AppLocalizations.of(context)!.delete_version_description),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              TextButton(
                onPressed: () async {
                  await widget.patch.removePatch();
                  Navigator.pop(context);
                  setState(() {});
                },
                child: Text(AppLocalizations.of(context)!.confirm),
              ),
            ],
          );
        });
  }
}

class GameImageWithOpener extends StatefulWidget {
  GameImageWithOpener({Key? key, required this.pack, required this.game})
      : super(key: key);
  UserJackboxPack pack;
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
                      child: GestureDetector(
                          onSecondaryTap: () async {
                            Launcher.launchGame(widget.pack, widget.game)
                                .then((value) => setState(() {}))
                                .catchError((e) => ErrorService.showError(
                                    context, e.toString()));
                          },
                          onTap: () => Navigator.pushNamed(context, "/game",
                              arguments: [widget.pack, widget.game]),
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
                                    color: Colors.blue.withOpacity(
                                        playButtonVisible ? 0.9 : 0),
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
                                              FluentIcons.info,
                                              color: Colors.white
                                                  .withOpacity(opacity),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .small_information,
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
