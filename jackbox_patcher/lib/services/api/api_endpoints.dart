enum APIEndpoints {
  PACKS,
  WELCOME,
  BLUR_HASHES
}

extension APIEndpointsExtension on APIEndpoints {
  String get path {
    switch (this) {
      case APIEndpoints.PACKS:
        return '/packs.json';
      case APIEndpoints.WELCOME:
        return '/welcome.json';
      case APIEndpoints.BLUR_HASHES:
        return '/blurHashes.json';
    }
  }
}