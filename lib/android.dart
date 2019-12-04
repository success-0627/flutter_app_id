import 'dart:io';
import 'package:flutter_application_id/custom_exceptions.dart';
import 'package:flutter_application_id/constants.dart' as constants;

void updateApplicationId(Map<String, dynamic> flutterLauncherIconsConfig) {
  print('Updating Android application ID');
  final String applicationId = flutterLauncherIconsConfig['android'];
  isAndroidApplicationIdCorrectFormat(applicationId);
  overwriteAndroidManifestWithNewApplicationId(applicationId);
}

/// Ensures that the Android icon name is in the correct format
bool isAndroidApplicationIdCorrectFormat(String iconName) {
  // assure the icon only consists of lowercase letters, numbers and underscore
  if (!RegExp(r'^[a-zA-Z0-9_\.]+$').hasMatch(iconName)) {
    throw const InvalidAndroidApplicationIdException(
        constants.errorIncorrectAndroidApplicationId);
  }
  return true;
}

/// Updates the line which specifies the launcher icon within the AndroidManifest.xml
/// with the new icon name (only if it has changed)
///
/// Note: default iconName = "ic_launcher"
Future<void> overwriteAndroidManifestWithNewApplicationId(
    String applicationId) async {
  final File androidGradleFile = File(constants.androidGradleFile);
  final List<String> lines = await androidGradleFile.readAsLines();
  for (int x = 0; x < lines.length; x++) {
    String line = lines[x];
    if (line.contains('applicationId')) {
      // Using RegExp replace the value of android:icon to point to the new icon
      // anything but a quote of any length: [^"]*
      // an escaped quote: \\" (escape slash, because it exists regex)
      // quote, no quote / quote with things behind : \"[^"]*
      // repeat as often as wanted with no quote at start: [^"]*(\"[^"]*)*
      // escaping the slash to place in string: [^"]*(\\"[^"]*)*"
      // result: any string which does only include escaped quotes
      line = line.replaceAll(RegExp(r'applicationId[ ]*"[^"]*(\\"[^"]*)*"'),
          'applicationId="$applicationId"');
      lines[x] = line;
      // used to stop git showing a diff if the icon name hasn't changed
      lines.add('');
    }
  }
  await androidGradleFile.writeAsString(lines.join('\n'));
}
