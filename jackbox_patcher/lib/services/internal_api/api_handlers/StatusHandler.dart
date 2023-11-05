import 'dart:convert';

import 'package:jackbox_patcher/services/internal_api/api_handlers/AbstractHandler.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shelf/shelf.dart';

class StatusHandler extends AbstractHandler {
  StatusHandler()
      : super(url: "/status", method: RestApiMethods.GET, scopes: []);

  @override
  Function get handle {
    return (Request req) async {
      if (super.hasAccess(req) != null) {
        return hasAccess(req);
      }
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return Response.ok(jsonEncode({
        "version":packageInfo.version,
        "buildNumber":packageInfo.buildNumber,
        "appName":packageInfo.appName,
        "status": "ok",
      }));
    };
  }
}
