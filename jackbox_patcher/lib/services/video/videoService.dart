import 'dart:io';

import 'package:media_kit/media_kit.dart';

class VideoService {
  static Player player = Player();

  static void pause() {
    player.pause();
  }

  static void playPause(){
    player.playOrPause();
  }

  static void stop() {
    player.stop();
  }
}
