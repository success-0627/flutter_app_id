import 'package:flutter_application_id/plist.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should update value if present', () {
    final Plist plistUpdater = Plist.fromString('''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>aKey</key>
        <string>valueBefore</string>
      </dict>
      </plist>
    ''');
    plistUpdater.updateString('aKey', 'valueAfter');
    expect(plistUpdater.toString(), '''
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
    final Plist plistUpdater = Plist.fromString('''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>aKey</key>
        <string>valueBefore</string>
      </dict>
      </plist>
    ''');
    plistUpdater.updateString('absentKey', 'valueAfter');
    expect(plistUpdater.toString(), '''
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
