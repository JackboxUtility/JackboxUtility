import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:jackbox_patcher/app_configuration.dart';
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
            level: kReleaseMode ? Level.error : Level.debug,
            output: kReleaseMode
                ? FileOutput(file: File(LOGS_OUTPUT))
                : ConsoleOutput());
}
