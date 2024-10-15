import 'package:flutter/material.dart';
import 'package:quicktalk/auth/auth_service.dart';
import 'package:quicktalk/components/my_drawer.dart';
import 'package:quicktalk/components/usertile.dart';
import 'package:quicktalk/services/chatservices/chatservices.dart';

import 'chatpage.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final Chatservices _chatservices = Chatservices();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 60.0),
          child: Center(
            child: Text(
              "USERS",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: "Monospace"),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
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

          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != _authService.getCurrentUser()!.email) {
      return Usertile(
        text: userData["email"],
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
