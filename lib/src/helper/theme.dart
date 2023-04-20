import 'package:flutter/material.dart';

class MyTheme {
  static Color primaryColor = Colors.red[900]!;

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,                        // defaultBackgroundColor
    colorScheme: const ColorScheme.dark(),
    primaryColor: primaryColor,                                           // backgroundColor
    iconTheme: const IconThemeData(color: Colors.grey, opacity: 0.8),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionHandleColor: Colors.white,
      selectionColor: Colors.black
    ),
    splashFactory: NoSplash.splashFactory,
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryColor,
      inactiveTrackColor: Colors.grey[700],
      thumbColor: primaryColor
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(),
    primaryColor: primaryColor,
    iconTheme: const IconThemeData(color: Colors.black, opacity: 0.8),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.black,
      selectionHandleColor: Colors.black,
      selectionColor: Colors.white
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryColor,
      inactiveTrackColor: Colors.grey[700],
      thumbColor: primaryColor
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
  );

}