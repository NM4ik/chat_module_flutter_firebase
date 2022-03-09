import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_flutter/data/database/firestore/firestore_methods.dart';
import 'package:chat_flutter/ui/pages/chats_page.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatelessWidget {
  ConversationPage({Key? key}) : super(key: key);
  FireStoreMethods fireStoreMethods = FireStoreMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFAC83F0), Color(0xFF948CF3)],
            ),
          ),
        ),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10000.0),
              child: CachedNetworkImage(
                width: 40,
                height: 40,
                // imageUrl: chatRoom.chatIcon.toString(),
                imageUrl:
                    'https://sun9-47.userapi.com/impf/c852128/v852128674/193b6e/Uy7BDEgRaLE.jpg?size=2048x1999&quality=96&sign=0c1a3a26d3bf367aa97ed347a0b816d6&type=album',
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            const Text(
              'chat-name',
              style: TextStyle(fontSize: 24, fontFamily: 'SF', fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(width: 2, color: Colors.blueAccent),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const TextField(
                        // controller: messageEditingController,
                        style: TextStyle(color: Colors.grey),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(onPressed: () async{
                    print('MESSAGES');
                    print(await fireStoreMethods.getConversationMessages('OQewp4DKL2q6x9EqJPLV'));
                  }, icon: const Icon(Icons.send)),
                ],
              ),
            ),


            Container(

             ),
          ],
        ),
      ),
    );
  }
}
