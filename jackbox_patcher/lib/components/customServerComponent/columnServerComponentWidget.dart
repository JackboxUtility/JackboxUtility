import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/customServerComponent/customServerComponentWidgetFactory.dart';
import 'package:jackbox_patcher/model/customServerComponent/columnServerComponent.dart';

class ColumnServerComponentWidget extends StatefulWidget {
  ColumnServerComponentWidget({Key? key, required this.component}) : super(key: key);

  final ColumnServerComponent component;

  @override
  State<ColumnServerComponentWidget> createState() => _ColumnServerComponentWidgetState();
}

class _ColumnServerComponentWidgetState extends State<ColumnServerComponentWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.component.children.map((e) => CustomServerComponentWidgetFactory(component: e)).toList(),
    );
  }
}