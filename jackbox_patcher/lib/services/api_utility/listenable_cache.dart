import 'package:fluent_ui/fluent_ui.dart';

class ListenableCache<T> extends Listenable {
  List<VoidCallback> _listeners = [];
  bool somethingChanged = true;

  Map<String, T> _cache = {};

  void set(String key, T value) {
    _cache[key] = value;
  }

  T? get(String key) {
    return _cache[key];
  }

  void remove(String key) {
    _cache.remove(key);
  }

  void clear() {
    _cache.clear();
  }

  bool exists(String key) {
    return _cache.containsKey(key);
  }

  void notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
}
