import 'package:flutter_application_id/pbxproj.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should update symbol value if present', () {
    final Pbxproj pbxproj = Pbxproj.fromString('''
      {
        disable = symbolBefore;
      }
    ''');
    pbxproj.updateSymbol('disable', 'symbolAfter');
    expect(pbxproj.toString(), '''
      {
        disable = symbolAfter;
      }
    ''');
  });

  test('Should not update value if absent', () {
    final Pbxproj pbxproj = Pbxproj.fromString('''
      {
        disable = symbolBefore;
      }
    ''');
    pbxproj.updateSymbol('absent', 'symbolAfter');
    expect(pbxproj.toString(), '''
      {
        disable = symbolBefore;
      }
    ''');
  });
}
