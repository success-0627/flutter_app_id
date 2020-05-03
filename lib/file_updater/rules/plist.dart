import '../file_updater.dart';

class Plist implements UpdateRule {
  Plist(this.key, this.value);

  final String key;
  final String value;
  bool previousLineMatchedKey = false;

  @override
  String update(String line) {
    if (line.contains('<key>$key</key>')) {
      previousLineMatchedKey = true;
      return line;
    }

    if (!previousLineMatchedKey) {
      return line;
    } else {
      previousLineMatchedKey = false;
      return line.replaceAll(
          RegExp(r'<string>[^<]*</string>'), '<string>$value</string>');
    }
  }
}
