import 'package:jackbox_patcher/services/internal_api/rest_api_scopes.dart';

class ExtensionToken {
  String token;
  List<RestApiScopes> scopes = [];

  ExtensionToken({required this.token, required this.scopes});
}