import 'package:fluent_ui/fluent_ui.dart';

/// Keeps the focus on the items of a [NavigationPane] when their page is rebuilt.
///
/// fluent_ui gives a new key to every [NavigationPane] and [PaneItemExpander], and the pages create them in their
/// build method, so the footer items and the expanders (with their items) are rebuilt from scratch every time their
/// page is rebuilt, e.g. when an item is selected. The focused item would then lose the focus, which would go back to
/// another item of the pane. Each item gets its focus node from here instead, with an id that doesn't change between
/// builds.
class PaneItemFocusNodes {
  final Map<String, FocusNode> _focusNodes = {};

  /// The focus node of the pane item [id]. Must be called each time the item is created (in the build of its page):
  /// if the item is focused, it gets a new node that is focused after the frame, and the previous node is disposed.
  FocusNode get(String id) {
    FocusNode? focusNode = _focusNodes[id];
    if (focusNode != null && focusNode.hasPrimaryFocus) {
      // The new widget of the item wouldn't show that it's focused if it got the same node, so it gets a new node
      // which is focused once the item is built
      FocusNode newFocusNode = FocusNode(debugLabel: id);
      _focusNodes[id] = newFocusNode;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (newFocusNode.context?.mounted ?? false) {
          newFocusNode.requestFocus();
        }
        focusNode.dispose();
      });
      return newFocusNode;
    }
    return _focusNodes.putIfAbsent(id, () => FocusNode(debugLabel: id));
  }

  /// Give the focus to the pane item [id], if it was already created
  void requestFocus(String id) {
    _focusNodes[id]?.requestFocus();
  }

  void dispose() {
    for (FocusNode focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    _focusNodes.clear();
  }
}
