import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jackbox_patcher/components/quick_launch_area.dart';
import 'package:jackbox_patcher/services/gamepad/gamepad_intents.dart';

void main() {
  late int launches;
  late FocusNode gameNode;
  late FocusNode otherNode;

  /// A game in a QuickLaunchArea, and another focusable widget
  Future<void> pumpGame(WidgetTester tester, {bool enabled = true, bool fails = false}) async {
    launches = 0;
    gameNode = FocusNode(debugLabel: "Game");
    otherNode = FocusNode(debugLabel: "Other");
    addTearDown(gameNode.dispose);
    addTearDown(otherNode.dispose);
    await tester.pumpWidget(FluentApp(
        home: Column(children: [
      QuickLaunchArea(
          enabled: enabled,
          onLaunch: () async {
            launches++;
            if (fails) {
              throw Exception("The game can't be launched");
            }
          },
          child: Focus(focusNode: gameNode, child: const QuickLaunchFeedback(child: SizedBox(width: 40, height: 30)))),
      Focus(focusNode: otherNode, child: const SizedBox(width: 40, height: 30)),
    ])));
    gameNode.requestFocus();
    await tester.pump();
  }

  QuickLaunchStatus status() => QuickLaunchArea.of(gameNode.context!);

  void sendX(QuickLaunchStep step) {
    Actions.invoke(gameNode.context!, QuickLaunchIntent(step));
  }

  testWidgets('X pushes the game in and launches it when it\'s released', (tester) async {
    await pumpGame(tester);
    sendX(QuickLaunchStep.PRESS);
    await tester.pump();
    expect(status().pushed, isTrue);
    expect(launches, 0);

    sendX(QuickLaunchStep.RELEASE);
    await tester.pump();
    expect(status().pushed, isFalse);
    expect(status().launching, isTrue);
    expect(launches, 1);
    expect(find.byType(ProgressRing), findsOneWidget);

    // While the game opens, whatever the launcher does
    await tester.pump(QuickLaunchArea.launchingDuration);
    await tester.pump();
    expect(status().launching, isFalse);
    expect(find.byType(ProgressRing), findsNothing);
  });

  testWidgets('Space works like X, and its repeats are handled', (tester) async {
    await pumpGame(tester);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(status().pushed, isTrue);
    expect(await tester.sendKeyRepeatEvent(LogicalKeyboardKey.space), isTrue);
    expect(launches, 0);

    await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(status().pushed, isFalse);
    expect(launches, 1);
    await tester.pump(QuickLaunchArea.launchingDuration);
  });

  testWidgets('Space with another key isn\'t a quick launch', (tester) async {
    await pumpGame(tester);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    expect(await tester.sendKeyDownEvent(LogicalKeyboardKey.space), isFalse);
    await tester.pump();
    expect(status().pushed, isFalse);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    expect(launches, 0);
  });

  testWidgets('the game isn\'t launched if it loses the focus, or if X is cancelled', (tester) async {
    await pumpGame(tester);
    sendX(QuickLaunchStep.PRESS);
    await tester.pump();
    otherNode.requestFocus();
    await tester.pump();
    expect(status().pushed, isFalse);
    sendX(QuickLaunchStep.RELEASE);
    await tester.pump();
    expect(launches, 0);

    gameNode.requestFocus();
    await tester.pump();
    sendX(QuickLaunchStep.PRESS);
    await tester.pump();
    sendX(QuickLaunchStep.CANCEL);
    await tester.pump();
    expect(status().pushed, isFalse);
    sendX(QuickLaunchStep.RELEASE);
    await tester.pump();
    expect(launches, 0);
  });

  testWidgets('a game shown launching isn\'t pushed in or launched again', (tester) async {
    await pumpGame(tester);
    status().launch();
    await tester.pump();
    expect(launches, 1);

    sendX(QuickLaunchStep.PRESS);
    await tester.pump();
    expect(status().pushed, isFalse);
    sendX(QuickLaunchStep.RELEASE);
    status().launch();
    await tester.pump();
    expect(launches, 1);

    await tester.pump(QuickLaunchArea.launchingDuration);
    await tester.pump();
    status().launch();
    expect(launches, 2);
    await tester.pump(QuickLaunchArea.launchingDuration);
  });

  testWidgets('a failed launch isn\'t shown launching anymore', (tester) async {
    await pumpGame(tester, fails: true);
    status().launch();
    await tester.pump();
    expect(launches, 1);
    expect(status().launching, isFalse);
    expect(find.byType(ProgressRing), findsNothing);
  });

  testWidgets('a disabled area lets Space through', (tester) async {
    await pumpGame(tester, enabled: false);
    expect(await tester.sendKeyDownEvent(LogicalKeyboardKey.space), isFalse);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
    sendX(QuickLaunchStep.PRESS);
    await tester.pump();
    expect(status().pushed, isFalse);
  });
}
