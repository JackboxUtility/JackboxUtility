import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/jackbox/jackboxgame.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';
import 'package:jackbox_patcher/pages/search_ui/searchGames.dart';
import 'package:jackbox_patcher/services/translations/language_service.dart';

import '../../model/usermodel/userjackboxpack.dart';
import '../../services/api/api_service.dart';
import '../../services/user/userdata.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchGameMenuWidget extends StatefulWidget {
  SearchGameMenuWidget({Key? key}) : super(key: key);

  @override
  State<SearchGameMenuWidget> createState() => _SearchGameMenuWidgetState();
}

class _SearchGameMenuWidgetState extends State<SearchGameMenuWidget> {
  int _selectedView = 0;
  late TextEditingController _searchController;
  bool showAllPacks = false;

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
            AppLocalizations.of(context)!.search_game,
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
          footerItems: [
            PaneItem(
              icon: Icon(FluentIcons.package),
              title: Text(showAllPacks == false
                  ? AppLocalizations.of(context)!.show_all_packs
                  : AppLocalizations.of(context)!.show_owned_packs_only),
              body: Container(),
              onTap: () {
                setState(() {
                  showAllPacks = !showAllPacks;
                  _selectedView = 0;
                });
              },
            )
          ]),
    );
  }

  _buildPaneItems() {
    List<NavigationPaneItem> items = [];
    List<NavigationPaneItem> packItems = [];
    List<UserJackboxPack> wantedPacks = [];
    if (showAllPacks) {
      wantedPacks = UserData().packs;
    } else {
      wantedPacks = UserData().packs.where((element) => element.owned).toList();
    }
    for (var userPack in wantedPacks) {
      packItems.add(PaneItem(
          icon: CachedNetworkImage(imageUrl: APIService().assetLink(userPack.pack.icon), fit: BoxFit.fitHeight, height:50, memCacheHeight: 50),
          title: Text(userPack.pack.name),
          body: SearchGameWidget(
            filter: (UserJackboxPack pack, UserJackboxGame game) =>
                pack.pack.id == userPack.pack.id &&
                game.game.name
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()),
            comeFromGame: false,
            showAllPacks: showAllPacks,
            background: userPack.pack.background,
            name: userPack.pack.name,
            description: userPack.pack.description,
            icon: userPack.pack.icon,
          )));
    }

    List<NavigationPaneItem> typeItem = [];

    List<NavigationPaneItem> tagItem = [];

    for (var type in JackboxGameType.values) {
      tagItem.add(PaneItem(
          icon: Container(),
          title: Text(type.name),
          body: SearchGameWidget(
            filter: (UserJackboxPack pack, UserJackboxGame game) =>
                game.game.info.type == type &&
                game.game.name
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()) &&
                (showAllPacks || pack.owned),
            comeFromGame: false,
            background: APIService().getDefaultBackground(),
            name: type.name,
            description: type.description,
            showAllPacks: showAllPacks,
            icon: null,
          )));
    }

    for (var tag in APIService().getTags()) {
      tagItem.add(PaneItem(
          icon: Container(),
          title: Text(tag.name),
          body: SearchGameWidget(
            filter: (UserJackboxPack pack, UserJackboxGame game) =>
                game.game.info.tags.where((t) => t.id == tag.id).isNotEmpty &&
                game.game.name
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()) &&
                (showAllPacks || pack.owned),
            comeFromGame: false,
            background: APIService().getDefaultBackground(),
            name: tag.name,
            description: tag.description,
            showAllPacks: showAllPacks,
            icon: null,
          )));
    }

    if (UserData().packs.isNotEmpty) {
      items.add(PaneItemSeparator());
      items.add(PaneItemHeader(
          header: TextBox(
        placeholder: AppLocalizations.of(context)!.search,
        suffix: Icon(FluentIcons.search),
        controller: _searchController,
        onEditingComplete: () {
          setState(() {});
        },
      )));
      items.add(PaneItemSeparator());
      items.add(PaneItem(
          icon: Icon(FluentIcons.game),
          title: Text(AppLocalizations.of(context)!.all_games),
          body: SearchGameWidget(
            filter: (UserJackboxPack pack, UserJackboxGame game) =>
                game.game.name
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()) &&
                (showAllPacks || pack.owned),
            comeFromGame: false,
            background: APIService().getDefaultBackground(),
            name: AppLocalizations.of(context)!.all_games,
            description: AppLocalizations.of(context)!.all_games_description,
            showAllPacks: showAllPacks,
            icon: null,
          )));
      items.add(PaneItemExpander(
        icon: Icon(FluentIcons.gift_box_solid),
        body: Container(),
        title: Text(AppLocalizations.of(context)!.search_by_pack),
        items: packItems,
        onTap: () {
          setState(() {
            _selectedView = 2;
          });
        },
      ));

      // items.add(PaneItemExpander(
      //   icon: Icon(FluentIcons.people),
      //   body: Container(),
      //   title: Text(AppLocalizations.of(context)!.search_by_type),
      //   items: typeItem,
      //   onTap: () {
      //     setState(() {
      //       _selectedView = 3 + packItems.length;
      //     });
      //   },
      // ));

      List<NavigationPaneItem> translationItem = _buildTranlationPaneItem();

      items.add(PaneItemExpander(
        icon: Icon(FluentIcons.translate),
        body: Container(),
        title: Text(AppLocalizations.of(context)!.search_by_translation),
        items: translationItem,
        onTap: () {
          setState(() {
            _selectedView = 3 + packItems.length + typeItem.length;
          });
        },
      ));

      items.add(PaneItemExpander(
        icon: Icon(FluentIcons.tag),
        body: Container(),
        title: Text(AppLocalizations.of(context)!.search_by_tags),
        items: tagItem,
        onTap: () {
          setState(() {
            _selectedView =
                4 + packItems.length + typeItem.length + translationItem.length;
          });
        },
      ));
    }

    return items;
  }

  List<NavigationPaneItem> _buildTranlationPaneItem(){
    List<NavigationPaneItem> translationItem = [];

    // Adding each translation values
    for (var translation in JackboxGameTranslationCategory.values) {
      translationItem.add(PaneItem(
          icon: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: translation.color ),width:10, height:10),
          title: Text(translation.name),
          body: SearchGameWidget(
            filter: (UserJackboxPack pack, UserJackboxGame game) =>
                translation.filter(pack,game) &&
                game.game.name
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()) &&
                (showAllPacks || pack.owned),
            showAllPacks: showAllPacks,
            comeFromGame: false,
            background: APIService().getDefaultBackground(),
            name: translation.name,
            description: translation.description,
            icon: null,
          )));
    }
    return translationItem;

    
  }
}
