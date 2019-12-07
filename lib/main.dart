import 'dart:io';

import 'package:args/args.dart';

import 'configuration.dart';
import 'constants.dart';
import 'gradle.dart';
import 'plist.dart';

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

  // Load the config file
  final Configuration config =
      await loadConfigFileFromArgResults(argResults, verbose: true);

  try {
    await updateApplicationIdFromConfig(config);
  } catch (e) {
    stderr.writeln(e);
    exit(2);
  }
}

Future<void> updateApplicationIdFromConfig(Configuration config) async {
  if (config.android != null) {
    stdout.writeln('Updating Android application Id');
    final Gradle gradleConf = await Gradle.fromFile(File(ANDROID_CONFIG_FILE));
    gradleConf.updateString(ANDROID_APPID_KEY, config.android);
    gradleConf.toFile(File(ANDROID_CONFIG_FILE));
  }
  if (config.ios != null) {
    stdout.writeln('Updating iOS application Id');
    final Plist plistConf = await Plist.fromFile(File(IOS_CONFIG_FILE));
    plistConf.updateString(IOS_APPID_KEY, config.ios);
    plistConf.toFile(File(IOS_CONFIG_FILE));
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
