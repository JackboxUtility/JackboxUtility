import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/customServerComponent/customServerComponentWidgetFactory.dart';
import 'package:jackbox_patcher/model/customServerComponent/containerServerComponent.dart';

class ContainerServerComponentWidget extends StatefulWidget {
  ContainerServerComponentWidget({Key? key, required this.component})
      : super(key: key);

  final ContainerServerComponent component;

  @override
  State<ContainerServerComponentWidget> createState() =>
      _ColumnServerComponentWidgetState();
}

class _ColumnServerComponentWidgetState
    extends State<ContainerServerComponentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.component.child != null
          ? CustomServerComponentWidgetFactory(
              component: widget.component.child!)
          : null,
    );
  }
}
