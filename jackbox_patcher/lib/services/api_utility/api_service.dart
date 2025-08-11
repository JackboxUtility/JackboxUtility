import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:http/http.dart' as http;
import 'package:jackbox_patcher/app_configuration.dart';
import 'package:jackbox_patcher/model/custom_server_component/custom_server_component.dart';
import 'package:jackbox_patcher/model/jackbox/jackbox_game.dart';
import 'package:jackbox_patcher/model/jackbox/jackbox_pack_patch.dart';
import 'package:jackbox_patcher/model/misc/url_blur_hash.dart';
import 'package:jackbox_patcher/model/news.dart';
import 'package:jackbox_patcher/model/patch_server_configurations.dart';
import 'package:jackbox_patcher/model/patch_server.dart';
import 'package:jackbox_patcher/model/user_model/interface/installable_patch.dart';
import 'package:jackbox_patcher/services/api_utility/dio_mixin.dart';
import 'package:jackbox_patcher/services/api_utility/listenable_cache.dart';
import 'package:jackbox_patcher/services/files/folder_service.dart';
import 'package:jackbox_patcher/services/logger/logger.dart';

import '../../model/game_tag.dart';
import '../../model/jackbox/jackbox_pack.dart';
import '../../model/patchs_category.dart';
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
    cachedServers = [];
    cachedPacks = [];
    cachedTags = [];
    cachedNews = [];
    internalCache.clear();
  }

  Future<PatchServer?> recoverServerFromLink(String serverLink) async {
    JULogger().i("[API Service] Recovering server from link");
    try {
      final serverInfo = await getRequest(Uri.parse(serverLink));
      final Map<String, dynamic> data = jsonDecode(serverInfo.data);
      final PatchServer patchServer = PatchServer.fromJson(serverLink, data);
      return patchServer;
    } catch (e) {
      JULogger().e("[API Service] Failed to recover server from link");
      JULogger().e("[API Service] $e");
      return null;
    }
  }

  Future<void> recoverAvailableServers() async {
    JULogger().i("[API Service] Recovering available servers");
    resetCache();
    final data = await getRequest(Uri.parse(masterServer));

    if (!data.sameAsCached) {
      final List<dynamic> availableServers = jsonDecode(data.data);
      for (var server in availableServers) {
        try {
          final serverInfo = await getRequest(Uri.parse(server));
          final Map<String, dynamic> data = jsonDecode(serverInfo.data);
          cachedServers.add(PatchServer.fromJson(server, data));
        } catch (e) {
          JULogger().e("[API Service] Failed to recover server from link");
          JULogger().e("[API Service] $e");
        }
      }
    }
  }

  Future<void> recoverServerInfo(String serverLink) async {
    JULogger().i("[API Service] Recovering server info");
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
      bool somethingHasChanged = await applyExternalConfiguration(percentDone);
      return somethingHasChanged;
    }
  }

  Future<bool> applyExternalConfiguration(
      Function(double percent) percentDone) async {
    int totalPacksDone = 0;
    int totalPacks = 0;
    bool somethingHasChanged = false;
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
              if (!retrievedData.sameAsCached) {
                somethingHasChanged = true;
              }
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
              if (!retrievedData.sameAsCached) {
                somethingHasChanged = true;
              }
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
    return somethingHasChanged;
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
    JULogger().i("[API Service] Sending GET request to $uri");
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
      JULogger().e("[API Service] Failed to send GET request to $uri");
      throw Exception("Failed to send GET request to $uri");
    }
  }

  // Get remote file size (bytes)
  Future<int> fetchFileSize(String sourceUri) async {
    JULogger().i("[API Service] Fetching file size of $sourceUri");
    final dio = Dio();
    final url = APIService().assetLink(sourceUri);
    try {
      final rsp = await dio.head(
        url,
        options: Options(
          followRedirects: true,
          maxRedirects: 5,
          validateStatus: (s) => s != null && s < 400,
          headers: _buildDownloadHeaders(),
        ),
      );
      final cl = rsp.headers.value(HttpHeaders.contentLengthHeader);
      if (cl != null) {
        return int.parse(cl);
      }
      final cr = rsp.headers.value(HttpHeaders.contentRangeHeader);
      if (cr != null && cr.contains('/')) {
        final total = cr.split('/').last.trim();
        return int.parse(total);
      }
    } catch (e) {
      JULogger().w("[API Service] HEAD failed for $url: $e");
    }

    // Fallback: first byte to discover total size via Content-Range
    final rsp2 = await dio.get<List<int>>(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
        maxRedirects: 5,
        validateStatus: (s) => s != null && s < 400,
        headers: {
          ..._buildDownloadHeaders(),
          HttpHeaders.rangeHeader: "bytes=0-0",
        },
      ),
    );
    final cr2 = rsp2.headers.value(HttpHeaders.contentRangeHeader);
    if (cr2 != null && cr2.contains('/')) {
      final total = cr2.split('/').last.trim();
      return int.parse(total);
    }
    final cl2 = rsp2.headers.value(HttpHeaders.contentLengthHeader);
    if (cl2 != null) {
      return int.parse(cl2);
    }
    throw Exception("Unable to determine remote file size for $url");
  }

  // Download pack/game patch
  Future<String> downloadPatch(
      InstallablePatch patch,
      String patchUri,
      void Function(double, double) progressCallback,
      CancelToken cancelToken,
      bool allowResume) async {
    JULogger().i("[API Service] Downloading patch \"${patch.getName()}\"");
    String patchPath =
        "${FolderService().downloadPath}/${patch.getName()}.${patchUri.split(".").last}";

    await _downloadFile(APIService().assetLink(patchUri), patchPath,
        progressCallback: progressCallback,
        cancelToken: cancelToken,
        allowResume: allowResume);
    return patchPath;
  }

  Future<String> downloadPackLoader(
      JackboxPack pack, void Function(double, double) progressCallback) async {
    JULogger().i(
        "[API Service] Downloading loader for pack \"${pack.name}\" (${pack.id})");
    String packLoaderPath =
        "${FolderService().downloadPath}/loader/${pack.id}/default.zip";

    await _downloadFile("$baseAssets/${pack.loader!.path}", packLoaderPath,
        progressCallback: progressCallback);
    return packLoaderPath;
  }

  Future<String> downloadGameLoader(JackboxPack pack, JackboxGame game,
      void Function(double, double) progressCallback) async {
    JULogger().i(
        "[API Service] Downloading loader for game \"${game.name}\" (${game.id}) of pack \"${pack.name}\" (${pack.id})");
    String gameLoaderPath =
        "${FolderService().downloadPath}/loader/${pack.id}/${game.id}.zip";

    await _downloadFile("$baseAssets/${game.loader!.path}", gameLoaderPath,
        progressCallback: progressCallback);
    return gameLoaderPath;
  }

  /// Download an remote file to the local file system, resuming
  /// past downloads if enabled and applicable.
  ///
  /// [sourceUri] Source/remote file uri
  ///
  /// [destPath] Local/destination file path
  ///
  /// [progressCallback] Progress callback (optional)
  ///
  /// [cancelToken] Cancel token (optional)
  ///
  /// [allowResume] Allow to resume download if partial content is present from previous download attempt (optional; default: `false`)
  ///
  /// Implementation description:
  ///
  /// This method uses two kinds of files to store data:
  /// - Destination file: stores the complete content (download finished)
  /// - Partial file: stores the partial content of previous attempts (download incomplete/ongoing)
  ///
  /// While the download is ongoing, the content is stored in the partial file (`.part`). If the size matches or exceeds the remote file size,
  /// it is then transferred to the destination file (provided via parameter).
  ///
  /// Partial files may be kept for future calls with [allowResume] set to `true`, allowing it to resume where it left off.
  /// Depending on the situation, this method may (un-)resume by itself, e.g. when a connection issue happens or it is in an invalid state.
  Future<void> _downloadFile(String sourceUri, String destPath,
      {void Function(double, double)? progressCallback,
      CancelToken? cancelToken,
      bool allowResume = false}) async {
    File destFile = File(destPath);
    File partFile = File("$destPath.part");

    // Get local file size
    int downloadedBytes = 0;
    if (partFile.existsSync()) {
      if (allowResume) {
        downloadedBytes = await partFile.length();
      } else {
        await partFile.delete();
      }
    }

    // Get remote file size
    int sourceBytes = await fetchFileSize(sourceUri);

    // Local file size equals or exceeds remote size
    if (downloadedBytes >= sourceBytes) {
      await _transferFile(partFile, destFile);
      return;
    }

    DioForJackboxUtility dio = DioForJackboxUtility();
    bool resume = allowResume; // Whether to actually resume the download
    int retryAttempts = 0;
    const int maxRetryAttempts = 8;

    JULogger()
        .i("[API Service] Downloading file $sourceUri to part file ${partFile.path}");
    if (downloadedBytes > 0) {
      JULogger().i("[API Service] Resuming download at byte $downloadedBytes");
    }

    // Download loop
    while (downloadedBytes < sourceBytes) {
      try {
        await dio.downloadUri(
          Uri.parse(sourceUri),
          partFile.path,
          options: Options(
            headers: _buildDownloadHeaders(startAt: downloadedBytes),
            responseType: ResponseType.bytes,
            followRedirects: true,
            maxRedirects: 5,
            receiveTimeout: 60000, // 60s no data -> timeout
            sendTimeout: 60000,
            validateStatus: (status) {
              return status == HttpStatus.ok ||
                  status == HttpStatus.partialContent;
            },
          ),
          deleteOnError: false,
          deleteOnCancel: !allowResume, // keep part file if resume is allowed
          appendData: true,
          cancelToken: cancelToken,
          onReceiveProgress: (receivedBytes, totalBytes) {
            if (progressCallback != null) {
              // Add previously downloaded bytes to make resumed progress clear
              progressCallback((downloadedBytes + receivedBytes).toDouble(),
                  (downloadedBytes + totalBytes).toDouble());
            }
          },
        );

        downloadedBytes = await partFile.length();
        retryAttempts = 0; // reset after successful chunk
      } on DioError catch (e) {
        final partFileExists = partFile.existsSync();
        final previousDownloaded = downloadedBytes;
        final nowSize =
            partFileExists ? partFile.lengthSync() : previousDownloaded;
        final receivedBytes = nowSize - previousDownloaded;
        downloadedBytes = nowSize;

        Response<ResponseBody>? response =
            e.response as Response<ResponseBody>?;
        if (response?.statusCode == HttpStatus.requestedRangeNotSatisfiable &&
            resume) {
          // Byte range invalid -> restart clean
          JULogger().e(
              "[API Service] Failed to resume download due to remote rejecting byte range (416).");
          JULogger().i(
              "[API Service] Deleting associated files and re-downloading completely.");
          resume = false;
          downloadedBytes = 0;
          if (partFileExists) {
            await partFile.delete();
          }
          continue;
        }

        // Transient network issues: connection closed, socket error, or timeout
        final msg = e.message ?? e.error?.toString() ?? "";
        final isConnectionClosed =
            e.type == DioErrorType.other &&
            (msg.contains("Connection closed while receiving data") ||
                e.error is SocketException);
        final isTimeout = e.type == DioErrorType.receiveTimeout;

        if (e.type == DioErrorType.cancel) {
          // Download cancelled by user
          JULogger().i("[API Service] Download cancelled");
          rethrow;
        } else if (isConnectionClosed || isTimeout) {
          retryAttempts++;
          if (retryAttempts > maxRetryAttempts) {
            JULogger().e(
                "[API Service] Maximum retry attempts reached ($maxRetryAttempts).");
            rethrow;
          }
          final delaySec = retryAttempts >= 5
              ? 30
              : (retryAttempts == 4 ? 15 : (1 << retryAttempts)); // 2,4,8,...
          JULogger().w(
              "[API Service] ${isTimeout ? 'Timeout' : 'Connection closed'} while receiving data; attempting to reconnect in ${delaySec}s (retry $retryAttempts/$maxRetryAttempts).");
          resume = true;
          await Future.delayed(Duration(seconds: delaySec));
          continue;
        } else {
          // Unexpected error
          JULogger().e("[API Service] File download failed: $e");
          rethrow;
        }
      }
    }

    await _transferFile(partFile, destFile);
  }

  Map<String, String> _buildDownloadHeaders({int? startAt}) {
    final headers = <String, String>{
      HttpHeaders.userAgentHeader: "JackboxUtility",
      HttpHeaders.acceptHeader: "application/octet-stream",
      HttpHeaders.acceptEncodingHeader: "identity",
      HttpHeaders.connectionHeader: "keep-alive",
    };
    if (startAt != null && startAt > 0) {
      headers[HttpHeaders.rangeHeader] = "bytes=$startAt-";
    }
    return headers;
  }

  Future<void> _transferFile(File sourceFile, File destFile) async {
    if (destFile.existsSync()) {
      await destFile.delete();
    }
    await sourceFile.rename(destFile.path);
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
