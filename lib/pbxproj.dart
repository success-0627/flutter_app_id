import 'dart:io';

class Pbxproj {
  Pbxproj(List<String> lines) : _data = lines;

  final List<String> _data;

  static Pbxproj fromString(String s) {
    return Pbxproj(s.split('\n'));
  }

  static Future<Pbxproj> fromFile(File file) async {
    return Pbxproj(await file.readAsLines());
  }

  void toFile(File file) async {
    await file.writeAsString(_data.join('\n'));
  }

  void updateSymbol(String key, String value) {
    for (int x = 0; x < _data.length; x++) {
      final String line = _data[x];
      if (line.contains('$key')) {
        _data[x] = line.replaceAllMapped(
            RegExp('($key[ ]*=[ ]*)[a-zA-Z-_0-9.]*;'),
            (Match match) => '${match[1]}$value;');
      }
    }
  }

  @override
  String toString() {
    return _data.join('\n');
  }
}
