import 'dart:io';
import 'dart:typed_data';

class Tmp3InstallController {
  static const _originalControllerUrl = 'jackbox.tv';
  static const _originalOnlineServiceUrl =
      'https://api.jackboxgames.com/arcade';

  static Future<void> run(String gameDirectory, String controllerUrl,
      String onlineServiceUrl) async {
    final separator = Platform.pathSeparator;
    final executable = File([
      Directory(gameDirectory).absolute.path,
      'TMP3',
      'Binaries',
      'Win64',
      'TMP3-Win64-Shipping.exe',
    ].join(separator));
    if (!await executable.exists()) {
      throw FileSystemException('TMP3 executable not found', executable.path);
    }

    final patched = patchExecutable(
      await executable.readAsBytes(),
      controllerUrl,
      onlineServiceUrl,
    );
    await executable.writeAsBytes(patched, flush: true);
  }

  static Uint8List patchExecutable(
      Uint8List bytes, String controllerUrl, String onlineServiceUrl) {
    _validateControllerUrl(controllerUrl);
    _validateOnlineServiceUrl(onlineServiceUrl);

    final result = bytes;
    _replaceUtf16(
        result, _originalOnlineServiceUrl, onlineServiceUrl, 'service URL');
    _replaceUtf16(
        result, _originalControllerUrl, controllerUrl, 'controller URL');
    return result;
  }

  static void _validateControllerUrl(String value) {
    final hostname = RegExp(
        r'^(?:[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?\.)+[A-Za-z]{2,63}$');
    if (!hostname.hasMatch(value) ||
        value.length > _originalControllerUrl.length) {
      throw const FormatException('Invalid TMP3 controller URL.');
    }
  }

  static void _validateOnlineServiceUrl(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment ||
        value.codeUnits
            .any((character) => character < 0x21 || character > 0x7e) ||
        value.length > _originalOnlineServiceUrl.length) {
      throw const FormatException('Invalid TMP3 online service URL.');
    }
  }

  static void _replaceUtf16(
      Uint8List bytes, String source, String replacement, String name) {
    final sourceBytes = _utf16le(source);
    final replacementBytes = _utf16le(replacement);
    final sourceOffsets = _findAll(bytes, sourceBytes);

    if (sourceOffsets.isEmpty) {
      final replacementOffsets = _findAll(bytes, replacementBytes);
      if (replacementOffsets.length == 1) return;
    }
    if (sourceOffsets.length != 1) {
      throw StateError(
          'Expected one TMP3 $name field, found ${sourceOffsets.length}.');
    }

    final offset = sourceOffsets.single;
    bytes.fillRange(offset, offset + sourceBytes.length, 0);
    bytes.setRange(offset, offset + replacementBytes.length, replacementBytes);
  }

  static Uint8List _utf16le(String value) {
    final bytes = Uint8List(value.length * 2);
    for (var index = 0; index < value.length; index++) {
      final character = value.codeUnitAt(index);
      bytes[index * 2] = character & 0xff;
      bytes[index * 2 + 1] = character >> 8;
    }
    return bytes;
  }

  static List<int> _findAll(Uint8List bytes, Uint8List needle) {
    final offsets = <int>[];
    var start = 0;
    while (start <= bytes.length - needle.length) {
      final offset = bytes.indexOf(needle.first, start);
      if (offset < 0 || offset > bytes.length - needle.length) break;
      var matches = true;
      for (var index = 1; index < needle.length; index++) {
        if (bytes[offset + index] != needle[index]) {
          matches = false;
          break;
        }
      }
      if (matches) {
        offsets.add(offset);
        start = offset + needle.length;
      } else {
        start = offset + 1;
      }
    }
    return offsets;
  }
}
