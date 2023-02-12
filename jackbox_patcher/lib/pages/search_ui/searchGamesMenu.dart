import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';
import 'package:jackbox_patcher/pages/search_ui/searchGames.dart';

import '../../model/usermodel/userjackboxpack.dart';
import '../../services/api/api_service.dart';
import '../../services/user/userdata.dart';

class SearchGameMenuWidget extends StatefulWidget {
  SearchGameMenuWidget({Key? key}) : super(key: key);

  @override
  State<SearchGameMenuWidget> createState() => _SearchGameMenuWidgetState();
}

class _SearchGameMenuWidgetState extends State<SearchGameMenuWidget> {
     int _selectedView = 0;
  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    return NavigationView(
      appBar: NavigationAppBar(
          automaticallyImplyLeading: false,leading:GestureDetector(child: Icon(FluentIcons.chevron_left), onTap: () => Navigator.pop(context),), title: Text("Rechercher un jeu", style: typography.title,)),
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
    ];
    List<NavigationPaneItem> packItems = [];
    for (var userPack in UserData().packs) {
        packItems.add(PaneItem(
            icon: Image.network(APIService().assetLink(userPack.pack.icon)),
            title: Text(userPack.pack.name),
            body: SearchGameWidget(
              filter: (UserJackboxPack pack, UserJackboxGame game) => pack.pack.id == userPack.pack.id,
              comeFromGame: false,
              background: APIService().assetLink(userPack.pack.background),
              name:userPack.pack.name,
              description: userPack.pack.description,
              icon: userPack.pack.icon,
            )));
      
    }

    if (UserData().packs.isNotEmpty) {
      items.add(PaneItemExpander(
        icon: Icon(FluentIcons.gift_box_solid),
        body: Container(),
        title: Text("Recherche par pack"),
        items: packItems,
      ));
    }

    return items;
  }
}