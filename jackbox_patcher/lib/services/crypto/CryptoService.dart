import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

class CryptoService {
  static generateRandomToken (int length) {
    var random = Random.secure();
    var values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64UrlEncode(values);
  }

  static String sha256Encrypt(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}