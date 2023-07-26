import 'customServerComponent.dart';

class TextServerComponent extends CustomServerComponent{
  late String text;
  TextServerComponent({required Map<String, dynamic> json}) : super(json: json){
    text = json['text'];
  }
}