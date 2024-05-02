import 'package:jackbox_patcher/model/custom_server_component/container_server_component.dart';
import 'package:jackbox_patcher/model/custom_server_component/countdown_server_component.dart';
import 'package:jackbox_patcher/model/custom_server_component/text_server_component.dart';

import 'column_server_component.dart';

abstract class CustomServerComponent {
  Map<String, dynamic> json;

  CustomServerComponent({required this.json});

  factory CustomServerComponent.buildServerComponent(
      Map<String, dynamic> json) {
    switch (json['type']) {
      case 'text':
        return TextServerComponent(json: json);
      case 'container':
        return ContainerServerComponent(json: json);
      case 'countdown':
        return CountdownServerComponent(json: json);
      case 'column':
        return ColumnServerComponent(json: json);
    }
    return ContainerServerComponent(json: json);
  }
}
