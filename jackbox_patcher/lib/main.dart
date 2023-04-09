import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:jackbox_patcher/pages/mainContainer.dart';
import 'package:jackbox_patcher/pages/search_ui/searchGames.dart';
import 'package:jackbox_patcher/pages/search_ui/searchGamesMenu.dart';
import 'package:jackbox_patcher/pages/select_server/selectServer.dart';
import 'package:jackbox_patcher/services/api/api_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jackbox_patcher/services/translations/translationsHelper.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'pages/game_ui/gameInfo.dart';
import 'pages/parameters/parameters.dart';
import 'pages/patcher/menu.dart';

void main() async {
  await SentryFlutter.init(
    (options) {
      options.environment = kDebugMode? 'development' : 'production';
      options.dsn = 'https://bc7660c906ba4f24ad2e37530bfa4c39@o518501.ingest.sentry.io/4504978536988672';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () =>runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blue,
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen() ? 2.0 : 0.0,
        ),
      ),
      localizationsDelegates: [
        FluentLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: [Locale("en"), Locale("fr"), Locale("de"), Locale("es")],
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => MainContainer(),
        '/serverSelect': (context) => SelectServerPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/settings': (context) =>
            showMainContainerIfNotLoaded(ParametersRoute()),
        '/game': (context) => showMainContainerIfNotLoaded(GameInfoRoute()),
        '/search': (context) => showMainContainerIfNotLoaded(SearchGameRoute()),
        '/searchMenu': (context) =>
            showMainContainerIfNotLoaded(SearchGameMenuWidget()),
        '/patch': (context) => showMainContainerIfNotLoaded(PatcherMenuWidget())
      },
      themeMode: ThemeMode.dark,
      title: 'Jackbox Utility',
    );
  }

  Widget showMainContainerIfNotLoaded(Widget widgetIfLoaded) {
    return APIService().cachedPacks.isNotEmpty
        ? widgetIfLoaded
        : MainContainer();
  }
}
