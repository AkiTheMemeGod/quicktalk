import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade100, // Lighter surface for better contrast
    primary: Colors.blueGrey.shade700, // A cooler, slightly darker primary
    secondary: Colors.blueGrey.shade300, // Matching secondary with softer tones
    tertiary: Colors.grey.shade50, // Very light tertiary for subtle contrasts
    inversePrimary: Colors.black, // Darker inverse for strong contrast
  ),
);
