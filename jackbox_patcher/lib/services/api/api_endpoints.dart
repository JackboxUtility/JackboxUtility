enum APIEndpoints {
  PACKS
}

extension APIEndpointsExtension on APIEndpoints {
  String get path {
    switch (this) {
      case APIEndpoints.PACKS:
        return '/packs.json';
    }
  }
}