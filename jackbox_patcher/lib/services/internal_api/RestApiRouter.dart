import 'package:jackbox_patcher/services/internal_api/handlers/AbstractHandler.dart';
import 'package:jackbox_patcher/services/internal_api/handlers/PingHandler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

class RestApiRouter {
  static final List<AbstractHandler> _handlers = [
    PingHandler()
  ];
  
  static final RestApiRouter _singleton = RestApiRouter._internal();

  factory RestApiRouter() {
    return _singleton;
  }

  RestApiRouter._internal();

  void startRouter() async {
    var handler = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(_echoRequest);

    var server = await shelf_io.serve(handler, 'localhost', 8080);
    print('Serving at http://${server.address.host}:${server.port}');
  }

  static Future<Response> _echoRequest(Request request) async {
    return Response.ok('Request for "${request.url}"');
  }
}