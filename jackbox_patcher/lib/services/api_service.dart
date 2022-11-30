class APIService {
  
  static final APIService _instance = APIService._internal();
  
  // Build factory
  factory APIService() {
    return _instance;
  }

  // Build internal
  APIService._internal();
}