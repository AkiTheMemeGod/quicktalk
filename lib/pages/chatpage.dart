import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quicktalk/auth/auth_service.dart';
import 'package:quicktalk/components/my_txtfeild.dart';
import 'package:quicktalk/services/chatservices/chatservices.dart';

class Chatpage extends StatelessWidget {
  final String recieverEmail;
  final String recieverId;

  Chatpage({super.key, required this.recieverEmail, required this.recieverId});

  final TextEditingController _messagecontroller = TextEditingController();
  final Chatservices _chatservices = Chatservices();
  final AuthService _authService = AuthService();

  void sendMessage() async {
    if (_messagecontroller.text.isNotEmpty) {
      await _chatservices.sendMessage(recieverId, _messagecontroller.text);
      _messagecontroller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          recieverEmail,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Expanded(child: _buildmessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildmessageList() {
    String senderId = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatservices.getMessages(recieverId, senderId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error..");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        return ListView(
          children: snapshot.data!.docs
              .map((doc) => _buildmessageListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildmessageListItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Text(data["message"]);
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
            child: MyTxtfeild(
                hint: "Type Something..",
                obscuretxt: false,
                controller: _messagecontroller)),
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.arrow_upward))
      ],
    );
  }
}
