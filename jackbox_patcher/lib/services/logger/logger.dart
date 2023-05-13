import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class JULogger extends Logger {
  static final JULogger _instance = JULogger._internal();

  factory JULogger() {
    return _instance;
  }

  // Build internal
  JULogger._internal():super(
    level: kReleaseMode ? Level.error : Level.debug,
    output: kReleaseMode ? FileOutput(file: File("./logs.txt")): ConsoleOutput()
  );

}