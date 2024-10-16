import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: const Color.fromARGB(
        255, 146, 182, 225), // Lighter surface for better contrast
    primary: const Color.fromARGB(
        255, 255, 255, 255), // A cooler, slightly darker primary
    secondary: const Color.fromARGB(
        255, 174, 208, 247), // Matching secondary with softer tones
    tertiary: Colors.grey.shade50, // Very light tertiary for subtle contrasts
    inversePrimary: Colors.black, // Darker inverse for strong contrast
  ),
);
