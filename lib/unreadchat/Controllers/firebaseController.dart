
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseController {
  static FirebaseController get instanace => FirebaseController();

  // Save Image to Storage


  // About Firebase Database
  Future<String?> saveUserDataToFirebaseDatabase(userId, userName, userIntro,
      downloadUrl) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('userId', isEqualTo: userId)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      String myID = userId;
      if (documents.length == 0) {
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'userId': userId,
          'name': userName,
          'intro': userIntro,
          'userImageUrl': downloadUrl,
          'createdAt': DateTime
              .now()
              .millisecondsSinceEpoch,
          'FCMToken': prefs.get('FCMToken') ?? 'NOToken',
        });
      } else {
        String userID = documents[0]['userId'];
        myID = userID;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', myID);
        await FirebaseFirestore.instance
            .collection('users').doc(userID).update({
          'name': userName,
          'intro': userIntro,
          'userImageUrl': downloadUrl,
          'createdAt': DateTime
              .now()
              .millisecondsSinceEpoch,
          'FCMToken': prefs.get('FCMToken') ?? 'NOToken',
        });
      }
      return myID;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUserToken(userID, token) async {
    await FirebaseFirestore.instance.collection('users').doc(userID).set({
      'FCMToken': token,
    });
  }

  Future<List<DocumentSnapshot>> takeUserInformationFromFBDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('FCMToken', isEqualTo: prefs.get('FCMToken') ?? 'None')
        .get();
    return result.docs;
  }

  Future<int?> getUnreadMSGCount([String? peerUserID]) async {
    try {
      int unReadMSGCount = 0;
      String? targetID = '';
      SharedPreferences prefs = await SharedPreferences.getInstance();

      peerUserID == null
          ? targetID = (prefs.get('userId') ?? 'NoId') as String?
          : targetID = peerUserID;
//      if (targetID != 'NoId') {
      final QuerySnapshot chatListResult = await FirebaseFirestore.instance
          .collection('users')
          .doc(targetID)
          .collection('chatlist')
          .get();
      final List<DocumentSnapshot> chatListDocuments = chatListResult.docs;
      for (var data in chatListDocuments) {
        final QuerySnapshot unReadMSGDocument = await FirebaseFirestore.instance
            .collection('chatroom')
            .doc(data['chatID'])
            .collection(data['chatID'])
            .where('idTo', isEqualTo: targetID)
            .where('isread', isEqualTo: false)
            .get();

        final List<DocumentSnapshot> unReadMSGDocuments =
            unReadMSGDocument.docs;
        unReadMSGCount = unReadMSGCount + unReadMSGDocuments.length;
      }
      print('unread MSG count is $unReadMSGCount');
//      }
      if (peerUserID == null) {
        return null;
      } else {
        return unReadMSGCount;
      }
    } catch (e) {
      print(e);
    }
  }

  Future updateChatRequestField(String documentID, String lastMessage, chatID,
      myID, selectedUserID) async {
    await FirebaseFirestore.instance.collection('users').doc(documentID)
        .collection('chatlist').doc(chatID)
        .set({
      'chatID': chatID,
      'chatWith': documentID == myID ? selectedUserID : myID,
      'lastChat': lastMessage,
      'timestamp': DateTime
          .now()
          .millisecondsSinceEpoch
    });
  }

  updateChatRequestFieldgrp(String documentID, String lastMessage, chatID, myID,
      selectedUserID) async {
    await FirebaseFirestore.instance.collection('users').doc(documentID)
        .collection('chatlist').doc(chatID)
        .set({
      'chatID': chatID,
      'chatWith': documentID == myID ? selectedUserID : myID,
      'lastChat': lastMessage,
      'isGroup': '0',
      'timestamp': DateTime
          .now()
          .millisecondsSinceEpoch
    });
  }

  Future sendMessageToChatRoom(chatID, myID, selectedUserID, content,
      messageType, createEditProfileModel, int stamp) async {
    await FirebaseFirestore.instance.collection('chatroom').doc(chatID).collection(
        chatID).doc(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString()).set({
      'idFrom': myID,
      'idTo': selectedUserID,
      'timestamp': stamp,
      'content': content,
      'type': messageType,
      'isread': false,
      'msgname': createEditProfileModel.firstName,
      'msgimage': createEditProfileModel.profilePicture,
    });
  }
}
