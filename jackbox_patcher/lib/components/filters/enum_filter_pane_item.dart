import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:jackbox_patcher/model/misc/filter_enum.dart';

import '../../model/misc/audio/SFXEnum.dart';
import '../../services/audio/sfx_service.dart';
import '../row_focus_node.dart';

class EnumFilterPaneItem extends PaneItemHeader {
  EnumFilterPaneItem(
      {super.key,
      required this.icon,
      required this.name,
      required this.onChanged,
      required this.onActivationChanged,
      required this.defaultValue,
      required this.availableValues,
      required this.activated})
      : super(
            header: EnumFilterPaneItemTitle(
                icon: icon,
                name: name,
                onChanged: onChanged,
                onActivationChanged: onActivationChanged,
                defaultValue: defaultValue,
                availableValues: availableValues,
                activated: activated));

  final IconData icon;
  final String name;
  final ValueChanged<FilterValue> onChanged;
  final ValueChanged<bool> onActivationChanged;
  final FilterValue defaultValue;
  final List<FilterValue> availableValues;
  final bool activated;
}

class EnumFilterPaneItemTitle extends StatefulWidget {
  EnumFilterPaneItemTitle(
      {Key? key,
      required this.icon,
      required this.name,
      required this.onChanged,
      required this.onActivationChanged,
      required this.defaultValue,
      required this.availableValues,
      required this.activated})
      : super(key: key);

  final IconData icon;
  final String name;
  final ValueChanged<FilterValue> onChanged;
  final ValueChanged<bool> onActivationChanged;
  final FilterValue defaultValue;
  final List<FilterValue> availableValues;
  final bool activated;

  @override
  State<EnumFilterPaneItemTitle> createState() =>
      _EnumFilterPaneItemTitleState();
}

class _EnumFilterPaneItemTitleState extends State<EnumFilterPaneItemTitle> {
  bool isChecked = false;
  bool activated = false;
  late FilterValue currentValue;
  final RowFocusNode _checkboxFocusNode = RowFocusNode(debugLabel: "Filter checkbox");
  final RowFocusNode _comboBoxFocusNode = RowFocusNode(debugLabel: "Filter combo box");

  @override
  void initState() {
    currentValue = widget.defaultValue;
    activated = widget.activated;
    _checkboxFocusNode.right = _comboBoxFocusNode;
    _comboBoxFocusNode.left = _checkboxFocusNode;
    super.initState();
  }

  @override
  void dispose() {
    _checkboxFocusNode.dispose();
    _comboBoxFocusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant EnumFilterPaneItemTitle oldWidget) {
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
      height: 33,
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
                color: activated
                    ? null
                    : const Color.fromARGB(255, 130, 130, 130))),
        Spacer(),
        widget.availableValues.length > 1
            ? ComboBox(
                focusNode: _comboBoxFocusNode,
                onTap: () {
                  SFXService().playSFX(SFX.FILTER_UP);
                },
                elevation: 0,
                items: widget.availableValues
                    .map((e) => ComboBoxItem(
                        value: e,
                        child: Row(children: [
                          Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: e.color)),
                          SizedBox(width: 10),
                          Text(e.name)
                        ])))
                    .toList(),
                onChanged: activated
                    ? (FilterValue? value) {
                        widget.onChanged(value!);
                        setState(() {
                          currentValue = value;
                        });
                        SFXService().playSFX(SFX.CLICK);
                      }
                    : null,
                value: currentValue)
            : Container()
      ]),
    );
  }
}
