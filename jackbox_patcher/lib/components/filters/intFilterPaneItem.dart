import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IntFilterPaneItem extends PaneItemHeader {
  IntFilterPaneItem(
      {
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
              icon:icon,
                name: name,
                onChanged: onChanged,
                onActivationChanged: onActivationChanged, 
                min: min,
                max: max,
                defaultValue: defaultValue,
                step: step, 
      activated :activated));

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
  State<IntFilterPaneItemTitle> createState() =>
      _IntFilterPaneItemTitleState();
}

class _IntFilterPaneItemTitleState
    extends State<IntFilterPaneItemTitle> {
  bool isChecked = false;
  bool activated = false;
  late int currentValue;

  @override
  void initState() {
    currentValue = widget.defaultValue;
    activated = widget.activated;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Checkbox(
          checked: activated,
          onChanged: (value) {
            widget.onActivationChanged(value!);
            setState(() {
              activated = value;
            });}),
      SizedBox(width: 8),
      Icon(widget.icon, color: activated?null:const Color.fromARGB(255, 130, 130, 130)),
      SizedBox(width: 10),
      Text(widget.name, style: TextStyle(color: activated ? null : const Color.fromARGB(255, 130, 130, 130))),
      Spacer(),
      GestureDetector(
        onTap: () {
          if (activated) {
            if (currentValue - widget.step >= widget.min)
              setState(() {
                currentValue = currentValue - widget.step;
                widget.onChanged(currentValue);
              });
          }
        },
        child:Icon(FontAwesomeIcons.minus, color: activated && currentValue!=widget.min?null:Colors.grey )), 
      SizedBox(width: 8),
      SizedBox(width:30, child: Text( currentValue.toString()+(currentValue==widget.max?"+":""), textAlign: TextAlign.center, style:TextStyle(color: activated?null:Colors.grey))),
      SizedBox(width: 8),
      GestureDetector(
        onTap: () {
          if (activated) {
            if (currentValue + widget.step <= widget.max)
              setState(() { 
                currentValue = currentValue + widget.step;
                widget.onChanged(currentValue); 
              });
          }
        },
        child:Icon(FontAwesomeIcons.plus, color: activated && currentValue!=widget.max?null:Colors.grey)),
    ]);
  }
}
