import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;
import 'package:jackbox_patcher/app_configuration.dart';
import 'package:jackbox_patcher/services/crypto/crypto_service.dart';
import 'package:jackbox_patcher/services/internal_api/extension_token.dart';
import 'package:jackbox_patcher/services/internal_api/api_handlers/abstract_handler.dart';
import 'package:jackbox_patcher/services/internal_api/api_handlers/get_games_handler.dart';
import 'package:jackbox_patcher/services/internal_api/api_handlers/status_handler.dart';
import 'package:jackbox_patcher/services/internal_api/api_handlers/register_handler.dart';
import 'package:jackbox_patcher/services/internal_api/ws/extension_websocket.dart';
import 'package:jackbox_patcher/services/internal_api/ws_message/abstract_ws_message.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'api_handlers/open_game_handler.dart';

class RestApiRouter {
  static final List<AbstractHandler> _httpHandlers = [
    StatusHandler(),
    RegisterHandler(),
    OpenGameHandler(),
    GetGamesHandler()
  ];

  static final List<ExtensionWebsocket> _wsChannels = [];

  List<ExtensionToken> tokens = [];

  fluent_ui.BuildContext? context = null;

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
          httpApp.get("/api${handler.url}", handler.handle);
          break;
        case RestApiMethods.POST:
          httpApp.post("/api${handler.url}", handler.handle);
          break;
        case RestApiMethods.PUT:
          httpApp.put("/api${handler.url}", handler.handle);
          break;
        case RestApiMethods.DELETE:
          httpApp.delete("/api${handler.url}", handler.handle);
          break;
      }
    }

    // Adding ws handlers
    httpApp.add("GET", "/ws", webSocketHandler((WebSocketChannel ws, String? subprotocol) {
      ws.stream.listen((message) {
        _handleWsRequest(ws, message);
      });
    }));

    await shelf_io.serve(httpApp, '127.0.0.1', REST_API_PORT, shared: true);
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

  void _handleWsRequest(WebSocketChannel ws, String message) {
    try {
      final convertedMessage = jsonDecode(message);
      if (convertedMessage["token"] != null) {
        final token = getToken(convertedMessage["token"]);
        if (token != null) {
          _wsChannels.add(ExtensionWebsocket(ws, token));
          ws.sink.add(jsonEncode({"status": "ok"}));
        }
      }
    } catch (e) {
    }
  }

  void sendMessage(AbstractWsMessage message) {
    for (ExtensionWebsocket channel in _wsChannels) {
      if (channel.token.scopes.contains(message.scope)) {
        channel.send(jsonEncode(message.toJson()));
      }
    }
  }
}
