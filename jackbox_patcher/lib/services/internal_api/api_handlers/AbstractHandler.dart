import 'package:jackbox_patcher/services/internal_api/RestApiRouter.dart';
import 'package:jackbox_patcher/services/internal_api/RestApiScopes.dart';
import 'package:jackbox_patcher/services/internal_api/ExtensionToken.dart';
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
      print(scope);
      print(tokenFound.scopes);
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
