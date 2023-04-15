import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/pages/patcher/categoryPackPatch.dart';

import '../../services/api/api_service.dart';
import '../../services/user/userdata.dart';
import 'packContainer.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatcherMenuWidget extends StatefulWidget {
  PatcherMenuWidget({Key? key}) : super(key: key);

  @override
  State<PatcherMenuWidget> createState() => _PatcherMenuWidgetState();
}

class _PatcherMenuWidgetState extends State<PatcherMenuWidget> {
  int _selectedView = 0;
  bool showAllPacks = false;
  List<NavigationPaneItem> items = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    if (items.length == 0) {
      _buildPaneItems();
    }
    return NavigationView(
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      appBar: NavigationAppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            child: Icon(FluentIcons.chevron_left),
            onTap: () => Navigator.pop(context),
          ),
          title: Text(
            APIService().cachedSelectedServer!.name,
            style: typography.title,
          )),
      pane: NavigationPane(
          onChanged: (int nSelected) {
            setState(() {
              _selectedView = nSelected;
            });
          },
          selected: _selectedView,
          items: items,
          footerItems: [
            PaneItem(
              icon: Icon(FluentIcons.package),
              title: 
                Text(showAllPacks==false? AppLocalizations.of(context)!.show_all_packs: AppLocalizations.of(context)!.show_owned_packs_only),
              body: Container(),
              onTap: () {
                setState(() {
                        showAllPacks = !showAllPacks;
                      });
                      _buildPaneItems();
              },
            )
          ]),
    );
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
    print(APIService().cachedCategories.length);
    items = [];
    _selectedView = 0;
    items.add(PaneItem(
        icon: Icon(FluentIcons.home),
        title: Text(AppLocalizations.of(context)!.all_patches),
        body: ListView(
            children: List.generate(
                APIService().cachedCategories.length,
                (i) => CategoryPackPatch(
                    category: APIService().cachedCategories[i],
                    showAllPacks: showAllPacks,
                    changeMenuView: _changeMenuView)))));
    for (var userPack in showAllPacks? UserData().packs: UserData().packs.where((element) => element.owned).toList()) {
      int countPatchs = 0;
      for (var game in userPack.games) {
        if (game.patches.length >= 1) {
          countPatchs = 1;
          break;
        }
      }
      if (userPack.patches.length >= 1) {
        countPatchs = 1;
      }
      if (countPatchs == 1) {
        items.add(PaneItem(
            key: ValueKey(userPack.pack.id),
            icon: Image.network(APIService().assetLink(userPack.pack.icon)),
            title: Text(userPack.pack.name),
            body: PatcherPackWidget(userPack: userPack)));
      }
    }
  }
}
