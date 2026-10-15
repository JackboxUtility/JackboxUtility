import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/misc/audio/SFXEnum.dart';
import '../../services/audio/sfx_service.dart';
import '../focusable_tap.dart';
import '../row_focus_node.dart';

class IntFilterPaneItem extends PaneItemHeader {
  IntFilterPaneItem(
      {super.key,
      required this.icon,
      required this.name,
      required this.onChanged,
      required this.onActivationChanged,
      required this.min,
      required this.max,
      required this.defaultValue,
      required this.step,
      required this.activated})
      : super(
            header: IntFilterPaneItemTitle(
                icon: icon,
                name: name,
                onChanged: onChanged,
                onActivationChanged: onActivationChanged,
                min: min,
                max: max,
                defaultValue: defaultValue,
                step: step,
                activated: activated));

  final IconData icon;
  final String name;
  final ValueChanged<int> onChanged;
  final ValueChanged<bool> onActivationChanged;
  final int min;
  final int max;
  final int defaultValue;
  final int step;
  final bool activated;
}

class IntFilterPaneItemTitle extends StatefulWidget {
  IntFilterPaneItemTitle(
      {Key? key,
      required this.icon,
      required this.name,
      required this.onChanged,
      required this.onActivationChanged,
      required this.min,
      required this.max,
      required this.defaultValue,
      required this.step,
      required this.activated})
      : super(key: key);

  final IconData icon;
  final String name;
  final ValueChanged<int> onChanged;
  final ValueChanged<bool> onActivationChanged;
  final int min;
  final int max;
  final int defaultValue;
  final int step;
  final bool activated;

  @override
  State<IntFilterPaneItemTitle> createState() => _IntFilterPaneItemTitleState();
}

class _IntFilterPaneItemTitleState extends State<IntFilterPaneItemTitle> {
  bool isChecked = false;
  bool activated = false;
  late int currentValue;
  final RowFocusNode _checkboxFocusNode = RowFocusNode(debugLabel: "Filter checkbox");
  final RowFocusNode _minusFocusNode = RowFocusNode(debugLabel: "Filter minus");
  final RowFocusNode _plusFocusNode = RowFocusNode(debugLabel: "Filter plus");

  @override
  void initState() {
    currentValue = widget.defaultValue;
    activated = widget.activated;
    _checkboxFocusNode.right = _minusFocusNode;
    _minusFocusNode.left = _checkboxFocusNode;
    _minusFocusNode.right = _plusFocusNode;
    _plusFocusNode.left = _minusFocusNode;
    super.initState();
  }

  @override
  void dispose() {
    _checkboxFocusNode.dispose();
    _minusFocusNode.dispose();
    _plusFocusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant IntFilterPaneItemTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The title is kept when the page is rebuilt (the page gives the filter
    // item a GlobalKey), so it follows the filter, e.g. when all the filters
    // are cleared
    activated = widget.activated;
    currentValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:33,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        MouseRegion(
          onEnter: (PointerEnterEvent e) {
            SFXService().playSFX(SFX.HOVER_OVER_STAR_OR_FILTER);
          },
          child: Checkbox(
              focusNode: _checkboxFocusNode,
              checked: activated,
              onChanged: (value) {
                widget.onActivationChanged(value!);
                setState(() {
                  activated = value;
                });
                SFXService().playSFX(SFX.CLICK);
              }),
        ),
        SizedBox(width: 8),
        Icon(widget.icon,
            color: activated ? null : const Color.fromARGB(255, 130, 130, 130)),
        SizedBox(width: 10),
        Text(widget.name,
            style: TextStyle(
                color:
                    activated ? null : const Color.fromARGB(255, 130, 130, 130))),
        Spacer(),
        // Can be selected with the keyboard or a controller once the filter is
        // activated, like the combo box of the other filters
        FocusableTap(
            focusNode: _minusFocusNode,
            onPressed: activated
                ? () {
                    if (currentValue - widget.step >= widget.min) {
                      setState(() {
                        currentValue = currentValue - widget.step;
                        widget.onChanged(currentValue);
                      });
                      SFXService().playSFX(SFX.CLICK);
                    }
                  }
                : null,
            child: Icon(FontAwesomeIcons.minus,
                color: activated && currentValue != widget.min
                    ? null
                    : Colors.grey)),
        SizedBox(width: 8),
        SizedBox(
            width: 30,
            child: Text(
                currentValue.toString() + (currentValue == widget.max ? "+" : ""),
                textAlign: TextAlign.center,
                style: TextStyle(color: activated ? null : Colors.grey))),
        SizedBox(width: 8),
        FocusableTap(
            focusNode: _plusFocusNode,
            onPressed: activated
                ? () {
                    if (currentValue + widget.step <= widget.max) {
                      setState(() {
                        currentValue = currentValue + widget.step;
                        widget.onChanged(currentValue);
                      });
                      SFXService().playSFX(SFX.CLICK);
                    }
                  }
                : null,
            child: Icon(FontAwesomeIcons.plus,
                color: activated && currentValue != widget.max
                    ? null
                    : Colors.grey)),
      ]),
    );
  }
}
