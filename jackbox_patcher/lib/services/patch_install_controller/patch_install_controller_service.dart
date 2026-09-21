import 'package:jackbox_patcher/model/base/patch_install_controller.dart';

import 'tmp3_install_controller.dart';

class PatchInstallControllerService {
  static Future<void> run(
      PatchInstallController? controller, String gameDirectory) async {
    if (controller == null) return;

    switch (controller.id) {
      case 'tmp3':
        await Tmp3InstallController.run(
          gameDirectory,
          controller.controllerUrl,
          controller.onlineServiceUrl,
        );
        return;
      default:
        throw UnsupportedError('Unknown install controller: ${controller.id}');
    }
  }
}
