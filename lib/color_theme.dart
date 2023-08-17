import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 253, 253, 253),
    primary: const Color.fromARGB(255, 255, 88, 88),
    background: const Color.fromARGB(255, 253, 253, 253),
  ),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 29, 29, 29),
    primary: const Color.fromARGB(255, 255, 88, 88),
    background: const Color.fromARGB(255, 29, 29, 29),
  ),
);
