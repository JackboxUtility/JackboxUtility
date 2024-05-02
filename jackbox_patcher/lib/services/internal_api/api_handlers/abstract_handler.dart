import 'package:jackbox_patcher/services/internal_api/rest_api_router.dart';
import 'package:jackbox_patcher/services/internal_api/rest_api_scopes.dart';
import 'package:jackbox_patcher/services/internal_api/extension_token.dart';
import 'package:shelf/shelf.dart';

enum RestApiMethods { GET, POST, PUT, DELETE }

class AbstractHandler {
  List<RestApiScopes> scopes = [];
  RestApiMethods method = RestApiMethods.GET;
  String url = "/";

  AbstractHandler(
      {required this.scopes, required this.method, required this.url});

  Response? hasAccess(Request request) {
    if (scopes.isEmpty) {
      return null;
    }
    String? token = request.headers['Authorization'];
    if (token == null) {
      return Response.forbidden("No token provided");
    }
    ExtensionToken? tokenFound = RestApiRouter().getToken(token);
    if (tokenFound == null) {
      return Response.forbidden("Invalid token");
    }
    for (RestApiScopes scope in scopes) {
      if (!tokenFound.scopes.contains(scope)) {
        return Response.forbidden("Invalid scope");
      }
    }
    return null;
  }

  Function get handle {
    return (Request req) {
      return Response.notFound("Not found");
    };
  }
}
