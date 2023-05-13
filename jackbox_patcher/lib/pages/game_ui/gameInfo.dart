import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:jackbox_patcher/components/blurhashimage.dart';
import 'package:jackbox_patcher/components/caroussel.dart';
import 'package:jackbox_patcher/model/jackbox/jackboxgame.dart';
import 'package:jackbox_patcher/services/error/error.dart';
import 'package:jackbox_patcher/services/launcher/launcher.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../model/usermodel/userjackboxgame.dart';
import '../../model/usermodel/userjackboxpack.dart';
import '../../services/api/api_service.dart';

class GameInfoRoute extends StatefulWidget {
  const GameInfoRoute({Key? key}) : super(key: key);

  @override
  State<GameInfoRoute> createState() => _GameInfoRouteState();
}

class _GameInfoRouteState extends State<GameInfoRoute> {
  @override
  Widget build(BuildContext context) {
    final List<dynamic> data =
        ModalRoute.of(context)!.settings.arguments as List;
    final UserJackboxPack pack = data[0] as UserJackboxPack;
    final UserJackboxGame game = data[1] as UserJackboxGame;
    final bool showAllPacks = data[2] as bool;
    return GameInfoWidget(pack: pack, game: game, showAllPacks: showAllPacks);
  }
}

class GameInfoWidget extends StatefulWidget {
  const GameInfoWidget(
      {Key? key,
      required this.pack,
      required this.game,
      required this.showAllPacks})
      : super(key: key);

  final UserJackboxPack pack;
  final UserJackboxGame game;
  final bool showAllPacks;
  @override
  State<GameInfoWidget> createState() => _GameInfoWidgetState();
}

class _GameInfoWidgetState extends State<GameInfoWidget> {
  Color? backgroundColor;
  String launchingStatus = "WAITING";
  @override
  Widget build(BuildContext context) {
    return NavigationView(
        content: ListView(children: [_buildHeader(), _buildBottom()]));
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
                  url: widget.pack.pack.background,
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
              top: 140,
              left: calculatePadding() - 30,
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                GestureDetector(
                  child: const Icon(FluentIcons.chevron_left),
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.game.game.name,
                  style: typography.titleLarge,
                ),
              ]))
        ])
      ],
    );
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
              child: Column(children: [
            Stack(children: [
              SizedBox(
                  child: AssetCarousselWidget(
                      images: widget.game.game.info.images))
            ]),
            SizedBox(
                height: 500,
                child: Markdown(
                  data: widget.game.game.info.description,
                  onTapLink: (text, href, title) {
                    launchUrl(Uri.parse(href!));
                  },
                ))
          ])),
          const SizedBox(
            width: 40,
          ),
          Column(children: [
            _buildPlayPanel(),
            const SizedBox(height: 20),
            _buildGameTags()
          ])
        ],
      ),
    );
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
                    CachedNetworkImage(
                       colorBlendMode: !widget.pack.owned
                                      ? BlendMode.saturation
                                      : null,
                                  color:
                                      !widget.pack.owned ? Colors.black : null,
                      imageUrl:
                          APIService().assetLink(widget.game.game.background),
                      fit: BoxFit.fitWidth,
                    ),
                    Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(children: [
                          Text(widget.game.game.info.smallDescription),
                          const SizedBox(height: 10),
                          !kIsWeb ? _buildPlayButton() : const SizedBox(height: 0),
                        ]))
                  ],
                ))));
  }

  Widget _buildPlayButton() {
    return !widget.pack.owned
        ? GestureDetector(
            onTap: () async {
              await Navigator.pushNamed(context, "/settings/packs");
              setState(() {});
            },
            child: Text(
                AppLocalizations.of(context)!.path_not_found_description,
                style: TextStyle(
                    color: Colors.red, decoration: TextDecoration.underline)))
        : ((widget.pack.path == null || widget.pack.path == "")
            ? GestureDetector(
                onTap: () async {
                  await Navigator.pushNamed(context, "/settings/packs");
                  setState(() {});
                },
                child: Text(
                    AppLocalizations.of(context)!.path_inexistant_description,
                    style: TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.underline)))
            : _buildLauncherButton());
  }

  Widget _buildLauncherButton() {
    if (widget.game.loader != null) {
      return SplitButtonBar(
          style: SplitButtonThemeData.standard(FluentTheme.of(context)).merge(
              SplitButtonThemeData(
                  primaryButtonStyle: ButtonStyle(
                      backgroundColor: ButtonState.all(Colors.green)),
                  actionButtonStyle: ButtonStyle(
                      backgroundColor: ButtonState.all(Colors.green)))),
          buttons: [
            Expanded(
                child: FilledButton(
                    style: ButtonStyle(
                        backgroundColor: ButtonState.all(Colors.green)),
                    onPressed: launchingStatus == "WAITING"
                        ? launchGameFunction
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(FluentIcons.play, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                            launchingStatus == "WAITING"
                                ? AppLocalizations.of(context)!.launch_game
                                : (launchingStatus == "LAUNCHING"
                                    ? AppLocalizations.of(context)!.launching
                                    : AppLocalizations.of(context)!.launched),
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ))),
            DropDownButton(leading: const SizedBox(height: 19), items: [
              MenuFlyoutItem(
                  leading: const Icon(FluentIcons.play),
                  text: Text(AppLocalizations.of(context)!.launch_game),
                  onPressed: launchGameFunction),
              MenuFlyoutItem(
                  leading: const Icon(FluentIcons.play),
                  text: Text(AppLocalizations.of(context)!.launch_pack),
                  onPressed: launchPackFunction),
              MenuFlyoutItem(
                  leading: const Icon(FluentIcons.info),
                  text: Text(AppLocalizations.of(context)!.more_informations),
                  onPressed: showLaunchInfo),
            ])
          ]);
    } else {
      return FilledButton(
          style: ButtonStyle(backgroundColor: ButtonState.all(Colors.green)),
          onPressed: launchingStatus == "WAITING" ? launchPackFunction : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(FluentIcons.play, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                  launchingStatus == "WAITING"
                      ? AppLocalizations.of(context)!.launch_pack
                      : (launchingStatus == "LAUNCHING"
                          ? AppLocalizations.of(context)!.launching
                          : AppLocalizations.of(context)!.launched),
                  style: const TextStyle(color: Colors.white)),
            ],
          ));
    }
  }

  void launchGameFunction() {
    launchingStatus = "LAUNCHING";
    setState(() {});
    Launcher.launchGame(widget.pack, widget.game).then((value) {
      launchingStatus = "LAUNCHED";
      setState(() {});
    }).catchError((error) {
      InfoBarService.showError(context, error.toString());
    });
  }

  void launchPackFunction() {
    launchingStatus = "LAUNCHING";
    setState(() {});
    Launcher.launchPack(widget.pack).then((value) {
      launchingStatus = "LAUNCHED";
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
          title: Text(AppLocalizations.of(context)!.more_informations),
          content: SizedBox(
              height: 200,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.launch_game_fast_launcher,
                      style: FluentTheme.of(context).typography.subtitle,
                    ),
                    Text(AppLocalizations.of(context)!
                        .launch_game_fast_launcher_description),
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!.launch_game,
                      style: FluentTheme.of(context).typography.subtitle,
                    ),
                    Text(AppLocalizations.of(context)!.launch_pack_description),
                  ])),
          actions: [
            HyperlinkButton(
              child: Text(AppLocalizations.of(context)!.close),
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

  List<Widget> _generateClassicGameTags() {
    JackboxGameInfo gameInfo = widget.game.game.info;
    List<Widget> gameTagWidgets = [];
    // Add tags available for all games
    gameTagWidgets.add(_buildGameTag(
        FluentIcons.allIcons["package"]!, widget.pack.pack.name,
        isLink: true,
        filter: (pack, game) => pack.pack.id == widget.pack.pack.id,
        background: APIService().assetLink(widget.pack.pack.background),
        description: widget.pack.pack.description));
    gameTagWidgets.add(_buildGameTag(FluentIcons.allIcons["people"]!,
        "${widget.game.game.info.players.min} - ${widget.game.game.info.players.max} ${AppLocalizations.of(context)!.players}"));
    gameTagWidgets
        .add(_buildGameTag(FluentIcons.allIcons["timer"]!, gameInfo.length));
    gameTagWidgets.add(_buildGameTag(
        FluentIcons.allIcons["group"]!, gameInfo.type.name,
        isLink: true,
        filter: (pack, game) => game.game.info.type == gameInfo.type,
        background: null,
        description: gameInfo.type.description));
    gameTagWidgets.add(_buildGameTag(
        FluentIcons.allIcons["translate"]!, gameInfo.translation.name,
        isLink: true,
        filter: (pack, game) =>
            game.game.info.translation == gameInfo.translation,
        background: null,
        description: gameInfo.translation.description));

    return gameTagWidgets;
  }

  List<Widget> _generateCustomGameTags() {
    JackboxGameInfo gameInfo = widget.game.game.info;
    List<Widget> gameTagWidgets = [];
    // Add custom tags
    for (var element in gameInfo.tags) {
      gameTagWidgets.add(_buildGameTag(
          FluentIcons.allIcons[element.icon]!, element.name,
          isLink: true,
          filter: (pack, game) =>
              game.game.info.tags.where((e) => e.id == element.id).isNotEmpty,
          background: null,
          description: element.description));
    }

    return gameTagWidgets;
  }

  String _generateGameType(String v) {
    if (v == "COOP") {
      return AppLocalizations.of(context)!.game_type_coop;
    } else {
      if (v == "VERSUS") {
        return AppLocalizations.of(context)!.game_type_versus;
      } else {
        return AppLocalizations.of(context)!.game_type_team;
      }
    }
  }

  Widget _buildGameTag(IconData icon, String text,
      {bool isLink = false,
      bool Function(UserJackboxPack, UserJackboxGame)? filter,
      String? background,
      String? description}) {
    return GestureDetector(
        onTap: () {
          if (isLink) {
            Navigator.pushNamed(context, "/search", arguments: [
              filter,
              background,
              text,
              description,
              null,
              widget.showAllPacks
            ]);
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
                          ? const TextStyle(decoration: TextDecoration.underline)
                          : null))
            ])));
  }
}
