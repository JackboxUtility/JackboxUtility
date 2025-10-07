import 'package:audioplayers/audioplayers.dart';
import 'package:jackbox_patcher/model/misc/audio/SFXPackEnum.dart';
import 'package:jackbox_patcher/services/user/user_data.dart';

import '../../model/misc/audio/SFXEnum.dart';

class SFXService {
  static final SFXService _instance = SFXService._internal();

  SFXPackEnum selectedPack = SFXPackEnum.DEFAULT;

  List<({SFX highPriority, SFX lowPriority})> sfxPriority = [
    (highPriority: SFX.CLICK, lowPriority: SFX.HOVER_OVER_STAR_OR_FILTER),
    (highPriority: SFX.HOVER_OVER_BANNER, lowPriority: SFX.HOVER_OVER_STAR_OR_FILTER),
    (highPriority: SFX.GAME_LAUNCHED, lowPriority: SFX.HOVER_OVER_STAR_OR_FILTER),
    (highPriority: SFX.GAME_LAUNCHED, lowPriority: SFX.CLICK),
    (highPriority: SFX.GAME_LAUNCHED, lowPriority: SFX.HOVER_OVER_BANNER),
    (highPriority: SFX.GAME_LAUNCHED, lowPriority: SFX.SCROLL_BETWEEN_GAME_INFO_TABS),
    (highPriority: SFX.GAME_LAUNCHED, lowPriority: SFX.CLOSE_GAME_INFO_TAB),
    (highPriority: SFX.CLOSE_GAME_INFO_TAB, lowPriority: SFX.HOVER_OVER_BANNER),
    (highPriority: SFX.OPEN_GAME_INFO_TAB, lowPriority: SFX.HOVER_OVER_STAR_OR_FILTER),
    (highPriority: SFX.OPEN_GAME_INFO_TAB, lowPriority: SFX.OPEN_GAME_LIST),
    (highPriority: SFX.OPEN_GAME_INFO_TAB, lowPriority: SFX.CLOSE_GAME_INFO_TAB)
  ];
  SFX? lastPlayedSFX;
  bool isCurrentlyPlaying = false;
  late AudioPlayer player = AudioPlayer();
  factory SFXService() {
    return _instance;
  }

  // Build internal
  SFXService._internal() {
    init();
  }

  init() {
    player.onPlayerComplete.listen((event) {
      isCurrentlyPlaying = false;
    });
  }

  Future<void> playSFX(SFX sfx) async {
    if (UserData().settings.isAudioActivated) {
      if (isCurrentlyPlaying) {
        if (sfxPriority.any((element) =>
            element.lowPriority == sfx && lastPlayedSFX != null && element.highPriority == lastPlayedSFX)) {
          return;
        }
      }

      if (isCurrentlyPlaying && lastPlayedSFX == sfx) {
        await player.seek(Duration.zero);
        return;
      }
      if (isCurrentlyPlaying) {
        await player.stop();
      }
      isCurrentlyPlaying = true;
      lastPlayedSFX = sfx;
      await player.play(AssetSource("audios/sfx/" + selectedPack.assetDirectory + "/" + sfx.assetName),
          mode: PlayerMode.lowLatency);
    }
  }
}
