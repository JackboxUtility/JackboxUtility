import 'customServerComponent.dart';

class CountdownServerComponent extends CustomServerComponent {
  late String endText;
  late String endTime;
  CountdownServerComponent({required Map<String, dynamic> json})
      : super(json: json) {
    endText = json['endText'];
    endTime = json['endTime']+"Z";
  }
}
