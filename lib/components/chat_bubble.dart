import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quicktalk/services/chatservices/chatservices.dart';
import 'package:quicktalk/themes/theme_provider.dart';

class MyChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;
  final String receiverId;
  final Timestamp timestamp;

  MyChatBubble(
      {super.key,
      required this.message,
      required this.isCurrentUser,
      required this.messageId,
      required this.userId,
      required this.receiverId,
      required this.timestamp});

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

  void _deletemessage(BuildContext context, String recieverId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Message?"),
        content: const Text("Are you sure you want to delete this message?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Chatservices().deletemessage(recieverId, messageId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Message deleted")));
              },
              child: const Text("Delete"))
        ],
      ),
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
    //String time = timestamp.toDate().toString();
    DateTime dateTime = timestamp.toDate();
    String time = DateFormat("hh:mm a").format(dateTime);
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          //show options
          _showoption(context, messageId, userId);
        } else {
          _deletemessage(context, receiverId);
        }
      },
      child: Container(
        padding: EdgeInsets.only(top: 15, right: 15, left: 15, bottom: 8),
        margin: EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
            color: isCurrentUser
                ? (isDarkMode
                    ? const Color.fromARGB(255, 26, 132, 231)
                    : const Color.fromARGB(255, 115, 199, 255))
                : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                  fontSize: 14,
                  color: isCurrentUser
                      ? (isDarkMode ? Colors.white : Colors.black)
                      : (isDarkMode ? Colors.white : Colors.black)),
            ),
            Text(
              time,
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
