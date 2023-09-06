## To run the app

1. Ensure Flutter SDK is installed correctly, visit https://flutter.dev/docs/get-started/install for details.
2. Switch flutter version to the one which is used by the project in pubspec.yaml file.
    - cd $PATH_TO_FLUTTER_SDK
    - git checkout $FLUTTER_VERSION
    - flutter doctor
3. Add Flutter plugin to your IDE. Supported: **Android Studio**, **VS Code**, **IntelliJ IDEA**. Review instructions if needed: https://flutter.dev/docs/development/tools
4. Git clone this repository, ``git clone git@gitlab.com:mobile/mobile.git``
5. Checkout **develop** branch as the one with most recent updates.
6. Prepare the app for build running 
```
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter run --flavor=development --dart-define=isTest=true -t lib/main_dev.dart
```
7. Run on a selected device/emulator

## [Back | Contents](contents.md)