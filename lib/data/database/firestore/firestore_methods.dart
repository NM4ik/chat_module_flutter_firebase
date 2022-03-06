import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreMethods {
  // CollectionReference rooms = FirebaseFirestore.instance.collection('chatRooms').doc('OQewp4DKL2q6x9EqJPLV').collection('messages');
  CollectionReference rooms = FirebaseFirestore.instance.collection('chatRooms');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  void getRooms() async {
    // var data = {
    //   'message': 'lalala',
    //   'sendBy': 'test'
    // };
    //
    // rooms.add(data);
    // print(rooms.docs.map((e) => e.data()).toList());

    var q = await rooms.get(); //получение документов всех чатов
    print(q.docs.map((e) => e.data()).toList()); // отображение информации о чате - название, пользователи


    var m = await rooms.doc('OQewp4DKL2q6x9EqJPLV').collection('messages').get(); // получени всех документов соообщений
    print(m.docs.map((e) => e.data()).toList()); // получение данных в документах, т.е сообщений.

    // print(await rooms.where("name" == "testRoom").get());
  }

//
// Future<List<dynamic>> getChatsForUser(String uid){
//   var chats = rooms.where("users".contains(uid));
//   return chats;
//
// }

}
