import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:jackbox_patcher/components/menu.dart';
import 'package:jackbox_patcher/pages/parameters/parameters.dart';
import 'package:jackbox_patcher/pages/patcher/packContainer.dart';
import 'package:jackbox_patcher/model/jackboxpack.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:jackbox_patcher/services/device/device.dart';
import 'package:jackbox_patcher/services/error/error.dart';
import 'package:jackbox_patcher/services/translations/translationsHelper.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/news.dart';

class MainContainer extends StatefulWidget {
  MainContainer({Key? key}) : super(key: key);

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedView = 0;
  bool _loaded = false;

  double calculatePadding() {
    if (MediaQuery.of(context).size.width > 1000) {
      return (MediaQuery.of(context).size.width - 880) / 2;
    } else {
      return 60;
    }
  }

  @override
  void initState() {
    _load();
    super.initState();
  }

  Widget build(BuildContext context) {
    TranslationsHelper().appLocalizations = AppLocalizations.of(context);
    return NavigationView(
        content: Stack(children: [
      _loaded
          ? Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                  onTap: () {
                    _openNotificationsWindow();
                  },
                  child: Icon(
                      APIService().cachedNews[0].id ==
                              UserData().getLastNewsReaden()
                          ? FluentIcons.ringer
                          : FluentIcons.ringer_active,
                      color: Colors.white,
                      size: 30)))
          : Container(),
      Column(children: [
        Expanded(
          child: _buildUpper(),
        ),
        _buildLower(),
      ])
    ]));
  }

  void _openNotificationsWindow() {
    UserData().setLastNewsReaden(APIService().cachedNews[0].id);
    showDialog(
        context: context,
        builder: (context) => ContentDialog(
                title: Text(AppLocalizations.of(context)!.notifications),
                content: ListView(
                    children: List.generate(
                            APIService().cachedNews.length,
                            (index) => _buildNotificationWidget(
                                APIService().cachedNews[index]))
                        .expand((w) => [w, SizedBox(height: 10)])
                        .toList()),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.close))
                ])).then((value) => setState(() {}));
  }

  Widget _buildNotificationWidget(News news) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => ContentDialog(
                          title: Text(news.title),
                          content: Markdown(
                              data: news.content,
                              onTapLink: (text, href, title) =>
                                  launchUrl(Uri.parse(href!))),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child:
                                    Text(AppLocalizations.of(context)!.close))
                          ]));
            },
            child: Container(
                color: FluentTheme.of(context).cardColor,
                width: 300,
                height: 100,
                child: Row(children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: Image.network(APIService().assetLink(news.image)),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 200,
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(news.title,
                            style: FluentTheme.of(context).typography.subtitle),
                        Text(news.smallDescription)
                      ],
                    ),
                  )
                ]))));
  }

  Widget _buildUpper() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      _loaded ? _buildConnectedServer() : Container(),
      Expanded(child: Container()),
      _buildTitle(),
      SizedBox(
        height: 30,
      ),
      _loaded
          ? _buildMenu()
          : LottieBuilder.asset("assets/lotties/QuiplashOutput.json",
              width: 200, height: 200),
      Expanded(child: Container()),
    ]);
  }

  Widget _buildMenu() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: calculatePadding()),
        child: Column(children: [
          MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FilledButton(
                  style: ButtonStyle(
                      backgroundColor: ButtonState.all(Colors.green),
                      shape: ButtonState.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)))),
                  onPressed: () {
                    Navigator.pushNamed(context, "/searchMenu");
                  },
                  child: Container(
                      width: 300,
                      height: 20,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(FluentIcons.play, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                                AppLocalizations.of(context)!
                                    .launch_search_game,
                                style: TextStyle(color: Colors.white))
                          ])))),
          SizedBox(height: 10),
          !DeviceService.isWeb()
              ? MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: FilledButton(
                      style: ButtonStyle(
                          backgroundColor: ButtonState.all(Colors.blue),
                          shape: ButtonState.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)))),
                      onPressed: () {
                        Navigator.pushNamed(context, "/patch");
                      },
                      child: Container(
                          width: 300,
                          height: 20,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FluentIcons.download, color: Colors.white),
                                SizedBox(width: 10),
                                Text(AppLocalizations.of(context)!.patch_a_game,
                                    style: TextStyle(color: Colors.white))
                              ]))))
              : SizedBox(height: 0),
          SizedBox(height: 30),
          !DeviceService.isWeb()
              ? MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: FilledButton(
                      style: ButtonStyle(
                          backgroundColor: ButtonState.all(Colors.grey),
                          shape: ButtonState.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)))),
                      onPressed: () {
                        Navigator.pushNamed(context, "/settings",
                            arguments: UserData().packs);
                      },
                      child: Container(
                          width: 300,
                          height: 20,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FluentIcons.settings, color: Colors.white),
                                SizedBox(width: 10),
                                Text(AppLocalizations.of(context)!.settings,
                                    style: TextStyle(color: Colors.white))
                              ]))))
              : SizedBox(height: 0)
        ]));
  }

  Widget _buildConnectedServer() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(AppLocalizations.of(context)!
          .connected_to_server(APIService().cachedSelectedServer!.name)),
      SizedBox(width: 10),
      GestureDetector(
        child: Text(AppLocalizations.of(context)!.connected_to_server_change,
            style: TextStyle(decoration: TextDecoration.underline)),
        onTap: () async {
          await Navigator.pushNamed(context, "/serverSelect");
          print("Resetting cache");
          UserData().packs = [];
          APIService().resetCache();
          _loaded = false;
          setState(() {});
          _load();
        },
      )
    ]);
  }

  Widget _buildTitle() {
    return Column(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: _loaded? Image.network(APIService().assetLink(APIService().cachedSelectedServer!.image), height: 100): Image.asset(
             "assets/logo.png",
            height: 100,
          )),
      Text(_loaded? APIService().cachedSelectedServer!.name: AppLocalizations.of(context)!.jackbox_utility,
          style: FluentTheme.of(context).typography.titleLarge)
    ]);
  }

  Widget _buildLower() {
    return Container();
  }

  void _load() async {
    print("Load");
    await UserData().init();
    if (UserData().getSelectedServer() == null) {
      await Navigator.pushNamed(context, "/serverSelect");
    }
    try {
      await _loadInfo();
      await _loadWelcome();
      await _loadPacks();
    } catch (e) {
      ErrorService.showError(
          context, AppLocalizations.of(context)!.connection_to_server_failed,
          duration: Duration(minutes: 5));
      rethrow;
    }
    setState(() {
      _loaded = true;
    });
  }

  Future<void> _loadInfo() async {
    await UserData().syncInfo();
  }

  Future<void> _loadWelcome() async {
    await UserData().syncWelcomeMessage();
  }

  Future<void> _loadPacks() async {
    await UserData().syncPacks();
  }
}
