import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/customServerComponent/columnServerComponentWidget.dart';
import 'package:jackbox_patcher/components/customServerComponent/containerServerComponentWidget.dart';
import 'package:jackbox_patcher/components/customServerComponent/textServerComponentWidget.dart';
import 'package:jackbox_patcher/model/customServerComponent/columnServerComponent.dart';
import 'package:jackbox_patcher/model/customServerComponent/containerServerComponent.dart';
import 'package:jackbox_patcher/model/customServerComponent/customServerComponent.dart';
import 'package:jackbox_patcher/model/customServerComponent/textServerComponent.dart';

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
    return ContainerServerComponentWidget(
        component: widget.component as ContainerServerComponent);
  }
}
