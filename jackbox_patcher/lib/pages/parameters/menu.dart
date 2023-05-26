import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jackbox_patcher/pages/parameters/appinfo.dart';
import 'package:jackbox_patcher/pages/parameters/packs.dart';
import 'package:jackbox_patcher/pages/parameters/serverinfo.dart';

import '../../components/closableRouteWithEsc.dart';


class ParametersRoute extends StatefulWidget {
  const ParametersRoute({Key? key}) : super(key: key);

  @override
  State<ParametersRoute> createState() => _ParametersRouteState();
}

class _ParametersRouteState extends State<ParametersRoute> {
  @override
  Widget build(BuildContext context) {
    return const ParametersMenuWidget();
  }
}

class ParametersMenuWidget extends StatefulWidget {
  const ParametersMenuWidget({Key? key}) : super(key: key);

  @override
  State<ParametersMenuWidget> createState() => _ParametersMenuWidgetState();
}

class _ParametersMenuWidgetState extends State<ParametersMenuWidget> {
  int _selectedView = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    return ClosableRouteWithEsc(child:NavigationView(
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
          title: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(FluentIcons.settings, size: 25)),
            const SizedBox(width: 10),
            Text(
            AppLocalizations.of(context)!.settings,
            style: typography.title,
          )])),
      pane: NavigationPane(
          onChanged: (int nSelected) {
            setState(() {
              _selectedView = nSelected;
            });
          },
          selected: _selectedView,
          items: [
            PaneItem(
              icon: const Icon(FluentIcons.package),
              title: Text(AppLocalizations.of(context)!.owned_packs),
              body: const ParametersWidget(
              ),
            ),
            PaneItem(
                icon: const Icon(FluentIcons.server),
                title: Text(AppLocalizations.of(context)!.server_information),
                body: ServerInfoWidget())
          ],
          footerItems: [
            PaneItem(
              icon: const Icon(FluentIcons.info),
              title: Text(AppLocalizations.of(context)!.app_information),
              body: const AppInfoWidget(),
            )
          ]),
    ));
  }
}
