import 'dart:io';

class Gradle {
  Gradle(List<String> lines) : _data = lines;

  final List<String> _data;

  static Gradle fromString(String s) {
    return Gradle(s.split('\n'));
  }

  static Future<Gradle> fromFile(File file) async {
    return Gradle(await file.readAsLines());
  }

  void toFile(File file) async {
    await file.writeAsString(_data.join('\n'));
  }

  void updateString(String key, String value) {
    for (int x = 0; x < _data.length; x++) {
      final String line = _data[x];
      if (line.contains('$key')) {
        _data[x] = line.replaceAllMapped(
            RegExp("($key[ ]*[^\"\'][\"\']*[\"\'])([^\"\']*)([\"\'])"),
            (Match match) => '${match[1]}$value${match[3]}');
      }
    }
  }

  void updateInt(String key, int value) {
    for (int x = 0; x < _data.length; x++) {
      final String line = _data[x];
      if (line.contains('$key')) {
        _data[x] = line.replaceAllMapped(
            RegExp('($key[ ]*)[0-9]*'), (Match match) => '${match[1]}$value');
      }
    }
  }

  @override
  String toString() {
    return _data.join('\n');
  }
}
