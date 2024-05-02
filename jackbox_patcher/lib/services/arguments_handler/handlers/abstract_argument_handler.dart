abstract class AbstractArgumentHandler {
  final String name;
  final String description;

  AbstractArgumentHandler(this.name, this.description);

  Future<bool> handle(List<String> arguments);
}