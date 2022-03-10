import 'dart:developer';

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
    var t = await rooms.where("users", arrayContains: userID).get();
    t.docs.map((e) {
      chatRooms.add(ChatRoom.fromJson(e.data() as Map<String, dynamic>));
    }).toList();
    return chatRooms;
  }

  Future<List<Message>> getConversationMessages(String chatRoomID) async {
    var t = await rooms.doc(chatRoomID).collection('messages').orderBy("time").get();
    return t.docs.map((e) => Message.fromJson(e.data())).toList();
  }

  // Stream<List<Message>> getStreamMessages(String chatRoomId) => Stream.periodic(const Duration(seconds: 1)).asyncMap((_) => getConversationMessages(chatRoomId));

  /// CRUD-operation with firestore

  sendMessage(Map<String, dynamic> messageMap, String documentId) {
    rooms.doc(documentId).collection('messages').add(messageMap).catchError((e) => log(e, name: 'sendMessageError'));
    updateChatRoomLastMessage(messageMap['message'], documentId);
  }

  updateChatRoomLastMessage(String lastMessage, String documentId) {
    rooms.doc(documentId).update({'chatLastMessage': lastMessage});
  }
}
