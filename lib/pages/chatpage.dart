import 'package:flutter/material.dart';
import 'package:quicktalk/auth/auth_service.dart';
import 'package:quicktalk/services/chatservices/chatservices.dart';

class Chatpage extends StatelessWidget {
  final String recieverEmail;
  final String recieverId;

  Chatpage({super.key, required this.recieverEmail, required this.recieverId});

  final TextEditingController _messagecontroller = TextEditingController();
  final Chatservices _chatservices = Chatservices();
  final AuthService _authService = AuthService();

  void sendMessage() async {
    if (_messagecontroller.text.isNotEmpty) {}
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
    );
  }
}
