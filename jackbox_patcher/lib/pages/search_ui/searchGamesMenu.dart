import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/components/closableRouteWithEsc.dart';
import 'package:jackbox_patcher/components/filters/intFilterPaneItem.dart';
import 'package:jackbox_patcher/components/starsRate.dart';
import 'package:jackbox_patcher/model/jackbox/jackboxgame.dart';
import 'package:jackbox_patcher/model/misc/filterEnum.dart';
import 'package:jackbox_patcher/model/misc/tip.dart';
import 'package:jackbox_patcher/model/usermodel/userjackboxgame.dart';
import 'package:jackbox_patcher/pages/search_ui/randomGame.dart';
import 'package:jackbox_patcher/pages/search_ui/searchGames.dart';

import '../../components/filters/enumFilterPaneItem.dart';
import '../../model/usermodel/userjackboxpack.dart';
import '../../services/api/api_service.dart';
import '../../services/user/userdata.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef Filter = ({bool activated, FilterValue selected, FilterType type});
typedef IntFilter = ({bool activated, int selected, String type});

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
  num maxSelectableView = 0;
  List<Filter> filters = [];
  List<IntFilter> intFilters = [];
  Key gamePaneKey = UniqueKey();

  @override
  void initState() {
    _searchController = TextEditingController();
    FilterType.values.forEach((element) {
      filters.add(
          (activated: false, selected: element.values.first, type: element));
    });
    intFilters.add((activated: false, selected: 10, type: "minPlayers"));
    intFilters.add((activated: false, selected: 30, type: "maxPlaytime"));
    UserData().gameList.loadFilters(filters);
    UserData().gameList.loadIntFilters(intFilters);
    super.initState();
    Future.delayed(
        Duration(milliseconds: 500),()=>
        UserData()
            .tips
            .getTip(TipAvailable.LAUNCHER_ON_STARTUP)
            .activate(context));
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
          size: NavigationPaneSize(openWidth: 400),
          onChanged: (int nSelected) {
            if (nSelected <= maxSelectableView) {
              setState(() {
                _searchController.text = "";
                _selectedView = nSelected;
              });
            }
          },
          selected: _selectedView,
          items: _buildPaneItems(),
          footerItems: [
            PaneItemExpander(
                onTap: () {},
                icon: Icon(FontAwesomeIcons.filter),
                title: Text("Filter"),
                infoBadge:
                    filters.where((element) => element.activated).length > 0 ||
                            intFilters
                                    .where((element) => element.activated)
                                    .length >
                                0
                        ? Checkbox(
                            checked: true,
                            onChanged: (value) {
                              setState(() {
                                for (int i = 0; i < filters.length; i++) {
                                  filters[i] = (
                                    activated: false,
                                    selected: filters[i].selected,
                                    type: filters[i].type
                                  );
                                }
                                for (int i = 0; i < intFilters.length; i++) {
                                  intFilters[i] = (
                                    activated: false,
                                    selected: intFilters[i].selected,
                                    type: intFilters[i].type
                                  );
                                }
                                UserData().gameList.saveFilters(filters);
                                UserData().gameList.saveIntFilters(intFilters);
                              });
                            },
                          )
                        : Container(),
                items: _buildGameFilterPaneItems(),
                body: Container()),
            if (UserJackboxGame.countHiddenGames(UserData().packs) >= 1)
              PaneItem(
                icon: Icon(showHidden
                    ? FontAwesomeIcons.eyeSlash
                    : FontAwesomeIcons.eye),
                title: Text(showHidden == false
                    ? "Show games you've hidden"
                    : "Hide games you've hidden"),
                body: Container(),
                onTap: () {
                  setState(() {
                    showHidden = !showHidden;
                  });
                },
              ),
            if (UserJackboxPack.countUnownedPack(UserData().packs) >= 1)
              PaneItem(
                icon: const Icon(FontAwesomeIcons.boxArchive),
                title: Text(showAllPacks == false
                    ? AppLocalizations.of(context)!.show_all_packs
                    : AppLocalizations.of(context)!.show_owned_packs_only),
                body: Container(),
                onTap: () {
                  setState(() {
                    showAllPacks = !showAllPacks;
                  });
                },
              )
          ]),
    ));
  }

  List<NavigationPaneItem> _buildGameFilterPaneItems() {
    List<NavigationPaneItem> items = [];
    items.add(IntFilterPaneItem(
        activated: intFilters
            .firstWhere((element) => element.type == "minPlayers")
            .activated,
        icon: FluentIcons.people,
        min: 1,
        max: 11,
        step: 1,
        defaultValue: intFilters
            .firstWhere((element) => element.type == "minPlayers")
            .selected,
        name: "Number of players",
        onChanged: (int value) {
          int index =
              intFilters.indexWhere((element) => element.type == "minPlayers");
          intFilters[index] =
              (activated: true, selected: value, type: "minPlayers");
          _saveIntFilter(intFilters[index]);
          setState(() {});
        },
        onActivationChanged: (bool value) {
          int index =
              intFilters.indexWhere((element) => element.type == "minPlayers");
          intFilters[index] = (
            activated: value,
            selected: intFilters[index].selected,
            type: "minPlayers"
          );
          _saveIntFilter(intFilters[index]);
          setState(() {});
        }));
    items.add(IntFilterPaneItem(
        activated: intFilters
            .firstWhere((element) => element.type == "maxPlaytime")
            .activated,
        icon: FontAwesomeIcons.clock,
        min: 10,
        max: 40,
        step: 5,
        defaultValue: intFilters
            .firstWhere((element) => element.type == "maxPlaytime")
            .selected,
        name: "Max playtime",
        onChanged: (int value) {
          int index =
              intFilters.indexWhere((element) => element.type == "maxPlaytime");
          intFilters[index] =
              (activated: true, selected: value, type: "maxPlaytime");
          _saveIntFilter(intFilters[index]);
          setState(() {});
        },
        onActivationChanged: (bool value) {
          int index =
              intFilters.indexWhere((element) => element.type == "maxPlaytime");
          intFilters[index] = (
            activated: value,
            selected: intFilters[index].selected,
            type: "maxPlaytime"
          );
          _saveIntFilter(intFilters[index]);
          setState(() {});
        }));
    for (var filter in filters) {
      items.add(EnumFilterPaneItem(
          activated: filter.activated,
          icon: filter.type.icon,
          defaultValue: filter.selected,
          name: filter.type.name,
          availableValues: filter.type.values,
          onChanged: (FilterValue value) {
            var index =
                filters.indexWhere((element) => element.type == filter.type);
            filters[index] =
                (activated: true, selected: value, type: filter.type);
            _saveFilter(filters[index]);
            setState(() {});
          },
          onActivationChanged: (bool value) {
            var index =
                filters.indexWhere((element) => element.type == filter.type);
            filters[index] = (
              activated: value,
              selected: filter.selected,
              type: filter.type
            );
            _saveFilter(filters[index]);
            setState(() {});
          }));
    }

    return items;
  }

  void _saveFilter(Filter filter) {
    UserData().gameList.saveFilter(filter);
  }

  void _saveIntFilter(IntFilter filter) {
    UserData().gameList.saveIntFilter(filter);
  }

  bool _filterGameBasedOnActiveFilters(
      UserJackboxPack pack, UserJackboxGame game) {
    for (({bool activated, FilterValue selected, FilterType type}) filter
        in filters) {
      if (filter.activated) {
        if (!filter.selected.isValidWithThisFilter(game.game)) {
          return false;
        }
      }
    }

    if (intFilters[0].activated &&
        (game.game.info.players.min > intFilters[0].selected ||
            game.game.info.players.max < intFilters[0].selected)) {
      return false;
    }
    if (intFilters[1].activated &&
        (game.game.info.playtime.max > intFilters[1].selected)) {
      return false;
    }
    return true;
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
                    .contains(_searchController.text.toLowerCase()) &&
                _filterGameBasedOnActiveFilters(pack, game),
            comeFromGame: false,
            showAllPacks: showAllPacks,
            linkedPack: userPack,
            name: userPack.pack.name,
            description: userPack.pack.description,
            icon: userPack.pack.icon,
          )));
    }

    List<NavigationPaneItem> typeItem = [];

    List<NavigationPaneItem> tagItem = _buildTagsPaneItem();

    for (var type in JackboxGameType.values) {
      tagItem.add(PaneItem(
          icon: Icon(type.icon),
          title: Text(type.name),
          body: SearchGameWidget(
              filter: (UserJackboxPack pack, UserJackboxGame game) =>
                  game.game.info.type == type &&
                  game.game.name
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()) &&
                  (showAllPacks || pack.owned) &&
                  (showHidden || !game.hidden) &&
                  _filterGameBasedOnActiveFilters(pack, game),
              comeFromGame: false,
              linkedPack: null,
              name: type.name,
              description: type.description,
              showAllPacks: showAllPacks,
              icon: null,
              parentReload: () => setState(() {}))));
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
                  (showAllPacks || pack.owned) &&
                  (showHidden || !game.hidden) &&
                  _filterGameBasedOnActiveFilters(pack, game),
              comeFromGame: false,
              linkedPack: null,
              name: AppLocalizations.of(context)!.all_games,
              description: AppLocalizations.of(context)!.all_games_description,
              showAllPacks: showAllPacks,
              icon: null,
              parentReload: () => setState(() {}))));
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

      List<NavigationPaneItem> starsItem = _buildStarsPaneItem();

      items.add(PaneItemExpander(
        icon: const Icon(FontAwesomeIcons.tag),
        body: Container(),
        title: Text(AppLocalizations.of(context)!.search_by_tags),
        items: tagItem,
        onTap: () {
          setState(() {
            _selectedView = 3 + packItems.length + typeItem.length;
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
            _selectedView =
                4 + packItems.length + typeItem.length + tagItem.length;
          });
        },
      ));

      items.add(PaneItem(
          icon: Icon(FontAwesomeIcons.dice),
          title: Text("Random game"),
          body: RandomGameWidget(
            filter: (UserJackboxPack pack, UserJackboxGame game) =>
                (showAllPacks || pack.owned) &&
                (showHidden || !game.hidden) &&
                _filterGameBasedOnActiveFilters(pack, game),
          )));
    }

    maxSelectableView = 1;
    for (var item in items) {
      if (item is PaneItemExpander) {
        maxSelectableView += item.items.length + 1;
      }
    }

    return items;
  }

  List<NavigationPaneItem> _buildTagsPaneItem() {
    List<PaneItem> tagItem = [];

    for (var tag in APIService().getTags()) {
      tagItem.add(PaneItem(
          icon: Icon(FluentIcons.allIcons[tag.icon]),
          title: Text(tag.name),
          body: SearchGameWidget(
              filter: (UserJackboxPack pack, UserJackboxGame game) =>
                  game.game.info.tags.where((t) => t.id == tag.id).isNotEmpty &&
                  game.game.name
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()) &&
                  (showAllPacks || pack.owned) &&
                  (showHidden || !game.hidden) &&
                  _filterGameBasedOnActiveFilters(pack, game),
              comeFromGame: false,
              linkedPack: null,
              name: tag.name,
              description: tag.description,
              showAllPacks: showAllPacks,
              icon: null,
              parentReload: () => setState(() {}))));
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
              (showAllPacks || pack.owned) &&
              (showHidden || !game.hidden) &&
              _filterGameBasedOnActiveFilters(pack, game),
          comeFromGame: false,
          linkedPack: null,
          name: "Ranked by stars",
          description: "Games ranked by stars from your personal ranking",
          showAllPacks: showAllPacks,
          icon: null,
          parentReload: () => setState(() {}),
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
