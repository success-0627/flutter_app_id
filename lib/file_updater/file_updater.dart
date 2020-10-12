import 'dart:io';

abstract class UpdateRule {
  String update(String line);
}

class FileUpdater {
  FileUpdater(List<String> lines) : _data = lines;

  final List<String> _data;

  static void updateFile(File file, UpdateRule updateRule) async {
    final FileUpdater fileUpdater = await FileUpdater.fromFile(file);
    fileUpdater.update(updateRule);
    fileUpdater.toFile(file);
  }

  static FileUpdater fromString(String s) {
    return FileUpdater(s.split('\n'));
  }

  static Future<FileUpdater> fromFile(File file) async {
    return FileUpdater(await file.readAsLines());
  }

  void toFile(File file) async {
    await file.writeAsString(_data.join('\n'));
  }

  void update(UpdateRule rule) {
    for (int x = 0; x < _data.length; x++) {
      _data[x] = rule.update(_data[x]);
    }
  }

  @override
  String toString() {
    return _data.join('\n');
  }
}
