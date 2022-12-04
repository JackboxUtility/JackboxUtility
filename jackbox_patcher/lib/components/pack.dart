import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jackbox_patcher/components/game.dart';
import 'package:jackbox_patcher/model/jackboxpack.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxpack.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';

class PackWidget extends StatefulWidget {
  PackWidget({Key? key, required this.userPack}) : super(key: key);

  final UserJackboxPack userPack;
  @override
  State<PackWidget> createState() => _PackWidgetState();
}

class _PackWidgetState extends State<PackWidget> {
  String pathFoundStatus = "LOADING";
  late TextEditingController pathController;

  @override
  void initState() {
    pathController = TextEditingController(text: widget.userPack.path);
    _loadPathFoundStatus();
    super.initState();
  }

  void _loadPathFoundStatus() async {
    Directory? folder = widget.userPack.getPackFolder();
    if (folder == null) {
      setState(() {
        pathFoundStatus = "INEXISTANT";
      });
    } else {
      if (await folder.exists()) {
        setState(() {
          pathFoundStatus = "FOUND";
        });
      } else {
        setState(() {
          pathFoundStatus = "NOT_FOUND";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [_buildHeader(), SizedBox(height: 30), _buildGames()]);
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
                height: 200,
                child: Row(children: [
                  Expanded(
                      child: CachedNetworkImage(
                    imageUrl:
                        APIService().assetLink(widget.userPack.pack.background),
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
                        Color.fromRGBO(39, 39, 39, 0.5),
                        Color.fromRGBO(39, 39, 39, 1)
                      ],
                      stops: [
                        0.0,
                        1.0
                      ])),
            ),
            Positioned(
              top: 140,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userPack.pack.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.userPack.pack.description,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  )
                ],
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: CachedNetworkImage(
                imageUrl: APIService().assetLink(widget.userPack.pack.icon),
                height: 100,
              ),
            ),
            Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                    style: ButtonStyle(
                        backgroundColor: ButtonState.all(
                            FluentTheme.of(context).inactiveBackgroundColor)),
                    onPressed: () async {
                      await _showParametersDialog();
                    },
                    icon: Icon(FluentIcons.settings))),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        _buildPathMessage()
      ],
    );
  }

  Widget _buildPathMessage() {
    if (pathFoundStatus == "LOADING") {
      return ProgressRing();
    }
    if (pathFoundStatus == "FOUND") {
      return Container();
    }
    if (pathFoundStatus == "NOT_FOUND") {
      return InfoBar(
        severity: InfoBarSeverity.error,
        title: Text("Chemin introuvable"),
        content: Text(
            "Le chemin pour ce pack n'a pas été trouvé sur votre ordinateur. Vous devez de nouveau ajouter le chemin pour ce pack dans ses paramètres"),
      );
    }
    return InfoBar(
      severity: InfoBarSeverity.warning,
      title: Text("Chemin inexistant"),
      content: Text(
          "Vous n'avez pas ajouté le chemin vers le pack. Vous pouvez le faire dans les paramètres"),
    );
  }

  Widget _buildGames() {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: StaggeredGrid.count(
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            crossAxisCount: 3,
            children: widget.userPack.games
                .map((e) => GameCard(pack: widget.userPack, game: e))
                .toList()));
  }

  Future<void> _showParametersDialog() async {
    await showDialog(
        context: context,
        builder: (context) => ContentDialog(
              title: Text("Paramètres"),
              content: SizedBox(height:100,child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Chemin du pack"),
                    SizedBox(
                      height: 6,
                    ),
                    TextBox(
                      controller: pathController,
                      onChanged: (value) {
                        widget.userPack.setPath(value);
                      },
                    )
                  ])),
              actions: [
                TextButton(
                    child: Text("Valider"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ));
    _loadPathFoundStatus();
  }
}
