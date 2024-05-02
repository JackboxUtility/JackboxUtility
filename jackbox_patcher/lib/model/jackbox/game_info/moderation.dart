enum GameInfoModeration {
  FULL_MODERATION,
  CENSORING,
  NO_MODERATION;
}

extension GameInfoModerationExtension on GameInfoModeration {
  static GameInfoModeration fromValue(String value) {
    switch (value) {
      case 'FULL_MODERATION':
        return GameInfoModeration.FULL_MODERATION;
      case 'CENSORING':
        return GameInfoModeration.CENSORING;
      case 'NO_MODERATION':
        return GameInfoModeration.NO_MODERATION;
    }
    return GameInfoModeration.NO_MODERATION;
  }
}