import 'dart:io';

import 'package:jackbox_patcher/services/crypto/CryptoService.dart';
import 'package:jackbox_patcher/services/internal_api/Token.dart';
import 'package:jackbox_patcher/services/internal_api/api_handlers/AbstractHandler.dart';
import 'package:jackbox_patcher/services/internal_api/api_handlers/PingHandler.dart';
import 'package:jackbox_patcher/services/internal_api/api_handlers/RegisterHandler.dart';
import 'package:jackbox_patcher/services/internal_api/ws_handlers/AbstractWsHandler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';

class RestApiRouter {
  static final List<AbstractHandler> _httpHandlers = [
    PingHandler(),
    RegisterHandler()
  ];
  static final List<AbstractWsHandler> _wsHandlers = [];

  List<ExtensionToken> tokens = [];

  static final RestApiRouter _singleton = RestApiRouter._internal();

  factory RestApiRouter() {
    return _singleton;
  }

  RestApiRouter._internal();

  void startRouter() async {
    // HTTP Router
    await startHTTPRouter();
  }

  Future<void> startHTTPRouter() async {
    var httpApp = Router();

    for (AbstractHandler handler in _httpHandlers) {
      switch (handler.method) {
        case RestApiMethods.GET:
          httpApp.get(handler.url, handler.handle);
          break;
        case RestApiMethods.POST:
          httpApp.post(handler.url, handler.handle);
          break;
        case RestApiMethods.PUT:
          httpApp.put(handler.url, handler.handle);
          break;
        case RestApiMethods.DELETE:
          httpApp.delete(handler.url, handler.handle);
          break;
      }
    }

    // Adding ws handlers
    httpApp.add("GET", "/ws", webSocketHandler((ws) {
      ws.stream.listen((message) {
        ws.sink.add('echo: $message');
      });
    }));

    await shelf_io.serve(httpApp, '127.0.0.1', 8080, shared: true);
  }

  static Future<Response> _echoRequest(Request request) async {
    return Response.ok('Request for "${request.url}"');
  }

  ExtensionToken? getToken(String token) {
    List<ExtensionToken> tokensFound = tokens
        .where((element) => element.token == CryptoService.sha256Encrypt(token))
        .toList();
    if (tokensFound.isEmpty) {
      return null;
    } else {
      return tokensFound[0];
    }
  }
}
