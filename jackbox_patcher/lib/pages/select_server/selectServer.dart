import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/model/patchserver.dart';
import 'package:jackbox_patcher/services/api_utility/api_service.dart';
import 'package:jackbox_patcher/services/error/error.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';
import 'package:lottie/lottie.dart';

import '../../components/dialogs/customServerDialog.dart';
import '../../services/translations/translationsHelper.dart';

class SelectServerPage extends StatefulWidget {
  const SelectServerPage({Key? key}) : super(key: key);

  @override
  State<SelectServerPage> createState() => _SelectServerPageState();
}

class _SelectServerPageState extends State<SelectServerPage> {
  List<PatchServer> servers = [];

  @override
  void initState() {
    _load();
    super.initState();
  }

  void _load() async {
    try {
      await APIService().recoverAvailableServers();
    } catch (e) {
      InfoBarService.showError(
          context,
          TranslationsHelper()
              .appLocalizations!
              .connection_to_main_server_failed);
      rethrow;
    }
    servers = APIService().cachedServers;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
        content: ListView(
      children: [
        Column(children: [
          const SizedBox(height: 20),
          Text(TranslationsHelper().appLocalizations!.select_server_subtitle,
              style: FluentTheme.of(context).typography.title),
        ]),
        const SizedBox(height: 20),
        servers.length != 0? Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: StaggeredGrid.count(
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                crossAxisCount: 4,
                children: List.generate(
                    servers.length, (index) => _buildServerCard(servers[index]))
                  ..add(_buildAddServerCard()))): _buildLoadingServers(),
      ],
    ));
  }

  Widget _buildLoadingServers() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(height: 20),
      LottieBuilder.asset("assets/lotties/QuiplashOutput.json",
                  width: 120, height: 120, fit: BoxFit.fitWidth),
      Text(
        TranslationsHelper().appLocalizations!.select_server_loading, textAlign: TextAlign.center, style: FluentTheme.of(context).typography.subtitle,
      )
    ]);
  }

  Widget _buildServerCard(PatchServer server) {
    return Container(
        child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            height: 200,
            margin: const EdgeInsets.only(top: 25),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Acrylic(
                    shadowColor: const Color.fromARGB(255, 48, 48, 48),
                    blurAmount: 1,
                    tintAlpha: 1,
                    tint: const Color.fromARGB(255, 48, 48, 48),
                    child: Stack(children: [
                      Container(
                          padding: const EdgeInsets.only(bottom: 12),
                          margin: const EdgeInsets.only(top: 50),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Column(children: [
                                    Text(server.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 25)),
                                    const SizedBox(height: 10),
                                    Text(
                                      server.description,
                                    ),
                                    Expanded(child: Container()),
                                    _buildRowButtons(server)
                                  ]),
                                ))
                              ])),
                    ])))),
        _buildServerImage(server),
      ],
    ));
  }

  Widget _buildServerImage(PatchServer server) {
    return SizedBox(
        height: 75,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: IntrinsicWidth(
                      child: CachedNetworkImage(
                    imageUrl: server.image,
                    fit: BoxFit.contain,
                  )))
            ])));
  }

  Widget _buildAddServerCard() {
    return Container(
        child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            height: 200,
            margin: const EdgeInsets.only(top: 25),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Acrylic(
                  shadowColor: const Color.fromARGB(255, 48, 48, 48),
                  blurAmount: 1,
                  tintAlpha: 1,
                  tint: Color.fromARGB(255, 35, 35, 35),
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(
                        color: Color.fromARGB(255, 48, 48, 48),
                        width: 2,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Container(
                      padding: const EdgeInsets.only(bottom: 12),
                      margin: const EdgeInsets.only(top: 50),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(children: [
                                Text(TranslationsHelper().appLocalizations!.custom_server_title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 25)),
                                const SizedBox(height: 10),
                                Text(
                                  TranslationsHelper().appLocalizations!.custom_server_description,
                                  textAlign: TextAlign.center,
                                ),
                                Expanded(child: Container()),
                                _buildAddServerRowButtons()
                              ]),
                            ))
                          ])),
                ))),
        _buildAddServerImage(),
      ],
    ));
  }

  Widget _buildAddServerImage() {
    return SizedBox(
        height: 75,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(child: Icon(FontAwesomeIcons.gear, size: 34,), margin: EdgeInsets.only(top:24),)
            ])));
  }

  Widget _buildAddServerRowButtons() {
    return Row(children: [
      Expanded(
          child: Button(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) => CustomServerDialog());
              },
              child: Text(
                  TranslationsHelper().appLocalizations!.select_server_button)))
    ]);
  }

  Widget _buildRowButtons(PatchServer server) {
    return Row(children: [
      Expanded(
          child: Button(
              onPressed: () async {
                await chooseServer(server);
                Navigator.pop(context);
              },
              child: Text(
                  TranslationsHelper().appLocalizations!.select_server_button)))
    ]);
  }

  Future<void> chooseServer(PatchServer server) async {
    await UserData().setSelectedServer(server.infoUrl);
  }
}
