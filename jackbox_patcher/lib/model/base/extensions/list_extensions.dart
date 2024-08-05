import 'dart:async';

extension ListExtensions<T> on List<T> {
  FutureOr<T?> firstWhereOrNull(FutureOr<bool> Function(T) test) async {
    for (var element in this) {
      if (await test(element)) {
        return element;
      }
    }
    return null;
  }
}