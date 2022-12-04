enum APIEndpoints {
  PACKS,
  WELCOME
}

extension APIEndpointsExtension on APIEndpoints {
  String get path {
    switch (this) {
      case APIEndpoints.PACKS:
        return '/packs.json';
      case APIEndpoints.WELCOME:
        return '/welcome.json';
    }
  }
}