import 'package:jackbox_patcher/model/customServerComponent/containerServerComponent.dart';
import 'package:jackbox_patcher/model/customServerComponent/countdownServerComponent.dart';
import 'package:jackbox_patcher/model/customServerComponent/textServerComponent.dart';

import 'columnServerComponent.dart';

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
