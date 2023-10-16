enum RestApiScopes { NAVIGATION }

extension RestApiScopesExtension on RestApiScopes {
  String get id {
    switch (this) {
      case RestApiScopes.NAVIGATION:
        return "navigation";
    }
  }

  String get name {
    switch (this) {
      case RestApiScopes.NAVIGATION:
        return "Navigation";
    }
  }

  String get description {
    switch (this) {
      case RestApiScopes.NAVIGATION:
        return "Savoir quel écran est affiché sur l'application en temps réel";
    }
  }
}
