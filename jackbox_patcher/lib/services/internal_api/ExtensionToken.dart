import 'package:jackbox_patcher/services/internal_api/RestApiScopes.dart';

class ExtensionToken {
  String token;
  List<RestApiScopes> scopes = [];

  ExtensionToken({required this.token, required this.scopes});
}