import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jackbox_patcher/services/gamepad/gamepad_service.dart';

void main() {
  // The keyboard hides the controller buttons, but the controller buttons sent as keys must not
  group('Keyboard keys', () {
    test('the keys of a keyboard count', () {
      expect(GamepadService.isKeyboardKey(PhysicalKeyboardKey.keyA), isTrue);
      expect(GamepadService.isKeyboardKey(PhysicalKeyboardKey.arrowDown), isTrue);
      expect(GamepadService.isKeyboardKey(PhysicalKeyboardKey.space), isTrue);
      expect(GamepadService.isKeyboardKey(PhysicalKeyboardKey.enter), isTrue);
      expect(GamepadService.isKeyboardKey(PhysicalKeyboardKey.escape), isTrue);
      expect(GamepadService.isKeyboardKey(PhysicalKeyboardKey.controlLeft), isTrue);
    });

    test('the controller buttons sent as keys do not count', () {
      expect(GamepadService.isKeyboardKey(PhysicalKeyboardKey.gameButtonA), isFalse);
      // A VK_GAMEPAD_* key of Windows, which has no scan code
      expect(GamepadService.isKeyboardKey(const PhysicalKeyboardKey(0x01600000000)), isFalse);
    });
  });
}
