import 'package:jackbox_patcher/services/internal_api/rest_api_scopes.dart';

class AbstractWsMessage {
  final String channel;
  final RestApiScopes scope;

  AbstractWsMessage(this.channel, this.scope);

  Map<String, dynamic> toJson() {
    return {
      'channel': channel
    };
  }
}