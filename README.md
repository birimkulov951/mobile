# mobile

Example app.
Version with hidden all valuable information such as tokens, keys, links and etc.

## About

This repository serves the source code for Example mobile app for iOS and Android built with Flutter

## Quick start

After cloning the repository you can get started by using the Flutter version specified in
the [pubspec.yaml](pubspec.yaml) file and by running:

```
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter packages pub run build_runner watch --delete-conflicting-outputs
flutter run --flavor=development --dart-define=isTest=true -t lib/main_dev.dart
flutter build ipa --release  --flavor production --target=lib/main_pro.dart --export-options-plist=ExportOptions.plist
```

