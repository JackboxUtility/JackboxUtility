import 'package:fluent_ui/fluent_ui.dart';

class BooleanSetting extends StatefulWidget {
  BooleanSetting(
      {Key? key,
      required this.title,
      required this.description,
      required this.isChecked,
      required this.setter,
      required this.parentReload})
      : super(key: key);

  final String title;
  final String description;
  final bool isChecked;
  final Future<void> Function(bool) setter;
  final Function() parentReload;

  @override
  State<BooleanSetting> createState() => _BooleanSettingState();
}

class _BooleanSettingState extends State<BooleanSetting> {
  @override
  Widget build(BuildContext context) {
    return ListTile.selectable(
      title: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title,
                  style: FluentTheme.of(context).typography.bodyLarge),
              Text(widget.description,
                  style: FluentTheme.of(context).typography.body),
            ],
          ),
          const Spacer(),
          ToggleSwitch(
              checked: widget.isChecked,
              onChanged: (value) async {
                await widget.setter(!widget.isChecked);
        widget.parentReload();
                setState(() {});
              }),
        ],
      ),
      selected: widget.isChecked,
      onPressed: () async {
        await widget.setter(!widget.isChecked);
        widget.parentReload();
        setState(() {});
      },
    );
  }
}
