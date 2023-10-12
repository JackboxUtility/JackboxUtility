import 'package:jackbox_patcher/services/crypto/CryptoService.dart';
import 'package:jackbox_patcher/services/internal_api/Token.dart';
import 'package:jackbox_patcher/services/internal_api/handlers/AbstractHandler.dart';
import 'package:jackbox_patcher/services/internal_api/handlers/PingHandler.dart';
import 'package:jackbox_patcher/services/internal_api/handlers/RegisterHandler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

class RestApiRouter {
  static final List<AbstractHandler> _handlers = [PingHandler(), RegisterHandler()];

  List<ExtensionToken> tokens = [

  ];

  static final RestApiRouter _singleton = RestApiRouter._internal();

  factory RestApiRouter() {
    return _singleton;
  }

  RestApiRouter._internal();

  void startRouter() async {
    var app = Router();

    for (AbstractHandler handler in _handlers) {
      switch (handler.method) {
        case RestApiMethods.GET:
          app.get(handler.url, handler.handle);
          break;
        case RestApiMethods.POST:
          app.post(handler.url, handler.handle);
          break;
        case RestApiMethods.PUT:
          app.put(handler.url, handler.handle);
          break;
        case RestApiMethods.DELETE:
          app.delete(handler.url, handler.handle);
          break;
      }
    }

    var server = await shelf_io.serve(app, 'localhost', 8080);
    print('Serving at http://${server.address.host}:${server.port}');
  }

  static Future<Response> _echoRequest(Request request) async {
    return Response.ok('Request for "${request.url}"');
  }

  ExtensionToken? getToken(String token) {
    List<ExtensionToken> tokensFound =
        tokens.where((element) => element.token == CryptoService.sha256Encrypt(token)).toList();
    if (tokensFound.isEmpty) {
      return null;
    } else {
      return tokensFound[0];
    }
  }
}
