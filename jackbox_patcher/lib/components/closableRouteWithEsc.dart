import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:jackbox_patcher/model/misc/audio/SFXEnum.dart';
import 'package:jackbox_patcher/services/audio/SFXService.dart';

class ClosableRouteWithEsc extends StatefulWidget {
  ClosableRouteWithEsc(
      {Key? key,
      required this.child,
      this.leftEvent,
      this.rightEvent,
      this.closeSFX = false})
      : super(key: key);

  final Widget child;
  final Function()? leftEvent;
  final Function()? rightEvent;
  final bool closeSFX;

  @override
  State<ClosableRouteWithEsc> createState() => _ClosableRouteWithEscState();
}

class _ClosableRouteWithEscState extends State<ClosableRouteWithEsc> {
  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKey: (node, event) {
        if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
          print(widget.closeSFX);
          if (widget.closeSFX) {
            SFXService().playSFX(SFX.CLOSE_GAME_INFO_TAB);
          }
          Navigator.of(context).pop();
          return KeyEventResult.handled;
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
        return KeyEventResult.ignored;
      },
      child: widget.child,
    );
  }
}
