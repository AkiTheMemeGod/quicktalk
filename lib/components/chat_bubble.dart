import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:quicktalk/components/popup_menu.dart';
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

  void _deletemessage(BuildContext context, String recieverId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Message?", style: GoogleFonts.breeSerif()),
        content: Text("Are you sure you want to delete this message?",
            style: GoogleFonts.breeSerif()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: GoogleFonts.breeSerif())),
          TextButton(
              onPressed: () {
                Chatservices().deletemessage(recieverId, messageId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Message deleted",
                        style: GoogleFonts.breeSerif())));
              },
              child: Text("Delete", style: GoogleFonts.breeSerif()))
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
          showPopover(
            context: context,
            bodyBuilder: (context) => PopupMenu(
              context: context,
              userId: userId,
              messageId: messageId,
              receiverId: receiverId,
              message: message,
            ),
            height: 120,
            width: 150,
            backgroundColor: Colors.grey.shade100,
          );
        } else {
          _deletemessage(context, receiverId);
        }
      },
      /*onLongPress: () {
        if (!isCurrentUser) {
          //show options
          _showoption(context, messageId, userId);
        } else {
          _deletemessage(context, receiverId);
        }
      }*/
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
