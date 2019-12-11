import 'package:flutter_application_id/file_updater/file_updater.dart';
import 'package:flutter_application_id/file_updater/rules/pbxproj.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FileUpdater _fileUpdater;

  void givenFileContent(String fileContent) {
    _fileUpdater = FileUpdater.fromString(fileContent);
  }

  void whenUpdating(String key, String value) {
    _fileUpdater.update(Pbxproj(key, value));
  }

  void thenExpectsFileContent(String fileContent) {
    expect(_fileUpdater.toString(), fileContent);
  }

  test('Should update symbol value if present', () {
    givenFileContent('''
      {
        disable = symbolBefore;
      }
    ''');
    whenUpdating('disable', 'symbolAfter');
    thenExpectsFileContent('''
      {
        disable = symbolAfter;
      }
    ''');
  });

  test('Should not update value if absent', () {
    givenFileContent('''
      {
        disable = symbolBefore;
      }
    ''');
    whenUpdating('absent', 'symbolAfter');
    thenExpectsFileContent('''
      {
        disable = symbolBefore;
      }
    ''');
  });
}
