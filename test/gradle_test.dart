import 'package:flutter_application_id/gradle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should update string value if present', () {
    final Gradle gradle = Gradle.fromString('''
      android {
        lintOptions {
            disable  'valueBefore'
        }
      }
    ''');
    gradle.updateString('disable', 'valueAfter');
    expect(gradle.toString(), '''
      android {
        lintOptions {
            disable  'valueAfter'
        }
      }
    ''');
  });

  test('Should not update value if absent', () {
    final Gradle gradle = Gradle.fromString('''
      android {
        lintOptions {
            disable 'valueBefore'
        }
      }
    ''');
    gradle.updateString('absent', 'valueAfter');
    expect(gradle.toString(), '''
      android {
        lintOptions {
            disable 'valueBefore'
        }
      }
    ''');
  });

  test('Should update int value if present', () {
    final Gradle gradle = Gradle.fromString('''
      android {
        lintOptions {
            disable  12
        }
      }
    ''');
    gradle.updateInt('disable', 13);
    expect(gradle.toString(), '''
      android {
        lintOptions {
            disable  13
        }
      }
    ''');
  });
}
