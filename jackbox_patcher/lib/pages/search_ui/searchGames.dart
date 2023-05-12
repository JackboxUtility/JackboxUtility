import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/launcher/launcher.dart';

class SearchGameRoute extends StatefulWidget {
  const SearchGameRoute({Key? key}) : super(key: key);

  @override
  State<SearchGameRoute> createState() => _SearchGameRouteState();
}

class _SearchGameRouteState extends State<SearchGameRoute> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> data = ModalRoute.of(context)!.settings.arguments as List;
    bool Function(UserJackboxPack, UserJackboxGame) filter = data[0];
    String? background = data[1];
    String? name = data[2];
    String? description = data[3];
    String? icon = data[4];
    bool? showAllPacks = data[5];
    return SearchGameWidget(
        filter: filter,
        comeFromGame: true,
        background: background,
        name: name,
        description: description,
        showAllPacks: showAllPacks ?? false,
        icon: icon);
  }
}

class SearchGameWidget extends StatefulWidget {
  const SearchGameWidget(
      {Key? key,
      required this.filter,
      this.comeFromGame = false,
      this.background,
      this.name,
      this.description,
      required this.showAllPacks,
      this.icon})
      : super(key: key);

  final bool Function(UserJackboxPack, UserJackboxGame) filter;
  final bool comeFromGame;
  final String? background;
  final String? name;
  final String? description;
  final bool showAllPacks;
  final String? icon;

  @override
  State<SearchGameWidget> createState() => _SearchGameWidgetState();
}

class _SearchGameWidgetState extends State<SearchGameWidget> {
  @override
  Widget build(BuildContext context) {
    return NavigationView(
        content: ListView(children: [_buildHeader(), _buildBottom()]));
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Stack(children: [
          SizedBox(
              height: 200,
              child: Row(children: [
                Expanded(
                    child: CachedNetworkImage(
                  imageUrl: widget.background != null
                      ? APIService().assetLink(widget.background!)
                      : APIService().getDefaultBackground(),
                  height: 200,
                  fit: BoxFit.fitWidth,
                ))
              ])),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                  height: 100,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(20, 20, 20, 0),
                      Color.fromRGBO(32, 32, 32, 1)
                    ],
                  )))),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                  height: 100,
                  child: Row(children: [
                    SizedBox(
                        width: calculatePadding() -
                            (widget.comeFromGame ? 40 : 0)),
                    widget.comeFromGame
                        ? GestureDetector(
                            child: const Icon(FluentIcons.chevron_left),
                            onTap: () => Navigator.pop(context))
                        : Container(),
                    widget.comeFromGame ? const SizedBox(width: 20) : Container(),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.description!,
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          )
                        ])
                  ])))
        ]),
        const SizedBox(height: 20)
      ],
    );
  }

  List<Map<String, Object>> getFilteredGames() {
    List<Map<String, Object>> games = [];
    for (var element in UserData().packs) {
      if (element.games.any((game) => widget.filter(element, game)) &&
          (widget.showAllPacks || element.owned)) {
        for (var game in element.games) {
          if (widget.filter(element, game)) {
            games.add({"game": game, "pack": element});
          }
        }
      }
    }
    return games;
  }

  Widget _buildBottom() {
    List<Map<String, Object>> games = getFilteredGames();
    if (games.isNotEmpty) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: calculatePadding()),
          child: StaggeredGrid.count(
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              crossAxisCount: _getGamesByGrid(),
              children: games
                  .map((game) => SearchGameGameWidget(
                        pack: game["pack"] as UserJackboxPack,
                        game: game["game"] as UserJackboxGame,
                        showAllPacks: widget.showAllPacks,
                      ))
                  .toList()));
    } else {
      return Column(children: [
        const SizedBox(height: 50),
        Image.asset("assets/images/Mayonnaise.webp", height:200, cacheHeight: 200,),
        Text(
          AppLocalizations.of(context)!.no_game_in_this_category_title,
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          AppLocalizations.of(context)!.no_game_in_this_category_description,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
        ),
      ]);
    }
  }

  int _getGamesByGrid() {
    if (MediaQuery.of(context).size.width > 1800) {
      return 5;
    } else if (MediaQuery.of(context).size.width > 1400) {
      return 4;
    } else if (MediaQuery.of(context).size.width > 1000) {
      return 3;
    } else if (MediaQuery.of(context).size.width > 600) {
      return 2;
    } else {
      return 1;
    }
  }

  double calculatePadding() {
    if (widget.comeFromGame && MediaQuery.of(context).size.width > 1000) {
      return (MediaQuery.of(context).size.width - 880) / 2;
    } else {
      return 60;
    }
  }

  Widget _buildPack(UserJackboxPack pack) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: calculatePadding()),
        child: StaggeredGrid.count(
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            crossAxisCount: 3,
            children: pack.games
                .where((game) => widget.filter(pack, game))
                .map((game) => SearchGameGameWidget(
                    pack: pack, game: game, showAllPacks: widget.showAllPacks))
                .toList()));
  }
}

class SearchGameGameWidget extends StatefulWidget {
  const SearchGameGameWidget(
      {Key? key,
      required this.pack,
      required this.game,
      required this.showAllPacks})
      : super(key: key);

  final UserJackboxPack pack;
  final UserJackboxGame game;
  final bool showAllPacks;
  @override
  State<SearchGameGameWidget> createState() => _SearchGameGameWidgetState();
}

class _SearchGameGameWidgetState extends State<SearchGameGameWidget> {
  bool isFirstTime = true;
  bool smallInfoVisible = false;
  @override
  Widget build(BuildContext context) {
    var gameInfo = widget.game.game.info;
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AspectRatio(
          aspectRatio: 2.17,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: isFirstTime ? 0 : (smallInfoVisible ? 0 : 1),
                    end: isFirstTime ? 0 : (smallInfoVisible ? 1 : 0),
                  ),
                  duration: const Duration(milliseconds: 200),
                  builder:
                      (BuildContext context, double opacity, Widget? child) {
                    return IntrinsicHeight(
                        child: GestureDetector(
                            onSecondaryTap: () =>
                                Launcher.launchGame(widget.pack, widget.game),
                            onTap: () => Navigator.pushNamed(context, "/game",
                                    arguments: [
                                      widget.pack,
                                      widget.game,
                                      widget.showAllPacks
                                    ]),
                            child: MouseRegion(
                              onEnter: (a) => setState(() {
                                isFirstTime = false;
                                smallInfoVisible = true;
                              }),
                              onExit: (a) => setState(() {
                                isFirstTime = false;
                                smallInfoVisible = false;
                              }),
                              child: Stack(fit: StackFit.expand, children: [
                                CachedNetworkImage(
                                  colorBlendMode: !widget.pack.owned
                                      ? BlendMode.saturation
                                      : null,
                                  color:
                                      !widget.pack.owned ? Colors.black : null,
                                  imageUrl: APIService()
                                      .assetLink(widget.game.game.background),
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                      Colors.black.withOpacity(opacity / 2),
                                      Colors.black.withOpacity(opacity)
                                    ]))),
                                Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 8, left: 8),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(widget.game.game.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 15,
                                                  color: Colors.white
                                                      .withOpacity(opacity))),
                                          Text(gameInfo.tagline,
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.white
                                                      .withOpacity(opacity))),
                                          const SizedBox(height: 10),
                                          Row(children: [
                                            Icon(
                                              FluentIcons.people,
                                              color: Colors.white
                                                  .withOpacity(opacity),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                                "${gameInfo.players.min} - ${gameInfo.players.max} ${AppLocalizations.of(
                                                            context)!
                                                        .players}",
                                                style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(opacity)))
                                          ]),
                                          Row(children: [
                                            Icon(
                                              FluentIcons.clock,
                                              color: Colors.white
                                                  .withOpacity(opacity),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(gameInfo.length,
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.white
                                                        .withOpacity(opacity)))
                                          ]),
                                          Row(children: [
                                            Icon(
                                              FluentIcons.translate,
                                              color: Colors.white
                                                  .withOpacity(opacity),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(gameInfo.translation.name,
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.white
                                                        .withOpacity(opacity)))
                                          ]),
                                        ]))
                              ]),
                            )));
                  })),
        ));
  }
}
