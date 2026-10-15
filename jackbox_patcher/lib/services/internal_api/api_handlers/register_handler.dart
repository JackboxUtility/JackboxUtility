import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/dialogs/extension_connection_dialog.dart';
import 'package:jackbox_patcher/services/crypto/crypto_service.dart';
import 'package:jackbox_patcher/services/internal_api/extension.dart';
import 'package:jackbox_patcher/services/internal_api/rest_api_router.dart';
import 'package:jackbox_patcher/services/internal_api/rest_api_scopes.dart';
import 'package:jackbox_patcher/services/internal_api/extension_token.dart';
import 'package:jackbox_patcher/services/internal_api/api_handlers/abstract_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:window_manager/window_manager.dart';

class RegisterHandler extends AbstractHandler {
  RegisterHandler()
      : super(url: "/register", method: RestApiMethods.POST, scopes: []);

  @override
  Function get handle {
    return (Request req) async {
      if (super.hasAccess(req) != null) {
        return hasAccess(req);
      }

      final requestBody = await req.readAsString();
      final Extension extension = Extension.fromJson(jsonDecode(requestBody));
      final List<RestApiScopes> scopes =
          scopesFromJson(jsonDecode(requestBody)["scopes"]);

      windowManager.focus();

      // Null when the dialog is closed without choosing (e.g. with Esc)
      bool? isExtensionAccepted = await showDialog<bool>(
          context: RestApiRouter().context!,
          builder: (context) {
            return ExtensionConnectionDialog(
                extension: extension, scopes: scopes);
          });

      if (isExtensionAccepted != true) {
        return Response.forbidden(
            jsonEncode({"error": "Extension not accepted"}));
      }
      String generatedToken = CryptoService.generateRandomToken(256);
      RestApiRouter().tokens.add(ExtensionToken(
          token: CryptoService.sha256Encrypt(generatedToken),
          scopes: scopes));
      return Response.ok(jsonEncode({"token": generatedToken}));
    };
  }

  List<RestApiScopes> scopesFromJson(json) {
    List<RestApiScopes> scopes = [];
    for (String scope in json) {
      scopes.add(RestApiScopes.values.firstWhere((e) => e.id == scope));
    }
    return scopes;
  }
}
