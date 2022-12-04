import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:jackbox_patcher/model/jackboxgame.dart';

import '../../model/jackboxpack.dart';
import 'api_endpoints.dart';

class APIService {
  static final APIService _instance = APIService._internal();
  final String baseEndpoint =
      "https://alexisl61.github.io/JackboxPatcherFR/api";
  final String baseAssets =
      "https://alexisl61.github.io/JackboxPatcherFR/assets";
  // Build factory
  factory APIService() {
    return _instance;
  }

  // Build internal
  APIService._internal();

  // Get packs
  Future<List<JackboxPack>> getPacks() async {
    final response =
        await get(Uri.parse('$baseEndpoint' + APIEndpoints.PACKS.path));
    if (response.statusCode == 200) {
      final List<dynamic> packs = jsonDecode(response.body);
      return packs.map((pack) => JackboxPack.fromJson(pack)).toList();
    } else {
      throw Exception('Failed to load packs');
    }
  }

  Future<String> getWelcome() async{
    final response =
    await get(Uri.parse('$baseEndpoint' + APIEndpoints.WELCOME.path));
    if (response.statusCode == 200) {
      final Map<dynamic,dynamic> welcome = jsonDecode(response.body);
      return welcome["data"];
    } else {
      throw Exception('Failed to load welcome');
    }
  }

  // Download patch
  Future<String> downloadPatch(
      JackboxGame game, void Function(double, double) progressCallback) async {
    Dio dio = Dio();
    print('$baseAssets/${game.patchPath}');
    final response = await dio.downloadUri(
        Uri.parse('$baseAssets/${game.patchPath}'),
        "./${game.id}_${game.latestVersion}.zip",
        onReceiveProgress: (received, total) { progressCallback(received.toDouble(), total.toDouble()); });
    if (response.statusCode == 200) {
      return "./${game.id}_${game.latestVersion}.zip";
    } else {
      throw Exception('Failed to download patch');
    }
  }

  String assetLink(String asset) {
    return '$baseAssets/$asset';
  }
}
