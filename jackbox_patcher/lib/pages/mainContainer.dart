import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:jackbox_patcher/components/dialogs/leaveApplicationDialog.dart';
import 'package:jackbox_patcher/components/menu.dart';
import 'package:jackbox_patcher/model/patchserver.dart';
import 'package:jackbox_patcher/pages/parameters/packs.dart';
import 'package:jackbox_patcher/pages/patcher/packContainer.dart';
import 'package:jackbox_patcher/model/jackboxpack.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:jackbox_patcher/services/device/device.dart';
import 'package:jackbox_patcher/services/downloader/downloader_service.dart';
import 'package:jackbox_patcher/services/error/error.dart';
import 'package:jackbox_patcher/services/translations/translationsHelper.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:window_manager/window_manager.dart';

import '../components/dialogs/automaticGameFinderDialog.dart';
import '../model/news.dart';
import '../services/automaticGameFinder/AutomaticGameFinder.dart';

class MainContainer extends StatefulWidget {
  MainContainer({Key? key}) : super(key: key);

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> with WindowListener {
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
    windowManager.addListener(this);
    _load(true);
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
      Container(),
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
                      onPressed: () async{
                        await Navigator.pushNamed(context, "/settings",
                            arguments: UserData().packs);
                        if (APIService().cachedSelectedServer!=null){
                          _loaded = false;
                          setState(() {});
                          _load(false);
                        }
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
          UserData().setSelectedServer(null);
          UserData().packs = [];
          APIService().resetCache();
          
        },
      )
    ]);
  }

  Widget _buildTitle() {
    return Column(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: _loaded
              ? Image.network(
                  APIService()
                      .assetLink(APIService().cachedSelectedServer!.image),
                  height: 100)
              : Image.asset(
                  "assets/logo.png",
                  height: 100,
                )),
      Text(
          _loaded
              ? APIService().cachedSelectedServer!.name
              : AppLocalizations.of(context)!.jackbox_utility,
          style: FluentTheme.of(context).typography.titleLarge)
    ]);
  }

  Widget _buildLower() {
    return Container();
  }

  void _load(bool automaticallyChooseBestServer) async {
    print("Loading");
    bool changedServer = false;
    bool automaticGameFindNotificationAvailable = false;
    await windowManager.setPreventClose(true);
    await UserData().init();
    if (UserData().getSelectedServer() == null) {
      if (automaticallyChooseBestServer) {
        await findBestServer();
      } else {
        await Navigator.pushNamed(context, "/serverSelect");
        automaticGameFindNotificationAvailable = true;
      }
      changedServer = true;
      print("ChangedServer");
    }
    try {
      await _loadInfo();
      await _loadWelcome();
      await _loadPacks();
      if (changedServer)
        await _launchAutomaticGameFinder(
            automaticGameFindNotificationAvailable);
    } catch (e) {
      InfoBarService.showError(
          context, AppLocalizations.of(context)!.connection_to_server_failed,
          duration: Duration(minutes: 5));
      rethrow;
    }
    setState(() {
      _loaded = true;
    });
  }

  Future<void> findBestServer() async {
    String locale = Platform.localeName;
    print(locale);
    await APIService().recoverAvailableServers();
    List<PatchServer> servers = APIService().cachedServers;
    print(servers);
    for (var server in servers) {
      print(server.languages);
      if (server.languages.where((e) => locale.startsWith(e)).length > 0) {
        print("Found server");
        await UserData().setSelectedServer(server.infoUrl);
        InfoBarService.showInfo(context, AppLocalizations.of(context)!.automatic_server_finder_found,
            AppLocalizations.of(context)!.automatic_server_finder_found_description(server.name));
        return;
      }
    }
    await Navigator.pushNamed(context, "/serverSelect");
  }

  Future<void> createVersionFile() async{
    if (!File("jackbox_patcher.version").existsSync()) {
      File("jackbox_patcher.version").createSync();
    }
    var packageInfo = (await PackageInfo.fromPlatform());
    File("jackbox_patcher.version").writeAsString(packageInfo.version+"+"+packageInfo.buildNumber);
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

  Future<void> _showAutomaticGameFinderDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AutomaticGameFinderDialog();
        });
  }

  Future<void> _launchAutomaticGameFinder(bool showNotification) async {
    int gamesFound =
        await AutomaticGameFinderService.findGames(UserData().packs);
    if (showNotification) {
      InfoBarService.showInfo(
          context,
          AppLocalizations.of(context)!.automatic_game_finder_title,
          AppLocalizations.of(context)!
              .automatic_game_finder_finish(gamesFound));
    }
  }

  @override
  void onWindowClose() async {
    bool _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {
      bool shouldClose = DownloaderService.isDownloading
          ? await (showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return LeaveApplicationDialog();
                  })) ==
              true
          : true;
      if (shouldClose) {
        windowManager.destroy();
      }
    }
  }
}
