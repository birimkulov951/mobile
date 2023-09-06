import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

const _sfProDisplay = 'SF Pro Display';
const _roboto = 'Roboto';

class MyTheme {
  static ThemeData get _lightTheme => ThemeData(
        fontFamily: Platform.isIOS ? _sfProDisplay : _roboto,
        brightness: Brightness.light,
        scaffoldBackgroundColor: ColorNode.Background,
        backgroundColor: Light.Navigation,
        disabledColor: Light.Disabled,
        indicatorColor: ColorNode.Gray,
        dividerColor: ColorNode.Gray,
        accentColor: ColorNode.Green,
        primaryColor: ColorNode.Green,
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorNode.Background,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          ),
          titleTextStyle: TextStyle(
            color: ColorNode.Dark1,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: IconThemeData(
            size: 20,
            color: ColorNode.Icon,
          ),
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(
            color: ColorNode.Dark1,
            fontSize: 14,
            letterSpacing: -.2,
            fontWeight: FontWeight.w400,
          ),
          bodyText1: TextStyle(
            color: Light.Dismiss,
            fontSize: 14,
            letterSpacing: -.2,
            fontWeight: FontWeight.w400,
          ),
          headline4: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: -.2,
          ),
          headline3: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: -.2,
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          // cursorColor: ColorNode.Green,
          cursorColor: ColorNode.Green,
        ),
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: ColorNode.Main,
            labelStyle: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: ColorNode.GreyScale600),
            prefixStyle: TextStyle(
                fontSize: 18,
                color: ColorNode.Dark1,
                fontWeight: FontWeight.w700),
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            disabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: ColorNode.GreyScale400,
            ),
            errorStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ColorNode.Red)),
        iconTheme: IconThemeData(color: ColorNode.Icon),
      );

  static ThemeData get _darkTheme => ThemeData(
        fontFamily: Platform.isIOS ? _sfProDisplay : _roboto,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        backgroundColor: Dark.Navigation,
        disabledColor: Dark.Disabled,
        indicatorColor: ColorNode.DarkGray,
        dividerColor: Colors.white,
        accentColor: ColorNode.Green,
        primaryColor: ColorNode.Green,
        bottomAppBarTheme: BottomAppBarTheme(color: Color(0xFF111111)),
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            size: 20,
            color: Colors.white,
          ),
        ),
        textTheme: TextTheme(
          bodyText2:
              TextStyle(color: Colors.white, fontSize: 14, letterSpacing: -.2),
          bodyText1:
              TextStyle(color: Dark.Dismiss, fontSize: 14, letterSpacing: -.2),
          headline4: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: -.2,
          ),
          headline3: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: -.2,
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          // cursorColor: ColorNode.Green,
          cursorColor: ColorNode.Green,
        ),
        inputDecorationTheme: InputDecorationTheme(
          prefixStyle: TextStyle(fontSize: 16, color: Colors.white),
          disabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
          ),
          labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      );

  static ThemeData switchTheme(Brightness brightness) {
    pref?.setCurrentTheme(brightness.index);
    if (brightness == Brightness.light)
      return _lightTheme;
    else
      return _darkTheme;
  }

  static ThemeData get currentTheme {
    if (pref?.themeNode == null) {
      return _lightTheme;
    }
    return Brightness.values[pref!.themeNode] == Brightness.light
        ? _lightTheme
        : _darkTheme;
  }
}
