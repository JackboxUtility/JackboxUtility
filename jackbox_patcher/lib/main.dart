import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/app_configuration.dart';
import 'package:jackbox_patcher/components/controller_hints.dart';
import 'package:jackbox_patcher/l10n/app_localizations.dart';
import 'package:jackbox_patcher/pages/main_container.dart';
import 'package:jackbox_patcher/pages/settings/menu.dart';
import 'package:jackbox_patcher/pages/search_ui/search_games.dart';
import 'package:jackbox_patcher/pages/search_ui/search_games_menu.dart';
import 'package:jackbox_patcher/pages/select_server/select_server.dart';
import 'package:jackbox_patcher/services/api_utility/api_service.dart';
import 'package:jackbox_patcher/services/gamepad/gamepad_service.dart';

import 'pages/game_ui/gameinfo.dart';
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
        '/settings': (context) => showMainContainerIfNotLoaded(const ParametersRoute()),
        '/settings/packs': (context) => showMainContainerIfNotLoaded(const ParametersPackRoute()),
        '/game': (context) => showMainContainerIfNotLoaded(const GameInfoRoute()),
        '/search': (context) => showMainContainerIfNotLoaded(const SearchGameRoute()),
        '/searchMenu': (context) => showMainContainerIfNotLoaded(const SearchGameMenuWidget()),
        '/patch': (context) => showMainContainerIfNotLoaded(const PatcherMenuWidget())
      },
      navigatorObservers: [GamepadService().routeObserver],
      builder: (context, child) {
        // Make the focused widget easier to see from the couch while a controller is connected
        return ValueListenableBuilder<bool>(
            valueListenable: GamepadService().padConnected,
            builder: (context, padConnected, _) {
              return FocusTheme(
                  data: FocusThemeData(glowFactor: padConnected ? 2.0 : null),
                  // The column is always there, so the pages aren't rebuilt when a controller is connected
                  child: Column(children: [
                    Expanded(child: child!),
                    // What the controller buttons do, hidden while the keyboard or the mouse is used (or by a setting)
                    ListenableBuilder(
                        listenable:
                            Listenable.merge([GamepadService().controllerInUse, GamepadService().buttonBarEnabled]),
                        builder: (context, _) {
                          bool visible =
                              GamepadService().controllerInUse.value && GamepadService().buttonBarEnabled.value;
                          // It slides in and out at the bottom of the app
                          return ClipRect(
                              child: AnimatedAlign(
                                  alignment: Alignment.topCenter,
                                  heightFactor: visible ? 1 : 0,
                                  duration: GamepadService.buttonBarSlideDuration,
                                  curve: Curves.easeInOut,
                                  child: ExcludeSemantics(excluding: !visible, child: const ControllerHints())));
                        }),
                  ]));
            });
      },
      themeMode: ThemeMode.dark,
      title: 'Jackbox Utility',
    );
  }

  Widget showMainContainerIfNotLoaded(Widget widgetIfLoaded) {
    return APIService().cachedPacks.isNotEmpty ? widgetIfLoaded : const MainContainer();
  }
}
