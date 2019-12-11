import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:flutter_application_id/custom_exceptions.dart';
import 'package:flutter_application_id/file_updater/rules/xml.dart';

import 'configuration.dart';
import 'constants.dart';
import 'file_updater/file_updater.dart';
import 'file_updater/rules/gradle.dart';
import 'file_updater/rules/pbxproj.dart';
import 'file_updater/rules/plist.dart';

const String fileOption = 'file';
const String helpFlag = 'help';

Future<void> updateApplicationIdFromArguments(List<String> arguments) async {
  final ArgParser parser = ArgParser(allowTrailingOptions: true);
  parser.addFlag(helpFlag, abbr: 'h', help: 'Usage help', negatable: false);
  // Make default null to differentiate when it is explicitly set
  parser.addOption(fileOption,
      abbr: 'f', help: 'Config file (default: $DEFAULT_CONFIG_FILES)');
  final ArgResults argResults = parser.parse(arguments);

  if (argResults[helpFlag]) {
    stdout.writeln('Updates application id for iOS and Android');
    stdout.writeln(parser.usage);
    exit(0);
  }

  try {
    final Configuration config =
        await loadConfigFileFromArgResults(argResults, verbose: true);

    await updateApplicationIdFromConfig(config);
  } catch (e) {
    if (e is InvalidFormatException) {
      stderr.writeln('Invalid configuration format.');
    } else {
      stderr.writeln(e);
    }
    exit(2);
  }
}

Future<void> updateApplicationIdFromConfig(Configuration config) async {
  if (config.android != null) {
    if (config.android.id != null) {
      stdout.writeln('Updating Android application Id');
      FileUpdater.updateFile(File(ANDROID_GRADLE_FILE),
          GradleString(ANDROID_APPID_KEY, config.android.id));
    }
    if (config.android.name != null) {
      stdout.writeln('Updating Android application name');
      FileUpdater.updateFile(File(ANDROID_MANIFEST_FILE),
          XmlAttribute(ANDROID_APPNAME_KEY, config.android.name));
    }
    if (config.ios != null) {
      if (config.ios.id != null) {
        stdout.writeln('Updating iOS application Id');
        FileUpdater.updateFile(
            File(IOS_PBXPROJ_FILE), Pbxproj(IOS_APPID_KEY, config.ios.id));
      }
      if (config.ios.name != null) {
        stdout.writeln('Updating iOS application name');
        FileUpdater.updateFile(
            File(IOS_PLIST_FILE), Plist(IOS_APPNAME_KEY, config.ios.name));
      }
    }
  }
}

Future<Configuration> loadConfigFileFromArgResults(ArgResults argResults,
    {bool verbose}) async {
  verbose ??= false;
  Configuration config;

  config ??= await loadConfigFile(argResults[fileOption], verbose: verbose);
  for (String configFile in DEFAULT_CONFIG_FILES) {
    config ??= await loadConfigFile(configFile, verbose: verbose);
  }

  return config;
}

Future<Configuration> loadConfigFile(String filePath, {bool verbose}) async {
  verbose ??= false;
  if (filePath != null) {
    try {
      return Configuration.fromFile(File(filePath));
    } catch (e) {
      if (verbose) {
        stderr.writeln(e);
      }
    }
  }
  return null;
}
