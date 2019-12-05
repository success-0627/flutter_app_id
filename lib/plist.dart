import 'dart:io';

class Plist {
  Plist(List<String> lines) : _data = lines;

  final List<String> _data;

  static Plist fromString(String s) {
    return Plist(s.split('\n'));
  }

  static Future<Plist> fromFile(File file) async {
    return Plist(await file.readAsLines());
  }

  void toFile(File file) async {
    await file.writeAsString(_data.join('\n'));
  }

  void updateString(String key, String value) {
    for (int x = 0; x < _data.length; x++) {
      final String line = _data[x];
      if (line.contains('<key>$key</key>')) {
        x++; //going straight to next line

        _data[x] = _data[x].replaceAll(
            RegExp(r'<string>[^<]*</string>'), '<string>$value</string>');
      }
    }
  }

  @override
  String toString() {
    return _data.join('\n');
  }
}
