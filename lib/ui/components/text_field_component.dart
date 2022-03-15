import 'dart:developer';

import 'package:chat_flutter/data/database/firestore/firestore_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/entity/message.dart';

class TextFieldComponent extends StatelessWidget {
  TextFieldComponent({Key? key, required this.chatRoomID, required this.userCredential}) : super(key: key);
  TextEditingController messageController = TextEditingController();
  FireStoreMethods fireStoreMethods = FireStoreMethods();
  final String chatRoomID;
  final UserCredential userCredential;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: messageController,
      decoration: const InputDecoration(hintText: 'message', border: InputBorder.none),
      maxLines: 1,
      onSubmitted: (text) {
        Message message = Message(
            sendBy: 'Nikita',
            time: DateTime.now().millisecondsSinceEpoch.toString(),
            email: '${userCredential.user!.email}',
            message: messageController.text,
            authorIcon: '');

        fireStoreMethods.sendMessage(message.toJson(), chatRoomID);
        // log(chatRoomID, name: "CHATROOMID: ");

        // Future.delayed(const Duration(milliseconds: 2000), () {
        //   scrollIndex(messages.length);
        // }); HOW TO KEEP POSITION OF MESSAGES?
        messageController.clear();
      },
      // onSubmitted: {},
    );
  }
}
