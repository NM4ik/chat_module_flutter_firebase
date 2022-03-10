import 'package:chat_flutter/data/database/firestore/firestore_methods.dart';
import 'package:flutter/material.dart';

import '../../data/entity/message.dart';

class TextFieldComponent extends StatelessWidget {
  TextFieldComponent({Key? key, required this.chatRoomID}) : super(key: key);
  TextEditingController messageController = TextEditingController();
  FireStoreMethods fireStoreMethods = FireStoreMethods();
  final String chatRoomID;

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
            email: 'nikitka32171@gmail.com',
            message: messageController.text,
            authorIcon: '');

        fireStoreMethods.sendMessage(message.toJson(), chatRoomID);

        // Future.delayed(const Duration(milliseconds: 2000), () {
        //   scrollIndex(messages.length);
        // }); HOW TO KEEP POSITION OF MESSAGES?
        messageController.clear();
      },
      // onSubmitted: {},
    );
  }
}
