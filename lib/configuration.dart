import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_application_id/custom_exceptions.dart';
import 'package:yaml/yaml.dart';

class Configuration extends Equatable {
  const Configuration({this.android, this.ios});

  static const String _FLUTTER_APPLICATION_ID_KEY = 'flutter_application_id';
  static const String _IOS_KEY = 'ios';
  static const String _ANDROID_KEY = 'android';
  final String android;
  final String ios;

  static Configuration fromString(String data) {
    final YamlMap yamlMap = loadYaml(data);

    if (yamlMap == null || !yamlMap.containsKey(_FLUTTER_APPLICATION_ID_KEY) || !(yamlMap[_FLUTTER_APPLICATION_ID_KEY] is Map)) {
      throw NoConfigFoundException();
    }
    return Configuration(
        android: yamlMap[_FLUTTER_APPLICATION_ID_KEY][_ANDROID_KEY],
        ios: yamlMap[_FLUTTER_APPLICATION_ID_KEY][_IOS_KEY]);
  }

  static Future<Configuration> fromFile(File file) async {
    return Configuration.fromString(await file.readAsString());
  }

  @override
  List<Object> get props => <Object>[android, ios];
}
