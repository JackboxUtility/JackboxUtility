import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:jackbox_patcher/components/pack.dart';
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

  @override
  void initState() {
    _loadPacks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
          automaticallyImplyLeading: false, title: Text("Jackbox Patcher")),
      pane: NavigationPane(
        onChanged: (int nSelected) {
          setState(() {
            _selectedView = nSelected;
          });
        },
        selected: _selectedView,
        items: _buildPaneItems(),
      ),
    );
  }

  _buildPaneItems() {
    List<NavigationPaneItem> items = [
      PaneItem(
          icon: Icon(FluentIcons.home),
          title: Text("Menu"),
          body: Center(
            child: Text(_loaded ? "Menu" : "Chargement..."),
          )),
    ];
    if (UserData().packs.isNotEmpty) {
      items.add(PaneItemHeader(
        header: Text("Packs"),
      ));
    }
    for (var userPack in UserData().packs) {
      items.add(PaneItem(
          icon: Image.network(APIService().assetLink(userPack.pack.icon)),
          title: Text(userPack.pack.name),
          body: PackWidget(userPack: userPack)));
    }
    return items;
  }

  Future<void> _loadPacks() async {
    await UserData().syncPacks();
    setState(() {
      _loaded = true;
    });
  }
}
