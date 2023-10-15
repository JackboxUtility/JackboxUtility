import 'dart:convert';

import 'package:jackbox_patcher/services/crypto/CryptoService.dart';
import 'package:jackbox_patcher/services/internal_api/RestApiRouter.dart';
import 'package:jackbox_patcher/services/internal_api/Scopes.dart';
import 'package:jackbox_patcher/services/internal_api/Token.dart';
import 'package:jackbox_patcher/services/internal_api/api_handlers/AbstractHandler.dart';
import 'package:shelf/shelf.dart';

class RegisterHandler extends AbstractHandler {
  RegisterHandler()
      : super(url: "/register", method: RestApiMethods.GET, scopes: []);

  @override
  Function get handle {
    return (Request req) {
      if (super.hasAccess(req) != null) {
        return hasAccess(req);
      }
      String generatedToken = CryptoService.generateRandomToken(256);
      RestApiRouter().tokens.add(ExtensionToken(
          token: CryptoService.sha256Encrypt(generatedToken),
          scopes: [RestApiScopes.GAMES]));
      return Response.ok(jsonEncode({"token": generatedToken}));
    };
  }
}
