import 'package:jackbox_patcher/services/gamepad/gamepad_mapper.dart';

/// Reads the state of the connected controllers.
///
/// GamepadService polls it while the app is in front and doesn't depend on the
/// library used. To use another library (e.g. the gamepads package, which also
/// supports Linux and macOS), implement this class and create it in
/// GamepadService.init instead of XInputGamepadSource.
abstract class AbstractGamepadSource {
  /// Whether at least one controller is connected
  bool get anyConnected;

  /// The current state of every connected controller, with the buttons
  /// converted to [GamepadButtons].
  ///
  /// Called about every 16 ms with the time since the service started. A
  /// library sending events can keep the last state of each controller and
  /// return it here.
  List<GamepadSnapshot> read(Duration now);

  /// Free what is used to read the controllers
  void dispose();
}
