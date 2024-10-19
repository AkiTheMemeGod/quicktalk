// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTxtfeild extends StatelessWidget {
  final String hint;
  final bool obscuretxt;
  final TextEditingController controller;
  final FocusNode? focusNode;

  MyTxtfeild(
      {super.key,
      required this.hint,
      required this.obscuretxt,
      required this.controller,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        obscureText: obscuretxt,
        focusNode: focusNode,
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: true,
            hintText: hint,
            hintStyle: GoogleFonts.breeSerif(
              color: Theme.of(context).colorScheme.primary,
            )),
      ),
    );
  }
}
