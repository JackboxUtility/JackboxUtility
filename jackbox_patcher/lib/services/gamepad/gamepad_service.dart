import 'dart:async';
import 'dart:io';
import 'dart:math' show max;

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:jackbox_patcher/services/gamepad/gamepad_intents.dart';
import 'package:jackbox_patcher/services/gamepad/gamepad_mapper.dart';
import 'package:jackbox_patcher/services/gamepad/launcher_window.dart';
import 'package:jackbox_patcher/services/gamepad/sources/abstract_gamepad_source.dart';
import 'package:jackbox_patcher/services/gamepad/sources/xinput_gamepad_source.dart';
import 'package:jackbox_patcher/services/logger/logger.dart';

/// Lets the user navigate the app with an Xbox controller (Windows only).
///
/// Controller inputs are sent to the focused widget as the same intents as the
/// keyboard (arrows, Enter, Esc), so every focusable widget works with it.
/// Inputs are ignored while another window (e.g. a game) is in front.
///
/// The controllers are read by an [AbstractGamepadSource] (XInput for now), the
/// rest doesn't depend on the library used.
class GamepadService {
  static final GamepadService _instance = GamepadService._internal();

  /// Polling interval while the app is in front and a controller is connected
  static const Duration activePollInterval = Duration(milliseconds: 16);

  /// Polling interval while the app is in the background or no controller is connected
  static const Duration idlePollInterval = Duration(milliseconds: 250);

  /// Every input is ignored for this time after the app comes back in front or a
  /// controller is connected
  static const Duration resumeInputDelay = Duration(milliseconds: 250);

  /// A and X are ignored for this time after a page or a dialog is opened, so a
  /// double press doesn't also press a button of the new page
  static const Duration routeChangeActivateDelay = Duration(milliseconds: 200);

  /// A and X are ignored during a game launch, so it isn't launched twice. The
  /// lock ends when the app loses the focus, a few seconds after the launch is
  /// done, or at most after [launchMaxActivateDelay].
  static const Duration launchSettledActivateDelay = Duration(seconds: 8);
  static const Duration launchMaxActivateDelay = Duration(seconds: 60);

  /// While a trigger is held, each step of the right stick scrolls this part of the visible page (about 10 times
  /// faster than without a trigger in a maximized 1080p window), but at least [fastScrollMinStep] for the small
  /// scrollables of the dialogs
  static const double fastScrollPageFraction = 0.5;
  static const double fastScrollMinStep = 150;

  /// A fast scroll step lasts a bit longer than the time between two steps, so the next one takes over before it
  /// ends and the page scrolls continuously while the stick is held
  static const Duration fastScrollDuration = Duration(milliseconds: 100);

  /// Time the bar of the controller buttons takes to slide in or out
  static const Duration buttonBarSlideDuration = Duration(milliseconds: 150);

  /// Usage page of the keyboard keys in [PhysicalKeyboardKey.usbHidUsage]
  static const int keyboardUsagePage = 0x00070000;

  static const List<GamepadCommand> _directionCommands = [
    GamepadCommand.UP,
    GamepadCommand.DOWN,
    GamepadCommand.LEFT,
    GamepadCommand.RIGHT
  ];

  /// The inputs that change the focus or the page, they cancel X while it's held
  static const List<GamepadCommand> _quickLaunchCancelCommands = [
    ..._directionCommands,
    GamepadCommand.ACTIVATE,
    GamepadCommand.BACK,
    GamepadCommand.PREVIOUS,
    GamepadCommand.NEXT
  ];

  /// Whether at least one controller is connected
  final ValueNotifier<bool> padConnected = ValueNotifier(false);

  /// Whether the controller is the input in use: one is connected and it was used after the keyboard and the
  /// mouse. Its buttons are only shown then.
  final ValueNotifier<bool> controllerInUse = ValueNotifier(false);

  /// Whether the bar of the controller buttons is shown while the controller is in use (a setting)
  final ValueNotifier<bool> buttonBarEnabled = ValueNotifier(true);

  /// Saves the setting of the bar when it's shown or hidden with the View button
  void Function(bool enabled)? onButtonBarToggled;

  /// Must be added to the app navigator observers
  final GamepadRouteObserver routeObserver = GamepadRouteObserver();

  final GamepadMapper _mapper = GamepadMapper();
  final Stopwatch _clock = Stopwatch()..start();
  AbstractGamepadSource? _source;
  LauncherWindow? _launcherWindow;
  Timer? _timer;
  bool _wasForeground = false;
  Duration _ignoreInputUntil = Duration.zero;
  Duration _ignoreActivateUntil = Duration.zero;
  Duration? _launchLockedUntil;
  FocusTraversalPolicy? _lastMovePolicy;

  /// Scrolls the focused widget into view again once the bar of the controller buttons slid in
  Timer? _revealTimer;

  /// The widget X is pressed on, it's launched if it still has the focus when X is released
  FocusNode? _quickLaunchNode;
  int _padCount = 0;

  factory GamepadService() {
    return _instance;
  }

  // Build internal
  GamepadService._internal();

  /// Start listening to the controllers. Does nothing if it's already started.
  void init() {
    // Only Windows is supported for now: the controllers are read with XInput and LauncherWindow uses Win32.
    // Another platform needs another AbstractGamepadSource (e.g. with the gamepads package) and its own way to
    // know if the app window is in front.
    if (!Platform.isWindows || _source != null) {
      return;
    }
    JULogger().i("[GAMEPAD] Starting controller support");
    _source = XInputGamepadSource();
    _launcherWindow = LauncherWindow();
    _wasForeground = false;
    HardwareKeyboard.instance.addHandler(_onKeyEvent);
    GestureBinding.instance.pointerRouter.addGlobalRoute(_onPointerEvent);
    _schedule(Duration.zero);
  }

  /// Stop listening to the controllers
  void stop() {
    if (_source == null) {
      return;
    }
    JULogger().i("[GAMEPAD] Stopping controller support");
    _timer?.cancel();
    _timer = null;
    _source!.dispose();
    _source = null;
    _launcherWindow?.dispose();
    _launcherWindow = null;
    HardwareKeyboard.instance.removeHandler(_onKeyEvent);
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_onPointerEvent);
    _cancelQuickLaunch();
    _padCount = 0;
    padConnected.value = false;
    _setControllerInUse(false);
  }

  /// Called when a game or a pack starts launching
  void onLaunchStarted() {
    _launchLockedUntil = _clock.elapsed + launchMaxActivateDelay;
  }

  /// Called when a game or a pack launch is done
  void onLaunchSettled() {
    if (_launchLockedUntil == null) {
      return;
    }
    Duration settledLock = _clock.elapsed + launchSettledActivateDelay;
    if (settledLock < _launchLockedUntil!) {
      _launchLockedUntil = settledLock;
    }
  }

  /// Called when a game or a pack launch failed, nothing will be launched so A and X can be used again right away
  void onLaunchFailed() {
    _launchLockedUntil = null;
  }

  /// Called when a page or a dialog is opened or closed
  void onRouteChanged() {
    _ignoreActivateUntil = _clock.elapsed + routeChangeActivateDelay;
  }

  /// Whether [key] is a key of a keyboard, and not e.g. a controller button sent as a key
  static bool isKeyboardKey(PhysicalKeyboardKey key) {
    return (key.usbHidUsage & 0xFFFF0000) == keyboardUsagePage;
  }

  /// The keyboard was used, so the controller isn't the input in use anymore
  bool _onKeyEvent(KeyEvent event) {
    // The controller buttons can also come as keys (the VK_GAMEPAD_* keys of Windows), they don't count
    if (event is KeyDownEvent && !event.synthesized && isKeyboardKey(event.physicalKey)) {
      _setControllerInUse(false);
    }
    // The key still does what it does
    return false;
  }

  /// The mouse or the touchpad was clicked or scrolled (or the screen touched), so the controller isn't the input in
  /// use anymore. Moving the mouse doesn't count, it can be bumped while using the controller.
  void _onPointerEvent(PointerEvent event) {
    if (event is PointerDownEvent || event is PointerSignalEvent || event is PointerPanZoomStartEvent) {
      _setControllerInUse(false);
    }
  }

  /// Called when the setting of the bar of the controller buttons is changed
  void setButtonBarEnabled(bool enabled) {
    if (enabled && !buttonBarEnabled.value && controllerInUse.value) {
      // Turned on with the controller (A on the setting, or View), the bar makes the page shorter. Not while the
      // keyboard or the mouse is used: the bar isn't shown, and the focused widget can be far from where the user
      // scrolled with the mouse.
      _keepFocusVisibleWithBar();
    }
    buttonBarEnabled.value = enabled;
  }

  /// View shows or hides the bar of the controller buttons, and the setting is saved
  void _toggleButtonBar() {
    if (buttonBarEnabled.value && !controllerInUse.value) {
      // The bar is only hidden because the keyboard or the mouse was used, this press brings it back
      return;
    }
    bool enabled = !buttonBarEnabled.value;
    setButtonBarEnabled(enabled);
    onButtonBarToggled?.call(enabled);
  }

  /// [focusMoved] when the input that makes the controller the one in use moved the focus
  void _setControllerInUse(bool inUse, {bool focusMoved = false}) {
    if (inUse && focusMoved && !controllerInUse.value) {
      // The focus was just scrolled into view, but the bar will take room at the bottom of the page. Only after a
      // move: otherwise the focused widget can be far from where the user scrolled with the mouse.
      _keepFocusVisibleWithBar();
    }
    controllerInUse.value = inUse;
  }

  /// The bar of the controller buttons takes room at the bottom of the page once it slid in, so the focused widget
  /// is scrolled into view again then
  void _keepFocusVisibleWithBar() {
    _revealTimer?.cancel();
    // A bit longer, the bar only starts sliding at the next frame
    _revealTimer = Timer(buttonBarSlideDuration + const Duration(milliseconds: 100), () {
      _revealTimer = null;
      // Not if the bar isn't shown anymore (e.g. the mouse was used since)
      if (!controllerInUse.value || !buttonBarEnabled.value) {
        return;
      }
      BuildContext? focusedContext = FocusManager.instance.primaryFocus?.context;
      if (focusedContext != null && focusedContext.mounted) {
        Scrollable.ensureVisible(focusedContext,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut);
      }
    });
  }

  void _schedule(Duration delay) {
    _timer = Timer(delay, _tick);
  }

  void _tick() {
    if (_source == null) {
      return;
    }
    List<GamepadCommand> commands = [];
    Duration now = _clock.elapsed;
    try {
      if (!_launcherWindow!.isInFront()) {
        // A game or another app is in front, the controller is theirs
        _wasForeground = false;
        _launchLockedUntil = null;
        _cancelQuickLaunch();
        _schedule(idlePollInterval);
        return;
      }
      List<GamepadSnapshot> pads = _source!.read(now);
      bool connected = _source!.anyConnected;
      if (!_wasForeground || (connected && !padConnected.value)) {
        // Buttons still held (e.g. the one used to quit the game) must be released first
        _mapper.rebase();
        _ignoreInputUntil = now + resumeInputDelay;
        _wasForeground = true;
      }
      if (connected != padConnected.value) {
        // A controller that was just connected is the one in use, until the keyboard or the mouse is used
        _setControllerInUse(connected);
      }
      padConnected.value = connected;
      if (pads.length < _padCount) {
        // The controller holding X may be the one that was disconnected, it doesn't launch the game
        _cancelQuickLaunch();
      }
      _padCount = pads.length;
      commands = _mapper.update(pads, now);
      _schedule(connected ? activePollInterval : idlePollInterval);
    } catch (e) {
      JULogger().e("[GAMEPAD] Failed to read the controllers, stopping controller support");
      JULogger().e("[GAMEPAD] $e");
      stop();
      return;
    }

    if (now < _ignoreInputUntil) {
      return;
    }
    if (commands.contains(GamepadCommand.TOGGLE_BUTTON_BAR)) {
      // Before the controller is in use again, the bar was hidden or not
      _toggleButtonBar();
    }
    if (commands.isNotEmpty) {
      _setControllerInUse(true, focusMoved: commands.any(_directionCommands.contains));
    }
    // Errors from the widgets are left to the global error handlers, the next tick is already scheduled
    for (GamepadCommand command in commands) {
      _dispatch(command, now);
    }
  }

  /// Send the [command] to the focused widget, like a keyboard shortcut would
  void _dispatch(GamepadCommand command, Duration now) {
    if (_quickLaunchCancelCommands.contains(command)) {
      // Like moving the mouse away from a button before releasing it, the game X is held on isn't launched
      _cancelQuickLaunch();
    }
    FocusNode? focusedNode = FocusManager.instance.primaryFocus;
    BuildContext? focusedContext = focusedNode?.context;
    if (focusedNode == null || focusedContext == null || focusedNode == FocusManager.instance.rootScope) {
      // Nothing is focused (e.g. the focused widget was removed while the app was in the background)
      routeObserver.focusCurrentRoute();
      return;
    }
    if (!routeObserver.isInCurrentRoute(focusedNode)) {
      // The focused widget is hidden behind the page or dialog in front (e.g. it was autofocused after a page was
      // opened on top of it), it must never be moved or pressed: the page in front gets the focus back instead
      JULogger().d("[GAMEPAD] The focus was behind the page in front, giving it back");
      routeObserver.focusCurrentRoute();
      return;
    }

    switch (command) {
      case GamepadCommand.UP:
        _moveFocus(focusedContext, TraversalDirection.up);
        break;
      case GamepadCommand.DOWN:
        _moveFocus(focusedContext, TraversalDirection.down);
        break;
      case GamepadCommand.LEFT:
        _moveFocus(focusedContext, TraversalDirection.left);
        break;
      case GamepadCommand.RIGHT:
        _moveFocus(focusedContext, TraversalDirection.right);
        break;
      case GamepadCommand.ACTIVATE:
        if (_isActivateIgnored(now)) {
          return;
        }
        if (focusedNode is FocusScopeNode) {
          // Only the page or the dialog itself is focused, select its first control instead
          focusedNode.focusInDirection(TraversalDirection.down);
        } else {
          Actions.maybeInvoke(focusedContext, const ActivateIntent());
        }
        break;
      case GamepadCommand.QUICK_LAUNCH_PRESS:
        if (_isActivateIgnored(now)) {
          return;
        }
        _quickLaunchNode = focusedNode;
        Actions.maybeInvoke(focusedContext, const QuickLaunchIntent(QuickLaunchStep.PRESS));
        break;
      case GamepadCommand.QUICK_LAUNCH_RELEASE:
        // Like a button, the game is only launched if X is released on it (it isn't shown pushed in anymore if it
        // lost the focus)
        if (focusedNode == _quickLaunchNode) {
          Actions.maybeInvoke(focusedContext, const QuickLaunchIntent(QuickLaunchStep.RELEASE));
        }
        _quickLaunchNode = null;
        break;
      case GamepadCommand.BACK:
        Actions.maybeInvoke(focusedContext, const DismissIntent());
        break;
      case GamepadCommand.PREVIOUS:
        Actions.maybeInvoke(focusedContext, const PreviousItemIntent());
        break;
      case GamepadCommand.NEXT:
        Actions.maybeInvoke(focusedContext, const NextItemIntent());
        break;
      case GamepadCommand.SCROLL_UP:
        _scroll(focusedNode, focusedContext, AxisDirection.up);
        break;
      case GamepadCommand.SCROLL_DOWN:
        _scroll(focusedNode, focusedContext, AxisDirection.down);
        break;
      case GamepadCommand.TOGGLE_BUTTON_BAR:
        // Already done in _tick, it doesn't depend on the focus
        break;
    }
  }

  /// X won't be released on the widget it was pressed on (e.g. the app isn't in front anymore), so it isn't shown
  /// pushed in anymore
  void _cancelQuickLaunch() {
    BuildContext? context = _quickLaunchNode?.context;
    _quickLaunchNode = null;
    if (context != null && context.mounted) {
      Actions.maybeInvoke(context, const QuickLaunchIntent(QuickLaunchStep.CANCEL));
    }
  }

  /// Whether A and X are ignored for now (just after a page was opened, or while launching a game)
  bool _isActivateIgnored(Duration now) {
    return now < _ignoreActivateUntil || isLaunchLocked;
  }

  /// Whether a game is launching, so another launch is ignored (A and X, and Space on the keyboard)
  bool get isLaunchLocked => _launchLockedUntil != null && _clock.elapsed < _launchLockedUntil!;

  void _moveFocus(BuildContext focusedContext, TraversalDirection direction) {
    // The pane and the page of a NavigationView don't use the same traversal policy, and each one remembers its
    // last moves to go back with the opposite direction. A forgotten history would send the focus back where it
    // left the page, so it's cleared when the policy changes.
    FocusTraversalPolicy? policy = FocusTraversalGroup.maybeOf(focusedContext);
    FocusScopeNode? scope = FocusManager.instance.primaryFocus?.nearestScope;
    if (policy != null && scope != null && policy != _lastMovePolicy) {
      policy.invalidateScopeData(scope);
    }
    _lastMovePolicy = policy;
    // Unlike the keyboard arrows, the controller can't move the cursor of a text field, so it leaves it
    Actions.maybeInvoke(focusedContext, DirectionalFocusIntent(direction, ignoreTextFields: false));
  }

  void _scroll(FocusNode focusedNode, BuildContext focusedContext, AxisDirection direction) {
    // The page is scrolled away from the focused widget, it isn't scrolled back to it once the bar slid in
    _revealTimer?.cancel();
    _revealTimer = null;
    if (focusedNode is FocusScopeNode) {
      // Only the page or the dialog itself is focused and its scrollable is below it, so nothing can be scrolled
      // yet: select its first control instead, like A does
      focusedNode.focusInDirection(TraversalDirection.down);
    } else if (!_mapper.fastScroll || !_scrollFaster(focusedContext, direction)) {
      Actions.maybeInvoke(focusedContext, ScrollIntent(direction: direction));
    }
  }

  /// Scroll further than a ScrollIntent (which scrolls by a line), at the same pace. Returns false if nothing can be
  /// scrolled vertically from the focused widget, so a ScrollIntent is used instead.
  bool _scrollFaster(BuildContext focusedContext, AxisDirection direction) {
    if (_verticalScrollPosition(focusedContext) == null) {
      return false;
    }
    // Started on the next frame: started now, the scroll would only move from the frame after
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      ScrollPosition? position = focusedContext.mounted ? _verticalScrollPosition(focusedContext) : null;
      if (position == null) {
        return;
      }
      double step = max(position.viewportDimension * fastScrollPageFraction, fastScrollMinStep);
      double distance = direction == position.axisDirection ? step : -step;
      position.moveTo(position.pixels + distance, duration: fastScrollDuration, curve: Curves.linear);
    });
    return true;
  }

  /// The vertical scrollable around the focused widget or, like for a ScrollIntent, the primary one of the page
  /// or dialog (e.g. the content of a dialog while one of its buttons is focused)
  ScrollPosition? _verticalScrollPosition(BuildContext focusedContext) {
    ScrollableState? scrollable = Scrollable.maybeOf(focusedContext, axis: Axis.vertical);
    if (scrollable != null) {
      return scrollable.position;
    }
    ScrollController? controller = PrimaryScrollController.maybeOf(focusedContext);
    if (controller == null || controller.positions.length != 1 || controller.position.axis != Axis.vertical) {
      return null;
    }
    return controller.position;
  }
}

/// Keeps track of the page or dialog in front, so the controller can always
/// give it the focus back
class GamepadRouteObserver extends NavigatorObserver {
  Route<dynamic>? _currentRoute;

  /// Changes after each page or dialog change, once the new one is built
  final ValueNotifier<int> routeChanges = ValueNotifier(0);

  /// Name of the page in front (e.g. "/game"), null for a dialog
  String? get currentRouteName => _currentRoute?.settings.name;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _setCurrentRoute(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _setCurrentRoute(previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route == _currentRoute) {
      _setCurrentRoute(previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute == _currentRoute) {
      _setCurrentRoute(newRoute);
    }
  }

  void _setCurrentRoute(Route<dynamic>? route) {
    _currentRoute = route;
    GamepadService().onRouteChanged();
    // The navigator calls the observers while it's building, the listeners can only rebuild after
    WidgetsBinding.instance.addPostFrameCallback((_) => routeChanges.value++);
  }

  /// Give the focus to the page or dialog in front
  void focusCurrentRoute() {
    _currentRouteScope()?.requestFocus();
  }

  /// Whether [node] is in the page or dialog in front. Also true when it can't be known yet (the page isn't built).
  bool isInCurrentRoute(FocusNode node) {
    FocusScopeNode? scope = _currentRouteScope();
    return scope == null || node == scope || node.ancestors.contains(scope);
  }

  FocusScopeNode? _currentRouteScope() {
    Route<dynamic>? route = _currentRoute;
    if (route is ModalRoute && route.subtreeContext != null) {
      return FocusScope.of(route.subtreeContext!, createDependency: false);
    }
    return null;
  }
}
