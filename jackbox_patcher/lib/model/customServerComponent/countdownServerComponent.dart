import 'customServerComponent.dart';

class CountdownServerComponent extends CustomServerComponent {
  late String endText;
  late DateTime endTime;
  CountdownServerComponent({required Map<String, dynamic> json})
      : super(json: json) {
    endText = json['endText'];
    endTime = DateTime.parse(json['endTime']);
  }
}
