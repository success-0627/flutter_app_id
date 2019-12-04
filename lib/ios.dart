import 'dart:io';
import 'package:flutter_application_id/constants.dart' as constants;

import 'custom_exceptions.dart';

void updateApplicationId(Map<String, dynamic> flutterLauncherIconsConfig) {
  print('Updating iOS application ID');
  final String applicationId = flutterLauncherIconsConfig['android'];
  isIosApplicationIdCorrectFormat(applicationId);
  overwriteIosSetupWithNewApplicationId(applicationId);
}

/// Ensures that the Android icon name is in the correct format
bool isIosApplicationIdCorrectFormat(String iconName) {
  // assure the icon only consists of lowercase letters, numbers and underscore
  if (!RegExp(r'^[a-zA-Z0-9_\.]+$').hasMatch(iconName)) {
    throw const InvalidIosIconNameException(
        constants.errorIncorrectAndroidApplicationId);
  }
  return true;
}

/// Updates the line which specifies the launcher icon within the AndroidManifest.xml
/// with the new icon name (only if it has changed)
///
/// Note: default iconName = "ic_launcher"
Future<void> overwriteIosSetupWithNewApplicationId(
    String applicationId) async {
  final File iosSetupFile = File(constants.iosConfigFile);
  final List<String> lines = await iosSetupFile.readAsLines();
  for (int x = 0; x < lines.length; x++) {
    final String line = lines[x];
    if (line.contains('<key>CFBundleIdentifier</key>')) {
      x++; //going straight to next line
      lines[x] = '<string>$applicationId</string>';
    }
  }
  await iosSetupFile.writeAsString(lines.join('\n'));
}
