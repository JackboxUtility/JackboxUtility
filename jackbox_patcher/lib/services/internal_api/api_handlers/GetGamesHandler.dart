import 'dart:convert';

import 'package:jackbox_patcher/services/internal_api/RestApiScopes.dart';
import 'package:jackbox_patcher/services/internal_api/api_handlers/AbstractHandler.dart';
import 'package:jackbox_patcher/services/user/userdata.dart';
import 'package:shelf/shelf.dart';

class GetGamesHandler extends AbstractHandler {
  GetGamesHandler()
      : super(
            url: "/games/list",
            method: RestApiMethods.GET,
            scopes: [RestApiScopes.NAVIGATION]);

  @override
  Function get handle {
    return (Request req) async {
      if (super.hasAccess(req) != null) {
        return hasAccess(req);
      }
      
      return Response.ok(jsonEncode({"status": "ok", "data": UserData().packs.map((e) => e.toJson()).toList()}));
    };
  }
}