import 'package:jackbox_patcher/services/arguments_handler/handlers/abstract_argument_handler.dart';
import 'package:jackbox_patcher/services/launcher/launcher.dart';

class LaunchGameHandler extends AbstractArgumentHandler {
  LaunchGameHandler() : super("Launch game", "Launch a game or a pack");

  Future<bool> handle(List<String> args) async {
    if (args.isNotEmpty) {
      if (args[0] == "launch") {
        if (args.length == 3) {
          switch (args[1]) {
            case "pack":
              return await Launcher.launchRawPack(args[2]);
            case "game":
              return await Launcher.launchRawGame(args[2]);
            default:
              print("Usage : launch <pack|game> <packId|gameId>");
          }
        } else {
          print("Usage : launch <pack|game> <packId|gameId>");
        }
      }
    }
    return false;
  }
}
