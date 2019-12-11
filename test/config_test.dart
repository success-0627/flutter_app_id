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
            android: 
              id: "com.example.myAndroidApp" 
              name: "androidName"
            ios: 
              id: "com.example.myIosApp" 
              name: "iOSName"
        '''),
        const Configuration(
            android: PlatformConfiguration(
                id: 'com.example.myAndroidApp', name: 'androidName'),
            ios: PlatformConfiguration(
                id: 'com.example.myIosApp', name: 'iOSName')));
  });

  test('Name should be null if absent', () {
    expect(
        Configuration.fromString('''
          flutter_application_id:
            android: 
              id: "com.example.myAndroidApp"
            ios: 
              id: "com.example.myIosApp"
        '''),
        const Configuration(
            android: PlatformConfiguration(id: 'com.example.myAndroidApp'),
            ios: PlatformConfiguration(id: 'com.example.myIosApp')));
  });

  test('Id should be null if absent', () {
    expect(
        Configuration.fromString('''
          flutter_application_id:
            android: 
              name: "androidName"
            ios: 
              name: "iOSName"
        '''),
        const Configuration(
            android: PlatformConfiguration(name: 'androidName'),
            ios: PlatformConfiguration(name: 'iOSName')));
  });

  test('Android should be null if absent from file', () {
    expect(
        Configuration.fromString('''
      flutter_application_id:
        ios: 
          id: "com.example.myIosApp" 
          name: "iOSName"
      '''),
        const Configuration(
            ios: PlatformConfiguration(
                id: 'com.example.myIosApp', name: 'iOSName')));
  });

  test('iOS should be null if absent from file', () {
    expect(
        Configuration.fromString('''
      flutter_application_id:
        android: 
          id: "com.example.myAndroidApp"
          name: "androidName"
      '''),
        const Configuration(
            android: PlatformConfiguration(
                id: 'com.example.myAndroidApp', name: 'androidName')));
  });

  test(
      'Should throw InvalidFormatException when `android` section not an object',
      () {
    expect(() => Configuration.fromString('''
      flutter_application_id:
        android: "toto"
        ios: 
          id: "com.example.myIosApp" 
          name: "iOSName"
      '''), throwsA(const TypeMatcher<InvalidFormatException>()));
  });

  test('Should throw InvalidFormatException when `ios` section not an object',
      () {
    expect(() => Configuration.fromString('''
      flutter_application_id:
        android: 
          id: "com.example.myAndroidApp"
          name: "androidName"
        ios: "toto"
      '''), throwsA(const TypeMatcher<InvalidFormatException>()));
  });

  test(
      'Should throw NoConfigFoundException when `flutter_application_id` section is missing',
      () {
    expect(() => Configuration.fromString('''
          anotherKey: pouet
        '''), throwsA(const TypeMatcher<NoConfigFoundException>()));
  });

  test('Should throw YamlException when file is invalid yaml', () {
    expect(() => Configuration.fromString('''
          key: value: value:;
        '''), throwsA(const TypeMatcher<YamlException>()));
  });
}
