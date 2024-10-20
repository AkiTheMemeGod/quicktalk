import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quicktalk/auth/auth_service.dart';
import 'package:quicktalk/components/chat_bubble.dart';
import 'package:quicktalk/components/my_txtfeild.dart';
import 'package:quicktalk/services/chatservices/chatservices.dart';

class Chatpage extends StatefulWidget {
  final String recieverEmail;
  final String recieverId;
//comment
  Chatpage({super.key, required this.recieverEmail, required this.recieverId});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  final TextEditingController _messagecontroller = TextEditingController();

  final Chatservices _chatservices = Chatservices();

  final AuthService _authService = AuthService();

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(microseconds: 100), () => scrolldown());
        //WidgetsBinding.instance.addPostFrameCallback((_) => scrolldown());
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      scrolldown();
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messagecontroller.dispose();

    super.dispose();
  }

  final ScrollController _myscrollcontroller = ScrollController();

  void scrolldown() {
    _myscrollcontroller.animateTo(_myscrollcontroller.position.extentTotal,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void sendMessage() async {
    if (_messagecontroller.text.isNotEmpty) {
      await _chatservices.sendMessage(
        widget.recieverId,
        _messagecontroller.text,
      );

      _messagecontroller.clear();
    }
    scrolldown();
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.recieverEmail.length > 10
        ? widget.recieverEmail.substring(0, widget.recieverEmail.length - 10)
        : widget.recieverEmail;

    return Scaffold(
      //backgroundColor: Colors.black,

      appBar: AppBar(
        title: Text(
          name[0].toUpperCase() + name.substring(1),
          style: GoogleFonts.breeSerif(
              color: Theme.of(context).colorScheme.inversePrimary),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
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
      stream: _chatservices.getMessages(widget.recieverId, senderId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error..");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        return ListView(
          controller: _myscrollcontroller,
          children: snapshot.data!.docs
              .map((doc) => _buildmessageListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildmessageListItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            MyChatBubble(
              message: data["message"],
              isCurrentUser: isCurrentUser,
              messageId: doc.id,
              userId: data["senderID"],
              receiverId: data["recieverId"],
              timestamp: data["timestamp"],
            ),
          ],
        ));
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: MyTxtfeild(
            hint: "Type Something..",
            obscuretxt: false,
            controller: _messagecontroller,
            focusNode: myFocusNode,
          )),
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
