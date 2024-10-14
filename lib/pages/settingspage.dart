import 'package:flutter/material.dart';

class Settingspage extends StatelessWidget {
  const Settingspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80.0),
          child: Text(
            "Settings",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}
