import 'dart:convert';
import 'dart:io';

import 'package:jackbox_patcher/app_configuration.dart';
import 'package:jackbox_patcher/services/api_utility/api_service.dart';
import 'package:jackbox_patcher/services/launcher/launcher.dart';
import 'package:jackbox_patcher/services/logger/logger.dart';
import 'package:jackbox_patcher/services/mobile_remote/mobile_remote_state.dart';
import 'package:jackbox_patcher/services/mobile_remote/mobile_spa.dart';
import 'package:jackbox_patcher/services/user/user_data.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// LAN-facing HTTP + WebSocket server that powers the phone remote control.
///
/// Runs on port [MOBILE_REMOTE_PORT] bound to all interfaces (0.0.0.0),
/// so any device on the same network can reach it.
///
/// No auth token is required — this is intentionally open on the LAN so the
/// person running the app on their PC can control it from their phone without
/// extra setup.
class MobileRemoteServer {
  // ── singleton ─────────────────────────────────────────────────────────────
  static final MobileRemoteServer _instance = MobileRemoteServer._internal();

  factory MobileRemoteServer() => _instance;

  MobileRemoteServer._internal();

  // ── state ──────────────────────────────────────────────────────────────────
  /// Fires whenever the phone sends a state update so the desktop UI can react.
  final MobileRemoteStateNotifier stateFromPhone = MobileRemoteStateNotifier();

  final List<WebSocketChannel> _phoneClients = [];

  bool _running = false;

  // ── lifecycle ──────────────────────────────────────────────────────────────
  Future<void> start() async {
    if (_running) return;
    _running = true;

    final router = Router();

    // Serve the SPA
    router.get('/', _handleRoot);

    // REST endpoints
    router.get('/api/games', _handleGetGames);
    router.post('/api/games/launch/<gameId>', _handleLaunchGame);
    router.get('/api/state', _handleGetState);
    router.post('/api/state', _handlePostState);

    // WebSocket
    router.get(
        '/ws',
        webSocketHandler((WebSocketChannel ws, String? _) {
          _phoneClients.add(ws);
          JULogger().i('[MobileRemote] Phone connected, total=${_phoneClients.length}');

          // Send current state immediately on connect
          ws.sink.add(jsonEncode(stateFromPhone.value.toJson()));

          ws.stream.listen(
            (message) => _handleWsMessage(ws, message as String),
            onDone: () {
              _phoneClients.remove(ws);
              JULogger().i('[MobileRemote] Phone disconnected, total=${_phoneClients.length}');
            },
            cancelOnError: true,
          );
        }));

    final handler = const Pipeline().addMiddleware(_corsHeaders()).addHandler(router.call);

    await shelf_io.serve(handler, InternetAddress.anyIPv4, MOBILE_REMOTE_PORT, shared: true);
    JULogger().i('[MobileRemote] Server started on 0.0.0.0:$MOBILE_REMOTE_PORT');
  }

  // ── HTTP handlers ──────────────────────────────────────────────────────────
  Future<Response> _handleRoot(Request _) async {
    return Response.ok(
      kMobileSpaHtml,
      headers: {'Content-Type': 'text/html; charset=utf-8'},
    );
  }

  Future<Response> _handleGetGames(Request _) async {
    final packs = UserData()
        .packs
        .map((p) => {
              'id': p.pack.id,
              'name': p.pack.name,
              'icon': APIService().assetLink(p.pack.icon),
              'owned': p.owned,
              'games': p.games
                  .where((g) => !g.hidden)
                  .map((g) => {
                        'id': g.game.id,
                        'name': g.game.name,
                        'thumbnail': APIService().assetLink(g.game.background),
                        'players': {
                          'min': g.game.info.players.min,
                          'max': g.game.info.players.max,
                        },
                      })
                  .toList(),
            })
        .toList();

    return Response.ok(
      jsonEncode({'packs': packs, 'state': stateFromPhone.value.toJson()}),
      headers: _jsonHeaders,
    );
  }

  Future<Response> _handleLaunchGame(Request req, String gameId) async {
    final game = UserData().packs.getGameById(gameId);
    if (game == null) {
      return Response.notFound(
        jsonEncode({'error': 'Game not found'}),
        headers: _jsonHeaders,
      );
    }
    // Fire-and-forget — launching is async and can take a while
    Launcher.launchGame(game.getPack(), game);
    return Response.ok(jsonEncode({'status': 'ok'}), headers: _jsonHeaders);
  }

  Future<Response> _handleGetState(Request _) async {
    return Response.ok(
      jsonEncode(stateFromPhone.value.toJson()),
      headers: _jsonHeaders,
    );
  }

  Future<Response> _handlePostState(Request req) async {
    try {
      final body = await req.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;
      final newState = MobileRemoteState.fromJson(json);
      stateFromPhone.value = newState;
      _broadcastToPhones(jsonEncode(newState.toJson()));
      return Response.ok(jsonEncode({'status': 'ok'}), headers: _jsonHeaders);
    } catch (_) {
      return Response.badRequest(
        body: jsonEncode({'error': 'Invalid state payload'}),
        headers: _jsonHeaders,
      );
    }
  }

  // ── WebSocket handling ─────────────────────────────────────────────────────
  void _handleWsMessage(WebSocketChannel ws, String message) {
    try {
      final json = jsonDecode(message) as Map<String, dynamic>;
      final type = json['type'] as String?;

      if (type == 'state_update') {
        final newState = MobileRemoteState.fromJson(json);
        stateFromPhone.value = newState;
        // Echo updated state to all other connected phones
        _broadcastToPhones(jsonEncode(newState.toJson()), except: ws);
      } else if (type == 'launch') {
        final gameId = json['gameId'] as String?;
        if (gameId != null) {
          final game = UserData().packs.getGameById(gameId);
          if (game != null) {
            Launcher.launchGame(game.getPack(), game);
          }
        }
      }
    } catch (e) {
      JULogger().w('[MobileRemote] Could not parse WS message: $e');
    }
  }

  // ── public API called by the desktop UI ───────────────────────────────────
  /// Called by [SearchGameMenuWidget] whenever the desktop filter state changes.
  /// Pushes the new state to all connected phones.
  void pushStateToPhones(MobileRemoteState state) {
    _broadcastToPhones(jsonEncode(state.toJson()));
  }

  // ── helpers ────────────────────────────────────────────────────────────────
  void _broadcastToPhones(String message, {WebSocketChannel? except}) {
    final dead = <WebSocketChannel>[];
    for (final client in _phoneClients) {
      if (identical(client, except)) continue;
      try {
        client.sink.add(message);
      } catch (_) {
        dead.add(client);
      }
    }
    _phoneClients.removeWhere((c) => dead.contains(c));
  }

  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
  };

  /// Adds permissive CORS headers so browsers on the phone don't block requests.
  Middleware _corsHeaders() {
    return (Handler inner) => (Request req) async {
          if (req.method == 'OPTIONS') {
            return Response.ok('', headers: {
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
              'Access-Control-Allow-Headers': 'Content-Type',
            });
          }
          final response = await inner(req);
          return response.change(headers: {
            'Access-Control-Allow-Origin': '*',
          });
        };
  }

  /// Returns the first non-loopback IPv4 address for this machine,
  /// useful for showing the user where to point their phone.
  static Future<String?> getLanIpAddress() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLinkLocal: false,
      );
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          if (!addr.isLoopback) return addr.address;
        }
      }
    } catch (_) {}
    return null;
  }
}
