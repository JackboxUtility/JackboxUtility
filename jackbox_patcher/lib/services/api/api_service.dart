import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:jackbox_patcher/model/jackboxgame.dart';
import 'package:jackbox_patcher/model/jackboxpatch.dart';
import 'package:jackbox_patcher/model/news.dart';

import '../../model/gametag.dart';
import '../../model/jackboxpack.dart';
import 'api_endpoints.dart';

class APIService {
  static final APIService _instance = APIService._internal();
  final String baseEndpoint =
      "https://alexisl61.github.io/JackboxUtility/api/v2";
  final String baseAssets =
      "https://alexisl61.github.io/JackboxUtility/assets";

  List<JackboxPack> cachedPacks = [];
  List<GameTag> cachedTags = [];
  List<News> cachedNews = [];
  // Build factory
  factory APIService() {
    return _instance;
  }

  // Build internal
  APIService._internal();

  Future<void> recoverPacksAndTags() async {
    final response =
        await get(Uri.parse('$baseEndpoint' + APIEndpoints.PACKS.path));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      cachedTags = data["tags"].map<GameTag>((tag) => GameTag.fromJson(tag)).toList();
      cachedPacks = 
          data["packs"].map<JackboxPack>((pack) => JackboxPack.fromJson(pack)).toList();
    } else {
      throw Exception('Failed to load packs and tags');
    }
  }

  Future<void> recoverNewsAndLinks()async{
    final response =
        await get(Uri.parse('$baseEndpoint' + APIEndpoints.WELCOME.path));
    if (response.statusCode == 200) {
      final Map<dynamic, dynamic> welcome = jsonDecode(response.body);
      cachedNews = welcome["news"].map<News>((news) => News.fromJson(news)).toList();
    } else {
      //throw Exception('Failed to load welcome');
    }
  }

  // Get packs
  List<JackboxPack> getPacks() {
    return cachedPacks;
  }

  // Get tags
  List<GameTag> getTags() {
    return cachedTags;
  }

  // Download patch
  Future<String> downloadPatch(JackboxPatch patch,
      void Function(double, double) progressCallback) async {
    Dio dio = Dio();
    print('$baseAssets/${patch.patchPath}');
    final response = await dio.downloadUri(
        Uri.parse('$baseAssets/${patch.patchPath}'), "./downloads/tmp.zip",
        onReceiveProgress: (received, total) {
      progressCallback(received.toDouble(), total.toDouble());
    });
    if (response.statusCode == 200) {
      return "./downloads/tmp.zip";
    } else {
      throw Exception('Failed to download patch');
    }
  }

  Future<String> downloadPackLoader(
      JackboxPack pack, void Function(double, double) progressCallback) async {
    Dio dio = Dio();
    final response = await dio.downloadUri(
        Uri.parse('$baseAssets/${pack.loader!.path}'),
        "./downloads/loader/${pack.id}/default.zip",
        onReceiveProgress: (received, total) {
      progressCallback(received.toDouble(), total.toDouble());
    });
    if (response.statusCode == 200) {
      return "./downloads/loader/${pack.id}/default.zip";
    } else {
      throw Exception('Failed to download patch');
    }
  }

  Future<String> downloadGameLoader(JackboxPack pack, JackboxGame game,
      void Function(double, double) progressCallback) async {
    Dio dio = Dio();
    final response = await dio.downloadUri(
        Uri.parse('$baseAssets/${game.loader!.path}'),
        "./downloads/loader/${pack.id}/${game.id}.zip",
        onReceiveProgress: (received, total) {
      progressCallback(received.toDouble(), total.toDouble());
    });
    if (response.statusCode == 200) {
      return "./downloads/loader/${pack.id}/${game.id}.zip";
    } else {
      throw Exception('Failed to download patch');
    }
  }

  String assetLink(String asset) {
    return '$baseAssets/$asset';
  }

  String getDefaultBackground(){
    return '$baseAssets/backgrounds/default_background.png';
  }
}
