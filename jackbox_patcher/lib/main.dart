import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedView = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        actions: Icon(Icons.gite),
        automaticallyImplyLeading: false,
        title: Text("Jackbox Patcher")),
      pane: NavigationPane(
        onChanged: (int nSelected){
          setState(() {
            _selectedView = nSelected;
          });
        },
        selected: _selectedView,
        items: [
          PaneItem(
            icon: Icon(FluentIcons.home),
            title: Text("Menu"),
            body:Center(child: Text("Menu"),)
          ),
          PaneItemHeader(
            header: Text("Packs"),
          ),
          PaneItem(
            icon: Icon(FluentIcons.box_addition_solid),
            title: Text("Jackbox Party Pack 1"),
            body:Center(child: Text("Jackbox party pack 1"),)
          
          ),
          PaneItem(
            icon: Icon(FluentIcons.box_addition_solid),
            title: Text("Jackbox Party Pack 2"),
            body:Center(child: Text("Jackbox party pack 2"),)
          
          ),
          PaneItem(
            icon: Icon(FluentIcons.settings),
            title: Text("Settings"),
            body:Center(child: Text("Settings"),)
          ),
          
        ],
      ),
    );
    
  }
}
