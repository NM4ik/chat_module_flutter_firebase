import 'package:equatable/equatable.dart';

class ChatRoom extends Equatable {
  final String name;
  final List<dynamic>? usersId;

  const ChatRoom({required this.name, this.usersId});

  @override
  List<Object?> get props => [name, usersId];

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(name: json['name'], usersId: json['users']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'users': usersId};
  }
}
