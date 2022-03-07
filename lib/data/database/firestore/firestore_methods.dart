import 'package:chat_flutter/data/entity/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    t.docs.map((e) => chatRooms.add(ChatRoom.fromJson(e.data() as Map<String, dynamic>))).toList();
    return chatRooms;
  }

//
// Future<List<dynamic>> getChatsForUser(String uid){
//   var chats = rooms.where("users".contains(uid));
//   return chats;
//
// }

}
