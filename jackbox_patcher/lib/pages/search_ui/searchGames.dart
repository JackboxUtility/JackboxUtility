import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jackbox_patcher/model/jackboxpack.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';

import '../../services/launcher/launcher.dart';

class SearchGameRoute extends StatefulWidget {
  SearchGameRoute({Key? key}) : super(key: key);

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
    return SearchGameWidget(
        filter: filter,
        comeFromGame: true,
        background: background,
        name: name,
        description: description,
        icon: icon);
  }
}

class SearchGameWidget extends StatefulWidget {
  SearchGameWidget(
      {Key? key,
      required this.filter,
      this.comeFromGame = false,
      this.background,
      this.name,
      this.description,
      this.icon})
      : super(key: key);

  final bool Function(UserJackboxPack, UserJackboxGame) filter;
  final bool comeFromGame;
  final String? background;
  final String? name;
  final String? description;
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
    
    Typography typography = FluentTheme.of(context).typography;
    return Column(
      children: [
        Stack(children: [
          SizedBox(
              height: 200,
              child: Row(children: [
                Expanded(
                    child: Image.network(
                  widget.background != null
                      ? widget.background!
                      : APIService().getDefaultBackground(),
                  fit: BoxFit.fitWidth,
                ))
              ])),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                  height: 100,
                  decoration: BoxDecoration(
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
              child: Container(
                  height: 100,
                  child: Row(children: [
                    SizedBox(width: calculatePadding()-(widget.comeFromGame? 40:0)),
                    widget.comeFromGame?GestureDetector(child: Icon(FluentIcons.chevron_left), onTap: () => Navigator.pop(context)):Container(),
                    widget.comeFromGame?SizedBox(width: 20):Container(),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                    widget.name!,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.description!,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  )
                        ])
                  ])))
        ]),
        SizedBox(height: 20)
      ],
    );
  }

  List<Map<String, Object>> getFilteredGames() {
    List<Map<String, Object>> games = [];
    for (var element in UserData().packs) {
      if (element.games.any((game) => widget.filter(element, game))) {
        for (var game in element.games) {
          if (widget.filter(element, game)) {
            games.add({"game":game,"pack":element});
          }
        }
      }
    }
    return games;
  }

  Widget _buildBottom() {
    List<Map<String, Object>> games = getFilteredGames();
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: calculatePadding()),
        child: StaggeredGrid.count(
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            crossAxisCount: 3,
            children: games
                .map((game) => SearchGameGameWidget(pack: game["pack"] as UserJackboxPack, game: game["game"] as UserJackboxGame))
                .toList()));
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
                .map((game) => SearchGameGameWidget(pack: pack, game: game))
                .toList()));
  }
}

class SearchGameGameWidget extends StatefulWidget {
  SearchGameGameWidget({Key? key, required this.pack, required this.game})
      : super(key: key);

  final UserJackboxPack pack;
  final UserJackboxGame game;
  @override
  State<SearchGameGameWidget> createState() => _SearchGameGameWidgetState();
}

class _SearchGameGameWidgetState extends State<SearchGameGameWidget> {
  bool smallInfoVisible = false;
  @override
  Widget build(BuildContext context) {
    var gameInfo = widget.game.game.info;
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: smallInfoVisible ? 0 : 1,
              end: smallInfoVisible ? 1 : 0,
            ),
            duration: Duration(milliseconds: 200),
            builder: (BuildContext context, double opacity, Widget? child) {
              return IntrinsicHeight(
                  child: GestureDetector(
                      onSecondaryTap: () =>
                          Launcher.launchGame(widget.pack, widget.game),
                      onTap: () => Navigator.pushNamed(context, "/game",
                          arguments: [widget.pack, widget.game]),
                      child: MouseRegion(
                        onEnter: (a) => setState(() {
                          smallInfoVisible = true;
                        }),
                        onExit: (a) => setState(() {
                          smallInfoVisible = false;
                        }),
                        child: Stack(children: [
                          Image.network(
                            APIService().assetLink(widget.game.game.background),
                            fit: BoxFit.fitWidth,
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
                              padding: EdgeInsets.all(8),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.game.game.name,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white
                                                .withOpacity(opacity))),
                                    Text(gameInfo.tagline,
                                        style: TextStyle(
                                            color: Colors.white
                                                .withOpacity(opacity))),
                                    SizedBox(height: 10),
                                    Row(children: [
                                      Icon(
                                        FluentIcons.people,
                                        color:
                                            Colors.white.withOpacity(opacity),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                          gameInfo.players.min.toString() +
                                              " - " +
                                              gameInfo.players.max.toString() +
                                              " joueurs",
                                          style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(opacity)))
                                    ]),
                                    Row(children: [
                                      Icon(
                                        FluentIcons.group,
                                        color:
                                            Colors.white.withOpacity(opacity),
                                      ),
                                      SizedBox(width: 10),
                                      Text(gameInfo.type.name,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.white
                                                  .withOpacity(opacity)))
                                    ]),
                                    Row(children: [
                                      Icon(
                                        FluentIcons.translate,
                                        color:
                                            Colors.white.withOpacity(opacity),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                              gameInfo.translation.name,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.white
                                                  .withOpacity(opacity)))
                                    ]),
                                  ]))
                        ]),
                      )));
            }));
  }

  String _generateGameType(String v) {
    if (v == "COOP") {
      return "Jeu en coopération";
    } else {
      if (v == "VERSUS") {
        return "Chacun pour soi";
      } else {
        return "Jeu en équipe";
      }
    }
  }

  String _generateGameTranslation(String v) {
    if (v == "FRENCH") {
      return "Traduit en français";
    } else {
      if (v == "FRENCH_JBFR") {
        return "Traduit par la communauté";
      } else {
        return "Non traduit";
      }
    }
  }
}
