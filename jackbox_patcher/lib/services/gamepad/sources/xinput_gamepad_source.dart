import 'dart:ffi';
import 'dart:math' show max;

import 'package:ffi/ffi.dart';
import 'package:jackbox_patcher/services/gamepad/gamepad_mapper.dart';
import 'package:jackbox_patcher/services/gamepad/sources/abstract_gamepad_source.dart';
import 'package:win32/win32.dart';

/// Reads the Xbox controllers with XInput. Only works on Windows.
class XInputGamepadSource implements AbstractGamepadSource {
  /// XInputGetState is slow on empty slots, so they aren't checked on every read
  static const Duration emptySlotsCheckInterval = Duration(seconds: 2);

  final Pointer<XINPUT_STATE> _state = calloc<XINPUT_STATE>();
  final List<bool> _connectedSlots = List.filled(XUSER_MAX_COUNT, false);
  Duration? _lastEmptySlotsCheck;

  @override
  bool get anyConnected => _connectedSlots.contains(true);

  @override
  List<GamepadSnapshot> read(Duration now) {
    bool checkEmptySlots = _lastEmptySlotsCheck == null || now - _lastEmptySlotsCheck! >= emptySlotsCheckInterval;
    if (checkEmptySlots) {
      _lastEmptySlotsCheck = now;
    }

    List<GamepadSnapshot> pads = [];
    for (int slot = 0; slot < XUSER_MAX_COUNT; slot++) {
      if (!_connectedSlots[slot] && !checkEmptySlots) {
        continue;
      }
      _connectedSlots[slot] = XInputGetState(slot, _state) == ERROR_SUCCESS;
      if (_connectedSlots[slot]) {
        XINPUT_GAMEPAD gamepad = _state.ref.Gamepad;
        // XInput uses the same button bits and stick values as GamepadSnapshot
        pads.add((
          buttons: gamepad.wButtons,
          leftX: gamepad.sThumbLX,
          leftY: gamepad.sThumbLY,
          rightY: gamepad.sThumbRY,
          trigger: max(gamepad.bLeftTrigger, gamepad.bRightTrigger)
        ));
      }
    }
    return pads;
  }

  @override
  void dispose() {
    free(_state);
  }
}
