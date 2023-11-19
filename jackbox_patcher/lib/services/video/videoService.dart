import 'dart:io';

import 'package:media_kit/media_kit.dart';

class VideoService {
  static Player player = Player();

  static void pause() {
    if (!Platform.isLinux) {
      player.pause();
    }
  }

  static void playPause() {
    if (!Platform.isLinux) {
      player.playOrPause();
    }
  }

  static void stop() {
    if (!Platform.isLinux) {
      player.stop();
    }
  }
}
