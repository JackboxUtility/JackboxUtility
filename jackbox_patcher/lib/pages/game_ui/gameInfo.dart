import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../model/usermodel/userjackboxgame.dart';
import '../../model/usermodel/userjackboxpack.dart';
import '../../services/api/api_service.dart';

class GameInfoRoute extends StatefulWidget {
  GameInfoRoute({Key? key}) : super(key: key);

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
    return GameInfoWidget(pack: pack, game: game);
  }
}

class GameInfoWidget extends StatefulWidget {
  GameInfoWidget({Key? key, required this.pack, required this.game})
      : super(key: key);

  final UserJackboxPack pack;
  final UserJackboxGame game;
  @override
  State<GameInfoWidget> createState() => _GameInfoWidgetState();
}

class _GameInfoWidgetState extends State<GameInfoWidget> {
  Color? backgroundColor;
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
                  imageUrl: APIService().assetLink(widget.pack.pack.background),
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
              left: calculatePadding(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.game.game.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
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
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl:
                            APIService().assetLink(widget.game.game.background),
                        fit: BoxFit.fitWidth,
                      )))
            ])
          ])),
          SizedBox(
            width: 40,
          ),
          Column(children: [
            _buildPlayPanel(),
            SizedBox(height: 20),
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
            tint: Color.fromARGB(255, 48, 48, 48),
            child: SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          APIService().assetLink(widget.game.game.background),
                      fit: BoxFit.fitWidth,
                    ),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(children: [
                          Text(widget.game.game.info.smallDescription),
                          SizedBox(height: 10),
                          FilledButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      ButtonState.all(Colors.green)),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(FluentIcons.play, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text("Jouer",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ))
                        ]))
                  ],
                ))));
  }

  Widget _buildGameTags() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Acrylic(
            shadowColor: backgroundColor,
            blurAmount: 1,
            tintAlpha: 1,
            tint: Color.fromARGB(255, 48, 48, 48),
            child: SizedBox(
                width: 300,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildGameTag(
                              Icon(FluentIcons.allIcons["people"]),
                              widget.game.game.info.players.min.toString() +
                                  " - " +
                                  widget.game.game.info.players.max.toString() +
                                  " joueurs"),
                          _buildGameTag(Icon(FluentIcons.timer),
                              widget.game.game.info.length.toString()),
                          _buildGameTag(
                            Icon(FluentIcons.group),
                            _generateGameType(widget.game.game.info.type),
                          ),
                          
                        ])))));
  }

  String _generateGameType(String v) { 
    if (v == "COOP") {
      return "Jeu en coopération";
    }else{
      if (v == "VERSUS"){
        return "Chacun pour soi";
      }else{
        return "Jeu en équipe";
      }
    }
  }

  Widget _buildGameTag(Widget icon, String text) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(children: [
          icon,
          SizedBox(width: 10),
          Expanded(child: Text(text))
        ]));
  }
}
