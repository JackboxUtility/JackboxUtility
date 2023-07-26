import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/customServerComponent/customServerComponentWidgetFactory.dart';
import 'package:jackbox_patcher/model/customServerComponent/TextServerComponent.dart';

class TextServerComponentWidget extends StatefulWidget {
  TextServerComponentWidget({Key? key, required this.component})
      : super(key: key);

  final TextServerComponent component;

  @override
  State<TextServerComponentWidget> createState() =>
      _ColumnServerComponentWidgetState();
}

class _ColumnServerComponentWidgetState
    extends State<TextServerComponentWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.component.text
    );
  }
}
