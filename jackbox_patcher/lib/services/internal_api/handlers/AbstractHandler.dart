import 'package:jackbox_patcher/services/internal_api/Scopes.dart';
import 'package:shelf/shelf.dart';

class AbstractHandler {
  List<RestApiScopes> scopes = [];

  Future<Response> handle(Request req) async {
    throw UnimplementedError();
  }
}