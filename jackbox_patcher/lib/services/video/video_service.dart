import 'dart:io';

import 'package:media_kit/media_kit.dart';

class VideoService {
  static Player player = Player();

  static void pause() {
    if (Platform.isWindows) {
      player.pause();
    }
  }

  static void playPause() {
    if (Platform.isWindows) {
      player.playOrPause();
    }
  }

  static void stop() {
    if (Platform.isWindows) {
      player.stop();
    }
  }
}