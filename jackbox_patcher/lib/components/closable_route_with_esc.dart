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

  @override
  State<ClosableRouteWithEsc> createState() => _ClosableRouteWithEscState();
}

class _ClosableRouteWithEscState extends State<ClosableRouteWithEsc> {
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
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKey: (node, event) {
        if (event.isKeyPressed(LogicalKeyboardKey.escape) ||
            event.isKeyPressed(LogicalKeyboardKey.backspace)) {
          if (_handleNavigateBack(context)) {
            return KeyEventResult.handled;
          }
        }
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          if (widget.leftEvent != null) {
            widget.leftEvent!();
            return KeyEventResult.handled;
          }
        }
        if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          if (widget.rightEvent != null) {
            widget.rightEvent!();
            return KeyEventResult.handled;
          }
        }
        if (event.isKeyPressed(LogicalKeyboardKey.space)) {
          if (widget.pressingSpacePauseVideo) {
            VideoService.playPause();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          MouseBackButtonRecognizer:
              GestureRecognizerFactoryWithHandlers<MouseBackButtonRecognizer>(
            () => MouseBackButtonRecognizer(),
            (instance) =>
                instance.onTapDown = (details) => _handleNavigateBack(context),
          ),
        },
        child: widget.child,
      ),
    );
  }
}
