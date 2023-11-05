import 'dart:io';

enum AppPlatform {
  WINDOWS, 
  MAC,
  LINUX
}

extension AppPlatformExtension on AppPlatform {
  String get name {
    switch (this) {
      case AppPlatform.WINDOWS:
        return "windows";
      case AppPlatform.MAC:
        return "mac";
      case AppPlatform.LINUX:
        return "linux";
      default:
        return "unknown";
    }
  }

  static AppPlatform fromString(String platform) {
    switch (platform) {
      case "windows":
        return AppPlatform.WINDOWS;
      case "mac":
        return AppPlatform.MAC;
      case "linux":
        return AppPlatform.LINUX;
      default:
        return AppPlatform.WINDOWS;
    }
  }
}

extension AppPlatformList on List<AppPlatform> {
  bool currentPlatformInclude(){
    if (Platform.isWindows && contains(AppPlatform.WINDOWS)) {
      return true;
    } else if (Platform.isMacOS && contains(AppPlatform.MAC)) {
      return true;
    } else if (Platform.isLinux && contains(AppPlatform.LINUX)) {
      return true;
    } else {
      return false;
    }
  }
}