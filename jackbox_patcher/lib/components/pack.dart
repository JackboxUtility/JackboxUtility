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
  @override
  Widget build(BuildContext context) {
    return ListView(children: [_buildHeader(), SizedBox(height: 30),  _buildGames()]);
  }

  Widget _buildHeader() {
    return Container(
      child: Stack(
        children: [
          SizedBox(
              height: 200,
              child: Row(children: [
                Expanded(
                    child:  CachedNetworkImage(imageUrl:
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
            child: CachedNetworkImage(imageUrl: APIService().assetLink(widget.userPack.pack.icon),
              height: 100,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGames() {
    return Padding(padding: EdgeInsets.only(left: 20, right:20, bottom: 20),child:StaggeredGrid.count(
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          crossAxisCount: 3,
            children: widget.userPack.games
                .map((e) => GameCard(pack:widget.userPack,game: e))
                .toList()));
  }
}
