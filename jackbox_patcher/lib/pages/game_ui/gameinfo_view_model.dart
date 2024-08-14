import 'package:flutter/material.dart';
import 'package:jackbox_patcher/model/base/extensions/null_extensions.dart';
import 'package:jackbox_patcher/model/misc/audio/SFXEnum.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_game_patch.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack.dart';
import 'package:jackbox_patcher/model/user_model/user_jackbox_pack_patch.dart';
import 'package:jackbox_patcher/mvvm/viewmodel.dart';
import 'package:jackbox_patcher/services/api_utility/api_service.dart';
import 'package:jackbox_patcher/services/audio/sfx_service.dart';
import 'package:jackbox_patcher/services/discord/discord_service.dart';
import 'package:jackbox_patcher/services/error/error.dart';
import 'package:jackbox_patcher/services/internal_api/rest_api_router.dart';
import 'package:jackbox_patcher/services/internal_api/ws_message/game_page_open_ws_message.dart';
import 'package:jackbox_patcher/services/launcher/launcher.dart';
import 'package:jackbox_patcher/services/translations/translations_helper.dart';
import 'package:jackbox_patcher/services/video/video_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GameinfoViewModel extends EventViewModel {
  late int selectedGameIndex = 0;
  bool showAllPacks = false;
  List<UserJackboxGameWithParent>? availableGames;

  /// Services to use
  DiscordService _discordService = DiscordService();
  SFXService _sfxService = SFXService();
  APIService _apiService = APIService();
  RestApiRouter _restApiRouter = RestApiRouter();

  /// The status of the game launching
  GameInfoLaunchingStatus launchingStatus = GameInfoLaunchingStatus.WAITING;

  /// Necessary to rebuild the caroussel
  UniqueKey carousselKey = UniqueKey();

  UserJackboxGame get selectedUserGame => availableGames![selectedGameIndex].game;
  UserJackboxPack get selectedUserPack => availableGames![selectedGameIndex].pack;

  GameinfoViewModel(UserJackboxGame userGame, this.showAllPacks, this.availableGames) {
    _discordService.launchGameInfoPresence(userGame.game.name);
    _apiService.internalCache.addListener(_internalCacheListener);
    _restApiRouter.sendMessage(GamePageOpenWsMessage(userGame.game));

    this.selectedGameIndex = availableGames!.indexWhere((element) => element.game.game.id == userGame.game.id);
  }

  _internalCacheListener() {
    notify(null);
  }

  /// Dispose the view model
  dispose() {
    _apiService.internalCache.removeListener(_internalCacheListener);
  }

  /// To know if a user can open the next or previous game using arrows
  bool canOpenOtherGame() {
    return availableGames != null && availableGames!.length > 1 && launchingStatus == GameInfoLaunchingStatus.WAITING;
  }

  /// Open previous game available
  openPreviousGame() {
    if (canOpenOtherGame()) {
      if (selectedGameIndex > 0) {
        selectedGameIndex--;
      } else {
        selectedGameIndex = availableGames!.length - 1;
      }
      _afterShowNewGame();
    }
  }

  /// Open next game available
  openNextGame() {
    if (canOpenOtherGame()) {
      if (selectedGameIndex < availableGames!.length - 1) {
        selectedGameIndex++;
      } else {
        selectedGameIndex = 0;
      }
      _afterShowNewGame();
    }
  }

  /// Do the actions after starting to show a new game
  _afterShowNewGame() {
    _discordService.launchGameInfoPresence(selectedUserGame.game.name);
    _restApiRouter.sendMessage(GamePageOpenWsMessage(selectedUserGame.game));
    _sfxService.playSFX(SFX.SCROLL_BETWEEN_GAME_INFO_TABS);
    launchingStatus = GameInfoLaunchingStatus.WAITING;
    notify(null);
  }

  /// Open an url in the markdown body
  openUrl(String url) {
    launchUrlString(url);
  }

  /// If the selected game as at least one component (e.g. a fixing patch)
  bool gamesComponentExist() {
    return (_apiService.cachedServerMessage?.gamesComponent
            ?.where((element) => element.gameId == selectedUserGame.game.id)
            .isNotEmpty)
        .orFalse();
  }

  void updateStarsRate(int stars) {
    selectedUserGame.stars = stars;
  }

  void toggleHideGameButton() {
    _sfxService.playSFX(SFX.CLICK);
    selectedUserGame.hidden = !selectedUserGame.hidden;
    notify(null);
  }

  // Launch the game
  void launchGame() {
    VideoService.pause();
    launchingStatus = GameInfoLaunchingStatus.LAUNCHING;
    notify(null);
    Launcher.launchGame(selectedUserPack, selectedUserGame).then((value) {
      launchingStatus = GameInfoLaunchingStatus.LAUNCHED;
      notify(null);
    }).catchError((error) {
      notify(InfoBarEvent(error.toString()));
    });
  }

  void handleOpenTag(BuildContext context, IconData icon, String text,
      {bool isLink = false,
      bool Function(UserJackboxPack, UserJackboxGame)? filter,
      UserJackboxPack? linkedPack,
      String? description}) async {
    VideoService.pause();
    _sfxService.playSFX(SFX.OPEN_GAME_INFO_TAB);

    await Navigator.pushNamed(context, "/search",
        arguments: [filter, linkedPack, text, description, null, showAllPacks]);

    carousselKey = UniqueKey();
    notify(null);
  }

  ({String status, bool isDisabled}) getPatchStatus(UserJackboxPackPatch patch) {
    switch (patch.getInstalledStatus()) {
      case UserInstalledPatchStatus.INEXISTANT:
        return (status: TranslationsHelper().appLocalizations!.patch_unavailable, isDisabled: true);
      case UserInstalledPatchStatus.INSTALLED:
        return (status: TranslationsHelper().appLocalizations!.patch_installed(1), isDisabled: true);
      case UserInstalledPatchStatus.INSTALLED_OUTDATED:
        return (status: TranslationsHelper().appLocalizations!.patch_outdated(1), isDisabled: false);
      case UserInstalledPatchStatus.NOT_INSTALLED:
        return (status: TranslationsHelper().appLocalizations!.patch_not_installed(1), isDisabled: false);
    }
  }
}

/// Utility class to store a game with its parent pack
class UserJackboxGameWithParent {
  UserJackboxGame game;
  UserJackboxPack pack;

  UserJackboxGameWithParent(this.game, this.pack);
}

enum GameInfoLaunchingStatus { WAITING, LAUNCHING, LAUNCHED, FAILED }
