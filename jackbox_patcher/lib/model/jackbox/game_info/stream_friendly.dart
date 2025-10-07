enum GameInfoStreamFriendly {
  PLAYABLE,
  MIDLY_PLAYABLE,
  NOT_PLAYABLE;
}

extension GameInfoStreamFriendlyExtension on GameInfoStreamFriendly {
  static GameInfoStreamFriendly fromValue(String value) {
    switch (value) {
      case 'PLAYABLE':
        return GameInfoStreamFriendly.PLAYABLE;
      case 'MIDLY_PLAYABLE':
        return GameInfoStreamFriendly.MIDLY_PLAYABLE;
      case 'NOT_PLAYABLE':
        return GameInfoStreamFriendly.NOT_PLAYABLE;
    }
    return GameInfoStreamFriendly.NOT_PLAYABLE;
  }

  String toValue() {
    switch (this) {
      case GameInfoStreamFriendly.PLAYABLE:
        return 'PLAYABLE';
      case GameInfoStreamFriendly.MIDLY_PLAYABLE:
        return 'MIDLY_PLAYABLE';
      case GameInfoStreamFriendly.NOT_PLAYABLE:
        return 'NOT_PLAYABLE';
    }
  }
}