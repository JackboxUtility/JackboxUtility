import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jackbox_patcher/pages/parameters/appinfo.dart';
import 'package:jackbox_patcher/pages/parameters/packs.dart';
import 'package:jackbox_patcher/pages/parameters/serverinfo.dart';

import '../../model/usermodel/userjackboxpack.dart';
import '../../services/user/userdata.dart';

class ParametersRoute extends StatefulWidget {
  ParametersRoute({Key? key}) : super(key: key);

  @override
  State<ParametersRoute> createState() => _ParametersRouteState();
}

class _ParametersRouteState extends State<ParametersRoute> {
  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    return ParametersMenuWidget();
  }
}

class ParametersMenuWidget extends StatefulWidget {
  ParametersMenuWidget({Key? key}) : super(key: key);

  @override
  State<ParametersMenuWidget> createState() => _ParametersMenuWidgetState();
}

class _ParametersMenuWidgetState extends State<ParametersMenuWidget> {
  int _selectedView = 0;
  List<UserJackboxPack> packs = UserData().packs;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
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
            AppLocalizations.of(context)!.settings,
            style: typography.title,
          )),
      pane: NavigationPane(
          onChanged: (int nSelected) {
            setState(() {
              _selectedView = nSelected;
            });
          },
          selected: _selectedView,
          items: [
            PaneItem(
              icon: Icon(FluentIcons.package),
              title: Text("Games"),
              body: ParametersWidget(
                originalPacks: packs,
              ),
            ),
            PaneItem(
                icon: Icon(FluentIcons.server),
                title: Text("Server"),
                body: ServerInfoWidget())
          ],
          footerItems: [
            PaneItem(
              icon: Icon(FluentIcons.info),
              title: Text("Application info"),
              body: AppInfoWidget(),
            )
          ]),
    );
  }
}
