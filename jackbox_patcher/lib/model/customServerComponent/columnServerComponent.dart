import 'customServerComponent.dart';

class ColumnServerComponent extends CustomServerComponent {
  late List<CustomServerComponent> children;
  ColumnServerComponent({required Map<String, dynamic> json})
      : super(json: json) {
    children = [];
    for (var child in json["children"]) {
      children.add(CustomServerComponent.buildServerComponent(child));
    }
    print(children);
  }
}
