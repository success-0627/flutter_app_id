# Flutter App Id

A command-line tool which simplifies the task of updating your Flutter app's ID (iOS BundleID and Android applicationId).

## :book: Guide

#### 1. Setup the config file

Add your Flutter App Id configuration to your `pubspec.yaml` or create a new config file. 
An example is shown below.
```yaml
dev_dependencies: 
  flutter_application_id: "^0.0.1"
  
flutter_application_id:
  android: "com.example.myAndroidApp" 
  ios: "com.example.myIosApp" 
```
If you name your configuration file something other than `pubspec.yaml` you will need to specify 
the name of the file when running the package.

```
flutter pub get
flutter pub run flutter_application_id:main -f <your config file name here>
```

#### 2. Run the package

After setting up the configuration, all that is left to do is run the package.

```
flutter pub get
flutter pub run flutter_application_id:main
```

In the above configuration, the package is setup to replace the existing application id in both the Android and iOS project.


## :mag: Attributes

Shown below is the full list of attributes which you can specify within your Flutter Launcher Icons configuration.

- `android`/`ios`
  - absent: Ignore updateing application id for this platform
  - `com.example.applicationId`: This will update the application id for the platform with the name you specify.

### Special thanks

- Thanks to Mark O'Sullivan and all the contributors to the project [flutter_launcher_icon](https://github.com/fluttercommunity/flutter_application_id) which I used as a base.
