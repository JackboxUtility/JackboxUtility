import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/components/dialogs/extensionConnectionDialog.dart';
import 'package:jackbox_patcher/services/crypto/CryptoService.dart';
import 'package:jackbox_patcher/services/internal_api/Extension.dart';
import 'package:jackbox_patcher/services/internal_api/RestApiRouter.dart';
import 'package:jackbox_patcher/services/internal_api/RestApiScopes.dart';
import 'package:jackbox_patcher/services/internal_api/ExtensionToken.dart';
import 'package:jackbox_patcher/services/internal_api/api_handlers/AbstractHandler.dart';
import 'package:shelf/shelf.dart';
import 'package:window_manager/window_manager.dart';

class RegisterHandler extends AbstractHandler {
  RegisterHandler()
      : super(url: "/register", method: RestApiMethods.GET, scopes: []);

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

      bool isExtensionAccepted = await showDialog(
          context: RestApiRouter().context!,
          builder: (context) {
            return ExtensionConnectionDialog(
                extension: extension, scopes: scopes);
          }) as bool;

      if (!isExtensionAccepted) {
        return Response.forbidden(
            jsonEncode({"error": "Extension not accepted"}));
      }
      String generatedToken = CryptoService.generateRandomToken(256);
      RestApiRouter().tokens.add(ExtensionToken(
          token: CryptoService.sha256Encrypt(generatedToken),
          scopes: [RestApiScopes.NAVIGATION]));
      return Response.ok(jsonEncode({"token": generatedToken}));
    };
  }

  List<RestApiScopes> scopesFromJson(json) {
    List<RestApiScopes> scopes = [];
    for (String scope in json) {
      print(scope);
      print(RestApiScopes.values);
      scopes.add(RestApiScopes.values.firstWhere((e) => e.id == scope));
    }
    return scopes;
  }
}
