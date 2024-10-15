import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quicktalk/themes/theme_provider.dart';

class MyChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  MyChatBubble({super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
          color: isCurrentUser
              ? (isDarkMode ? Colors.green.shade600 : Colors.grey.shade500)
              : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12)),
      child: Text(
        message,
        style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black, fontSize: 17),
      ),
    );
  }
}
