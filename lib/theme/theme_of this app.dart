import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
    backgroundColor: Colors.grey.shade800,
    hintColor: Colors.white,
    toggleableActiveColor: Colors.black,
    searchBarTheme: SearchBarThemeData(
      backgroundColor: MaterialStateProperty.all(Colors.grey.shade800),
      hintStyle:
          MaterialStateProperty.all(const TextStyle(color: Colors.white)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: Colors.green.shade400,
    ),
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: Colors.grey.shade900,
      primary: Colors.black54,
      secondary: Colors.black12,
    )
);

ThemeData lightMode = ThemeData(
    hintColor: Colors.black,
    toggleableActiveColor: Colors.white,
    searchBarTheme: SearchBarThemeData(
      backgroundColor: MaterialStateProperty.all(Colors.grey.shade100),
      hintStyle:
          MaterialStateProperty.all(const TextStyle(color: Colors.white)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
      backgroundColor: Colors.green.shade400,
    ),
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: Colors.grey.shade200,
      primary: Colors.grey.shade50,
      secondary: Colors.grey.shade400,
    )
);
