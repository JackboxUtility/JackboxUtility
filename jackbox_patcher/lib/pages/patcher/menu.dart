import 'package:fluent_ui/fluent_ui.dart';

import '../../services/api/api_service.dart';
import '../../services/user/userdata.dart';
import 'packContainer.dart';

class PatcherMenuWidget extends StatefulWidget {
  PatcherMenuWidget({Key? key}) : super(key: key);

  @override
  State<PatcherMenuWidget> createState() => _PatcherMenuWidgetState();
}

class _PatcherMenuWidgetState extends State<PatcherMenuWidget> {
  int _selectedView = 0;
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
        items: _buildPaneItems(),
      ),
    );
  }

  _buildPaneItems() {
    List<NavigationPaneItem> items = [];
    List<NavigationPaneItem> patchingItems = [];
    for (var userPack in UserData().packs) {
      int countPatchs = 0;
      for (var game in userPack.games) {
        if (game.patches.length >= 1) {
          countPatchs = 1;
          break;
        }
      }
      print(userPack.patches.length);
      if (userPack.patches.length >= 1) {
        countPatchs = 1;
      }
      if (countPatchs == 1) {
        items.add(PaneItem(
            icon: Image.network(APIService().assetLink(userPack.pack.icon)),
            title: Text(userPack.pack.name),
            body: PatcherPackWidget(userPack: userPack)));
      }
    }

    return items;
  }
}
