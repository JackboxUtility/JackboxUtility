import 'package:jackbox_patcher/services/internal_api/handlers/AbstractHandler.dart';
import 'package:shelf/shelf.dart';

class PingHandler extends AbstractHandler{
  @override
  Future<Response> handle(Request req) async {
    return Response.ok("Pong");    
  }
}