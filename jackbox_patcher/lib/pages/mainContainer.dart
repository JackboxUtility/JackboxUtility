import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/menu.dart';
import 'package:jackbox_patcher/pages/parameters/parameters.dart';
import 'package:jackbox_patcher/pages/patcher/pack.dart';
import 'package:jackbox_patcher/model/jackboxpack.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';

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
        content: Column(children: [
      Expanded(
        child: _buildUpper(),
      ),
      _buildLower(),
    ]));
  }

  Widget _buildUpper() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      _buildTitle(),
      SizedBox(
        height: 30,
      ),
      _buildMenu(),
    ]);
  }

  Widget _buildMenu() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: calculatePadding()),
        child: Column(children: [
          FilledButton(
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
                      ]))),
          SizedBox(height: 10),
          FilledButton(
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
                      ]))),
          SizedBox(height: 30),
          FilledButton(
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
                      ])))
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
      Text("Jackbox Patcher",
          style: FluentTheme.of(context).typography.titleLarge)
    ]);
  }

  Widget _buildLower() {
    return Column(children: []);
  }

  // @override
  // Widget build(BuildContext context) {
  //   return NavigationView(
  //     appBar: NavigationAppBar(
  //         automaticallyImplyLeading: false, title: Text("Jackbox Patcher")),
  //     pane: NavigationPane(
  //       onChanged: (int nSelected) {
  //         setState(() {
  //           _selectedView = nSelected;
  //         });
  //       },
  //       selected: _selectedView,
  //       items: _buildPaneItems(),
  //     ),
  //   );
  // }

  // _buildPaneItems() {
  //   List<NavigationPaneItem> items = [
  //     PaneItem(
  //         icon: Icon(FluentIcons.home),
  //         title: Text("Menu"),
  //         body: Center(
  //           child: _loaded ? MenuWidget() : Text("Chargement..."),
  //         )),
  //   ];

  //   items.add(PaneItem(
  //     icon: Icon(FluentIcons.play),
  //     body: Container(),
  //     title: Text("Lancement rapide"),
  //   ));
  //   List<NavigationPaneItem> patchingItems = [];
  //   for (var userPack in UserData().packs) {
  //     int countPatchs = 0;
  //     for (var games in userPack.games) {
  //       for (var patch in games.patches) {
  //         countPatchs = 1;
  //         break;
  //       }
  //     }
  //     if (countPatchs == 1) {
  //       patchingItems.add(PaneItem(
  //           icon: Image.network(APIService().assetLink(userPack.pack.icon)),
  //           title: Text(userPack.pack.name),
  //           body: PatcherPackWidget(userPack: userPack)));
  //     }
  //   }
  //   if (UserData().packs.isNotEmpty) {
  //     items.add(PaneItemExpander(
  //       icon: Icon(FluentIcons.list),
  //       body: Container(),
  //       title: Text("Liste des patchs français"),
  //       items: patchingItems,
  //     ));
  //   }

  //   items.add(PaneItem(
  //           icon: Icon(FluentIcons.settings),
  //           title: Text("Paramètres"),
  //           body: ParametersWidget(packs:UserData().packs)));
  //   return items;
  // }

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
