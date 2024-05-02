import 'package:fluent_ui/fluent_ui.dart';

class ColumnSetting extends StatefulWidget {
  ColumnSetting({Key? key, required this.children, required this.color}) : super(key: key);

  final List<Widget> children;
  final Color color;

  @override
  State<ColumnSetting> createState() => _ColumnSettingState();
}

class _ColumnSettingState extends State<ColumnSetting> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: widget.color),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.children,
      ),
    );
  }
}