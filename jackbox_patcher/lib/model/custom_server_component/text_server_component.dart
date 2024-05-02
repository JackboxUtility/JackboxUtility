import 'custom_server_component.dart';

class TextServerComponent extends CustomServerComponent{
  late String text;
  TextServerComponent({required Map<String, dynamic> json}) : super(json: json){
    text = json['text'];
  }
}