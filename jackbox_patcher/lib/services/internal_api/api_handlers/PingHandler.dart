import 'package:jackbox_patcher/services/internal_api/Scopes.dart';
import 'package:jackbox_patcher/services/internal_api/api_handlers/AbstractHandler.dart';
import 'package:shelf/shelf.dart';

class PingHandler extends AbstractHandler {
  PingHandler() : super(url: "/ping", method: RestApiMethods.GET, scopes: [RestApiScopes.GAMES]);

  @override
  Function get handle {
    return (Request req) {
      if (super.hasAccess(req) != null) {
        return hasAccess(req);
      }
      return Response.ok(req.url.path);
    };
  }
}
