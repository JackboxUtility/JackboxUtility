import 'dart:io';

class ProcessHelper {
  static Future<ProcessResult> run(String executable, List<String> args) async {
    return await Process.run(executable, args);
  }

  static Future<String> runAndGetOutput(String executable, List<String> args) async {
    ProcessResult result = await Process.run(executable, args);
    return result.stdout.toString();
  }
}