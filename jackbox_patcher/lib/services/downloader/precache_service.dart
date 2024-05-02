import 'package:fluent_ui/fluent_ui.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';
import 'package:jackbox_patcher/services/api_utility/api_service.dart';
import 'package:jackbox_patcher/services/logger/logger.dart';

import '../user/user_data.dart';

class PrecacheService {
  static final PrecacheService _instance = PrecacheService._internal();

  factory PrecacheService() {
    return _instance;
  }

  // Build internal
  PrecacheService._internal();

  Future<void> precacheAll(BuildContext context) async {
    try {
      await precachePackImages(context);
    } catch (e) {
      JULogger().e("[PrecacheService] $e");
      rethrow;
    }
  }

  Future<void> precacheServer(context) async {
    await precacheImageURL(APIService().cachedSelectedServer!.image, context);
    for (var news in APIService().cachedNews) {
      await precacheImageURL(news.image, context);
    }
  }

  Future<void> precachePackImages(context) async {
    List<UserJackboxPack> packs = UserData().packs;
    for (var pack in packs) {
      await precacheImageURL(pack.pack.icon, context);
      await precacheImageURL(pack.pack.background, context);
      for (var game in pack.pack.games) {
        await precacheImageURL(game.background, context);
      }
    }
  }

  Future<void> precacheImageURL(imageUrl, context) {
    return precacheImage(
        Image.network(APIService().assetLink(imageUrl)).image, context);
  }
}
