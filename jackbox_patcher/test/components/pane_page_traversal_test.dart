import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jackbox_patcher/components/pane_page_traversal.dart';

void main() {
  /// A pane on the left and a page on the right, like a NavigationView (its page has its own traversal group)
  Future<Map<String, FocusNode>> pumpPane(WidgetTester tester,
      {required List<double> paneItems, required List<double> pageItems, bool withPaneTraversal = true}) async {
    Map<String, FocusNode> nodes = {};
    Widget column(String name, List<double> tops) {
      return SizedBox(
          width: 200,
          height: 600,
          child: Stack(children: [
            for (int i = 0; i < tops.length; i++)
              Positioned(
                  top: tops[i],
                  left: 0,
                  child: Focus(
                      focusNode: nodes.putIfAbsent("$name$i", () => FocusNode(debugLabel: "$name$i")),
                      child: const SizedBox(width: 100, height: 40))),
          ]));
    }

    Widget view = Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      column("pane", paneItems),
      FocusTraversalGroup(child: PanePageTraversal(child: column("page", pageItems))),
    ]);
    await tester.pumpWidget(FluentApp(home: withPaneTraversal ? PaneTraversal(child: view) : view));
    for (FocusNode node in nodes.values) {
      addTearDown(node.dispose);
    }
    return nodes;
  }

  Future<void> press(WidgetTester tester, LogicalKeyboardKey key) async {
    await tester.sendKeyEvent(key);
    await tester.pump();
  }

  testWidgets('without it, down at the bottom of the pane goes to the page', (tester) async {
    Map<String, FocusNode> nodes =
        await pumpPane(tester, paneItems: [0, 40], pageItems: [0, 200], withPaneTraversal: false);
    nodes["pane1"]!.requestFocus();
    await tester.pump();
    await press(tester, LogicalKeyboardKey.arrowDown);
    expect(nodes["page1"]!.hasPrimaryFocus, isTrue);
  });

  testWidgets('up and down stay in the pane, right goes to the page', (tester) async {
    Map<String, FocusNode> nodes = await pumpPane(tester, paneItems: [0, 40], pageItems: [0, 200]);
    nodes["pane1"]!.requestFocus();
    await tester.pump();
    await press(tester, LogicalKeyboardKey.arrowDown);
    expect(nodes["pane1"]!.hasPrimaryFocus, isTrue);
    await press(tester, LogicalKeyboardKey.arrowUp);
    expect(nodes["pane0"]!.hasPrimaryFocus, isTrue);
    await press(tester, LogicalKeyboardKey.arrowUp);
    expect(nodes["pane0"]!.hasPrimaryFocus, isTrue);
    await press(tester, LogicalKeyboardKey.arrowRight);
    expect(nodes["page0"]!.hasPrimaryFocus, isTrue);
  });

  testWidgets('up and down stay in the page, left goes to the pane', (tester) async {
    Map<String, FocusNode> nodes = await pumpPane(tester, paneItems: [0, 300], pageItems: [0, 40]);
    nodes["page1"]!.requestFocus();
    await tester.pump();
    await press(tester, LogicalKeyboardKey.arrowDown);
    expect(nodes["page1"]!.hasPrimaryFocus, isTrue);
    await press(tester, LogicalKeyboardKey.arrowLeft);
    expect(nodes["pane0"]!.hasPrimaryFocus, isTrue);
  });
}
