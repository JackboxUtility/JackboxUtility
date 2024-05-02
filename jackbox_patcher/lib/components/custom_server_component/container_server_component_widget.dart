import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/custom_server_component/custom_server_component_widget_factory.dart';
import 'package:jackbox_patcher/model/custom_server_component/container_server_component.dart';

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
