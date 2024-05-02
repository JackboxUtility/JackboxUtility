import 'package:jackbox_patcher/model/custom_server_component/custom_server_component.dart';

class ContainerServerComponent extends CustomServerComponent{
  CustomServerComponent? child;
  ContainerServerComponent({required Map<String, dynamic> json}) : super(json: json){
    if (json["child"] != null){
      child = CustomServerComponent.buildServerComponent(json["child"]);
    }
  }
}