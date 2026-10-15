import 'package:flutter_test/flutter_test.dart';
import 'package:jackbox_patcher/services/gamepad/gamepad_mapper.dart';
import 'package:win32/win32.dart';

void main() {
  // XInputGamepadSource gives the XInput buttons to the mapper without converting them
  test('XInput buttons have the GamepadButtons values', () {
    expect(XINPUT_GAMEPAD_DPAD_UP, GamepadButtons.dpadUp);
    expect(XINPUT_GAMEPAD_DPAD_DOWN, GamepadButtons.dpadDown);
    expect(XINPUT_GAMEPAD_DPAD_LEFT, GamepadButtons.dpadLeft);
    expect(XINPUT_GAMEPAD_DPAD_RIGHT, GamepadButtons.dpadRight);
    expect(XINPUT_GAMEPAD_BACK, GamepadButtons.view);
    expect(XINPUT_GAMEPAD_LEFT_SHOULDER, GamepadButtons.leftShoulder);
    expect(XINPUT_GAMEPAD_RIGHT_SHOULDER, GamepadButtons.rightShoulder);
    expect(XINPUT_GAMEPAD_A, GamepadButtons.a);
    expect(XINPUT_GAMEPAD_B, GamepadButtons.b);
    expect(XINPUT_GAMEPAD_X, GamepadButtons.x);
  });
}
