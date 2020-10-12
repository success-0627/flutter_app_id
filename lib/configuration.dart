import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_application_id/custom_exceptions.dart';
import 'package:yaml/yaml.dart';

import 'constants.dart';

class PlatformConfiguration extends Equatable {
  static const String ID_KEY = 'id';
  static const String NAME_KEY = 'name';

  final String id;
  final String name;

  const PlatformConfiguration({this.id, this.name});

  static PlatformConfiguration fromYamlMap(dynamic map) {
    if (map == null) {
      return null;
    }
    if (map is! YamlMap) {
      throw InvalidFormatException();
    }
    return PlatformConfiguration(id: map[ID_KEY], name: map[NAME_KEY]);
  }

  @override
  List<Object> get props => <Object>[id, name];
}

class PlatformConfigurationIOS extends PlatformConfiguration {
  static const String PLIST_KEY = 'plist';
  static const String PBXPROJ_KEY = 'pbxproj';

  final String plist;
  final String pbxproj;

  const PlatformConfigurationIOS({
    String id,
    String name,
    this.plist,
    this.pbxproj,
  }) : super(id: id, name: name);

  static PlatformConfigurationIOS fromYamlMap(dynamic map) {
    if (map == null) {
      return null;
    }
    if (!(map is YamlMap)) {
      throw InvalidFormatException();
    }
    return PlatformConfigurationIOS(
      id: map[PlatformConfiguration.ID_KEY],
      name: map[PlatformConfiguration.NAME_KEY],
      plist: map[PlatformConfigurationIOS.PLIST_KEY] ?? IOS_PLIST_FILE,
      pbxproj: map[PlatformConfigurationIOS.PBXPROJ_KEY] ?? IOS_PBXPROJ_FILE,
    );
  }

  @override
  List<Object> get props => (super.props..addAll(<Object>[plist, pbxproj]));
}

class Configuration extends Equatable {
  const Configuration({this.android, this.ios});

  static const String _FLUTTER_APPLICATION_ID_KEY = 'flutter_application_id';
  static const String _IOS_KEY = 'ios';
  static const String _ANDROID_KEY = 'android';
  final PlatformConfiguration android;
  final PlatformConfigurationIOS ios;

  static Configuration fromString(String data) {
    final YamlMap yamlMap = loadYaml(data);

    if (yamlMap == null ||
        !yamlMap.containsKey(_FLUTTER_APPLICATION_ID_KEY) ||
        !(yamlMap[_FLUTTER_APPLICATION_ID_KEY] is YamlMap)) {
      throw NoConfigFoundException();
    }
    return Configuration(
      android: PlatformConfiguration.fromYamlMap(
        yamlMap[_FLUTTER_APPLICATION_ID_KEY][_ANDROID_KEY],
      ),
      ios: PlatformConfigurationIOS.fromYamlMap(
        yamlMap[_FLUTTER_APPLICATION_ID_KEY][_IOS_KEY],
      ),
    );
  }

  static Future<Configuration> fromFile(File file) async {
    return Configuration.fromString(await file.readAsString());
  }

  @override
  List<Object> get props => <Object>[android, ios];
}
