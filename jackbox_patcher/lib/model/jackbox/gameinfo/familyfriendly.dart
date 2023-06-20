enum GameInfoFamilyFriendly {
  FAMILY_FRIENDLY,
  OPTIONAL,
  NOT_FAMILY_FRIENDLY;
}

extension GameInfoFamilyFriendlyExtension on GameInfoFamilyFriendly {
  static GameInfoFamilyFriendly fromValue(String value) {
    switch (value) {
      case 'FAMILY_FRIENDLY':
        return GameInfoFamilyFriendly.FAMILY_FRIENDLY;
      case 'OPTIONAL':
        return GameInfoFamilyFriendly.OPTIONAL;
      case 'NOT_FAMILY_FRIENDLY':
        return GameInfoFamilyFriendly.NOT_FAMILY_FRIENDLY;
    }
    return GameInfoFamilyFriendly.NOT_FAMILY_FRIENDLY;
  }
}
