import 'dart:convert';

import 'package:jackbox_patcher/services/internal_api/rest_api_scopes.dart';
import 'package:jackbox_patcher/services/internal_api/api_handlers/abstract_handler.dart';
import 'package:jackbox_patcher/services/user/user_data.dart';
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