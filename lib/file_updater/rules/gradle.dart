import '../file_updater.dart';

class GradleString implements UpdateRule {
  GradleString(this.key, this.value);

  final String key;
  final String value;

  @override
  String update(String line) {
    return line.replaceAllMapped(
        RegExp("($key[ ]*[^\"\'][\"\']*[\"\'])([^\"\']*)([\"\'])"),
        (Match match) => '${match[1]}$value${match[3]}');
  }
}
