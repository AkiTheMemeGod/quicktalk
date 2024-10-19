import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quicktalk/models/message.dart';

class Chatservices extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getUserStreamExcludingBlocked() {
    final currentUser = _auth.currentUser;

    return _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .orderBy("timestamp", descending: false)
        .snapshots()
        .asyncMap((snapshot) async {
      final blockedUserids = snapshot.docs.map((doc) => doc.id).toList();

      final usersSnapshots = await _firestore.collection("Users").get();

      return usersSnapshots.docs
          .where((doc) =>
              doc.data()['email'] != currentUser.email &&
              !blockedUserids.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });
  }

  Future<void> sendMessage(String recieverId, message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newmessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        recieverId: recieverId,
        message: message,
        timestamp: timestamp);

    List<String> ids = [currentUserId, recieverId];
    ids.sort();

    String chatroom = ids.join("_");

    await _firestore
        .collection("chat_rooms")
        .doc(chatroom)
        .collection("messages")
        .add(newmessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userID, otherUserId) {
    List<String> ids = [userID, otherUserId];
    ids.sort();

    String chatroom = ids.join("_");
    return _firestore
        .collection("chat_rooms")
        .doc(chatroom)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Future<List> getLastMessage(String userID, String otherUserId) async {
    List<String> ids = [userID, otherUserId];
    ids.sort();

    String chatroom = ids.join("_");

    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection("chat_rooms")
        .doc(chatroom)
        .collection("messages")
        .orderBy("timestamp", descending: true) // Fetch latest first
        .limit(1) // Limit to the last message
        .get();

    // Check if there are messages in the snapshot
    if (snapshot.docs.isNotEmpty) {
      List data = [
        snapshot.docs.first.data()['message'],
        snapshot.docs.first.data()['timestamp']
      ];
      //print(snapshot.docs.first.data()['message'].toString());
      // Access the message data and return the "message" field as a String
      return data;
    } else {
      throw Exception("No messages found in the chat room.");
    }
  }

  //report

  Future<void> reportUser(String messageId, String UserId) async {
    final currentUser = _auth.currentUser;

    final report = {
      'reportedBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': UserId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection("Reports").add(report);
  }

//block

  Future<void> blockUser(String userId) async {
    final currentUser = _auth.currentUser;

    await _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .doc(userId)
        .set({});

    notifyListeners();
  }

  // unblock

  Future<void> unblockUser(String blockedUserId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .doc(blockedUserId)
        .delete();
  }

  Future<void> deletemessage(String receiverId, String messageId) async {
    try {
      final String currentUserId = _auth.currentUser!.uid;

      // Sort the user IDs to get the chat room ID
      List<String> ids = [currentUserId, receiverId];
      ids.sort();

      String chatroom = ids.join("_");

      // Find the message in the Firestore collection using the messageId and delete it
      await _firestore
          .collection("chat_rooms")
          .doc(chatroom)
          .collection("messages")
          .doc(messageId)
          .delete();
    } catch (e) {
      print('Error deleting message: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userId) {
    return _firestore
        .collection("Users")
        .doc(userId)
        .collection("BlockedUsers")
        .snapshots()
        .asyncMap((snapshot) async {
      final blockedUsersIds = snapshot.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(blockedUsersIds
          .map((id) => _firestore.collection("Users").doc(id).get()));

      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
