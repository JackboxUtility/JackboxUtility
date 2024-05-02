import 'package:jackbox_patcher/services/arguments_handler/handlers/abstract_argument_handler.dart';
import 'package:jackbox_patcher/services/arguments_handler/handlers/launch_game_handler.dart';

class ArgumentsHandler {
  static List<AbstractArgumentHandler> handlers = [LaunchGameHandler()];

  factory ArgumentsHandler() {
    return _singleton;
  }

  ArgumentsHandler._internal();

  static final ArgumentsHandler _singleton = ArgumentsHandler._internal();

  Future<bool> handle(List<String> arguments) async {
    arguments = arguments.join(" ").split(" ");
    if (arguments.length == 0) {
      return false;
    }
    for (AbstractArgumentHandler handler in handlers) {
      if (await handler.handle(arguments)) {
        return true;
      }
    }
    return false;
  }
}
