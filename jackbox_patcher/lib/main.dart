import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/mainContainer.dart';

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
      themeMode: ThemeMode.dark,
      title: 'Flutter Demo',
      home: MainContainer(),
    );
  }
}

