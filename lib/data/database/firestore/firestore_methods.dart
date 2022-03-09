import 'dart:developer';

import 'package:chat_flutter/data/entity/chat_room.dart';
import 'package:chat_flutter/data/entity/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FireStoreMethods {
  // CollectionReference rooms = FirebaseFirestore.instance.collection('chatRooms').doc('OQewp4DKL2q6x9EqJPLV').collection('messages');
  CollectionReference rooms = FirebaseFirestore.instance.collection('chatRooms');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<List<ChatRoom>> getRoomsByUser(String userID) async {
    //var q = await rooms.get(); //получение документов всех чатов
    //print(q.docs.map((e) => e.data()).toList()); // отображение информации о чате - название, пользователи

    //var m = await rooms.doc('OQewp4DKL2q6x9EqJPLV').collection('messages').get(); // получени всех документов соообщений
    //print(m.docs.map((e) => e.data()).toList()); // получение данных в документах, т.е сообщений.
    List<ChatRoom> chatRooms = [];
    var t = await rooms.where("users", arrayContains: userID).get();

    t.docs.map((e) {
      chatRooms.add(ChatRoom.fromJson(e.data() as Map<String, dynamic>));
    }).toList();

    print(t.docs.map((e) => e.data()));

    // var q = await rooms.where("users", arrayContains: userID).get();

    // print('ID: ');
    // print(chatRooms[0].id);
    // print(q.docs.map((e) => e.id));
    //
    // print(t.docs.map((e) => e.id));

    return chatRooms;
  }
  
  Future<dynamic> getConversationMessages(String chatRoomID) async{
    var t = await rooms.doc(chatRoomID).collection('messages').get();
    return t.docs.map((e) => e.data());
  }

// Future<Stream<List<ChatRoom>>> getChatRooms(String userID) async {
//   dynamic rooms = await getRoomsByUser(userID);
//   return rooms;
// }

/**
 * Why "get" last message? i Think need when message push to messages push last message to chatRoom['lastMessage']
 */
/* Future<Message> getLastMessage(CollectionReference rooms, String roomId) async{
    var messages = await rooms.doc(roomId).collection('messages').get();
    var lastMessage = Message.fromJson(messages.docs.last as Map<String, dynamic>);
    return lastMessage;
  }*/

//
// Future<List<dynamic>> getChatsForUser(String uid){
//   var chats = rooms.where("users".contains(uid));
//   return chats;
//
// }

}
