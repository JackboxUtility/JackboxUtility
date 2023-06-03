import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/components/closableRouteWithEsc.dart';
import 'package:jackbox_patcher/components/starsRate.dart';
import 'package:jackbox_patcher/model/jackbox/jackboxgame.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';
import 'package:jackbox_patcher/pages/search_ui/searchGames.dart';
import 'package:jackbox_patcher/services/discord/DiscordService.dart';

import '../../model/usermodel/userjackboxpack.dart';
import '../../services/api/api_service.dart';
import '../../services/user/userdata.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchGameMenuWidget extends StatefulWidget {
  const SearchGameMenuWidget({Key? key}) : super(key: key);

  @override
  State<SearchGameMenuWidget> createState() => _SearchGameMenuWidgetState();
}

class _SearchGameMenuWidgetState extends State<SearchGameMenuWidget> {
  int _selectedView = 0;
  late TextEditingController _searchController;
  bool showAllPacks = false;
  bool showHidden = false;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    return ClosableRouteWithEsc(
        child: NavigationView(
      appBar: NavigationAppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            child: const Icon(FluentIcons.chevron_left),
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
            if (UserJackboxGame.countHiddenGames(UserData().packs)>=1) 
            PaneItem(
              icon: Icon(showHidden? FontAwesomeIcons.eyeSlash :FontAwesomeIcons.eye),
              title: Text(showHidden == false
                  ? "Show games you've hidden"
                  : "Hide games you've hidden"),
              body: Container(),
              onTap: () {
                setState(() {
                  showHidden = !showHidden;
                  _selectedView = 0;
                });
              },
            ),
            PaneItem(
              icon: const Icon(FontAwesomeIcons.boxArchive),
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
    ));
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
          icon: CachedNetworkImage(
              imageUrl: APIService().assetLink(userPack.pack.icon),
              filterQuality: FilterQuality.high,
              fit: BoxFit.fitHeight,
              memCacheHeight: 40),
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

    List<NavigationPaneItem> tagItem = _buildTagsPaneItem();

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
                (showAllPacks || pack.owned) && (showHidden || !game.hidden),
            comeFromGame: false,
            background: APIService().getDefaultBackground(),
            name: type.name,
            description: type.description,
            showAllPacks: showAllPacks,
            icon: null,
          )));
    }

    if (UserData().packs.isNotEmpty) {
      items.add(PaneItemSeparator());
      items.add(PaneItemHeader(
          header: TextBox(
        autofocus: true,
        placeholder: AppLocalizations.of(context)!.search,
        suffix: const Icon(FluentIcons.search),
        controller: _searchController,
        onChanged: (String value) {
          setState(() {});
        },
        onEditingComplete: () {
          setState(() {});
        },
      )));
      items.add(PaneItemSeparator());
      items.add(PaneItem(
          icon: const Icon(FontAwesomeIcons.gamepad),
          title: Text(AppLocalizations.of(context)!.all_games),
          body: SearchGameWidget(
            filter: (UserJackboxPack pack, UserJackboxGame game) =>
                game.game.name
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()) &&
                (showAllPacks || pack.owned) && (showHidden || !game.hidden),
            comeFromGame: false,
            background: APIService().getDefaultBackground(),
            name: AppLocalizations.of(context)!.all_games,
            description: AppLocalizations.of(context)!.all_games_description,
            showAllPacks: showAllPacks,
            icon: null,
          )));
      items.add(PaneItemExpander(
        icon: const Icon(FontAwesomeIcons.boxOpen),
        body: Container(),
        title: Text(AppLocalizations.of(context)!.search_by_pack),
        items: packItems,
        onTap: () {
          setState(() {
            _selectedView = 2;
          });
        },
      ));

      List<NavigationPaneItem> translationItem = _buildTranslationPaneItem();
      List<NavigationPaneItem> starsItem = _buildStarsPaneItem();

      items.add(PaneItemExpander(
        icon: const Icon(FontAwesomeIcons.language),
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
        icon: const Icon(FontAwesomeIcons.tag),
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

      items.add(PaneItemExpander(
        icon: const Icon(FontAwesomeIcons.solidStar),
        body: Container(),
        title: Text("Search by ranking"),
        items: starsItem,
        onTap: () {
          setState(() {
            _selectedView = 5 +
                packItems.length +
                typeItem.length +
                translationItem.length +
                tagItem.length;
          });
        },
      ));
    }

    return items;
  }

  List<NavigationPaneItem> _buildTranslationPaneItem() {
    List<NavigationPaneItem> translationItem = [];

    // Adding each translation values
    for (var translation in JackboxGameTranslationCategory.values) {
      if (translation == JackboxGameTranslationCategory.COMMUNITY_DUBBED &&
          APIService()
                  .cachedConfigurations!
                  .getConfiguration("LAUNCHER", "HIDE_DUBBED_BY_COMMUNITY") ==
              true) continue;
      translationItem.add(PaneItem(
          icon: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: translation.color),
              width: 10,
              height: 10),
          title: Text(translation.name),
          body: SearchGameWidget(
            filter: (UserJackboxPack pack, UserJackboxGame game) =>
                translation.filter(pack, game) &&
                game.game.name
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()) &&
                (showAllPacks || pack.owned) && (showHidden || !game.hidden),
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

  List<NavigationPaneItem> _buildTagsPaneItem() {
    List<PaneItem> tagItem = [];

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
                (showAllPacks || pack.owned) && (showHidden || !game.hidden),
            comeFromGame: false,
            background: APIService().getDefaultBackground(),
            name: tag.name,
            description: tag.description,
            showAllPacks: showAllPacks,
            icon: null,
          )));
    }

    return tagItem;
  }

  List<NavigationPaneItem> _buildStarsPaneItem() {
    List<PaneItem> starItems = [];

    starItems.add(PaneItem(
        icon: Container(),
        title: Text("Personal ranking"),
        body: SearchGameWidget(
          filter: (UserJackboxPack pack, UserJackboxGame game) =>
              game.game.name
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) &&
              (showAllPacks || pack.owned) && (showHidden || !game.hidden),
          comeFromGame: false,
          background: APIService().getDefaultBackground(),
          name: "Ranked by stars",
          description: "Games ranked by stars from your personal ranking",
          showAllPacks: showAllPacks,
          icon: null,
          separators: [
            for (int i = 5; i >= 0; i--)
              i != 0
                  ? Row(
                      children: [
                        StarsRateWidget(
                          defaultStars: i,
                          readOnly: true,
                          color: Colors.yellow,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Text("Unranked",
                            style:
                                FluentTheme.of(context).typography.bodyLarge),
                      ],
                    )
          ],
          separatorFilter: (p0, p1) {
            return 5 - p1.stars;
          },
        )));

    return starItems;
  }
}
