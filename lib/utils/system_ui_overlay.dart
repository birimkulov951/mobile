import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void updateSystemUIOverlay({
  Color? navigationBarColor,
  Color? statusBarColor,
}) =>
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: navigationBarColor ?? Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
