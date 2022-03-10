import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String? message;
  final String sendBy;
  final String? authorIcon;
  final String time;
  final String email;

  const Message({this.message, required this.sendBy, this.authorIcon, required this.time, required this.email});


  @override
  List<Object?> get props => [message, sendBy, authorIcon, time, email];

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(sendBy: json['sendBy'], time: json['time'], message: json['message'], authorIcon: json['authorIcon'], email: json['email']);
  }

  Map<String, dynamic> toJson() {
    return {'sendBy': sendBy, 'time': time, 'message': message, 'authorIcon': authorIcon, 'email': email};
  }
}
