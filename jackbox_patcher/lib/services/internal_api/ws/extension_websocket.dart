
import 'package:jackbox_patcher/services/internal_api/extension_token.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ExtensionWebsocket {
  final WebSocketChannel channel;
  final ExtensionToken token;  

  const ExtensionWebsocket(this.channel, this.token);

  void send(String message) {
    channel.sink.add(message);
  }
}