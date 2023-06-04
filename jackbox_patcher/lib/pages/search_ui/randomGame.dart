import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';
import 'package:jackbox_patcher/pages/patcher/gamePatch.dart';
import 'package:jackbox_patcher/pages/search_ui/searchGames.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../services/games/GamesService.dart';

class RandomGameWidget extends StatefulWidget {
  RandomGameWidget({Key? key, required this.showUnownedGames, required this.showHiddenGames}) : super(key: key);
  
  final bool showUnownedGames;
  final bool showHiddenGames;

  @override
  State<RandomGameWidget> createState() => _RandomGameWidgetState();
}

class _RandomGameWidgetState extends State<RandomGameWidget> {
  UserJackboxGame? selectedGame;

  @override
  void initState() {
    _selectRandomGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: 
      [
        Positioned(top: 0,
        left: 0,
        right:0,
        bottom: 0,child: CachedNetworkImage(imageUrl: APIService().assetLink(selectedGame!.getUserJackboxPack().pack.background), fit: BoxFit.cover, ),

        ),
        Positioned(top: 0,
        left: 0,
        right:0,
        bottom: 0,child:BackdropFilter(
          child:new Container(
            decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
          ),
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),)),
        Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height:MediaQuery.of(context).size.height*0.2, child: SearchGameGameWidget(pack: selectedGame!.getUserJackboxPack(), game: selectedGame!, showAllPacks: false)), 
            SizedBox(height: 20,),
            SizedBox(
              width: 200,
              child: FilledButton(
                onPressed: () => _selectRandomGame(),
                child: Row(children: [
                  const Icon(FontAwesomeIcons.dice),
                  const SizedBox(width: 10,),
                  const Text("Let's try another one !"),
                
                ]),
              ),
            ),
          ],)
        ),
      ]
    );
  }

  void _selectRandomGame() {
    setState(() {
      selectedGame = GamesService().chooseRandomGame(widget.showUnownedGames, widget.showHiddenGames);
    });
  }
}