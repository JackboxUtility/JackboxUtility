import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:jackbox_patcher/model/misc/audio/SFXEnum.dart';
import 'package:jackbox_patcher/services/audio/sfx_service.dart';
import 'package:jackbox_patcher/services/gamepad/gamepad_intents.dart';
import 'package:jackbox_patcher/services/video/video_service.dart';

import 'mouse_back_button_recognizer.dart';

class ClosableRouteWithEsc extends StatefulWidget {
  ClosableRouteWithEsc(
      {Key? key,
      required this.child,
      this.leftEvent,
      this.rightEvent,
      this.close = true,
      this.closeSFX = false,
      this.pressingSpacePauseVideo = false,
      this.stopVideo = true})
      : super(key: key);

  final Widget child;
  final Function()? leftEvent;
  final Function()? rightEvent;
  final bool closeSFX;
  final bool pressingSpacePauseVideo;
  final bool stopVideo;
  final bool close;

  @override
  State<ClosableRouteWithEsc> createState() => _ClosableRouteWithEscState();
}

class _ClosableRouteWithEscState extends State<ClosableRouteWithEsc> {
  // A scope (and not a simple node) so the widgets of the page can be focused and
  // moved between with the arrows or a controller
  FocusScopeNode focusNode = FocusScopeNode(debugLabel: DateTime.now().toString());

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  /// Whether a text field is being edited, Esc and Backspace are then used by the text field
  bool _isEditingText() {
    return FocusManager.instance.primaryFocus?.context?.findAncestorStateOfType<EditableTextState>() != null;
  }

  /// Holding a key handled by this page must only do its action once, and not something else after (e.g. closing
  /// the pages below or moving the focus)
  /// Up or down without modifiers (shift + up selects the text) while a text field is being edited
  bool _isLeavingTextField(KeyEvent event) {
    return (const SingleActivator(LogicalKeyboardKey.arrowUp).accepts(event, HardwareKeyboard.instance) ||
            const SingleActivator(LogicalKeyboardKey.arrowDown).accepts(event, HardwareKeyboard.instance)) &&
        _isEditingText();
  }

  KeyEventResult _handleKeyRepeat(KeyRepeatEvent event) {
    if (_isLeavingTextField(event)) {
      // Nothing to go to in that direction, the cursor of the text field mustn't move either
      return KeyEventResult.handled;
    }
    if ((event.logicalKey == LogicalKeyboardKey.escape || event.logicalKey == LogicalKeyboardKey.backspace) &&
        widget.close &&
        !_isEditingText()) {
      return KeyEventResult.handled;
    }
    if ((event.logicalKey == LogicalKeyboardKey.arrowLeft && widget.leftEvent != null) ||
        (event.logicalKey == LogicalKeyboardKey.arrowRight && widget.rightEvent != null) ||
        (event.logicalKey == LogicalKeyboardKey.space && widget.pressingSpacePauseVideo)) {
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  /// Called with B on a controller, or Esc when it wasn't already handled
  void _handleDismiss(BuildContext context) {
    if (_isEditingText()) {
      FocusManager.instance.primaryFocus?.unfocus(disposition: UnfocusDisposition.previouslyFocusedChild);
    } else if (widget.close) {
      _handleNavigateBack(context);
    }
  }

  bool _handleNavigateBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      if (widget.stopVideo) {
        VideoService.stop();
      }
      if (widget.closeSFX) {
        SFXService().playSFX(SFX.CLOSE_GAME_INFO_TAB);
      }
      Navigator.of(context).pop();
      return true;
    }
    return false;
  }

  @override
  void didUpdateWidget(covariant ClosableRouteWithEsc oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.close && !oldWidget.close) {
      print("Requesting focus");
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: {
        DismissIntent: CallbackAction<DismissIntent>(onInvoke: (intent) => _handleDismiss(context)),
        PreviousItemIntent: CallbackAction<PreviousItemIntent>(onInvoke: (intent) => widget.leftEvent?.call()),
        NextItemIntent: CallbackAction<NextItemIntent>(onInvoke: (intent) => widget.rightEvent?.call()),
      },
      child: _buildFocusScope(context),
    );
  }

  Widget _buildFocusScope(BuildContext context) {
    return FocusScope(
      node: focusNode,
      autofocus: widget.close,
      onKeyEvent: (node, event) {
        if (event is KeyRepeatEvent) {
          return _handleKeyRepeat(event);
        }
        if (event is! KeyDownEvent) {
          return KeyEventResult.ignored;
        }
        if (_isLeavingTextField(event)) {
          // The text fields of the pages have a single line: up and down leave them, like with a controller
          FocusManager.instance.primaryFocus?.focusInDirection(
              event.logicalKey == LogicalKeyboardKey.arrowUp ? TraversalDirection.up : TraversalDirection.down);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.escape || event.logicalKey == LogicalKeyboardKey.backspace) {
          if (node == focusNode && widget.close && !_isEditingText() && _handleNavigateBack(context)) {
            return KeyEventResult.handled;
          }
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          if (widget.leftEvent != null) {
            widget.leftEvent!();
            return KeyEventResult.handled;
          }
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          if (widget.rightEvent != null) {
            widget.rightEvent!();
            return KeyEventResult.handled;
          }
        }
        if (event.logicalKey == LogicalKeyboardKey.space) {
          if (widget.pressingSpacePauseVideo) {
            VideoService.playPause();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          MouseBackButtonRecognizer: GestureRecognizerFactoryWithHandlers<MouseBackButtonRecognizer>(
            () => MouseBackButtonRecognizer(),
            (instance) => instance.onTapDown = (details) => _handleNavigateBack(context),
          ),
        },
        child: widget.child,
      ),
    );
  }
}
