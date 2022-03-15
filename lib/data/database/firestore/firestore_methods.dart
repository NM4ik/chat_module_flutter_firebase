import 'dart:developer';
import 'dart:math';

import 'package:chat_flutter/data/entity/chat_room.dart';
import 'package:chat_flutter/data/entity/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FireStoreMethods {
  CollectionReference rooms = FirebaseFirestore.instance.collection('chatRooms');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  /// GET-methods from firestore
  Future<List<ChatRoom>> getRoomsByUser(String userID) async {
    List<ChatRoom> chatRooms = [];
    var t = await rooms.orderBy("lastMessageTime", descending: true).where("users", arrayContains: userID).get();
    t.docs.map((e) {
      chatRooms.add(ChatRoom.fromJson(e.data() as Map<String, dynamic>));
    }).toList();
    return chatRooms;
  }

  Future<List<Message>> getConversationMessages(String chatRoomID) async {
    var t = await rooms.doc(chatRoomID).collection('messages').orderBy("time").get();
    return t.docs.map((e) => Message.fromJson(e.data())).toList();
  }

  /// CRUD-operation with firestore

  sendMessage(Map<String, dynamic> messageMap, String documentId) {
    rooms.doc(documentId).collection('messages').add(messageMap).catchError((e) => print('SEND MESSAGE ERROR:  ${e.toString()}'));
    updateChatRoomLastMessageAndTime(messageMap['message'], documentId);
  }

  updateChatRoomLastMessageAndTime(String lastMessage, String documentId) {
    rooms.doc(documentId).update({'chatLastMessage': lastMessage});
    rooms.doc(documentId).update({'lastMessageTime': DateTime.now().millisecondsSinceEpoch});
  }

  String createChatRoom(String chatName, String uid, String chatIcon) {
    int random = Random().nextInt(100000);
    List<dynamic> ids = [uid];

    String id = chatName + random.toString();

    ChatRoom chatRoom =
        ChatRoom(name: chatName, chatRoomId: id, lastMessageTime: '', chatLastMessage: '', chatIcon: chatIcon.isEmpty ? '' : chatIcon, usersId: ids);

    rooms.doc(chatRoom.chatRoomId).set(chatRoom.toJson());

    return id;
  }

  joinChatRoom(String chatRoomId, String uid) {
    rooms.doc('qwe21658').update({
      'users': FieldValue.arrayUnion([uid])
    });
  }
}
