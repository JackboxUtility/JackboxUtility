abstract class EventObserver {
  void notify(ViewEvent? event);
}

abstract class ViewEvent {
  String qualifier;

  ViewEvent(this.qualifier);

  @override
  String toString() {
    return 'ViewEvent{qualifier: $qualifier}';
  }
}