import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/custom_server_component/column_server_component_widget.dart';
import 'package:jackbox_patcher/components/custom_server_component/container_server_component_widget.dart';
import 'package:jackbox_patcher/components/custom_server_component/text_server_component_widget.dart';
import 'package:jackbox_patcher/model/custom_server_component/column_server_component.dart';
import 'package:jackbox_patcher/model/custom_server_component/container_server_component.dart';
import 'package:jackbox_patcher/model/custom_server_component/countdown_server_component.dart';
import 'package:jackbox_patcher/model/custom_server_component/custom_server_component.dart';
import 'package:jackbox_patcher/model/custom_server_component/text_server_component.dart';

import 'countdown_server_component_widget.dart';

class CustomServerComponentWidgetFactory extends StatefulWidget {
  CustomServerComponentWidgetFactory({Key? key, required this.component})
      : super(key: key);

  final CustomServerComponent component;

  @override
  State<CustomServerComponentWidgetFactory> createState() =>
      _CustomServerComponentWidgetFactoryState();
}

class _CustomServerComponentWidgetFactoryState
    extends State<CustomServerComponentWidgetFactory> {
  @override
  Widget build(BuildContext context) {
    if (widget.component is ColumnServerComponent) {
      return ColumnServerComponentWidget(
          component: widget.component as ColumnServerComponent);
    }

    if (widget.component is TextServerComponent) {
      return TextServerComponentWidget(
          component: widget.component as TextServerComponent);
    }

    if (widget.component is CountdownServerComponent) {
      return CountdownServerComponentWidget(
          component: widget.component as CountdownServerComponent);
    }

    return ContainerServerComponentWidget(
        component: widget.component as ContainerServerComponent);
  }
}
