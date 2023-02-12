import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/jackboxgame.dart';
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
  late TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    return NavigationView(
      appBar: NavigationAppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            child: Icon(FluentIcons.chevron_left),
            onTap: () => Navigator.pop(context),
          ),
          title: Text(
            "Rechercher un jeu",
            style: typography.title,
          )),
      pane: NavigationPane(
        onChanged: (int nSelected) {
          setState(() {
            _searchController.text = "";
            _selectedView = nSelected;
          });
        },
        selected: _selectedView,
        items: _buildPaneItems(),
      ),
    );
  }

  _buildPaneItems() {
    List<NavigationPaneItem> items = [];
    List<NavigationPaneItem> packItems = [];
    for (var userPack in UserData().packs) {
      packItems.add(PaneItem(
          icon: Image.network(APIService().assetLink(userPack.pack.icon)),
          title: Text(userPack.pack.name),
          body: SearchGameWidget(
            filter: (UserJackboxPack pack, UserJackboxGame game) =>
                pack.pack.id == userPack.pack.id &&
                game.game.name.toLowerCase().contains(_searchController.text.toLowerCase()),
            comeFromGame: false,
            background: APIService().assetLink(userPack.pack.background),
            name: userPack.pack.name,
            description: userPack.pack.description,
            icon: userPack.pack.icon,
          )));
    }

    List<NavigationPaneItem> typeItem = [];
    for (var type in JackboxGameType.values) {
      typeItem.add(PaneItem(
          icon: Container(),
          title: Text(type.name),
          body: SearchGameWidget(
            filter: (UserJackboxPack pack, UserJackboxGame game) =>
                game.game.info.type == type &&
                game.game.name.toLowerCase().contains(_searchController.text.toLowerCase()),
            comeFromGame: false,
            background: APIService().getDefaultBackground(),
            name: type.name,
            description: type.description,
            icon: null,
          )));
    }

    List<NavigationPaneItem> translationItem = [];
    for (var translation in JackboxGameTranslation.values) {
      translationItem.add(PaneItem(
          icon: Container(),
          title: Text(translation.name),
          body: SearchGameWidget(
            filter: (UserJackboxPack pack, UserJackboxGame game) =>
                game.game.info.translation == translation &&
                game.game.name.toLowerCase().contains(_searchController.text.toLowerCase()),
            comeFromGame: false,
            background: APIService().getDefaultBackground(),
            name: translation.name,
            description: translation.description,
            icon: null,
          )));
    }

    List<NavigationPaneItem> tagItem = [];
    for (var tag in APIService().getTags()) {
      tagItem.add(PaneItem(
          icon: Container(),
          title: Text(tag.name),
          body: SearchGameWidget(
            filter: (UserJackboxPack pack, UserJackboxGame game) =>
                game.game.info.tags.where((t) => t.id == tag.id).isNotEmpty &&
                game.game.name.toLowerCase().contains(_searchController.text.toLowerCase()),
            comeFromGame: false,
            background: APIService().getDefaultBackground(),
            name: tag.name,
            description: tag.description,
            icon: null,
          )));
    }

    if (UserData().packs.isNotEmpty) {
      items.add(PaneItemSeparator());
      items.add(PaneItemHeader(
          header: TextBox(
        placeholder: "Rechercher",
        suffix: Icon(FluentIcons.search),
        controller: _searchController,
        onEditingComplete: () {
          setState(() {});
        },
      )));
      items.add(PaneItemSeparator());
      items.add(PaneItem(
          icon: Icon(FluentIcons.game),
          title: Text("Tous les jeux"),
          body: SearchGameWidget(
            filter: (UserJackboxPack pack, UserJackboxGame game) =>
                game.game.name.toLowerCase().contains(_searchController.text.toLowerCase()),
            comeFromGame: false,
            background: APIService().getDefaultBackground(),
            name: "Tous les jeux",
            description:
                "Retrouvez tous les jeux Jackbox à un seul et même endroit !",
            icon: null,
          )));
      items.add(PaneItemExpander(
        icon: Icon(FluentIcons.gift_box_solid),
        body: Container(),
        title: Text("Recherche par pack"),
        items: packItems,
        onTap: () {
          setState(() {
            _selectedView = 2;
          });
        },
      ));

      items.add(PaneItemExpander(
        icon: Icon(FluentIcons.people),
        body: Container(),
        title: Text("Recherche par type"),
        items: typeItem,
        onTap: () {
          setState(() {
            _selectedView = 3 + packItems.length;
          });
        },
      ));

      items.add(PaneItemExpander(
        icon: Icon(FluentIcons.translate),
        body: Container(),
        title: Text("Recherche par traduction"),
        items: translationItem,
        onTap: () {
          setState(() {
            _selectedView = 4 + packItems.length + typeItem.length;
          });
        },
      ));

      items.add(PaneItemExpander(
        icon: Icon(FluentIcons.tag),
        body: Container(),
        title: Text("Recherche par tags"),
        items: tagItem,
        onTap: () {
          setState(() {
            _selectedView =
                5 + packItems.length + typeItem.length + translationItem.length;
          });
        },
      ));
    }

    return items;
  }
}
