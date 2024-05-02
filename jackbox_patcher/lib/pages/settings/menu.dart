import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jackbox_patcher/pages/settings/app_behavior.dart';
import 'package:jackbox_patcher/pages/settings/app_info.dart';
import 'package:jackbox_patcher/pages/settings/packs.dart';
import 'package:jackbox_patcher/pages/settings/server_info.dart';
import 'package:jackbox_patcher/services/discord/discord_service.dart';

import '../../components/closable_route_with_esc.dart';
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
  @override
  void initState() {
    DiscordService().launchSettingsPresence();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
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
              icon: const Icon(FluentIcons.package),
              title: Text(TranslationsHelper().appLocalizations!.owned_packs),
              body: const ParametersWidget(),
            ),
            PaneItem(
                icon: const Icon(FluentIcons.server),
                title: Text(
                    TranslationsHelper().appLocalizations!.server_information),
                body: ServerInfoWidget()),
            PaneItem(
              icon: const Icon(FontAwesomeIcons.play),
              title: Text(TranslationsHelper().appLocalizations!.app_behavior),
              body: AppBehaviorSettings(),
            )
          ],
          footerItems: [
            PaneItem(
              icon: const Icon(FluentIcons.info),
              title:
                  Text(TranslationsHelper().appLocalizations!.app_information),
              body: const AppInfoWidget(),
            )
          ]),
    ));
  }
}
