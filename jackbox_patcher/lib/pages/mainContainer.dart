import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/menu.dart';
import 'package:jackbox_patcher/pages/parameters/parameters.dart';
import 'package:jackbox_patcher/pages/patcher/pack.dart';
import 'package:jackbox_patcher/model/jackboxpack.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';
import 'package:lottie/lottie.dart';

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
    return NavigationView(
        content: Stack(children: [ 
          Positioned(child: GestureDetector(
            onTap: () {
              _openNotificationsWindow();
            },
            child: Icon(FluentIcons.ringer, color: Colors.white, size:30)), top: 10, right: 10),
         Column(children: [
      Expanded(
        child: _buildUpper(),
      ),
      _buildLower(),
    ])]));
  }

  void _openNotificationsWindow(){
    showDialog(context: context, builder: (context) => ContentDialog(
      title: Text("Notifications"),
      content: ListView(children: List.generate(APIService().cachedNews.length, (index) => _buildNotificationWidget(APIService().cachedNews[index]))),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Fermer"))]
    )
    );
  }

  Widget _buildNotificationWidget(News news){
    return Container(
      width: 300,
      height: 100,
      child: Row(children: [
        Container(
          width: 100,
          height: 100,
          child: Image.network(APIService().assetLink(news.image)),
        ),
        Container(
          width: 200,
          height: 100,
          child: Column(children: [
            Text(news.title),
            Text(news.smallDescription)
          ],),
        )
      ],),
    );
  }

  Widget _buildUpper() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      _buildTitle(),
      SizedBox(
        height: 30,
      ),
      _loaded
          ? _buildMenu()
          : LottieBuilder.asset("assets/lotties/QuiplashOutput.json",
              width: 200, height: 200),
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
                            Text("Lancer / Rechercher un jeu",
                                style: TextStyle(color: Colors.white))
                          ])))),
          SizedBox(height: 10),
          MouseRegion(
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
                            Text("Patcher un jeu",
                                style: TextStyle(color: Colors.white))
                          ])))),
          SizedBox(height: 30),
          MouseRegion(
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
                            Text("Paramètres",
                                style: TextStyle(color: Colors.white))
                          ]))))
        ]));
  }

  Widget _buildTitle() {
    return Column(children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            "assets/logo.png",
            height: 100,
          )),
      Text("Jackbox Utility",
          style: FluentTheme.of(context).typography.titleLarge)
    ]);
  }

  Widget _buildLower() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/logos/discord-mark-white.png", height: 30),
        ],
      )
    ]);
  }

  void _load() async {
    await _loadWelcome();
    await _loadPacks();
    setState(() {
      _loaded = true;
    });
  }

  Future<void> _loadWelcome() async {
    await UserData().syncWelcomeMessage();
  }

  Future<void> _loadPacks() async {
    await UserData().syncPacks();
  }
}
