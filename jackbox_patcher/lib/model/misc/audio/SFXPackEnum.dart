enum SFXPackEnum {
  DEFAULT;
}

extension SFXPackEnumExtension on SFXPackEnum {
  String get assetDirectory {
    switch (this) {
      case SFXPackEnum.DEFAULT:
        return "default";
    }
  }
}
