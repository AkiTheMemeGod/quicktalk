import 'package:flutter/material.dart';

ThemeData darkmode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(
        255, 3, 18, 48), // Slightly lighter for better readability
    primary: const Color.fromARGB(
        255, 246, 242, 242), // Cooler, more distinct primary
    secondary: const Color.fromARGB(
        255, 10, 54, 105), // Balanced secondary with enough contrast
    tertiary: Colors.grey.shade700, // Softer tertiary for less visual weight
    inversePrimary:
        Colors.grey.shade200, // Lighter inverse for stronger contrast
  ),
);
