enum RestApiScopes { NAVIGATION, GAME_OPEN_CLOSE }

extension RestApiScopesExtension on RestApiScopes {
  String get id {
    switch (this) {
      case RestApiScopes.NAVIGATION:
        return "navigation";
      case RestApiScopes.GAME_OPEN_CLOSE:
        return "game_open_close";
    }
  }

  String get name {
    switch (this) {
      case RestApiScopes.NAVIGATION:
        return "Navigation";
      case RestApiScopes.GAME_OPEN_CLOSE:
        return "Open and close games";
    }
  }

  String get description {
    switch (this) {
      case RestApiScopes.NAVIGATION:
        return "Know which screen is displayed on the application in real time";
      case RestApiScopes.GAME_OPEN_CLOSE:
        return "Open and close games";
    }
  }
}
