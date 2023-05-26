import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';

class ClosableRouteWithEsc extends StatefulWidget {
  ClosableRouteWithEsc({Key? key, required this.child}) : super(key: key);

  final Widget child;

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
          Navigator.of(context).pop();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: widget.child,
    );
  }
}