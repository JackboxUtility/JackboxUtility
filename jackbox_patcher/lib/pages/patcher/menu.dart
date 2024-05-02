import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/pages/patcher/category_pack_patch.dart';
import 'package:jackbox_patcher/services/discord/discord_service.dart';

import '../../components/closable_route_with_esc.dart';
import '../../model/user_model/user_jackbox_pack.dart';
import '../../services/api_utility/api_service.dart';
import '../../services/translations/translations_helper.dart';
import '../../services/user/user_data.dart';
import 'pack_container.dart';

class PatcherMenuWidget extends StatefulWidget {
  const PatcherMenuWidget({Key? key}) : super(key: key);

  @override
  State<PatcherMenuWidget> createState() => _PatcherMenuWidgetState();
}

class _PatcherMenuWidgetState extends State<PatcherMenuWidget> {
  int _selectedView = 0;
  bool showAllPacks = false;
  List<NavigationPaneItem> items = [];

  @override
  void initState() {
    DiscordService().launchPatchingPresence();
    APIService().internalCache.addListener(_updateAfterPacksChange);
    super.initState();
  }

  @override
  void dispose() {
    APIService().internalCache.removeListener(_updateAfterPacksChange);
    super.dispose();
  }

  void _updateAfterPacksChange() {
    if (mounted) {
      items = [];
      int _tempSelectedView = _selectedView;
      _buildPaneItems();
      _selectedView = _tempSelectedView;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    if (items.isEmpty) {
      _buildPaneItems();
    }
    return ClosableRouteWithEsc(
        child: NavigationView(
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      appBar: NavigationAppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            child: const Icon(FluentIcons.chevron_left),
            onTap: () => Navigator.pop(context),
          ),
          title: Text(
            APIService().cachedSelectedServer!.name,
            style: typography.title,
          )),
      pane: NavigationPane(
          indicator: null,
          onChanged: (int nSelected) {
            setState(() {
              _selectedView = nSelected;
            });
          },
          selected: _selectedView,
          items: items,
          footerItems: [
            if (UserJackboxPack.countUnownedPack(UserData().packs) >= 1)
              PaneItem(
                icon: const Icon(FontAwesomeIcons.boxArchive),
                title: Text(showAllPacks == false
                    ? TranslationsHelper().appLocalizations!.show_all_packs
                    : TranslationsHelper()
                        .appLocalizations!
                        .show_owned_packs_only),
                body: Container(),
                onTap: () {
                  setState(() {
                    showAllPacks = !showAllPacks;
                  });
                  _buildPaneItems();
                },
              )
          ]),
    ));
  }

  _changeMenuView(String packId) {
    for (var i = 0; i < items.length; i++) {
      if (items[i].key == ValueKey(packId)) {
        setState(() {
          _selectedView = i;
        });
        break;
      }
    }
  }

  _buildPaneItems() {
    items = [];
    _selectedView = 0;
    items.add(PaneItem(
        icon: const Center(child: Icon(FluentIcons.home)),
        title: Text(TranslationsHelper().appLocalizations!.all_patches),
        body: ListView(
            children: List.generate(
                APIService().cachedCategories.length,
                (i) => CategoryPackPatch(
                    category: APIService().cachedCategories[i],
                    showAllPacks: showAllPacks,
                    changeMenuView: _changeMenuView)))));
    for (var userPack in showAllPacks
        ? UserData().packs
        : UserData().packs.where((element) => element.owned).toList()) {
      int countPatchs = 0;
      for (var game in userPack.games) {
        if (game.patches.isNotEmpty) {
          countPatchs = 1;
          break;
        }
      }
      if (userPack.patches.isNotEmpty) {
        countPatchs = 1;
      }
      if (countPatchs == 1) {
        items.add(PaneItem(
            key: ValueKey(userPack.pack.id),
            icon: CachedNetworkImage(
              fit: BoxFit.fitHeight,
              imageUrl: APIService().assetLink(userPack.pack.icon),
              memCacheHeight: 40,
              memCacheWidth: 40,
            ),
            title: Text(userPack.pack.name),
            body: PatcherPackWidget(userPack: userPack)));
      }
    }
  }
}
