import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quicktalk/auth/auth_service.dart';
import 'package:quicktalk/components/usertile.dart';
import 'package:quicktalk/services/chatservices/chatservices.dart';

class Blockeduserspage extends StatelessWidget {
  Blockeduserspage({super.key});

  final AuthService _authService = AuthService();
  final Chatservices _chatservices = Chatservices();

  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Unblock User?"),
        content: const Text("Are you sure you want to report this message?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Chatservices().unblockUser(userId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User Unblocked")));
              },
              child: const Text("Report"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = _authService.getCurrentUser()!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 60.0),
          child: Center(
            child: Text(
              "BLOCKED USERS",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: "Monospace"),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        actions: [],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _chatservices.getBlockedUsersStream(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final blockedusers = snapshot.data ?? [];

          if (blockedusers.isEmpty) {
            return const Center(
              child: Text("No Blocked Users"),
            );
          }

          return ListView.builder(
            itemCount: blockedusers.length,
            itemBuilder: (context, index) {
              final users = blockedusers[index];
              return Usertile(
                text: users["email"],
                lastmessage: "Blocked",
                lasttime: Timestamp.now(),
                onTap: () => _showUnblockBox(context, users['uid']),
              );
            },
          );
        },
      ),
    );
  }
}
