import 'package:fluent_ui/fluent_ui.dart';

/// Focus node of a control in a row (e.g. a filter of the pane).
///
/// Left and right go to the other controls of the row first. The arrows and the
/// controller pick the closest widget on screen otherwise, which can be one
/// hidden under the row (e.g. an item of the pane under the filters when the
/// window is small).
class RowFocusNode extends FocusNode {
  RowFocusNode({super.debugLabel});

  FocusNode? left;
  FocusNode? right;

  @override
  bool focusInDirection(TraversalDirection direction) {
    FocusNode? next = direction == TraversalDirection.left
        ? left
        : direction == TraversalDirection.right
            ? right
            : null;
    if (next == null) {
      return super.focusInDirection(direction);
    }
    if (next.context == null || !next.canRequestFocus) {
      // The rest of the row can't be selected yet (e.g. the filter is off), and the closest widget on screen could be
      // one hidden under the row
      return false;
    }
    // This move isn't known by the traversal policy, its history of the last moves would bring the focus back here
    FocusTraversalGroup.of(context!).invalidateScopeData(nearestScope!);
    next.requestFocus();
    return true;
  }
}
