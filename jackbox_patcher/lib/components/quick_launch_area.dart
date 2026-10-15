import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:jackbox_patcher/services/gamepad/gamepad_intents.dart';
import 'package:jackbox_patcher/services/gamepad/gamepad_service.dart';

/// Lets X on a controller, or Space on the keyboard, launch a game without opening its page.
///
/// It works like a button on screen: the game is shown pushed in while the key is held (see [QuickLaunchFeedback]),
/// and it's launched when the key is released, if it still has the focus. It's then shown launching while the game
/// opens. The other ways to launch it (e.g. a click on its play button) use [QuickLaunchArea.of], so they show it
/// launching too.
class QuickLaunchArea extends StatefulWidget {
  const QuickLaunchArea({super.key, this.enabled = true, required this.onLaunch, required this.child});

  /// How long the game is shown launching, about as long as a game takes to open. Not until the launch is done:
  /// depending on the launcher, it's done right away or only when the game is closed.
  static const Duration launchingDuration = Duration(seconds: 10);

  /// Whether X and Space launch the game (e.g. not if its pack isn't owned)
  final bool enabled;

  /// Launch the game. The returned future must fail if the launch fails (after the error is shown), so the game
  /// isn't shown launching anymore.
  final Future<void> Function() onLaunch;

  final Widget child;

  /// The state of the game of the area around [context]
  static QuickLaunchStatus of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_QuickLaunchScope>()!.status;
  }

  @override
  State<QuickLaunchArea> createState() => _QuickLaunchAreaState();
}

/// The state of the game of a [QuickLaunchArea]
class QuickLaunchStatus {
  const QuickLaunchStatus({required this.pushed, required this.launching, required this.launch});

  /// X or Space is held on the game
  final bool pushed;

  /// The game was just launched, it's opening
  final bool launching;

  /// Launch the game now (e.g. its play button was clicked), ignored while it's shown launching
  final VoidCallback launch;
}

class _QuickLaunchAreaState extends State<QuickLaunchArea> {
  bool _pushed = false;
  bool _launching = false;
  Timer? _launchingTimer;

  @override
  void dispose() {
    _launchingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
        canRequestFocus: false,
        skipTraversal: true,
        // A key held on the game while it loses the focus doesn't launch it
        onFocusChange: (bool focused) {
          if (!focused) {
            _setPushed(false);
          }
        },
        onKeyEvent: _onKeyEvent,
        child: Actions(
            actions: {
              QuickLaunchIntent: CallbackAction<QuickLaunchIntent>(onInvoke: (intent) => _onQuickLaunch(intent))
            },
            child: _QuickLaunchScope(
                status: QuickLaunchStatus(pushed: _pushed, launching: _launching, launch: _launch),
                child: widget.child)));
  }

  /// X on a controller
  void _onQuickLaunch(QuickLaunchIntent intent) {
    switch (intent.step) {
      case QuickLaunchStep.PRESS:
        _press();
        break;
      case QuickLaunchStep.RELEASE:
        _release();
        break;
      case QuickLaunchStep.CANCEL:
        _setPushed(false);
        break;
    }
  }

  /// Space on the keyboard works like X
  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (!widget.enabled || event.logicalKey != LogicalKeyboardKey.space) {
      return KeyEventResult.ignored;
    }
    if (event is KeyDownEvent) {
      if (HardwareKeyboard.instance.isControlPressed ||
          HardwareKeyboard.instance.isShiftPressed ||
          HardwareKeyboard.instance.isAltPressed ||
          HardwareKeyboard.instance.isMetaPressed) {
        // Only Space alone, like the other key shortcuts of the app
        return KeyEventResult.ignored;
      }
      _press();
    } else if (event is KeyUpEvent) {
      _release();
    }
    // The repeats while it's held are handled too, Space would activate the game (open its page) otherwise
    return KeyEventResult.handled;
  }

  void _press() {
    // Ignored while a game is launching, so it isn't launched twice (the lock lasts until the game is in front)
    if (widget.enabled && !_launching && !GamepadService().isLaunchLocked) {
      _setPushed(true);
    }
  }

  void _release() {
    if (_pushed) {
      _setPushed(false);
      _launch();
    }
  }

  void _launch() {
    if (_launching) {
      return;
    }
    setState(() {
      _launching = true;
    });
    Timer timer = Timer(QuickLaunchArea.launchingDuration, _stopLaunching);
    _launchingTimer = timer;
    widget.onLaunch().catchError((e) {
      // The game won't open (unless it's the error of an earlier launch)
      if (_launchingTimer == timer && timer.isActive) {
        timer.cancel();
        _stopLaunching();
      }
    });
  }

  void _stopLaunching() {
    if (mounted && _launching) {
      setState(() {
        _launching = false;
      });
    }
  }

  void _setPushed(bool pushed) {
    if (mounted && _pushed != pushed) {
      setState(() {
        _pushed = pushed;
      });
    }
  }
}

class _QuickLaunchScope extends InheritedWidget {
  const _QuickLaunchScope({required this.status, required super.child});

  final QuickLaunchStatus status;

  @override
  bool updateShouldNotify(_QuickLaunchScope oldWidget) {
    return status.pushed != oldWidget.status.pushed || status.launching != oldWidget.status.launching;
  }
}

/// Shows [child] pushed in (smaller and darker) while X or Space is held on the game of the [QuickLaunchArea]
/// around it, then dimmed with a progress ring while the game opens
class QuickLaunchFeedback extends StatelessWidget {
  const QuickLaunchFeedback({super.key, required this.child, this.pushedScale = 0.85});

  static const Duration pushDuration = Duration(milliseconds: 80);

  /// A bit longer, so it can be seen popping back out
  static const Duration releaseDuration = Duration(milliseconds: 150);

  final Widget child;

  /// Size of [child] while it's pushed in (e.g. pushed in less for a big image)
  final double pushedScale;

  @override
  Widget build(BuildContext context) {
    QuickLaunchStatus status = QuickLaunchArea.of(context);
    return Stack(alignment: Alignment.center, children: [
      AnimatedScale(
          scale: status.pushed ? pushedScale : 1,
          duration: status.pushed ? pushDuration : releaseDuration,
          curve: status.pushed ? Curves.easeOut : Curves.easeOutBack,
          child: AnimatedOpacity(
              opacity: status.launching ? 0.4 : (status.pushed ? 0.6 : 1), duration: pushDuration, child: child)),
      // Clicks go through it, to the button under it
      if (status.launching)
        const IgnorePointer(child: SizedBox(width: 20, height: 20, child: ProgressRing(strokeWidth: 3))),
    ]);
  }
}
