import '../file_updater.dart';

class XmlAttribute extends UpdateRule {
  XmlAttribute(this.key, this.value);

  final String key;
  final String value;

  @override
  String update(String line) {
    return line.replaceAllMapped(RegExp('($key[ ]*=[ ]*)"[a-zA-Z-_0-9.]*"'),
        (Match match) => '${match[1]}"$value"');
  }
}
