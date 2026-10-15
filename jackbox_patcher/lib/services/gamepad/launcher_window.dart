import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

/// Tells whether the app window is the one in front. Only works on Windows.
///
/// Controller inputs are ignored while it isn't, so they're left to the game,
/// the other app or the native dialog (e.g. the folder picker) in front. This
/// doesn't depend on the library used to read the controllers.
class LauncherWindow {
  /// Window class of the app window (see windows/runner/win32_window.cpp)
  static const String windowClass = "FLUTTER_RUNNER_WIN32_WINDOW";

  static const int _classNameLength = 256;

  final Pointer<Uint32> _processId = calloc<Uint32>();
  final Pointer<Utf16> _className = wsalloc(_classNameLength);
  int _lastForegroundWindow = 0;
  bool _lastForegroundIsLauncher = false;

  bool isInFront() {
    int window = GetForegroundWindow();
    if (window != _lastForegroundWindow) {
      _lastForegroundWindow = window;
      _lastForegroundIsLauncher = _isLauncherWindow(window);
    }
    return _lastForegroundIsLauncher;
  }

  bool _isLauncherWindow(int window) {
    if (window == 0) {
      return false;
    }
    GetWindowThreadProcessId(window, _processId);
    if (_processId.value != GetCurrentProcessId()) {
      return false;
    }
    GetClassName(window, _className, _classNameLength);
    return _className.toDartString() == windowClass;
  }

  void dispose() {
    free(_processId);
    free(_className);
  }
}
