import 'package:fluent_ui/fluent_ui.dart';

/// Keeps up and down in a page of a [NavigationView] with the arrows or a
/// controller: only left and right go between the page and its pane.
///
/// Without it, up at the top of the page (or down at its bottom) would go to an
/// item of the pane, which is hard to follow on a long page.
class PanePageTraversal extends StatefulWidget {
  const PanePageTraversal({super.key, required this.child});

  final Widget child;

  @override
  State<PanePageTraversal> createState() => _PanePageTraversalState();
}

class _PanePageTraversalState extends State<PanePageTraversal> {
  late final _PanePageTraversalPolicy _policy = _PanePageTraversalPolicy(_isInPage);

  bool _isInPage(FocusNode node) {
    return node.context?.findAncestorStateOfType<_PanePageTraversalState>() == this;
  }

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(policy: _policy, child: widget.child);
  }
}

/// Keeps up and down in the pane of a [NavigationView] with the arrows or a
/// controller: only left and right go between the pane and its pages. It goes
/// around the [NavigationView].
///
/// Without it, up at the top of the pane (or down at its bottom) would go to a
/// widget of the page.
class PaneTraversal extends StatefulWidget {
  const PaneTraversal({super.key, required this.child});

  final Widget child;

  @override
  State<PaneTraversal> createState() => _PaneTraversalState();
}

class _PaneTraversalState extends State<PaneTraversal> {
  late final _PaneTraversalPolicy _policy = _PaneTraversalPolicy(_isInPane);

  // The pages of a NavigationView have their own traversal group, the widgets of the pane only have this one
  bool _isInPane(FocusNode node) {
    return FocusTraversalGroup.maybeOfNode(node) == _policy || _isPaneClosed(node);
  }

  // In the minimal display mode (small window), the closed pane is out of the screen and only its menu button is
  // left, in the app bar above the page: nothing is kept in the pane then, so the menu button can go down to the page
  bool _isPaneClosed(FocusNode node) {
    InheritedNavigationView? view = node.context?.getInheritedWidgetOfExactType<InheritedNavigationView>();
    return view != null && view.displayMode == PaneDisplayMode.minimal && !view.minimalPaneOpen;
  }

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(policy: _policy, child: widget.child);
  }
}

/// Same order as the pages of fluent_ui, but up and down never leave the page
class _PanePageTraversalPolicy extends WidgetOrderTraversalPolicy with _VerticalBounds {
  _PanePageTraversalPolicy._(this._moves) : super(requestFocusCallback: _moves.requestFocus);

  factory _PanePageTraversalPolicy(bool Function(FocusNode) isInPage) {
    return _PanePageTraversalPolicy._(_VerticalMoves(isInPage));
  }

  @override
  final _VerticalMoves _moves;
}

/// Same order as the rest of the app, but up and down never leave the pane
class _PaneTraversalPolicy extends ReadingOrderTraversalPolicy with _VerticalBounds {
  _PaneTraversalPolicy._(this._moves) : super(requestFocusCallback: _moves.requestFocus);

  factory _PaneTraversalPolicy(bool Function(FocusNode) isInPane) {
    return _PaneTraversalPolicy._(_VerticalMoves(isInPane));
  }

  @override
  final _VerticalMoves _moves;
}

/// Up and down only go to the widgets of [_VerticalMoves.isInside]
mixin _VerticalBounds on DirectionalFocusTraversalPolicyMixin {
  _VerticalMoves get _moves;

  @override
  bool inDirection(FocusNode currentNode, TraversalDirection direction) {
    _moves.vertical = direction == TraversalDirection.up || direction == TraversalDirection.down;
    _moves.blocked = false;
    bool moved;
    try {
      moved = super.inDirection(currentNode, direction);
    } finally {
      _moves.vertical = false;
    }
    if (_moves.blocked) {
      // The history of the last moves now has one that didn't happen, the next opposite move would only undo it
      invalidateScopeData(currentNode.nearestScope!);
      // The closest widget was outside, but there can still be one inside in that direction (Flutter only looks in
      // the same list as the focused widget when that list isn't scrolled to its top or bottom)
      return _focusClosestInside(currentNode, direction == TraversalDirection.up);
    }
    return moved;
  }

  bool _focusClosestInside(FocusNode currentNode, bool up) {
    Rect from = currentNode.rect;
    List<FocusNode> candidates = currentNode.nearestScope!.traversalDescendants
        .where((node) =>
            node != currentNode &&
            _moves.isInside(node) &&
            (up ? node.rect.center.dy <= from.top : node.rect.center.dy >= from.bottom))
        .toList();
    if (candidates.isEmpty) {
      return false;
    }
    // Like Flutter: the ones right above or below first, then the closest
    bool inBand(FocusNode node) => node.rect.right > from.left && node.rect.left < from.right;
    candidates.sort((a, b) {
      if (inBand(a) != inBand(b)) {
        return inBand(a) ? -1 : 1;
      }
      int vertical = (a.rect.center.dy - from.center.dy).abs().compareTo((b.rect.center.dy - from.center.dy).abs());
      return vertical != 0
          ? vertical
          : (a.rect.center.dx - from.center.dx).abs().compareTo((b.rect.center.dx - from.center.dx).abs());
    });
    FocusTraversalPolicy.defaultTraversalRequestFocusCallback(candidates.first,
        alignmentPolicy:
            up ? ScrollPositionAlignmentPolicy.keepVisibleAtStart : ScrollPositionAlignmentPolicy.keepVisibleAtEnd);
    return true;
  }
}

/// Lets a move go only if it stays inside, when it's up or down
class _VerticalMoves {
  _VerticalMoves(this.isInside);

  final bool Function(FocusNode) isInside;
  bool vertical = false;
  bool blocked = false;

  void requestFocus(FocusNode node,
      {ScrollPositionAlignmentPolicy? alignmentPolicy, double? alignment, Duration? duration, Curve? curve}) {
    if (vertical && !isInside(node)) {
      blocked = true;
      return;
    }
    FocusTraversalPolicy.defaultTraversalRequestFocusCallback(node,
        alignmentPolicy: alignmentPolicy, alignment: alignment, duration: duration, curve: curve);
  }
}
