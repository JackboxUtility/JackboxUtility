import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/app_configuration.dart';
import 'package:jackbox_patcher/pages/mainContainer.dart';
import 'package:jackbox_patcher/pages/settings/menu.dart';
import 'package:jackbox_patcher/pages/search_ui/searchGames.dart';
import 'package:jackbox_patcher/pages/search_ui/searchGamesMenu.dart';
import 'package:jackbox_patcher/pages/select_server/selectServer.dart';
import 'package:jackbox_patcher/services/api_utility/api_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'pages/game_ui/gameInfo.dart';
import 'pages/settings/packs.dart';
import 'pages/patcher/menu.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      darkTheme: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blue,
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen(context) ? 2.0 : 0.0,
        ),
      ),
      localizationsDelegates: const [
        FluentLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: List.generate(APP_LANGUAGES.length, (index) => Locale(APP_LANGUAGES[index])),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const MainContainer(),
        '/serverSelect': (context) => const SelectServerPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/settings': (context) =>
            showMainContainerIfNotLoaded(const ParametersRoute()),
        '/settings/packs': (context) =>
            showMainContainerIfNotLoaded(const ParametersPackRoute()),
        '/game': (context) =>
            showMainContainerIfNotLoaded(const GameInfoRoute()),
        '/search': (context) =>
            showMainContainerIfNotLoaded(const SearchGameRoute()),
        '/searchMenu': (context) =>
            showMainContainerIfNotLoaded(const SearchGameMenuWidget()),
        '/patch': (context) =>
            showMainContainerIfNotLoaded(const PatcherMenuWidget())
      },
      themeMode: ThemeMode.dark,
      title: 'Jackbox Utility',
    );
  }

  Widget showMainContainerIfNotLoaded(Widget widgetIfLoaded) {
    return APIService().cachedPacks.isNotEmpty
        ? widgetIfLoaded
        : const MainContainer();
  }
}
