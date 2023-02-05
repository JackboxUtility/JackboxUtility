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
    bool showResearch = data[1];
    String? background = data[2];
    String? name = data[3];
    String? description = data[4];
    String? icon = data[5];
    return SearchGameWidget(
        filter: filter,
        showResearch: showResearch,
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
      this.showResearch = false,
      this.background,
      this.name,
      this.description,
      this.icon})
      : super(key: key);

  final bool Function(UserJackboxPack, UserJackboxGame) filter;
  final bool showResearch;
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
    return Column(
      children: [
        Stack(children: [
          SizedBox(
              height: 200,
              child: Row(children: [
                Expanded(
                    child: Image.network(
                  widget.background!,
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
                    SizedBox(width: calculatePadding() ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.name!,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          Text(widget.description!,
                              style: TextStyle(color: Colors.white))
                        ])
                  ])))
        ]),
        SizedBox(height: 20)
      ],
    );
  }

  Widget _buildBottom() {
    return Column(
        children: UserData()
            .packs
            .where((pack) => pack.games
                .where((game) => widget.filter(pack, game))
                .isNotEmpty)
            .map((pack) => _buildPack(pack))
            .toList());
  }

  double calculatePadding() {
    if (MediaQuery.of(context).size.width > 1000) {
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
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: IntrinsicHeight(child:  GestureDetector(
            onSecondaryTap: () => Launcher.launchGame(widget.pack, widget.game),
            onTap: () => Navigator.pushNamed(context, "/game",
                arguments: [widget.pack, widget.game]),
            child: MouseRegion(
                onEnter: (a) => setState(() {
                      smallInfoVisible = true;
                    }),
                onExit: (a) => setState(() {
                      smallInfoVisible = false;
                    }),
                child: Column(children: [
                  TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: smallInfoVisible ? 0 : 1,
                        end: smallInfoVisible ? 1 : 0,
                      ),
                      duration: Duration(milliseconds: 200),
                      builder: (BuildContext context, double opacity,
                          Widget? child) {
                        return Stack(children: [
                          Image.network(
                            APIService().assetLink(widget.game.game.background),
                            fit: BoxFit.fitWidth,
                          ),
                          Positioned(
                              right:0,
                              left:0,
                              bottom: 0,
                              child: Container(
                                  height:100,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(opacity)
                                      ])))),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                  height: 100,
                                  child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(widget.game.game.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                            color: Colors.white
                                                .withOpacity(opacity))),
                                    Text(widget.game.game.info.smallDescription.substring(0,20),style: TextStyle(
                                            color: Colors.white
                                                .withOpacity(opacity)))
                                  ])))
                        ]);
                      }),
                ])))));
  }
}
