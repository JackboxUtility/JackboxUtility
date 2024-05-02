import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:jackbox_patcher/services/files/folderService.dart';
import 'package:logger/logger.dart';

/// Logger class used to log errors and debug messages
class JULogger extends Logger {
  static final JULogger _instance = JULogger._internal();

  factory JULogger() {
    return _instance;
  }

  // Build internal
  JULogger._internal()
      : super(
            printer: HybridPrinter(SimplePrinter(printTime: true),
                error: PrettyPrinter(printTime: true, noBoxingByDefault: true)),
            filter: ProductionFilter(),
            level: FlavorConfig.instance.variables["loggerLevel"],
            output: kReleaseMode
                ? FileOutput(file: File(FolderService().logPath))
                : ConsoleOutput());
}
