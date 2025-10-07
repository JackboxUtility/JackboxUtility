import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:jackbox_patcher/model/misc/audio/SFXEnum.dart';
import 'package:jackbox_patcher/services/audio/sfx_service.dart';
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
  FocusNode focusNode = FocusNode(debugLabel: DateTime.now().toString());

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
    return Focus(
      focusNode: focusNode,
      autofocus: widget.close,
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) {
          return KeyEventResult.ignored;
        }
        if (event.logicalKey == LogicalKeyboardKey.escape || event.logicalKey == LogicalKeyboardKey.backspace) {
          if (node == focusNode && widget.close && _handleNavigateBack(context)) {
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
