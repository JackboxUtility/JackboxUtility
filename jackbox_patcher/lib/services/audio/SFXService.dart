import 'package:audioplayers/audioplayers.dart';
import 'package:jackbox_patcher/model/misc/audio/SFXPackEnum.dart';

import '../../model/misc/audio/SFXEnum.dart';

class SFXService {
  static final SFXService _instance = SFXService._internal();

  SFXPackEnum selectedPack = SFXPackEnum.DEFAULT;
  late AudioPlayer player = AudioPlayer();
  factory SFXService() {
    return _instance;
  }

  // Build internal
  SFXService._internal();

  void playSFX(SFX sfx) async{
    await player.play(AssetSource("audios/sfx/"+selectedPack.assetDirectory+"/"+ sfx.assetName));
  }
}
