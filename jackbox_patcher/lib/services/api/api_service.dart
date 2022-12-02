import 'dart:convert';

import 'package:http/http.dart';

import '../../model/jackboxpack.dart';
import 'api_endpoints.dart';

class APIService {
  static final APIService _instance = APIService._internal();
  final String baseEndpoint = "https://alexisl61.github.io/JackboxPatcherFR/api";
  final String baseAssets = "https://alexisl61.github.io/JackboxPatcherFR/assets";
  // Build factory
  factory APIService() {
    return _instance;
  }

  // Build internal
  APIService._internal();

  // Get packs
  Future<List<JackboxPack>> getPacks() async {
    final response = await get(Uri.parse('$baseEndpoint'+APIEndpoints.PACKS.path));
    if (response.statusCode == 200) {
      final List<dynamic> packs = jsonDecode(response.body);
      return packs.map((pack) => JackboxPack.fromJson(pack)).toList();
    } else {
      throw Exception('Failed to load packs');
    }
  }

  String assetLink(String asset) {
    return '$baseAssets/$asset';
  }
}
