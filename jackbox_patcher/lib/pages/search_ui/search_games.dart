import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/model/misc/sort_order.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';
import 'package:jackbox_patcher/services/api_utility/api_service.dart';
import 'package:jackbox_patcher/services/audio/sfx_service.dart';
import 'package:jackbox_patcher/services/user/user_data.dart';

import '../../components/closable_route_with_esc.dart';
import '../../components/stars_rate.dart';
import '../../model/misc/audio/SFXEnum.dart';
import '../../services/discord/discord_service.dart';
import '../../services/launcher/launcher.dart';
import '../../services/translations/translations_helper.dart';

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
    UserJackboxPack? linkedPack = data[1];
    String? name = data[2];
    String? description = data[3];
    String? icon = data[4];
    bool? showAllPacks = data[5];
    List<Widget>? separators = null;
    if (data.length >= 7) {
      separators = data[6];
    }

    int Function(UserJackboxPack, UserJackboxGame)? separatorFilter = null;
    if (data.length >= 8) {
      separatorFilter = data[7];
    }

    return ClosableRouteWithEsc(
        stopVideo: false,
        closeSFX: true,
        child: NavigationView(
            content: SearchGameWidget(
                filter: filter,
                comeFromGame: true,
                linkedPack: linkedPack,
                name: name,
                description: description,
                showAllPacks: showAllPacks ?? false,
                icon: icon,
                separators: separators,
                separatorFilter: separatorFilter)));
  }
}

class SearchGameWidget extends StatefulWidget {
  const SearchGameWidget(
      {Key? key,
      required this.filter,
      this.comeFromGame = false,
      this.linkedPack,
      this.name,
      this.description,
      required this.showAllPacks,
      this.separators,
      this.separatorFilter,
      this.icon,
      this.parentReload})
      : super(key: key);

  final bool Function(UserJackboxPack, UserJackboxGame) filter;
  final bool comeFromGame;
  final UserJackboxPack? linkedPack;
  final String? name;
  final String? description;
  final bool showAllPacks;
  final String? icon;
  final List<Widget>? separators;
  final int Function(UserJackboxPack, UserJackboxGame)? separatorFilter;
  final void Function()? parentReload;

  @override
  State<SearchGameWidget> createState() => _SearchGameWidgetState();
}

class _SearchGameWidgetState extends State<SearchGameWidget> {
  UniqueKey key = UniqueKey();
  SortOrder sortOrder = SortOrder.PACK;
  bool sortAscending = true;

  void _startDiscordrichPresence() {
    DiscordService().launchGameMenuPresence();
  }

  @override
  void initState() {
    _startDiscordrichPresence();
    sortOrder = UserData().gameList.loadSort();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      _buildHeader(),
      _buildBottom(),
      SizedBox(
        height: 20,
      )
    ]);
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
                  imageUrl: widget.linkedPack != null
                      ? APIService().assetLink(widget.linkedPack!.pack.background)
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
                    colors: [Color.fromRGBO(20, 20, 20, 0), Color.fromRGBO(32, 32, 32, 1)],
                  )))),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                  height: 100,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(width: calculatePadding() - (widget.comeFromGame ? 40 : 0)),
                    widget.comeFromGame
                        ? Container(
                            margin: EdgeInsets.only(top: 44),
                            child: GestureDetector(
                                child: const Icon(FluentIcons.chevron_left),
                                onTap: () {
                                  SFXService().playSFX(SFX.CLOSE_GAME_INFO_TAB);
                                  Navigator.pop(context);
                                }),
                          )
                        : Container(),
                    widget.comeFromGame ? const SizedBox(width: 20) : Container(),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name!,
                            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.description!,
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          )
                        ]),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            MouseRegion(
                                child: GestureDetector(
                                    child: Icon(sortAscending ? FontAwesomeIcons.sortDown : FontAwesomeIcons.sortUp),
                                    onTap: () {
                                      SFXService().playSFX(SFX.CLICK);
                                      key = UniqueKey();
                                      setState(() => sortAscending = !sortAscending);
                                    }),
                                cursor: SystemMouseCursors.click),
                            const SizedBox(width: 10),
                            ComboBox<SortOrder>(
                                onTap: () {
                                  SFXService().playSFX(SFX.FILTER_UP);
                                },
                                popupColor: Colors.black,
                                elevation: 0,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                value: sortOrder,
                                items: List.generate(
                                    SortOrder.values.length,
                                    (index) => ComboBoxItem(
                                          child: Text(TranslationsHelper()
                                              .appLocalizations!
                                              .sort_by(SortOrder.values[index].name)),
                                          value: SortOrder.values[index],
                                        )),
                                onChanged: (value) {
                                  SFXService().playSFX(SFX.CLICK);
                                  key = UniqueKey();
                                  setState(() => sortOrder = value!);
                                  UserData().gameList.saveSort(value!);
                                }),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                    SizedBox(width: calculatePadding() - (widget.comeFromGame ? 40 : 0)),
                  ]))),
          if (widget.linkedPack != null && widget.linkedPack!.owned)
            Positioned(
                top: 20,
                right: 60,
                child: IconButton(
                    style: ButtonStyle(backgroundColor: ButtonState.all(Colors.green)),
                    onPressed: () async {
                      Launcher.launchPack(widget.linkedPack!);
                    },
                    icon: const Icon(FluentIcons.play_solid)))
        ]),
        const SizedBox(height: 20)
      ],
    );
  }

  List<Map<String, Object>> getFilteredGames() {
    List<Map<String, Object>> games = [];
    for (var element in UserData().packs) {
      if (element.games.any((game) => widget.filter(element, game)) && (widget.showAllPacks || element.owned)) {
        for (var game in element.games) {
          if (widget.filter(element, game)) {
            if (widget.separators != null) {
              games.add({"game": game, "pack": element, "separator": widget.separatorFilter!(element, game)});
            } else {
              games.add({"game": game, "pack": element});
            }
          }
        }
      }
    }
    games = sortGames(games);
    return games;
  }

  Widget _buildBottom() {
    List<Map<String, Object>> games = getFilteredGames();
    if (games.isNotEmpty) {
      if (widget.separators != null) {
        List<Widget> widgetsWithSeparators = [];
        for (int i = 0; i < widget.separators!.length; i++) {
          if (games
              .where(
                (element) => element["separator"] == i,
              )
              .isNotEmpty) {
            Widget separator = widget.separators![i];
            List<Map<String, Object>> gamesWithSeparator = games
                .where(
                  (element) => element["separator"] == i,
                )
                .toList();
            widgetsWithSeparators.add(separator);
            widgetsWithSeparators.add(const SizedBox(height: 20));
            widgetsWithSeparators.add(StaggeredGrid.count(
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                crossAxisCount: _getGamesByGrid(),
                children: gamesWithSeparator
                    .map((game) => SearchGameGameWidget(
                          pack: game["pack"] as UserJackboxPack,
                          game: game["game"] as UserJackboxGame,
                          showAllPacks: widget.showAllPacks,
                          allAvailableGames: List.generate(
                              gamesWithSeparator.length,
                              (index) => (
                                    g: gamesWithSeparator[index]["game"] as UserJackboxGame,
                                    p: gamesWithSeparator[index]["pack"] as UserJackboxPack
                                  )),
                          parentReload: () {
                            setState(() {
                              key = UniqueKey();
                            });
                            if (widget.parentReload != null) {
                              widget.parentReload!();
                            }
                          },
                        ))
                    .toList()));
            widgetsWithSeparators.add(const SizedBox(height: 40));
          }
        }
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: calculatePadding()),
            child: Column(key: key, children: widgetsWithSeparators));
      }
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: calculatePadding()),
          child: StaggeredGrid.count(
                  key: key,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  crossAxisCount: _getGamesByGrid(),
                  children: games
                      .map((game) => SearchGameGameWidget(
                          pack: game["pack"] as UserJackboxPack,
                          game: game["game"] as UserJackboxGame,
                          showAllPacks: widget.showAllPacks,
                          allAvailableGames: List.generate(
                              games.length,
                              (index) => (
                                    g: games[index]["game"] as UserJackboxGame,
                                    p: games[index]["pack"] as UserJackboxPack
                                  )),
                          parentReload: () {
                            setState(() {
                              key = UniqueKey();
                            });

                            if (widget.parentReload != null) {
                              widget.parentReload!();
                            }
                          }))
                      .toList()));
    } else {
      return Column(children: [
        const SizedBox(height: 50),
        Image.asset(
          "assets/images/Mayonnaise.webp",
          height: 200,
          cacheHeight: 200,
        ),
        Text(
          TranslationsHelper().appLocalizations!.no_game_in_this_category_title,
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          TranslationsHelper().appLocalizations!.no_game_in_this_category_description,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
        ),
      ]);
    }
  }

  List<Map<String, Object>> sortGames(List<Map<String, Object>> games) {
    List<Map<String, Object>> gamesToSort = [];
    gamesToSort.addAll(games);
    switch (sortOrder) {
      case SortOrder.PACK:
        break;
      case SortOrder.STARS:
        gamesToSort.sort((a, b) {
          int firstGameStars = (b["game"] as UserJackboxGame).stars;
          int secondGameStars = (a["game"] as UserJackboxGame).stars;
          if (firstGameStars != secondGameStars) {
            return firstGameStars.compareTo(secondGameStars);
          } else {
            return games.indexOf(a).compareTo(games.indexOf(b));
          }
        });
        break;
      case SortOrder.NAME:
        gamesToSort.sort((a, b) => (a["game"] as UserJackboxGame)
            .game
            .filteredName
            .compareTo((b["game"] as UserJackboxGame).game.filteredName));
        break;
      case SortOrder.PLAYERS_NUMBER:
        gamesToSort.sort(((a, b) {
          int firstGameMax = (b["game"] as UserJackboxGame).game.info.players.max;
          int secondGameMax = (a["game"] as UserJackboxGame).game.info.players.max;
          if (firstGameMax != secondGameMax) {
            return firstGameMax.compareTo((secondGameMax));
          } else {
            return games.indexOf(a).compareTo(games.indexOf(b));
          }
        }));
        break;
    }
    if (!sortAscending) {
      gamesToSort = gamesToSort.reversed.toList();
    }
    return gamesToSort;
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
    if (widget.comeFromGame && MediaQuery.of(context).size.width > 1800) {
      return (MediaQuery.of(context).size.width - 1680) / 2;
    }
    if (widget.comeFromGame && MediaQuery.of(context).size.width > 1400) {
      return (MediaQuery.of(context).size.width - 1280) / 2;
    }
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
                      pack: pack,
                      game: game,
                      showAllPacks: widget.showAllPacks,
                      allAvailableGames:
                          List.generate(pack.pack.games.length, (index) => (g: pack.games[index], p: pack)),
                    ))
                .toList()));
  }
}

class SearchGameGameWidget extends StatefulWidget {
  const SearchGameGameWidget(
      {Key? key,
      required this.pack,
      required this.game,
      required this.showAllPacks,
      this.parentReload,
      this.allAvailableGames,
      this.disableHero})
      : super(key: key);

  final UserJackboxPack pack;
  final UserJackboxGame game;
  final bool showAllPacks;
  final Function? parentReload;
  final bool? disableHero;
  final List<({UserJackboxGame g, UserJackboxPack p})>? allAvailableGames;
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
                    begin: isFirstTime ? 1 : (smallInfoVisible ? 0 : 1),
                    end: isFirstTime ? 1 : (smallInfoVisible ? 1 : 0),
                  ),
                  duration: const Duration(milliseconds: 200),
                  builder: (BuildContext context, double opacity, Widget? child) {
                    return GestureDetector(
                        onTap: () async {
                          await Navigator.pushNamed(context, "/game",
                              arguments: [widget.pack, widget.game, widget.showAllPacks, widget.allAvailableGames]);
                          if (widget.parentReload != null) {
                            widget.parentReload!();
                          }
                          _startDiscordrichPresence();
                        },
                        child: MouseRegion(
                          onEnter: (a) => setState(() {
                            isFirstTime = false;
                            // smallInfoVisible = true;
                            // SFXService().playSFX(SFX.HOVER_OVER_BANNER);
                          }),
                          onExit: (a) => setState(() {
                            isFirstTime = false;
                            smallInfoVisible = false;
                          }),
                          child: Stack(fit: StackFit.expand, children: [
                            Hero(
                                    tag: widget.game.game.id + "_image",
                                    child: CachedNetworkImage(
                                      colorBlendMode: !widget.pack.owned ? BlendMode.saturation : null,
                                      color: !widget.pack.owned ? Colors.black : null,
                                      imageUrl: APIService().assetLink(widget.game.game.background),
                                      fit: BoxFit.cover,
                                    )),
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
                              padding: const EdgeInsets.only(bottom: 8, left: 8),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.game.game.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 14.5,
                                            color: Colors.white.withOpacity(opacity))),
                                    Text(gameInfo.tagline,
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis, color: Colors.white.withOpacity(opacity))),
                                    const SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(children: [
                                                Icon(
                                                  FluentIcons.people,
                                                  color: Colors.white.withOpacity(opacity),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                    "${gameInfo.players.min} - ${gameInfo.players.max} ${TranslationsHelper().appLocalizations!.players}",
                                                    style: TextStyle(color: Colors.white.withOpacity(opacity)))
                                              ]),
                                              Row(children: [
                                                Icon(
                                                  FluentIcons.clock,
                                                  color: Colors.white.withOpacity(opacity),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                    gameInfo.playtime.min.toString() +
                                                        " - " +
                                                        gameInfo.playtime.max.toString() +
                                                        " " +
                                                        TranslationsHelper().appLocalizations!.minutes,
                                                    style: TextStyle(
                                                        overflow: TextOverflow.ellipsis,
                                                        color: Colors.white.withOpacity(opacity)))
                                              ]),
                                              SizedBox(height: 4),
                                              Opacity(
                                                  opacity: opacity,
                                                  child: StarsRateWidget(
                                                    key: UniqueKey(),
                                                    color: Colors.white,
                                                    defaultStars: widget.game.stars,
                                                    readOnly: true,
                                                  )),
                                            ]),
                                        Spacer(),
                                        if (widget.pack.owned)
                                          Opacity(
                                              opacity: opacity,
                                              child: Padding(
                                                  padding: EdgeInsets.only(right: 8),
                                                  child: Button(
                                                    style: ButtonStyle(
                                                      backgroundColor: ButtonState.all<Color>(Colors.green),
                                                    ),
                                                    child: Icon(FontAwesomeIcons.play),
                                                    onPressed: () {
                                                      Launcher.launchGame(widget.pack, widget.game);
                                                    },
                                                  ))),
                                      ],
                                    )
                                  ]),
                            ),
                          ]),
                        ));
                  })),
        ));
  }

  void _startDiscordrichPresence() {
    DiscordService().launchGameMenuPresence();
  }
}
