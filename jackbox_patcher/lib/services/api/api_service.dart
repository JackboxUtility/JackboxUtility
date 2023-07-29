import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:http/http.dart' as http;
import 'package:jackbox_patcher/app_configuration.dart';
import 'package:jackbox_patcher/model/customServerComponent/columnServerComponent.dart';
import 'package:jackbox_patcher/model/customServerComponent/customServerComponent.dart';
import 'package:jackbox_patcher/model/jackbox/jackboxgame.dart';
import 'package:jackbox_patcher/model/jackbox/jackboxpackpatch.dart';
import 'package:jackbox_patcher/model/misc/urlblurhash.dart';
import 'package:jackbox_patcher/model/news.dart';
import 'package:jackbox_patcher/model/patchServerConfigurations.dart';
import 'package:jackbox_patcher/model/patchserver.dart';
import 'package:jackbox_patcher/services/api/listenable_cache.dart';
import 'package:jackbox_patcher/services/logger/logger.dart';

import '../../model/gametag.dart';
import '../../model/jackbox/jackboxpack.dart';
import '../../model/patchsCategory.dart';
import 'api_endpoints.dart';
import 'api_statistics_endpoints.dart';

typedef serverMessageType = ({
  CustomServerComponent? menuComponent,
  List<({CustomServerComponent component, String packId})>? patchesComponent,
  List<({CustomServerComponent component, String gameId})>? gamesComponent
});

class APIService {
  static final APIService _instance = APIService._internal();
  String masterServer = FlavorConfig.instance.variables["masterServerUrl"];
  String masterStatisticsServer = STATISTICS_SERVER_URL;
  String? baseEndpoint;
  String? baseAssets;

  ListenableCache<String> internalCache = ListenableCache<String>();

  List<PatchServer> cachedServers = [];
  PatchServer? cachedSelectedServer;
  List<JackboxPack> cachedPacks = [];
  List<GameTag> cachedTags = [];
  List<PatchCategory> cachedCategories = [];
  List<News> cachedNews = [];
  List<UrlBlurHash> cachedBlurHashes = [];
  PatchServerConfigurations? cachedConfigurations;
  serverMessageType? cachedServerMessage;

  factory APIService() {
    return _instance;
  }

  // Build internal
  APIService._internal();

  void resetCache() {
    JULogger().i("Resetting cache");
    cachedServers = [];
    cachedPacks = [];
    cachedTags = [];
    cachedNews = [];
    internalCache.clear();
  }

  Future<PatchServer?> recoverServerFromLink(String serverLink) async {
    JULogger().i("Recovering server from link");
    try {
      final serverInfo = await getRequest(Uri.parse(serverLink));
      final Map<String, dynamic> data = jsonDecode(serverInfo.data);
      final PatchServer patchServer = PatchServer.fromJson(serverLink, data);
      return patchServer;
    } catch (e) {
      JULogger().e("Failed to recover server from link");
      JULogger().e(e.toString());
      return null;
    }
  }

  Future<void> recoverAvailableServers() async {
    JULogger().i("Recovering available servers");
    resetCache();
    final data = await getRequest(Uri.parse(masterServer));

    if (!data.sameAsCached) {
      final List<dynamic> availableServers = jsonDecode(data.data);
      for (var server in availableServers) {
        final serverInfo = await getRequest(Uri.parse(server));
        final Map<String, dynamic> data = jsonDecode(serverInfo.data);
        cachedServers.add(PatchServer.fromJson(server, data));
      }
    }
  }

  Future<void> recoverServerInfo(String serverLink) async {
    JULogger().i("Recovering server info");
    final rawData = await getRequest(Uri.parse(serverLink));
      final Map<String, dynamic> data = jsonDecode(rawData.data);
      cachedSelectedServer = PatchServer.fromJson(serverLink, data);
      final endpoints = await cachedSelectedServer!.getVersionUrl();
      baseEndpoint = endpoints.apiEndpoint;
      baseAssets = endpoints.assetsEndpoint;
  }

  Future<bool> recoverPacksAndTags(Function(double) percentDone) async {
    final rawData =
        await getRequest(Uri.parse('$baseEndpoint${APIEndpoints.PACKS.path}'));

    if (!rawData.sameAsCached) {
      final Map<String, dynamic> data = jsonDecode(rawData.data);
      cachedTags =
          data["tags"].map<GameTag>((tag) => GameTag.fromJson(tag)).toList();
      cachedPacks = data["packs"]
          .map<JackboxPack>((pack) => JackboxPack.fromJson(pack))
          .toList();
      cachedCategories = data["patchsCategories"] != null
          ? data["patchsCategories"]
              .map<PatchCategory>(
                  (category) => PatchCategory.fromJson(category))
              .toList()
          : [];
      percentDone(100 / (cachedPacks.length + 1));
      await applyExternalConfiguration(percentDone);
      return true;
    } else {
      return false;
    }
  }

  Future<void> applyExternalConfiguration(
      Function(double percent) percentDone) async {
    int totalPacksDone = 0;
    int totalPacks = 0;
    List<Future> futures = [];
    for (JackboxPack pack in cachedPacks) {
      for (JackboxPackPatch patch in pack.patches) {
        if (patch.configuration != null) {
          if (patch.configuration!.versionOrigin ==
              OnlineVersionOrigin.REPO_FILE) {
            totalPacks++;
            final rawData =
                getRequest(Uri.parse(patch.configuration!.versionFile));
            rawData.then((retrievedData) {
              final Map<String, dynamic> data = jsonDecode(retrievedData.data);
              patch.latestVersion = data[patch.configuration!.versionProperty]
                  .replaceAll("Build:", "")
                  .trim();
              totalPacksDone++;
              percentDone(totalPacksDone / totalPacks * 100);
            });
            futures.add(rawData);
          }
        }
      }
      for (JackboxPackPatch patch in pack.fixes) {
        if (patch.configuration != null) {
          if (patch.configuration!.versionOrigin ==
              OnlineVersionOrigin.REPO_FILE) {
            totalPacks++;
            final rawData =
                getRequest(Uri.parse(patch.configuration!.versionFile));

            rawData.then((retrievedData) {
              final Map<String, dynamic> data = jsonDecode(retrievedData.data);
              patch.latestVersion = data[patch.configuration!.versionProperty]
                  .replaceAll("Build:", "")
                  .trim();
              totalPacksDone++;
              percentDone(totalPacksDone / totalPacks * 100);
            });
            futures.add(rawData);
          }
        }
      }
    }
    await Future.wait(futures);
  }

  Future<void> recoverNewsAndLinks() async {
    final rawData = await getRequest(
        Uri.parse('$baseEndpoint${APIEndpoints.WELCOME.path}'));

    if (!rawData.sameAsCached) {
      final Map<dynamic, dynamic> welcome = jsonDecode(rawData.data);
      cachedNews =
          welcome["news"].map<News>((news) => News.fromJson(news)).toList();
      internalCache.notifyListeners();
    }
  }

  Future<void> recoverBlurHashes() async {
    final rawData = await getRequest(
        Uri.parse('$baseEndpoint${APIEndpoints.BLUR_HASHES.path}'));
    if (!rawData.sameAsCached) {
      final List<dynamic> data = jsonDecode(rawData.data);
      cachedBlurHashes =
          data.map<UrlBlurHash>((tag) => UrlBlurHash.fromJson(tag)).toList();
    }
  }

  Future<void> recoverConfigurations() async {
    try {
      final rawData = await getRequest(
          Uri.parse('$baseEndpoint${APIEndpoints.CONFIGURATIONS.path}'));
      try {
        if (!rawData.sameAsCached) {
          final Map<String, dynamic> data = jsonDecode(rawData.data);
          cachedConfigurations = PatchServerConfigurations.fromJson(data);
        }
      } catch (e) {
        cachedConfigurations = PatchServerConfigurations.fromJson({});
      }
    } catch (e) {
      cachedConfigurations = PatchServerConfigurations.fromJson({});
    }
  }

  Future<void> recoverCustomComponent() async {
    try {
      final rawData = await getRequest(
          Uri.parse('$baseEndpoint${APIEndpoints.MESSAGES.path}'));
      if (!rawData.sameAsCached) {
        final Map<String, dynamic> data = jsonDecode(rawData.data);
        List<dynamic>? rawGamesComponent = data["gamesComponent"];
        List<dynamic>? rawPatchesComponent = data["patchesComponent"];
        List<({CustomServerComponent component, String gameId})>
            gamesComponent = [];
        List<({CustomServerComponent component, String packId})>
            patchesComponent = [];
        if (rawGamesComponent != null) {
          for (dynamic rawGameComponent in rawGamesComponent) {
            gamesComponent.add((
              component: CustomServerComponent.buildServerComponent(
                  rawGameComponent["component"]),
              gameId: rawGameComponent["gameId"]
            ));
          }
        }
        if (rawPatchesComponent != null) {
          for (dynamic rawPatchComponent in rawPatchesComponent) {
            patchesComponent.add((
              component: CustomServerComponent.buildServerComponent(
                  rawPatchComponent["component"]),
              packId: rawPatchComponent["packId"]
            ));
          }
        }
        cachedServerMessage = (
          menuComponent: data["menuComponent"] != null
              ? CustomServerComponent.buildServerComponent(
                  data["menuComponent"])
              : null,
          gamesComponent: gamesComponent,
          patchesComponent: patchesComponent
        );
        internalCache.notifyListeners();
      }
    } catch (e) {
      cachedServerMessage = null;
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

  // Send get request
  Future<({String data, bool sameAsCached})> getRequest(Uri uri) async {
    JULogger().i("Sending GET request to $uri");
    http.Response response = await http.get(uri);
    if (response.statusCode == 200) {
      if (!internalCache.exists(uri.toString())) {
        internalCache.set(uri.toString(), response.body);
        return (data: response.body, sameAsCached: false);
      } else {
        if (internalCache.get(uri.toString()) != response.body) {
          internalCache.set(uri.toString(), response.body);
          return (data: response.body, sameAsCached: false);
        } else {
          return (data: response.body, sameAsCached: true);
        }
      }
    } else {
      JULogger().e("Failed to send GET request to $uri");
      throw Exception("Failed to send GET request to $uri");
    }
  }

  // Download game patch
  Future<String> downloadPatch(
      String patchUri,
      void Function(double, double) progressCallback,
      CancelToken cancelToken) async {
    Dio dio = Dio();
    final response = await dio.downloadUri(
        Uri.parse(APIService().assetLink(patchUri)),
        "./downloads/tmp.${patchUri.split(".").last}",
        cancelToken: cancelToken,
        options: Options(), onReceiveProgress: (received, total) {
      progressCallback(received.toInt().toDouble(), total.toInt().toDouble());
    });

    if (response.statusCode == 200) {
      return "./downloads/tmp.${patchUri.split(".").last}";
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

  UrlBlurHash? getBlurHash(String url) {
    final blurHashes = cachedBlurHashes.where(
        (element) => element.url == url || element.url == assetLink(url));
    if (blurHashes.isNotEmpty) {
      return blurHashes.first;
    } else {
      return null;
    }
  }

  // Statistics
  Future<void> sendAppOpenData(String serverName, String serverUrl) async {
    await http.post(
        Uri.parse(
            '$masterStatisticsServer${APIStatisticsEndpoints.APP_OPEN.path}'),
        headers: null,
        body: {"serverName": serverName, "serverURL": serverUrl});
  }
}
