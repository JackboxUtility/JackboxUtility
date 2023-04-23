import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jackbox_patcher/model/patchserver.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:jackbox_patcher/services/error/error.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';

class SelectServerPage extends StatefulWidget {
  SelectServerPage({Key? key}) : super(key: key);

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
      InfoBarService.showError(context,
          AppLocalizations.of(context)!.connection_to_main_server_failed);
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
          SizedBox(height: 20),
          Text(AppLocalizations.of(context)!.select_server_title,
              style: FluentTheme.of(context).typography.title),
          Text(AppLocalizations.of(context)!.select_server_subtitle,
              style: FluentTheme.of(context).typography.subtitle),
        ]),
        SizedBox(height: 20),
        Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: StaggeredGrid.count(
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                crossAxisCount: 4,
                children: List.generate(servers.length,
                    (index) => _buildServerCard(servers[index]))))
      ],
    ));
  }

  Widget _buildServerCard(PatchServer server) {
    return Container(
        child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            height: 200,
            margin: EdgeInsets.only(top: 25),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Acrylic(
                    shadowColor: Color.fromARGB(255, 48, 48, 48),
                    blurAmount: 1,
                    tintAlpha: 1,
                    tint: Color.fromARGB(255, 48, 48, 48),
                    child: Stack(children: [
                      Container(
                          padding: EdgeInsets.only(bottom: 12),
                          margin: EdgeInsets.only(top: 50),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Column(children: [
                                    Text(server.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 25)),
                                    SizedBox(height: 10),
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
            padding: EdgeInsets.all(8),
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

  Widget _buildRowButtons(PatchServer server) {
    return Row(children: [
      Expanded(
          child: Button(
              onPressed: () async {
                await chooseServer(server);
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.select_server_button)))
    ]);
  }

  Future<void> chooseServer(PatchServer server) async {
    await UserData().setSelectedServer(server.infoUrl);
  }
}
