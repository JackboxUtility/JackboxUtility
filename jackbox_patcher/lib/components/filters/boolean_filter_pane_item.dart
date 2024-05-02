import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:jackbox_patcher/model/misc/audio/SFXEnum.dart';
import 'package:jackbox_patcher/services/audio/sfx_service.dart';

class BooleanFilterPaneItem extends PaneItemHeader {
  BooleanFilterPaneItem(
      {required this.name,
      required this.onChanged,
      required this.onActivationChanged})
      : super(
            header: BooleanFilterPaneItemTitle(
                name: name,
                onChanged: onChanged,
                onActivationChanged: onActivationChanged));

  final String name;
  final ValueChanged<bool> onChanged;
  final ValueChanged<bool> onActivationChanged;
}

class BooleanFilterPaneItemTitle extends StatefulWidget {
  BooleanFilterPaneItemTitle(
      {Key? key,
      required this.name,
      required this.onChanged,
      required this.onActivationChanged})
      : super(key: key);

  final String name;
  final ValueChanged<bool> onChanged;
  final ValueChanged<bool> onActivationChanged;

  @override
  State<BooleanFilterPaneItemTitle> createState() =>
      _BooleanFilterPaneItemTitleState();
}

class _BooleanFilterPaneItemTitleState
    extends State<BooleanFilterPaneItemTitle> {
  bool isChecked = false;
  bool activated = false;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      MouseRegion(
        onEnter: (PointerEnterEvent e){
          SFXService().playSFX(SFX.HOVER_OVER_STAR_OR_FILTER);
        },
        child: Checkbox(
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
      Text(widget.name,
          style: TextStyle(
              color:
                  activated ? null : const Color.fromARGB(255, 130, 130, 130))),
      Spacer(),
      ToggleSwitch(
        checked: isChecked,
        onChanged: activated
            ? (value) {
                setState(() {
                  isChecked = value;
                });
                widget.onChanged(value);
                SFXService().playSFX(SFX.CLICK);
              }
            : null,
      )
    ]);
  }
}
