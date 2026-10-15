import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/pages/settings/app_behavior.dart';
import 'package:jackbox_patcher/pages/settings/app_info.dart';
import 'package:jackbox_patcher/pages/settings/packs.dart';
import 'package:jackbox_patcher/pages/settings/server_info.dart';
import 'package:jackbox_patcher/services/discord/discord_service.dart';

import '../../components/closable_route_with_esc.dart';
import '../../components/pane_item_focus_nodes.dart';
import '../../components/pane_page_traversal.dart';
import '../../services/translations/translations_helper.dart';

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
  final PaneItemFocusNodes _paneFocusNodes = PaneItemFocusNodes();

  @override
  void initState() {
    DiscordService().launchSettingsPresence();
    super.initState();
  }

  @override
  void dispose() {
    _paneFocusNodes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
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
          title: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(FluentIcons.settings, size: 25)),
            const SizedBox(width: 10),
            Text(
              TranslationsHelper().appLocalizations!.settings,
              style: typography.title,
            )
          ])),
      pane: NavigationPane(
          onChanged: (int nSelected) {
            setState(() {
              _selectedView = nSelected;
            });
          },
          selected: _selectedView,
          items: [
            PaneItem(
              focusNode: _paneFocusNodes.get("owned_packs"),
              icon: const Icon(FluentIcons.package),
              title: Text(TranslationsHelper().appLocalizations!.owned_packs),
              body: const PanePageTraversal(child: ParametersWidget()),
            ),
            PaneItem(
                focusNode: _paneFocusNodes.get("server_information"),
                icon: const Icon(FluentIcons.server),
                title: Text(
                    TranslationsHelper().appLocalizations!.server_information),
                body: PanePageTraversal(child: ServerInfoWidget())),
            PaneItem(
              focusNode: _paneFocusNodes.get("app_behavior"),
              icon: const Icon(FontAwesomeIcons.play),
              title: Text(TranslationsHelper().appLocalizations!.app_behavior),
              body: PanePageTraversal(child: AppBehaviorSettings()),
            )
          ],
          footerItems: [
            PaneItem(
              focusNode: _paneFocusNodes.get("app_information"),
              icon: const Icon(FluentIcons.info),
              title:
                  Text(TranslationsHelper().appLocalizations!.app_information),
              body: const PanePageTraversal(child: AppInfoWidget()),
            )
          ]),
    )));
  }
}
