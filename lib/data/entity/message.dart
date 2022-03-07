import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String? message;
  final String sendBy;
  final String? sendByIcon;
  final String dateSend;

  const Message({this.message, required this.sendBy, this.sendByIcon, required this.dateSend});

  @override
  List<Object?> get props => [message, sendBy, sendByIcon, dateSend];

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(sendBy: json['sendBy'], dateSend: json['dateSend'], message: json['message'], sendByIcon: json['sendByIcon']);
  }

  Map<String, dynamic> toJson() {
    return {'sendBy': sendBy, 'dateSend': dateSend, 'message': message, 'sendByIcon': sendByIcon};
  }
}
