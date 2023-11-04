enum APIStatisticsEndpoints {
  APP_OPEN
}

extension APIStatisticsEndpointsExtension on APIStatisticsEndpoints {
  String get path {
    switch (this) {
      case APIStatisticsEndpoints.APP_OPEN:
        return '/api/app_open';
    }
  }
}