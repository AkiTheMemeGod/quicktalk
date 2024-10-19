import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:quicktalk/auth/auth_service.dart';
import 'package:quicktalk/components/my_drawer.dart';
import 'package:quicktalk/components/usertile.dart';
import 'package:quicktalk/services/chatservices/chatservices.dart';

import 'chatpage.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Chatservices _chatservices = Chatservices();

  final AuthService _authService = AuthService();

  Future<void> _refreshpage() async {
    setState(() {});
    return await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 60.0),
          child: Center(
            child: Text(
              "QuickTalk",
              style: GoogleFonts.breeSerif(
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      drawer: MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
        stream: _chatservices.getUserStreamExcludingBlocked(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          final users = snapshot.data!;

          // Fetch the last message for each user and sort based on timestamp
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _getUsersWithLastMessages(users),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Text("Error");
              }

              final sortedUsers = snapshot.data!;

              return LiquidPullToRefresh(
                onRefresh: _refreshpage,
                height: 300,
                animSpeedFactor: 2,
                showChildOpacityTransition: true,
                child: ListView(
                  children: sortedUsers
                      .map<Widget>(
                          (userData) => _buildUserListItem(userData, context))
                      .toList(),
                ),
              );
            },
          );
        });
  }

  Future<List<Map<String, dynamic>>> _getUsersWithLastMessages(
      List<Map<String, dynamic>> users) async {
    // Fetch last messages and timestamps for all users
    final List<Map<String, dynamic>> usersWithLastMessages = [];

    for (var userData in users) {
      final lastMessageData = await _chatservices
          .getLastMessage(_authService.getCurrentUser()!.uid, userData['uid'])
          .catchError((_) {
        // Handle error for fetching last message
        return ["No messages", Timestamp(0, 0)];
      });

      usersWithLastMessages.add({
        'userData': userData,
        'lastMessage': lastMessageData[0],
        'lastTime': lastMessageData[1] as Timestamp,
      });
    }

    // Sort the users by their last message timestamp in descending order
    usersWithLastMessages.sort((a, b) {
      return (b['lastTime'] as Timestamp).compareTo(a['lastTime'] as Timestamp);
    });

    return usersWithLastMessages;
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userWithLastMessage, BuildContext context) {
    final userData = userWithLastMessage['userData'];
    final lastMessage = userWithLastMessage['lastMessage'];
    final lastTime = userWithLastMessage['lastTime'] as Timestamp;

    if (userData['email'] != _authService.getCurrentUser()!.email) {
      return Usertile(
        text: userData["email"],
        lastmessage: lastMessage ?? "No messages",
        lasttime: lastTime,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Chatpage(
                  recieverEmail: userData["email"],
                  recieverId: userData['uid'],
                ),
              ));
        },
      );
    } else {
      return Container();
    }
  }
}
