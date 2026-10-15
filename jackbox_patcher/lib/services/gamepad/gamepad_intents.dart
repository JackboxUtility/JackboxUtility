import 'package:fluent_ui/fluent_ui.dart';

/// Show the previous item of the page (e.g. the previous game). Sent by the left
/// shoulder button of a controller.
class PreviousItemIntent extends Intent {
  const PreviousItemIntent();
}

/// Show the next item of the page (e.g. the next game). Sent by the right
/// shoulder button of a controller.
class NextItemIntent extends Intent {
  const NextItemIntent();
}

/// What the X button of a controller does to the focused game
enum QuickLaunchStep {
  /// X is pressed: the game is shown pushed in
  PRESS,

  /// X is released: the game is launched
  RELEASE,

  /// X won't be released on this game (e.g. the app isn't in front anymore): it isn't shown pushed in anymore
  CANCEL
}

/// Launch the focused game without opening its page, like its small play
/// button. Sent by the X button of a controller, see QuickLaunchArea.
class QuickLaunchIntent extends Intent {
  const QuickLaunchIntent(this.step);

  final QuickLaunchStep step;
}
