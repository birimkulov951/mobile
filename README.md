# mobile

Paynet mobile app (Qulay pul).
Version with hidden all valuable information such as tokens, keys, links and etc.

## About

This repository serves the source code for Paynet mobile app for iOS and Android built with Flutter

For more details, please visit the following page:
- [Project Paynet Mobile](https://ipsuz.atlassian.net/wiki/spaces/PM/overview?homepageId=262214)

## [Additional Topics](docs/contents.md)

## Quick start

After cloning the repository you can get started by using the Flutter version specified in
the [pubspec.yaml](pubspec.yaml) file and by running:

```
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter packages pub run build_runner watch --delete-conflicting-outputs
flutter run --flavor=development --dart-define=isTest=true -t lib/main_dev.dart
flutter build ipa --release  --flavor production --target=lib/main_pro.dart --export-options-plist=ExportOptions.plist
```

