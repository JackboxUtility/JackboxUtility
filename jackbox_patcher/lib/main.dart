import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/pages/mainContainer.dart';
import 'package:jackbox_patcher/pages/search_ui/searchGames.dart';
import 'package:jackbox_patcher/pages/search_ui/searchGamesMenu.dart';

import 'pages/game_ui/gameInfo.dart';
import 'pages/parameters/parameters.dart';
import 'pages/patcher/menu.dart';

void main() {
  runApp(const MyApp());
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
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => MainContainer(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/settings':(context) => ParametersRoute(),
        '/game': (context) => GameInfoRoute(),
        '/search': (context) => SearchGameRoute(),
        '/searchMenu':(context) => SearchGameMenuWidget(),
        '/patch':(context) => PatcherMenuWidget()
      },
      themeMode: ThemeMode.dark,
      title: 'Flutter Demo',
    );
  }
}

