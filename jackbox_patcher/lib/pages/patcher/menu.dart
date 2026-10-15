import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/pages/patcher/category_pack_patch.dart';
import 'package:jackbox_patcher/services/discord/discord_service.dart';

import '../../components/closable_route_with_esc.dart';
import '../../components/pane_item_focus_nodes.dart';
import '../../components/pane_page_traversal.dart';
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
  final PaneItemFocusNodes _paneFocusNodes = PaneItemFocusNodes();

  @override
  void initState() {
    DiscordService().launchPatchingPresence();
    APIService().internalCache.addListener(_updateAfterPacksChange);
    super.initState();
  }

  @override
  void dispose() {
    APIService().internalCache.removeListener(_updateAfterPacksChange);
    _paneFocusNodes.dispose();
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
        child: PaneTraversal(child: NavigationView(
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
                focusNode: _paneFocusNodes.get("show_all_packs"),
                icon: const Icon(FontAwesomeIcons.boxArchive),
                title: Text(showAllPacks == false
                    ? TranslationsHelper().appLocalizations!.show_all_packs
                    : TranslationsHelper().appLocalizations!.show_owned_packs_only),
                body: Container(),
                onTap: () {
                  setState(() {
                    showAllPacks = !showAllPacks;
                  });
                  _buildPaneItems();
                },
              )
          ]),
    )));
  }

  _changeMenuView(String packId) {
    // The card is only focused when it was opened with the keyboard or a controller (a click doesn't focus it)
    bool cardFocused =
        FocusManager.instance.primaryFocus?.context?.findAncestorWidgetOfExactType<PackInCategoryCard>() != null;
    for (var i = 0; i < items.length; i++) {
      if (items[i].key == ValueKey(packId)) {
        setState(() {
          _selectedView = i;
        });
        // The card used to open the pack disappears with the "All patches" page, the keyboard or the controller
        // continues from the pack in the pane instead of the top of the pane
        if (cardFocused) {
          _paneFocusNodes.requestFocus("pack_$packId");
        }
        break;
      }
    }
  }

  _buildPaneItems() {
    items = [];
    _selectedView = 0;
    items.add(PaneItem(
        focusNode: _paneFocusNodes.get("all_patches"),
        icon: const Center(child: Icon(FluentIcons.home)),
        title: Text(TranslationsHelper().appLocalizations!.all_patches),
        // Not a ListView: it only builds the categories close to the screen, so the arrows or a controller couldn't
        // reach the install button of the next ones
        body: PanePageTraversal(
            child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                    APIService().cachedCategories.length,
                    (i) => CategoryPackPatch(
                        category: APIService().cachedCategories[i],
                        showAllPacks: showAllPacks,
                        changeMenuView: _changeMenuView)))))));
    for (var userPack
        in showAllPacks ? UserData().packs : UserData().packs.where((element) => element.owned).toList()) {
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
            focusNode: _paneFocusNodes.get("pack_${userPack.pack.id}"),
            icon: CachedNetworkImage(
              fit: BoxFit.fitHeight,
              imageUrl: APIService().assetLink(userPack.pack.icon),
              memCacheHeight: 40,
              memCacheWidth: 40,
            ),
            title: Text(userPack.pack.name),
            body: PanePageTraversal(child: PatcherPackWidget(userPack: userPack))));
      }
    }
  }
}
