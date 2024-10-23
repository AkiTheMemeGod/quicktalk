// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quicktalk/components/dialog.dart';
import 'package:quicktalk/services/chatservices/chatservices.dart';

class PopupMenu extends StatelessWidget {
  final BuildContext context;
  final String userId;
  final String messageId;
  final String receiverId;
  final String message;
  TextEditingController controller = TextEditingController();

  PopupMenu(
      {super.key,
      required this.context,
      required this.userId,
      required this.messageId,
      required this.receiverId,
      //required this.controller,
      required this.message});

  void replymessagebubble() {
    Chatservices().sendMessage(receiverId, message);
  }

  void reply(context) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: controller,
          reply: replymessagebubble,
        );
      },
    );
  }

  void _reportContent(BuildContext context, String userId, String messageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Report Message?", style: GoogleFonts.breeSerif()),
        content: Text("Are you sure you want to report this message?",
            style: GoogleFonts.breeSerif()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: GoogleFonts.breeSerif())),
          TextButton(
              onPressed: () {
                Chatservices().reportUser(messageId, userId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Message Reported",
                        style: GoogleFonts.breeSerif())));
              },
              child: Text("Report", style: GoogleFonts.breeSerif()))
        ],
      ),
    );
  }

  void _blockUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Block User?", style: GoogleFonts.breeSerif()),
        content: Text("Are you sure you want to Block This User?",
            style: GoogleFonts.breeSerif()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: GoogleFonts.breeSerif())),
          TextButton(
              onPressed: () {
                Chatservices().blockUser(userId);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text("User Blocked", style: GoogleFonts.breeSerif())));
              },
              child: Text("Block", style: GoogleFonts.breeSerif()))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 45),
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                color: Colors.grey.shade100,
              ),
              child: Text(
                "Reply",
                style: GoogleFonts.breeSerif(color: Colors.black),
              )),
        ),
        GestureDetector(
          onTap: () => _reportContent(context, userId, messageId),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 9),
            height: 40,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            child: Text(
              "Report Message",
              style: GoogleFonts.breeSerif(color: Colors.black),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _blockUser(context, userId),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
              ),
              child: Text(
                "Block User",
                style: GoogleFonts.breeSerif(color: Colors.black),
              )),
        ),
      ],
    );
  }
}
