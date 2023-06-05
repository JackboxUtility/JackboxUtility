import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';
import 'package:jackbox_patcher/pages/patcher/gamePatch.dart';
import 'package:jackbox_patcher/pages/search_ui/searchGames.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:jackbox_patcher/services/launcher/launcher.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../services/games/GamesService.dart';

class RandomGameWidget extends StatefulWidget {
  RandomGameWidget(
      {Key? key, required this.showUnownedGames, required this.showHiddenGames})
      : super(key: key);

  final bool showUnownedGames;
  final bool showHiddenGames;

  @override
  State<RandomGameWidget> createState() => _RandomGameWidgetState();
}

class _RandomGameWidgetState extends State<RandomGameWidget> {
  UserJackboxGame? selectedGame;
  bool showGameBackground = false;

  @override
  void initState() {
    _selectRandomGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: CachedNetworkImage(
          imageUrl: APIService()
              .assetLink(selectedGame!.getUserJackboxPack().pack.background),
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin:
                                    showGameBackground?1:0.96,
                                end: showGameBackground?0.96:1
                              ),
                              curve: Curves.easeOut,
                              duration: showGameBackground
                                  ? const Duration(milliseconds: 1000)
                                  : const Duration(milliseconds: 200),
                              builder: (BuildContext context, double animation,
                                  Widget? child) {
                                    return Container(
            color: const Color.fromARGB(1, 32, 32, 32).withOpacity(animation),
    );})),
      Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin:
                                    showGameBackground?0.18:0.2,
                                end: showGameBackground?0.2:0.18
                              ),
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 200),
                              builder: (BuildContext context, double animation,
                                  Widget? child) {
                                    return SizedBox(
              height: MediaQuery.of(context).size.height * animation,
              child: SearchGameGameWidget(
                  pack: selectedGame!.getUserJackboxPack(),
                  game: selectedGame!,
                  showAllPacks: false));}),
          SizedBox(
            height: 20,
          ),
          TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin:
                                    showGameBackground?0:1,
                                end: showGameBackground?1:0
                              ),
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 200),
                              builder: (BuildContext context, double animation,
                                  Widget? child) {
                                    return Opacity(
                                      opacity: animation,
                                      child:SizedBox(
            width: 200,
            child: FilledButton(
              onPressed: () => _selectRandomGame(),
              child: Row(children: [
                const Icon(FontAwesomeIcons.dice),
                const SizedBox(
                  width: 10,
                ),
                const Text("Let's try another one !"),
              ]),
            )),
          );}),
          SizedBox(
            height: 20,
          ),
          TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin:
                                    showGameBackground?0:1,
                                end: showGameBackground?1:0
                              ),
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 200),
                              builder: (BuildContext context, double animation,
                                  Widget? child) {
                                    return Opacity(
                                      opacity: animation,
                                      child:SizedBox(
            width: 200,
            child: FilledButton(
                onPressed: () => _launchRandomGame(),
                child: const Text("I am feeling lucky")),
          ));}),
        ],
      )),
    ]);
  }

  void _selectRandomGame() async {
    showGameBackground = false;
    int animationState = 0;
    while (animationState < 5) {
      setState(() {
        selectedGame = GamesService()
            .chooseRandomGame(widget.showUnownedGames, widget.showHiddenGames);
      });
      animationState++;
      await Future.delayed(const Duration(milliseconds: 100));
    }
    setState(() {
      showGameBackground = true;
    });
  }

  void _launchRandomGame() {
    UserJackboxGame randomGame =
        GamesService().chooseRandomGame(false, widget.showHiddenGames);
    Launcher.launchGame(randomGame.getUserJackboxPack(), randomGame);
  }
}
