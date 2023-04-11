import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:jackbox_patcher/model/jackboxgame.dart';
import 'package:jackbox_patcher/model/jackboxgamepatch.dart';
import 'package:jackbox_patcher/model/jackboxpackpatch.dart';
import 'package:jackbox_patcher/model/news.dart';
import 'package:jackbox_patcher/model/patchserver.dart';
import 'package:jackbox_patcher/pages/patcher/categoryPackPatch.dart';

import '../../model/gametag.dart';
import '../../model/jackboxpack.dart';
import '../../model/patchsCategory.dart';
import 'api_endpoints.dart';

class APIService {
  static final APIService _instance = APIService._internal();
  String masterServer =
      "https://alexisl61.github.io/JackboxUtility/servers.json";
  String? baseEndpoint;
  String? baseAssets;

  List<PatchServer> cachedServers = [];
  PatchServer? cachedSelectedServer;
  List<JackboxPack> cachedPacks = [];
  List<GameTag> cachedTags = [];
  List<PatchCategory> cachedCategories = [];
  List<News> cachedNews = [];
  // Build factory
  factory APIService() {
    return _instance;
  }

  // Build internal
  APIService._internal();

  void resetCache() {
    cachedServers = [];
    cachedPacks = [];
    cachedTags = [];
    cachedNews = [];
  }

  Future<void> recoverAvailableServers() async {
    resetCache();
    final response = await get(Uri.parse(masterServer));
    if (response.statusCode == 200) {
      final List<dynamic> availableServers = jsonDecode(response.body);
      for (var server in availableServers) {
        final response = await get(Uri.parse(server));
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          cachedServers.add(PatchServer.fromJson(server, data));
        } else {}
      }
    } else {
      throw Exception('Failed to load servers');
    }
  }

  Future<void> recoverServerInfo(String serverLink) async {
    final response = await get(Uri.parse(serverLink));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      cachedSelectedServer = PatchServer.fromJson(serverLink, data);
      final endpoints = await cachedSelectedServer!.getVersionUrl();
      baseEndpoint = endpoints.apiEndpoint;
      baseAssets = endpoints.assetsEndpoint;
    } else {
      throw Exception('Failed to load servers');
    }
  }

  Future<void> recoverPacksAndTags() async {
    final response =
        await get(Uri.parse('$baseEndpoint' + APIEndpoints.PACKS.path));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      cachedTags =
          data["tags"].map<GameTag>((tag) => GameTag.fromJson(tag)).toList();
      cachedPacks = data["packs"]
          .map<JackboxPack>((pack) => JackboxPack.fromJson(pack))
          .toList();
      cachedCategories =data["patchsCategories"]!=null? data["patchsCategories"]
          .map<PatchCategory>(
              (category) => PatchCategory.fromJson(category))
          .toList():[];
    } else {
      throw Exception('Failed to load packs and tags');
    }
  }

  Future<void> recoverNewsAndLinks() async {
    final response =
        await get(Uri.parse('$baseEndpoint' + APIEndpoints.WELCOME.path));
    if (response.statusCode == 200) {
      final Map<dynamic, dynamic> welcome = jsonDecode(response.body);
      cachedNews =
          welcome["news"].map<News>((news) => News.fromJson(news)).toList();
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

  // Download game patch
  Future<String> downloadPatch(
      String patchUri, void Function(double, double) progressCallback) async {
    Dio dio = Dio();
    final response = await dio.downloadUri(
        Uri.parse(APIService().assetLink('${patchUri}')), "./downloads/tmp."+patchUri.split(".").last,
        options: Options(),
        onReceiveProgress: (received, total) {
      progressCallback(received.toInt().toDouble(), total.toInt().toDouble());
    });
    if (response.statusCode == 200) {
      return  "./downloads/tmp."+patchUri.split(".").last;
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
    return asset.startsWith("http") ? asset : '$baseAssets/$asset';
  }

  String getDefaultBackground() {
    return '$baseAssets/backgrounds/default_background.png';
  }
}
