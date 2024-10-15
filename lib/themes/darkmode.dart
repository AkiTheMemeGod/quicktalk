import 'package:flutter/material.dart';

ThemeData darkmode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(
        255, 25, 25, 25), // Slightly lighter for better readability
    primary: const Color.fromARGB(
        255, 246, 242, 242), // Cooler, more distinct primary
    secondary: Colors.grey.shade600, // Balanced secondary with enough contrast
    tertiary: Colors.grey.shade700, // Softer tertiary for less visual weight
    inversePrimary:
        Colors.grey.shade200, // Lighter inverse for stronger contrast
  ),
);
