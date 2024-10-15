import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quicktalk/services/chatservices/chatservices.dart';
import 'package:quicktalk/themes/theme_provider.dart';

class MyChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;

  MyChatBubble(
      {super.key,
      required this.message,
      required this.isCurrentUser,
      required this.messageId,
      required this.userId});

  void _showoption(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
            child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.flag),
              title: Text("Report"),
              onTap: () {
                Navigator.pop(context);
                _reportContent(context, userId, messageId);
              },
            ),
            ListTile(
              leading: Icon(Icons.block),
              title: Text("Block User"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);

                _blockUser(context, userId);
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text("Cancel"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ));
      },
    );
  }

  void _reportContent(BuildContext context, String userId, String messageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Report Message?"),
        content: const Text("Are you sure you want to report this message?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Chatservices().reportUser(messageId, userId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Message Reported")));
              },
              child: const Text("Report"))
        ],
      ),
    );
  }

  void _blockUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Block User?"),
        content: const Text("Are you sure you want to Block This User?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Chatservices().blockUser(userId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User Reported")));
              },
              child: const Text("Block"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          //show options
          _showoption(context, messageId, userId);
        }
      },
      child: Container(
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
      ),
    );
  }
}
