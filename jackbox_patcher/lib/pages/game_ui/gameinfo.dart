import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/components/blurhash_image.dart';
import 'package:jackbox_patcher/components/caroussel.dart';
import 'package:jackbox_patcher/components/custom_server_component/custom_server_component_widget_factory.dart';
import 'package:jackbox_patcher/components/dialogs/download_patch_dialog.dart';
import 'package:jackbox_patcher/components/dialogs/patch_available_dialog.dart';
import 'package:jackbox_patcher/components/fixes/game_fix_available.dart';
import 'package:jackbox_patcher/components/stars_rate.dart';
import 'package:jackbox_patcher/model/base/extensions/null_extensions.dart';
import 'package:jackbox_patcher/model/custom_server_component/custom_server_component.dart';
import 'package:jackbox_patcher/model/jackbox/game_info/jackbox_game_info.dart';
import 'package:jackbox_patcher/model/jackbox/jackbox_pack.dart';
import 'package:jackbox_patcher/model/misc/audio/SFXEnum.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack_patch.dart';
import 'package:jackbox_patcher/mvvm/observer.dart';
import 'package:jackbox_patcher/pages/game_ui/gameinfo_view_model.dart';
import 'package:jackbox_patcher/services/audio/sfx_service.dart';
import 'package:jackbox_patcher/services/error/error.dart';
import 'package:jackbox_patcher/services/video/video_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../components/closable_route_with_esc.dart';
import '../../components/game_info/special_game_info.dart';
import '../../model/user_model/user_jackbox_game.dart';
import '../../model/user_model/user_jackbox_pack.dart';
import '../../services/api_utility/api_service.dart';
import '../../services/translations/translations_helper.dart';

class GameInfoRoute extends StatefulWidget {
  const GameInfoRoute({Key? key}) : super(key: key);

  @override
  State<GameInfoRoute> createState() => _GameInfoRouteState();
}

class _GameInfoRouteState extends State<GameInfoRoute> {
  @override
  void initState() {
    SFXService().playSFX(SFX.OPEN_GAME_INFO_TAB);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> data = ModalRoute.of(context)!.settings.arguments as List;
    final UserJackboxPack pack = data[0] as UserJackboxPack;
    final UserJackboxGame game = data[1] as UserJackboxGame;
    final bool showAllPacks = data[2] as bool;
    List<UserJackboxGameWithParent>? allAvailableGames;
    if (data.length >= 4 && data[3] != null) {
      allAvailableGames = (data[3] as List<({UserJackboxGame g, UserJackboxPack p})>).map((e) {
        return UserJackboxGameWithParent(e.g, e.p);
      }).toList();
    }
    return GameInfoWidget(pack: pack, game: game, showAllPacks: showAllPacks, allAvailableGames: allAvailableGames);
  }
}

class GameInfoWidget extends StatefulWidget {
  const GameInfoWidget(
      {Key? key, required this.pack, required this.game, required this.showAllPacks, this.allAvailableGames})
      : super(key: key);

  final UserJackboxPack pack;
  final UserJackboxGame game;
  final bool showAllPacks;
  final List<UserJackboxGameWithParent>? allAvailableGames;
  @override
  State<GameInfoWidget> createState() => _GameInfoWidgetState();
}

class _GameInfoWidgetState extends State<GameInfoWidget> implements EventObserver {
  late GameinfoViewModel viewModel;
  FlyoutController starsController = FlyoutController();

  @override
  void initState() {
    viewModel = GameinfoViewModel(widget.game, widget.showAllPacks, widget.allAvailableGames);
    super.initState();
    viewModel.subscribe(this);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  // -- Utility --

  double calculatePadding() {
    if (MediaQuery.of(context).size.width > 1000) {
      return (MediaQuery.of(context).size.width - 880) / 2;
    } else {
      return 60;
    }
  }

  // -- MAIN BUILD --

  @override
  Widget build(BuildContext context) {
    return ClosableRouteWithEsc(
        pressingSpacePauseVideo: true,
        closeSFX: true,
        leftEvent: () => viewModel.openPreviousGame(),
        rightEvent: () => viewModel.openNextGame(),
        child: NavigationView(
            content: Stack(children: [
          ListView(children: [_buildHeader(), _buildBottom()]),
          if (viewModel.canOpenOtherGame()) _buildPreviousGameButton(),
          if (viewModel.canOpenOtherGame()) _buildNextGameButton()
        ])));
  }

  Widget _buildPreviousGameButton() {
    return Positioned(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: () => viewModel.openPreviousGame(),
              child: Icon(
                FluentIcons.chevron_left,
                size: 30,
                color: Colors.white,
              )),
        ));
  }

  Widget _buildNextGameButton() {
    return Positioned(
        height: MediaQuery.of(context).size.height,
        right: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: () => viewModel.openNextGame(),
              child: Icon(
                FluentIcons.chevron_right,
                size: 30,
                color: Colors.white,
              )),
        ));
  }

  // -- HEADER --

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
                  url: viewModel.selectedUserPack.pack.background,
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
                    colors: [Color.fromRGBO(20, 20, 20, 0), Color.fromRGBO(32, 32, 32, 1)],
                    stops: [0.0, 1.0])),
          ),
          Positioned(
              width: MediaQuery.of(context).size.width - calculatePadding() * 2,
              top: 140,
              left: calculatePadding() - 30,
              child: Row(children: [
                Expanded(
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                    viewModel.selectedUserGame.game.name,
                    style: typography.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ))
                ])),
              ]))
        ])
      ],
    );
  }

  // -- BOTTOM --

  Widget _buildBottom() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: calculatePadding()),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                child: AssetCarousselWidget(
                    key: viewModel.carousselKey, images: viewModel.selectedUserGame.game.info.images)),
            SizedBox(height: 20),
            MarkdownBody(
              data: viewModel.selectedUserGame.game.info.description,
              onTapLink: (text, href, title) {
                if (href != null) viewModel.openUrl(href);
              },
            ),
            SizedBox(height: 20),
            SpecialGameAllInfoWidget(gameInfo: viewModel.selectedUserGame.game.info),
            SizedBox(height: 20),
          ])),
          const SizedBox(
            width: 40,
          ),
          Column(children: [
            _buildPlayPanel(),
            const SizedBox(height: 20),
            if (viewModel.gamesComponentExist())
              Column(children: [_buildServerComponentPanel(), const SizedBox(height: 20)]),
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

  Widget _buildServerComponentPanel() {
    CustomServerComponent component = APIService()
        .cachedServerMessage!
        .gamesComponent!
        .where((element) => element.gameId == viewModel.selectedUserGame.game.id)
        .first
        .component;
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Acrylic(
            blurAmount: 1,
            tintAlpha: 1,
            tint: const Color.fromARGB(255, 48, 48, 48),
            child: SizedBox(
                width: 300,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CustomServerComponentWidgetFactory(component: component)))));
  }

  Widget _buildPlayPanel() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Acrylic(
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
                        child: Hero(
                          tag: viewModel.selectedUserGame.game.id + "_image",
                          child: CachedNetworkImage(
                            width: 300,
                            colorBlendMode: !viewModel.selectedUserPack.owned ? BlendMode.saturation : null,
                            color: !viewModel.selectedUserPack.owned ? Colors.black : null,
                            imageUrl: APIService().assetLink(viewModel.selectedUserGame.game.background),
                            fit: BoxFit.fitWidth,
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(children: [
                          Text(viewModel.selectedUserGame.game.info.smallDescription),
                          const SizedBox(height: 10),
                          !kIsWeb ? _buildPlayButton() : const SizedBox(height: 0),
                        ])),
                  ],
                ))));
  }

  Widget buildStarsNumberPanel() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Acrylic(
            blurAmount: 1,
            tintAlpha: 1,
            tint: const Color.fromARGB(255, 48, 48, 48),
            child: SizedBox(
                width: 300,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      StarsRateWidget(
                          key: UniqueKey(),
                          defaultStars: viewModel.selectedUserGame.stars,
                          onStarChanged: (int stars) {
                            setState(() {
                              viewModel.selectedUserGame.stars = stars;
                            });
                          }),
                    ])))));
  }

  Widget buildStarsPanel() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Acrylic(
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
                        viewModel.updateStarsRate(stars);
                      },
                    )))));
  }

  Widget _buildPlayButton() {
    return !viewModel.selectedUserPack.owned
        ? (viewModel.selectedUserPack.pack.storeLinks != null
            ? _buildStoreLinkButtonsList()
            : GestureDetector(
                onTap: () async {
                  await Navigator.pushNamed(context, "/settings/packs");
                  setState(() {});
                },
                child: Text(TranslationsHelper().appLocalizations!.path_not_found_description,
                    style: TextStyle(color: Colors.red, decoration: TextDecoration.underline))))
        : Row(
            children: [
              Expanded(child: _buildLauncherButton()),
              const SizedBox(width: 10),
              _buildHideGameButton(),
            ],
          );
  }

  Widget _buildStoreLinkButtonsList() {
    return viewModel.selectedUserPack.pack.storeLinks.let((StoreLinks storeLinks) {
          return Column(children: [
            Row(children: [
              if (storeLinks.steam != null)
                Expanded(
                    child: _buildStoreLinkButton(
                  storeName: "Steam",
                  storeLink: storeLinks.steam!,
                  icon: Icon(FontAwesomeIcons.steam),
                )),
              if (storeLinks.steam != null && storeLinks.epic != null) SizedBox(width: 4),
              if (storeLinks.epic != null)
                Expanded(
                    child: _buildStoreLinkButton(
                  storeName: "Epic Games",
                  storeLink: storeLinks.epic!,
                  icon: Image.asset(
                    "assets/logos/epicgames.webp",
                    height: 14,
                    cacheHeight: 28,
                  ),
                ))
            ]),
            SizedBox(height: 4),
            if (storeLinks.jackboxGamesStore != null)
              Row(
                children: [
                  Expanded(
                      child: _buildStoreLinkButton(
                          storeName: "Jackbox Games Store",
                          storeLink: storeLinks.jackboxGamesStore!,
                          icon: Icon(FontAwesomeIcons.boxOpen))),
                ],
              )
          ]);
        }) ??
        Container();
  }

  Widget _buildStoreLinkButton({required String storeName, required String storeLink, required Widget icon}) {
    return FilledButton(
        onPressed: () {
          launchUrlString(storeLink);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(storeName),
          ],
        ));
  }

  Widget _buildHideGameButton() {
    return Tooltip(
        message: viewModel.selectedUserGame.hidden
            ? TranslationsHelper().appLocalizations!.hidden_button_hidden_tooltip
            : TranslationsHelper().appLocalizations!.hidden_button_tooltip,
        child: IconButton(
          icon: SizedBox(
              width: 16,
              height: 16,
              child: Icon(viewModel.selectedUserGame.hidden ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                  key: UniqueKey(), size: viewModel.selectedUserGame.hidden ? 15 : 16)),
          onPressed: () {
            viewModel.toggleHideGameButton();
          },
          style: ButtonStyle(backgroundColor: ButtonState.all(Colors.blue)),
        ));
  }

  Widget _buildLauncherButton() {
    return FilledButton(
        style: ButtonStyle(backgroundColor: ButtonState.all(Colors.green)),
        onPressed: viewModel.launchingStatus == GameInfoLaunchingStatus.WAITING ? viewModel.launchGame : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(FluentIcons.play_solid, color: Colors.white),
            const SizedBox(width: 10),
            Text(
                viewModel.launchingStatus == GameInfoLaunchingStatus.WAITING
                    ? TranslationsHelper().appLocalizations!.launch_game
                    : (viewModel.launchingStatus == GameInfoLaunchingStatus.LAUNCHING
                        ? TranslationsHelper().appLocalizations!.launching
                        : TranslationsHelper().appLocalizations!.launched),
                style: const TextStyle(color: Colors.white)),
          ],
        ));
  }

  void showLaunchInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ContentDialog(
          title: Text(TranslationsHelper().appLocalizations!.more_informations),
          content: SizedBox(
              height: 200,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  TranslationsHelper().appLocalizations!.launch_game_fast_launcher,
                  style: FluentTheme.of(context).typography.subtitle,
                ),
                Text(TranslationsHelper().appLocalizations!.launch_game_fast_launcher_description),
                const SizedBox(height: 10),
                Text(
                  TranslationsHelper().appLocalizations!.launch_game,
                  style: FluentTheme.of(context).typography.subtitle,
                ),
                Text(TranslationsHelper().appLocalizations!.launch_pack_description),
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
      _buildGameTagsContainer(_generateClassicGameTags()),
      const SizedBox(height: 20),
      if (viewModel.selectedUserGame.game.info.tags.isNotEmpty) _buildGameTagsContainer(_generateCustomGameTags()),
    ]);
  }

  Widget _buildGameTagsContainer(List<Widget> children) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Acrylic(
            blurAmount: 1,
            tintAlpha: 1,
            tint: const Color.fromARGB(255, 48, 48, 48),
            child: SizedBox(
                width: 300,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children)))));
  }

  Widget buildSpecialGameInfo() {
    return Column(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Acrylic(
              blurAmount: 1, tintAlpha: 1, tint: const Color.fromARGB(255, 48, 48, 48), child: SizedBox(width: 300)))
    ]);
  }

  List<Widget> _generateClassicGameTags() {
    JackboxGameInfo gameInfo = viewModel.selectedUserGame.game.info;
    List<Widget> gameTagWidgets = [];
    // Add tags available for all games
    gameTagWidgets.add(_buildGameTag(FontAwesomeIcons.boxOpen, viewModel.selectedUserPack.pack.name,
        isLink: true,
        filter: (pack, game) => pack.pack.id == viewModel.selectedUserPack.pack.id,
        linkedPack: viewModel.selectedUserPack,
        description: viewModel.selectedUserPack.pack.description));
    gameTagWidgets.add(_buildGameTag(FluentIcons.people,
        "${viewModel.selectedUserGame.game.info.players.min} - ${viewModel.selectedUserGame.game.info.players.max} ${TranslationsHelper().appLocalizations!.players}"));
    gameTagWidgets.add(_buildGameTag(FontAwesomeIcons.clock,
        "${gameInfo.playtime.min} - ${gameInfo.playtime.max} " + TranslationsHelper().appLocalizations!.minutes));
    gameTagWidgets.add(_buildGameTag(gameInfo.type.icon, gameInfo.type.name,
        isLink: true,
        filter: (pack, game) => game.game.info.type == gameInfo.type,
        linkedPack: null,
        description: gameInfo.type.description));
    gameTagWidgets.add(_buildGameTag(FontAwesomeIcons.language, gameInfo.translation.name,
        isLink: true,
        filter: (pack, game) => game.game.info.translation == gameInfo.translation,
        linkedPack: null,
        description: gameInfo.translation.description));

    return gameTagWidgets;
  }

  List<Widget> _generateCustomGameTags() {
    JackboxGameInfo gameInfo = viewModel.selectedUserGame.game.info;
    List<Widget> gameTagWidgets = [];
    // Add custom tags
    for (var element in gameInfo.tags) {
      gameTagWidgets.add(_buildGameTag(FluentIcons.allIcons[element.icon]!, element.name,
          isLink: true,
          filter: (pack, game) => game.game.info.tags.where((e) => e.id == element.id).isNotEmpty,
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
            viewModel.handleOpenTag(context, icon, text,
                isLink: isLink, filter: filter, linkedPack: linkedPack, description: description);
          }
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Row(children: [
              Icon(icon),
              const SizedBox(width: 10),
              Expanded(child: Text(text, style: isLink ? const TextStyle(decoration: TextDecoration.underline) : null))
            ])));
  }

  Widget _buildGameFixAvailable(UserJackboxPackPatch fix) {
    return GameFixAvailableComponent(
      fix: fix,
      button: Row(
        children: [
          Expanded(
              child: Button(
                  onPressed: !viewModel.getPatchStatus(fix).isDisabled
                      ? () async {
                          await showDialog(
                              context: context,
                              builder: (context) =>
                                  DownloadPatchDialogComponent(localPaths: [widget.pack.path!], patchs: [fix]));
                          setState(() {});
                        }
                      : null,
                  child: Text(viewModel.getPatchStatus(fix).status))),
        ],
      ),
    );
  }

  Widget _buildGameFixes() {
    return FutureBuilder(
        future: widget.pack.getPathStatus(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == "FOUND" && widget.pack.owned) {
            return SizedBox(
              width: 300,
              child: Column(
                  children: List.generate(
                      widget.pack.fixes.length, (index) => _buildGameFixAvailable(widget.pack.fixes[index]))),
            );
          } else {
            return Container();
          }
        });
  }

  @override
  void notify(ViewEvent? event) async {
    if (mounted) {
      if (event is InfoBarEvent) {
        InfoBarService.showError(context, event.message);
      }
      if (event is DialogEvent) {
        if (event.type == DialogEventType.PATCH_AVAILABLE) {
          bool shouldShowPatchList =
              await showDialog(context: context, builder: (context) => PatchAvailableDialog()) as bool;
          if (shouldShowPatchList) {
            Navigator.pushNamed(context, "/patch");
          } else {
            viewModel.launchGame(force: true);
          }
        }
      }
      setState(() {});
    }
  }
}
