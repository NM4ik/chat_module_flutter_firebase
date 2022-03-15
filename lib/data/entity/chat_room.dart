import 'package:equatable/equatable.dart';


/// lastMessage time change to TimeStamp in ChatRoom and FireStore.ChatRoom.

class ChatRoom extends Equatable {
  final String? chatRoomId;
  final String name;
  final List<dynamic>? usersId;
  final String? chatIcon;
  final String? chatLastMessage;
  final String? lastMessageTime;

  const ChatRoom({required this.name, this.usersId, this.chatIcon, this.chatLastMessage, this.lastMessageTime, required this.chatRoomId});

  @override
  List<Object?> get props => [name, usersId, chatIcon, chatLastMessage, lastMessageTime];

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
        chatRoomId: json['chatRoomId'],
        name: json['name'],
        usersId: json['users'],
        chatIcon: json['chatIcon'],
        chatLastMessage: json['chatLastMessage'],
        lastMessageTime: json['lastMessageTime'].toString());
  }



  Map<String, dynamic> toJson() {
    return {'name': name, 'users': usersId, 'chatIcon': chatIcon, 'chatLastMessage': chatLastMessage, 'lastMessageTime': lastMessageTime, 'chatRoomId': chatRoomId};
  }
}
