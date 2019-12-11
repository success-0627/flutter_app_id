import 'package:flutter_application_id/file_updater/file_updater.dart';
import 'package:flutter_application_id/file_updater/rules/plist.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FileUpdater _fileUpdater;

  void givenFileContent(String fileContent) {
    _fileUpdater = FileUpdater.fromString(fileContent);
  }

  void whenUpdating(String key, String value) {
    _fileUpdater.update(Plist(key, value));
  }

  void thenExpectsFileContent(String fileContent) {
    expect(_fileUpdater.toString(), fileContent);
  }

  test('Should update value if present', () {
    givenFileContent('''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>aKey</key>
        <string>valueBefore</string>
      </dict>
      </plist>
    ''');
    whenUpdating('aKey', 'valueAfter');
    thenExpectsFileContent('''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>aKey</key>
        <string>valueAfter</string>
      </dict>
      </plist>
    ''');
  });

  test('Should not update value if absent', () {
    givenFileContent('''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>aKey</key>
        <string>valueBefore</string>
      </dict>
      </plist>
    ''');
    whenUpdating('absentKey', 'valueAfter');
    thenExpectsFileContent('''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>aKey</key>
        <string>valueBefore</string>
      </dict>
      </plist>
    ''');
  });
}
