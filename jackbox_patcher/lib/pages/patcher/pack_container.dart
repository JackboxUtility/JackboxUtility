import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jackbox_patcher/components/custom_server_component/custom_server_component_widget_factory.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game_patch.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack_patch.dart';
import 'package:jackbox_patcher/pages/patcher/pack_patch.dart';
import 'package:jackbox_patcher/services/api_utility/api_service.dart';

import '../../services/translations/translations_helper.dart';
import 'game_patch.dart';

class PatcherPackWidget extends StatefulWidget {
  const PatcherPackWidget({Key? key, required this.userPack}) : super(key: key);

  final UserJackboxPack userPack;
  @override
  State<PatcherPackWidget> createState() => _PatcherPackWidgetState();
}

class _PatcherPackWidgetState extends State<PatcherPackWidget> {
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
      if (await folder.exists() && mounted) {
        setState(() {
          pathFoundStatus = "FOUND";
        });
      } else {
        if (mounted) {
          setState(() {
            pathFoundStatus = "NOT_FOUND";
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [_buildHeader(), const SizedBox(height: 30), _buildGames()]);
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
                    imageUrl: APIService().assetLink(widget.userPack.pack.background),
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
                      colors: [Color.fromRGBO(39, 39, 39, 0.5), Color.fromRGBO(39, 39, 39, 1)],
                      stops: [0.0, 1.0])),
            ),
            Container(
              margin: const EdgeInsets.only(top: 140, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userPack.pack.name,
                    style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.userPack.pack.description,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
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
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        _buildPathMessage(),
        if (patchesComponentExist())
          Column(
            children: [
              const SizedBox(height: 20),
              CustomServerComponentWidgetFactory(
                  component: APIService()
                      .cachedServerMessage!
                      .patchesComponent!
                      .where((element) => element.packId == widget.userPack.pack.id)
                      .first
                      .component)
            ],
          )
      ],
    );
  }

  bool patchesComponentExist() {
    return APIService().cachedServerMessage != null &&
        APIService().cachedServerMessage!.patchesComponent != null &&
        APIService()
                .cachedServerMessage!
                .patchesComponent!
                .where((element) => element.packId == widget.userPack.pack.id)
                .length >
            0;
  }

  Widget _buildPathMessage() {
    if (pathFoundStatus == "LOADING") {
      return const ProgressRing();
    }
    if (pathFoundStatus == "FOUND") {
      return Container();
    }
    if (pathFoundStatus == "NOT_FOUND") {
      return InfoBar(
        severity: InfoBarSeverity.error,
        title: Text(TranslationsHelper().appLocalizations!.path_not_found),
        content: Text(TranslationsHelper().appLocalizations!.path_not_found_description),
      );
    }
    return InfoBar(
      severity: InfoBarSeverity.warning,
      title: Text(TranslationsHelper().appLocalizations!.path_inexistant),
      content: Text(TranslationsHelper().appLocalizations!.path_inexistant_description),
    );
  }

  Widget _buildGames() {
    List<Widget> gamesChildren = [];
    for (UserJackboxGame g in widget.userPack.games) {
      for (UserJackboxGamePatch p in g.patches) {
        gamesChildren.add(GamePatchCard(
          pack: widget.userPack,
          game: g,
          patch: p,
        ));
      }
    }

    List<Widget> packPatchChildren = [];
    for (UserJackboxPackPatch p in widget.userPack.patches) {
      packPatchChildren.add(PackPatch(
        pack: widget.userPack,
        patch: p,
      ));
    }
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(children: [
          Column(children: packPatchChildren),
          StaggeredGrid.count(mainAxisSpacing: 20, crossAxisSpacing: 20, crossAxisCount: 3, children: gamesChildren)
        ]));
  }

  Future<void> _showParametersDialog() async {
    await Navigator.pushNamed(context, "/settings/packs");
  }
}
