import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/components/blurhashimage.dart';
import 'package:jackbox_patcher/components/caroussel.dart';
import 'package:jackbox_patcher/components/customServerComponent/customServerComponentWidgetFactory.dart';
import 'package:jackbox_patcher/components/dialogs/downloadPatchDialog.dart';
import 'package:jackbox_patcher/components/fixes/gameFixAvailable.dart';
import 'package:jackbox_patcher/components/starsRate.dart';
import 'package:jackbox_patcher/model/customServerComponent/customServerComponent.dart';
import 'package:jackbox_patcher/model/jackbox/jackboxgame.dart';
import 'package:jackbox_patcher/model/misc/audio/SFXEnum.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgamepatch.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpackpatch.dart';
import 'package:jackbox_patcher/services/audio/SFXService.dart';
import 'package:jackbox_patcher/services/discord/DiscordService.dart';
import 'package:jackbox_patcher/services/error/error.dart';
import 'package:jackbox_patcher/services/internal_api/RestApiRouter.dart';
import 'package:jackbox_patcher/services/internal_api/Scopes.dart';
import 'package:jackbox_patcher/services/internal_api/ws_message/GameOpenWsMessage.dart';
import 'package:jackbox_patcher/services/launcher/launcher.dart';
import 'package:jackbox_patcher/services/video/videoService.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../components/closableRouteWithEsc.dart';
import '../../components/gameinfo/specialGameInfo.dart';
import '../../model/usermodel/userjackboxgame.dart';
import '../../model/usermodel/userjackboxpack.dart';
import '../../services/api_utility/api_service.dart';
import '../../services/translations/translationsHelper.dart';

class GameInfoRoute extends StatefulWidget {
  const GameInfoRoute({Key? key}) : super(key: key);

  @override
  State<GameInfoRoute> createState() => _GameInfoRouteState();
}

class _GameInfoRouteState extends State<GameInfoRoute> {
  @override
  void initState() {
    // TODO: implement initState
    SFXService().playSFX(SFX.OPEN_GAME_INFO_TAB);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> data =
        ModalRoute.of(context)!.settings.arguments as List;
    final UserJackboxPack pack = data[0] as UserJackboxPack;
    final UserJackboxGame game = data[1] as UserJackboxGame;
    final bool showAllPacks = data[2] as bool;
    List<({UserJackboxGame g, UserJackboxPack p})>? allAvailableGames;
    if (data.length >= 4 && data[3] != null) {
      allAvailableGames =
          data[3] as List<({UserJackboxGame g, UserJackboxPack p})>;
    }
    return GameInfoWidget(
        pack: pack,
        game: game,
        showAllPacks: showAllPacks,
        allAvailableGames: allAvailableGames);
  }
}

class GameInfoWidget extends StatefulWidget {
  const GameInfoWidget(
      {Key? key,
      required this.pack,
      required this.game,
      required this.showAllPacks,
      this.allAvailableGames})
      : super(key: key);

  final UserJackboxPack pack;
  final UserJackboxGame game;
  final bool showAllPacks;
  final List<({UserJackboxGame g, UserJackboxPack p})>? allAvailableGames;
  @override
  State<GameInfoWidget> createState() => _GameInfoWidgetState();
}

class _GameInfoWidgetState extends State<GameInfoWidget> {
  Color? backgroundColor;
  String launchingStatus = "WAITING";
  FlyoutController starsController = FlyoutController();
  late UserJackboxPack currentPack;
  late UserJackboxGame currentGame;
  UniqueKey carousselKey = UniqueKey();
  bool isOpeningAGame = false;

  @override
  void initState() {
    currentGame = widget.game;
    currentPack = widget.pack;
    DiscordService().launchGameInfoPresence(currentGame.game.name);
    APIService().internalCache.addListener(updateCustomServerComponent);
    RestApiRouter().sendMessage(GamePageOpenWsMessage(currentGame.game));
    super.initState();
  }

  @override
  void dispose() {
    APIService().internalCache.removeListener(updateCustomServerComponent);
    super.dispose();
  }

  void updateCustomServerComponent() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClosableRouteWithEsc(
        pressingSpacePauseVideo: true,
        closeSFX: true,
        leftEvent: () => _openPreviousGame(),
        rightEvent: () => _openNextGame(),
        child: NavigationView(
            content: Stack(children: [
          ListView(children: [_buildHeader(), _buildBottom()]),
          if (widget.allAvailableGames != null &&
              widget.allAvailableGames!.length > 1)
            Positioned(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () => _openPreviousGame(),
                      child: Icon(
                        FluentIcons.chevron_left,
                        size: 30,
                        color: Colors.white,
                      )),
                )),
          if (widget.allAvailableGames != null &&
              widget.allAvailableGames!.length > 1)
            Positioned(
                height: MediaQuery.of(context).size.height,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () => _openNextGame(),
                      child: Icon(
                        FluentIcons.chevron_right,
                        size: 30,
                        color: Colors.white,
                      )),
                ))
        ])));
  }

  void _openPreviousGame() {
    if (widget.allAvailableGames != null && !isOpeningAGame) {
      int index = widget.allAvailableGames!
          .indexWhere((element) => element.g.game.id == currentGame.game.id);
      if (index != -1) {
        if (index - 1 >= 0) {
          currentGame = widget.allAvailableGames![index - 1].g;
          currentPack = widget.allAvailableGames![index - 1].p;
          setState(() {});
        } else {
          currentGame =
              widget.allAvailableGames![widget.allAvailableGames!.length - 1].g;
          currentPack =
              widget.allAvailableGames![widget.allAvailableGames!.length - 1].p;
          setState(() {});
        }
        DiscordService().launchGameInfoPresence(currentGame.game.name);
        carousselKey = UniqueKey();
      }
      setState(() {
        launchingStatus = "WAITING";
      });
      SFXService().playSFX(SFX.SCROLL_BETWEEN_GAME_INFO_TABS);
    }
  }

  void _openNextGame() {
    if (widget.allAvailableGames != null && !isOpeningAGame) {
      int index = widget.allAvailableGames!
          .indexWhere((element) => element.g.game.id == currentGame.game.id);
      if (index != -1) {
        if (index + 1 < widget.allAvailableGames!.length) {
          currentGame = widget.allAvailableGames![index + 1].g;
          currentPack = widget.allAvailableGames![index + 1].p;
          setState(() {});
        } else {
          currentGame = widget.allAvailableGames![0].g;
          currentPack = widget.allAvailableGames![0].p;
          setState(() {});
        }
        DiscordService().launchGameInfoPresence(currentGame.game.name);
        carousselKey = UniqueKey();
      }
      setState(() {
        launchingStatus = "WAITING";
      });
      SFXService().playSFX(SFX.SCROLL_BETWEEN_GAME_INFO_TABS);
    }
  }

  Widget _buildHeader() {
    Typography typography = FluentTheme.of(context).typography;
    return Column(
      children: [
        Stack(children: [
          SizedBox(
              height: 200,
              child: Row(children: [
                Expanded(
                    child: BlurHashImage(
                  url: currentPack.pack.background,
                  fit: BoxFit.fitWidth,
                ))
              ])),
          Container(
            height: 200,
            decoration: const BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Color.fromRGBO(20, 20, 20, 0),
                      Color.fromRGBO(32, 32, 32, 1)
                    ],
                    stops: [
                      0.0,
                      1.0
                    ])),
          ),
          Positioned(
              width: MediaQuery.of(context).size.width - calculatePadding() * 2,
              top: 140,
              left: calculatePadding() - 30,
              child: Row(children: [
                Expanded(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      GestureDetector(
                        child: const Icon(FluentIcons.chevron_left),
                        onTap: () {
                          VideoService.stop();
                          SFXService().playSFX(SFX.CLOSE_GAME_INFO_TAB);
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(
                        currentGame.game.name,
                        style: typography.titleLarge,
                        overflow: TextOverflow.ellipsis,
                      ))
                    ])),
              ]))
        ])
      ],
    );
  }

  void _loadBackgroundColor() {
    PaletteGenerator.fromImageProvider(CachedNetworkImageProvider(
            APIService().assetLink(currentPack.pack.background)))
        .then((value) {
      setState(() {
        backgroundColor = value.dominantColor?.color;
      });
    });
  }

  double calculatePadding() {
    if (MediaQuery.of(context).size.width > 1000) {
      return (MediaQuery.of(context).size.width - 880) / 2;
    } else {
      return 60;
    }
  }

  Widget _buildBottom() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: calculatePadding()),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                SizedBox(
                    child: AssetCarousselWidget(
                        key: carousselKey,
                        images: currentGame.game.info.images)),
                SizedBox(height: 20),
                MarkdownBody(
                  data: currentGame.game.info.description,
                  onTapLink: (text, href, title) {
                    launchUrl(Uri.parse(href!));
                  },
                ),
                SizedBox(height: 20),
                SpecialGameAllInfoWidget(gameInfo: currentGame.game.info),
                SizedBox(height: 20),
              ])),
          const SizedBox(
            width: 40,
          ),
          Column(children: [
            _buildPlayPanel(),
            const SizedBox(height: 20),
            if (gamesComponentExist())
              Column(children: [
                _buildServerComponentPanel(),
                const SizedBox(height: 20)
              ]),
            buildStarsNumberPanel(),
            const SizedBox(height: 20),
            _buildGameTags(),
            const SizedBox(height: 20),
            _buildGameFixes(),
            const SizedBox(height: 20),
          ]),
        ],
      ),
    );
  }

  bool gamesComponentExist() {
    return APIService().cachedServerMessage != null &&
        APIService().cachedServerMessage!.gamesComponent != null &&
        APIService()
                .cachedServerMessage!
                .gamesComponent!
                .where((element) => element.gameId == currentGame.game.id)
                .length >
            0;
  }

  Widget _buildServerComponentPanel() {
    CustomServerComponent component = APIService()
        .cachedServerMessage!
        .gamesComponent!
        .where((element) => element.gameId == currentGame.game.id)
        .first
        .component;
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Acrylic(
            shadowColor: backgroundColor,
            blurAmount: 1,
            tintAlpha: 1,
            tint: const Color.fromARGB(255, 48, 48, 48),
            child: SizedBox(
                width: 300,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CustomServerComponentWidgetFactory(
                        component: component)))));
  }

  Widget _buildPlayPanel() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Acrylic(
            shadowColor: backgroundColor,
            blurAmount: 1,
            tintAlpha: 1,
            tint: const Color.fromARGB(255, 48, 48, 48),
            child: SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 2.17,
                      child: CachedNetworkImage(
                        width: 300,
                        colorBlendMode:
                            !currentPack.owned ? BlendMode.saturation : null,
                        color: !currentPack.owned ? Colors.black : null,
                        imageUrl:
                            APIService().assetLink(currentGame.game.background),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(children: [
                          Text(currentGame.game.info.smallDescription),
                          const SizedBox(height: 10),
                          !kIsWeb
                              ? _buildPlayButton()
                              : const SizedBox(height: 0),
                        ])),
                  ],
                ))));
  }

  Widget buildStarsNumberPanel() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Acrylic(
            shadowColor: backgroundColor,
            blurAmount: 1,
            tintAlpha: 1,
            tint: const Color.fromARGB(255, 48, 48, 48),
            child: SizedBox(
                width: 300,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StarsRateWidget(
                              key: UniqueKey(),
                              defaultStars: currentGame.stars,
                              onStarChanged: (int stars) {
                                setState(() {
                                  currentGame.stars = stars;
                                });
                              }),
                        ])))));
  }

  Widget buildStarsPanel() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Acrylic(
            shadowColor: backgroundColor,
            blurAmount: 1,
            tintAlpha: 1,
            tint: const Color.fromARGB(255, 48, 48, 48),
            child: SizedBox(
                width: 300,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: StarsRateWidget(
                      defaultStars: 0,
                      onStarChanged: (int stars) {
                        currentGame.stars = stars;
                      },
                    )))));
  }

  Widget _buildPlayButton() {
    return !currentPack.owned
        ? (currentPack.pack.storeLinks != null
            ? Column(children: [
                Row(children: [
                  if (currentPack.pack.storeLinks!.steam != null)
                    Expanded(
                      child: FilledButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FontAwesomeIcons.steam),
                              SizedBox(width: 10),
                              Text("Steam"),
                            ],
                          ),
                          onPressed: () {
                            launchUrlString(
                                currentPack.pack.storeLinks!.steam!);
                          }),
                    ),
                  if (currentPack.pack.storeLinks!.steam != null &&
                      currentPack.pack.storeLinks!.epic != null)
                    SizedBox(width: 4),
                  if (currentPack.pack.storeLinks!.epic != null)
                    Expanded(
                      child: FilledButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/logos/epicgames.webp",
                                height: 14,
                                cacheHeight: 28,
                              ),
                              SizedBox(width: 10),
                              Text("Epic Games"),
                            ],
                          ),
                          onPressed: () {
                            launchUrlString(currentPack.pack.storeLinks!.epic!);
                          }),
                    )
                ]),
                SizedBox(height: 4),
                if (currentPack.pack.storeLinks!.jackboxGamesStore != null)
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FontAwesomeIcons.boxOpen),
                                SizedBox(width: 10),
                                Text("Jackbox Games Store"),
                              ],
                            ),
                            onPressed: () {
                              launchUrlString(currentPack
                                  .pack.storeLinks!.jackboxGamesStore!);
                            }),
                      ),
                    ],
                  )
              ])
            : GestureDetector(
                onTap: () async {
                  await Navigator.pushNamed(context, "/settings/packs");
                  setState(() {});
                },
                child: Text(
                    TranslationsHelper()
                        .appLocalizations!
                        .path_not_found_description,
                    style: TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.underline))))
        : Row(
            children: [
              Expanded(child: _buildLauncherButton()),
              const SizedBox(width: 10),
              Tooltip(
                  message: currentGame.hidden
                      ? TranslationsHelper()
                          .appLocalizations!
                          .hidden_button_hidden_tooltip
                      : TranslationsHelper()
                          .appLocalizations!
                          .hidden_button_tooltip,
                  child: IconButton(
                    icon: SizedBox(
                        width: 16,
                        height: 16,
                        child: Icon(
                            currentGame.hidden
                                ? FontAwesomeIcons.eyeSlash
                                : FontAwesomeIcons.eye,
                            key: UniqueKey(),
                            size: currentGame.hidden ? 15 : 16)),
                    onPressed: () {
                      SFXService().playSFX(SFX.CLICK);
                      currentGame.hidden = !currentGame.hidden;
                      setState(() {});
                    },
                    style: ButtonStyle(
                        backgroundColor: ButtonState.all(Colors.blue)),
                  ))
            ],
          );
  }

  Widget _buildLauncherButton() {
    late Function() functionToLaunch;
    if (currentGame.loader != null) {
      functionToLaunch = launchGameFunction;
    } else {
      functionToLaunch = launchPackFunction;
    }
    return FilledButton(
        style: ButtonStyle(backgroundColor: ButtonState.all(Colors.green)),
        onPressed: launchingStatus == "WAITING" ? functionToLaunch : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(FluentIcons.play_solid, color: Colors.white),
            const SizedBox(width: 10),
            Text(
                launchingStatus == "WAITING"
                    ? TranslationsHelper().appLocalizations!.launch_game
                    : (launchingStatus == "LAUNCHING"
                        ? TranslationsHelper().appLocalizations!.launching
                        : TranslationsHelper().appLocalizations!.launched),
                style: const TextStyle(color: Colors.white)),
          ],
        ));
  }

  void launchGameFunction() async {
    VideoService.pause();
    launchingStatus = "LAUNCHING";
    isOpeningAGame = true;
    setState(() {});
    Launcher.launchGame(currentPack, currentGame).then((value) {
      launchingStatus = "LAUNCHED";
      isOpeningAGame = false;
      setState(() {});
    }).catchError((error) {
      InfoBarService.showError(context, error.toString());
    });
  }

  void launchPackFunction() async {
    VideoService.pause();
    launchingStatus = "LAUNCHING";
    isOpeningAGame = true;
    setState(() {});
    Launcher.launchPack(currentPack).then((value) {
      launchingStatus = "LAUNCHED";
      isOpeningAGame = false;
      setState(() {});
    }).catchError((error) {
      InfoBarService.showError(context, error.toString());
    });
  }

  void showLaunchInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ContentDialog(
          title: Text(TranslationsHelper().appLocalizations!.more_informations),
          content: SizedBox(
              height: 200,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TranslationsHelper()
                          .appLocalizations!
                          .launch_game_fast_launcher,
                      style: FluentTheme.of(context).typography.subtitle,
                    ),
                    Text(TranslationsHelper()
                        .appLocalizations!
                        .launch_game_fast_launcher_description),
                    const SizedBox(height: 10),
                    Text(
                      TranslationsHelper().appLocalizations!.launch_game,
                      style: FluentTheme.of(context).typography.subtitle,
                    ),
                    Text(TranslationsHelper()
                        .appLocalizations!
                        .launch_pack_description),
                  ])),
          actions: [
            HyperlinkButton(
              child: Text(TranslationsHelper().appLocalizations!.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildGameTags() {
    return Column(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Acrylic(
              shadowColor: backgroundColor,
              blurAmount: 1,
              tintAlpha: 1,
              tint: const Color.fromARGB(255, 48, 48, 48),
              child: SizedBox(
                  width: 300,
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _generateClassicGameTags()))))),
      const SizedBox(height: 20),
      if (currentGame.game.info.tags.isNotEmpty)
        ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Acrylic(
                shadowColor: backgroundColor,
                blurAmount: 1,
                tintAlpha: 1,
                tint: const Color.fromARGB(255, 48, 48, 48),
                child: SizedBox(
                    width: 300,
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _generateCustomGameTags())))))
    ]);
  }

  Widget buildSpecialGameInfo() {
    return Column(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Acrylic(
              shadowColor: backgroundColor,
              blurAmount: 1,
              tintAlpha: 1,
              tint: const Color.fromARGB(255, 48, 48, 48),
              child: SizedBox(width: 300)))
    ]);
  }

  List<Widget> _generateClassicGameTags() {
    JackboxGameInfo gameInfo = currentGame.game.info;
    List<Widget> gameTagWidgets = [];
    // Add tags available for all games
    gameTagWidgets.add(_buildGameTag(
        FontAwesomeIcons.boxOpen, currentPack.pack.name,
        isLink: true,
        filter: (pack, game) => pack.pack.id == currentPack.pack.id,
        linkedPack: currentPack,
        description: currentPack.pack.description));
    gameTagWidgets.add(_buildGameTag(FluentIcons.people,
        "${currentGame.game.info.players.min} - ${currentGame.game.info.players.max} ${TranslationsHelper().appLocalizations!.players}"));
    gameTagWidgets.add(_buildGameTag(
        FontAwesomeIcons.clock,
        "${gameInfo.playtime.min} - ${gameInfo.playtime.max} " +
            TranslationsHelper().appLocalizations!.minutes));
    gameTagWidgets.add(_buildGameTag(gameInfo.type.icon, gameInfo.type.name,
        isLink: true,
        filter: (pack, game) => game.game.info.type == gameInfo.type,
        linkedPack: null,
        description: gameInfo.type.description));
    gameTagWidgets.add(_buildGameTag(
        FontAwesomeIcons.language, gameInfo.translation.name,
        isLink: true,
        filter: (pack, game) =>
            game.game.info.translation == gameInfo.translation,
        linkedPack: null,
        description: gameInfo.translation.description));

    return gameTagWidgets;
  }

  List<Widget> _generateCustomGameTags() {
    JackboxGameInfo gameInfo = currentGame.game.info;
    List<Widget> gameTagWidgets = [];
    // Add custom tags
    for (var element in gameInfo.tags) {
      gameTagWidgets.add(_buildGameTag(
          FluentIcons.allIcons[element.icon]!, element.name,
          isLink: true,
          filter: (pack, game) =>
              game.game.info.tags.where((e) => e.id == element.id).isNotEmpty,
          linkedPack: null,
          description: element.description));
    }

    return gameTagWidgets;
  }

  String _generateGameType(String v) {
    if (v == "COOP") {
      return TranslationsHelper().appLocalizations!.game_type_coop;
    } else {
      if (v == "VERSUS") {
        return TranslationsHelper().appLocalizations!.game_type_versus;
      } else {
        return TranslationsHelper().appLocalizations!.game_type_team;
      }
    }
  }

  Widget _buildGameTag(IconData icon, String text,
      {bool isLink = false,
      bool Function(UserJackboxPack, UserJackboxGame)? filter,
      UserJackboxPack? linkedPack,
      String? description}) {
    return GestureDetector(
        onTap: () {
          if (isLink) {
            VideoService.pause();
            SFXService().playSFX(SFX.OPEN_GAME_INFO_TAB);
            Navigator.pushNamed(context, "/search", arguments: [
              filter,
              linkedPack,
              text,
              description,
              null,
              widget.showAllPacks
            ]).then((value) {
              setState(() {
                carousselKey = UniqueKey();
              });
            });
          }
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Row(children: [
              Icon(icon),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(text,
                      style: isLink
                          ? const TextStyle(
                              decoration: TextDecoration.underline)
                          : null))
            ])));
  }

  ({String status, bool isDisabled}) _getPatchStatus(
      UserJackboxPackPatch patch) {
    switch (patch.getInstalledStatus()) {
      case UserInstalledPatchStatus.INEXISTANT:
        return (
          status: TranslationsHelper().appLocalizations!.patch_unavailable,
          isDisabled: true
        );
      case UserInstalledPatchStatus.INSTALLED:
        return (
          status: TranslationsHelper().appLocalizations!.patch_installed(1),
          isDisabled: true
        );
      case UserInstalledPatchStatus.INSTALLED_OUTDATED:
        return (
          status: TranslationsHelper().appLocalizations!.patch_outdated(1),
          isDisabled: false
        );
      case UserInstalledPatchStatus.NOT_INSTALLED:
        return (
          status: TranslationsHelper().appLocalizations!.patch_not_installed(1),
          isDisabled: false
        );
    }
  }

  Widget buildGameFixAvailable(UserJackboxPackPatch fix) {
    return GameFixAvailableComponent(
      fix: fix,
      button: Row(
        children: [
          Expanded(
              child: Button(
                  onPressed: !_getPatchStatus(fix).isDisabled
                      ? () async {
                          await showDialog(
                              context: context,
                              builder: (context) =>
                                  DownloadPatchDialogComponent(
                                      localPaths: [widget.pack.path!],
                                      patchs: [fix]));
                          setState(() {});
                        }
                      : null,
                  child: Text(_getPatchStatus(fix).status))),
        ],
      ),
    );
  }

  Widget _buildGameFixes() {
    return FutureBuilder(
        future: widget.pack.getPathStatus(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data == "FOUND" &&
              widget.pack.owned) {
            return SizedBox(
              width: 300,
              child: Column(
                  children: List.generate(
                      widget.pack.fixes.length,
                      (index) =>
                          buildGameFixAvailable(widget.pack.fixes[index]))),
            );
          } else {
            return Container();
          }
        });
  }
}
