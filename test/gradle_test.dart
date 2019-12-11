import 'package:flutter_application_id/file_updater/file_updater.dart';
import 'package:flutter_application_id/file_updater/rules/gradle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FileUpdater _fileUpdater;

  void givenFileContent(String fileContent) {
    _fileUpdater = FileUpdater.fromString(fileContent);
  }

  void whenUpdating(String key, String value) {
    _fileUpdater.update(GradleString(key, value));
  }

  void thenExpectsFileContent(String fileContent) {
    expect(_fileUpdater.toString(), fileContent);
  }

  test('Should update string value if present', () {
    givenFileContent('''
      android {
        lintOptions {
            disable  'valueBefore'
        }
      }
    ''');
    whenUpdating('disable', 'valueAfter');
    thenExpectsFileContent('''
      android {
        lintOptions {
            disable  'valueAfter'
        }
      }
    ''');
  });

  test('Should not update value if absent', () {
    givenFileContent('''
      android {
        lintOptions {
            disable 'valueBefore'
        }
      }
    ''');
    whenUpdating('absent', 'valueAfter');
    thenExpectsFileContent('''
      android {
        lintOptions {
            disable 'valueBefore'
        }
      }
    ''');
  });
}
