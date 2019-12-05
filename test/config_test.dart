import 'package:flutter_application_id/configuration.dart';
import 'package:flutter_application_id/custom_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('Should load when correct', () {
    expect(
        Configuration.fromString('''
          flutter_application_id:
            android: "com.example.myAndroidApp" 
            ios: "com.example.myIosApp" 
        '''),
        const Configuration(
            android: 'com.example.myAndroidApp', ios: 'com.example.myIosApp'));
  });

  test('Android should be null if absent from file', () {
    expect(Configuration.fromString('''
      flutter_application_id:
        ios: "com.example.myIosApp"
      '''), const Configuration(ios: 'com.example.myIosApp'));
  });

  test('iOS should be null if absent from file', () {
    expect(Configuration.fromString('''
      flutter_application_id:
        android: "com.example.myAndroidApp" 
      '''), const Configuration(android: 'com.example.myAndroidApp'));
  });

  test(
      'Should throw NoConfigFoundException when `flutter_application_id` section is missing',
      () {
    expect(
        () => Configuration.fromString('''
          anotherKey: pouet
        '''),
        throwsA(const TypeMatcher<NoConfigFoundException>()));
  });

  test('Should throw YamlException when file is invalid yaml', () {
    expect(
        () => Configuration.fromString('''
          key: value: value:;
        '''),
        throwsA(const TypeMatcher<YamlException>()));
  });
}
