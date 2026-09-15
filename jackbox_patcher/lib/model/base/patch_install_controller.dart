class PatchInstallController {
  final String id;
  final String controllerUrl;
  final String onlineServiceUrl;

  PatchInstallController({
    required this.id,
    required this.controllerUrl,
    required this.onlineServiceUrl,
  });

  factory PatchInstallController.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final controllerUrl = json['controller_url'];
    final onlineServiceUrl = json['online_service_url'];
    if (id is! String ||
        controllerUrl is! String ||
        onlineServiceUrl is! String) {
      throw const FormatException('Invalid install controller configuration.');
    }
    return PatchInstallController(
      id: id,
      controllerUrl: controllerUrl,
      onlineServiceUrl: onlineServiceUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'controller_url': controllerUrl,
      'online_service_url': onlineServiceUrl,
    };
  }
}
