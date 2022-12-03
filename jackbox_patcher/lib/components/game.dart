import 'package:fluent_ui/fluent_ui.dart';

import '../model/usermodel/userjackboxgame.dart';
import '../services/api/api_service.dart';

class GameCard extends StatefulWidget {
  GameCard({Key? key, required this.game}) : super(key: key);

  final UserJackboxGame game;
  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
            height: 75,
            child: Padding(
                padding: EdgeInsets.all(32),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        APIService().assetLink(widget.game.game.background),
                        fit: BoxFit.contain,
                      ))
                ]))),
        Container(
            margin: EdgeInsets.only(top: 30, left: 5),
            child: Flyout(
                openMode: FlyoutOpenMode.hover,
                content: (context) =>
                    FlyoutContent(child: Text("Ce jeu est à jour")),
                child: Container(
                    width: 20,
                    height: 20,
                    decoration: new BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    )))),
        Container(
            margin: EdgeInsets.only(top: 25),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Acrylic(
                  blurAmount: 2,
                  tintAlpha: 1,
                    tint: Color.fromARGB(255, 48, 48, 48),
                    child: Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Column(children: [
                                  Text(widget.game.game.name,
                                      style: TextStyle(fontSize: 25)),
                                  Text(
                                      "Lorem ipsum dolor imset lorem ipsum dolor imset lorem ipsum dolor imset"),
                                  Text("À jour",
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 20)),
                                  Row(children: [
                                    Expanded(
                                        child: Button(
                                            onPressed: () {},
                                            child: Text("Désinstaller"))),
                                    Expanded(
                                        child: Button(
                                            onPressed: () {},
                                            child: Text("Installer")))
                                  ])
                                ]),
                              ))
                            ]))))),
        SizedBox(
            height: 75,
            child: Padding(
                padding: EdgeInsets.all(8),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        APIService().assetLink(widget.game.game.background),
                        fit: BoxFit.contain,
                      ))
                ]))),
        Container(
            margin: EdgeInsets.only(top: 35, left: 10),
            child: Flyout(
                openMode: FlyoutOpenMode.hover,
                content: (context) =>
                    FlyoutContent(child: Text("Ce jeu est à jour")),
                child: Container(
                    width: 10,
                    height: 10,
                    decoration: new BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    )))),
      ],
    ));
  }
}
