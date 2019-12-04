import 'dart:io';

import 'package:args/args.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter_application_id/android.dart' as android_launcher_icons;
import 'package:flutter_application_id/ios.dart' as ios_launcher_icons;
import 'package:flutter_application_id/constants.dart';
import 'package:flutter_application_id/custom_exceptions.dart';

const String fileOption = 'file';
const String helpFlag = 'help';
const String defaultConfigFile = 'flutter_application_id.yaml';

Future<void> updateApplicationIdFromArguments(List<String> arguments) async {
  final ArgParser parser = ArgParser(allowTrailingOptions: true);
  parser.addFlag(helpFlag, abbr: 'h', help: 'Usage help', negatable: false);
  // Make default null to differentiate when it is explicitly set
  parser.addOption(fileOption,
      abbr: 'f', help: 'Config file (default: $defaultConfigFile)');
  final ArgResults argResults = parser.parse(arguments);

  if (argResults[helpFlag]) {
    stdout.writeln('Updates application id for iOS and Android');
    stdout.writeln(parser.usage);
    exit(0);
  }

  // Load the config file
  final Map<String, dynamic> yamlConfig = loadConfigFileFromArgResults(argResults, verbose: true);

  // Create icons
  try {
    await updateApplicationIdFromConfig(yamlConfig);
  } catch (e) {
    stderr.writeln(e);
    exit(2);
  }
}

Future<void> updateApplicationIdFromConfig(Map<String, dynamic> config) async {
  if (!hasAndroidOrIOSConfig(config)) {
    throw const InvalidConfigException(errorMissingPlatform);
  }

  if (isNeedingNewAndroidApplicationId(config)) {
    android_launcher_icons.updateApplicationId(config);
  }
  if (isNeedingNewIOSApplicationId(config)) {
    ios_launcher_icons.updateApplicationId(config);
  }
}

Map<String, dynamic> loadConfigFileFromArgResults(ArgResults argResults,
    {bool verbose}) {
  verbose ??= false;
  final String configFile = argResults[fileOption];
  final String fileOptionResult = argResults[fileOption];

  // if icon is given, try to load icon
  if (configFile != null && configFile != defaultConfigFile) {
    try {
      return loadConfigFile(configFile, fileOptionResult);
    } catch (e) {
      if (verbose) {
        stderr.writeln(e);
      }

      return null;
    }
  }

  // If none set try flutter_application_id.yaml first then pubspec.yaml
  // for compatibility
  try {
    return loadConfigFile(defaultConfigFile, fileOptionResult);
  } catch (e) {
    // Try pubspec.yaml for compatibility
    if (configFile == null) {
      try {
        return loadConfigFile('pubspec.yaml', fileOptionResult);
      } catch (_) {}
    }

    // if nothing got returned, print error
    if (verbose) {
      stderr.writeln(e);
    }
  }

  return null;
}

Map<String, dynamic> loadConfigFile(String path, String fileOptionResult) {
  final File file = File(path);
  final String yamlString = file.readAsStringSync();
  final Map yamlMap = loadYaml(yamlString);

  if (yamlMap == null || !(yamlMap['flutter_application_id'] is Map)) {
    stderr.writeln(NoConfigFoundException('Check that your config file '
        '`${fileOptionResult ?? defaultConfigFile}`'
        ' has a `flutter_application_id` section'));
    exit(1);
  }

  // yamlMap has the type YamlMap, which has several unwanted sideeffects
  final Map<String, dynamic> config = <String, dynamic>{};
  for (MapEntry<dynamic, dynamic> entry in yamlMap['flutter_application_id'].entries) {
    config[entry.key] = entry.value;
  }

  return config;
}

bool hasAndroidOrIOSConfig(Map<String, dynamic> flutterIconsConfig) {
  return flutterIconsConfig.containsKey('android') ||
      flutterIconsConfig.containsKey('ios');
}

bool hasAndroidConfig(Map<String, dynamic> flutterLauncherIcons) {
  return flutterLauncherIcons.containsKey('android');
}

bool isNeedingNewAndroidApplicationId(Map<String, dynamic> flutterLauncherIconsConfig) {
  return hasAndroidConfig(flutterLauncherIconsConfig) &&
      flutterLauncherIconsConfig['android'] != false;
}

bool hasIOSConfig(Map<String, dynamic> flutterLauncherIconsConfig) {
  return flutterLauncherIconsConfig.containsKey('ios');
}

bool isNeedingNewIOSApplicationId(Map<String, dynamic> flutterLauncherIconsConfig) {
  return hasIOSConfig(flutterLauncherIconsConfig) &&
      flutterLauncherIconsConfig['ios'] != false;
}
