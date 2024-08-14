extension NullExtensions<T> on T? {
  bool get isNull => this == null;
  bool get isNotNull => this != null;

  /// Do the function in [block] if the object is not null
  Y? let<Y>(Y Function(T) block) {
    if (this != null) {
      return block(this!);
    }
    return null;
  }
}

extension NullBoolExtensions on bool? {
  bool get isTrue => this == true;
  bool get isFalse => this == false;

  bool orFalse() {
    return this ?? false;
  }

  bool orTrue() {
    return this ?? true;
  }
}