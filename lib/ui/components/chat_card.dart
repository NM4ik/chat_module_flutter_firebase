import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_flutter/constants.dart';
import 'package:chat_flutter/data/entity/chat_room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/conversation_page.dart';

class ChatCard extends StatelessWidget {
  ChatRoom chatRoom;
  final UserCredential user;

  ChatCard({Key? key, required this.chatRoom, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(chatRoom.chatRoomId.toString());

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationPage(
                      chatRoomID: chatRoom.chatRoomId.toString(),
                      user: user,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.5),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: const Color(0xFFAC83F0), width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10000.0),
                    child: CachedNetworkImage(
                      width: 50,
                      height: 50,
                      imageUrl: chatRoom.chatIcon.toString(),
                      // 'https://sun9-47.userapi.com/impf/c852128/v852128674/193b6e/Uy7BDEgRaLE.jpg?size=2048x1999&quality=96&sign=0c1a3a26d3bf367aa97ed347a0b816d6&type=album',
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chatRoom.name,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, fontFamily: 'SF'),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Opacity(
                          opacity: 0.64,
                          child: chatRoom.chatLastMessage == null
                              ? Text(
                                  '${chatRoom.chatLastMessage}',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'SF'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : const Text("no messages")),
                    ],
                  ),
                )),
                Opacity(
                  opacity: 0.64,
                  // child: Text('${DateTime.now().hour.toString()} hours'),
                  child: Text(
                    chatRoom.lastMessageTime.toString(),
                    style: TextStyle(fontFamily: 'SF', fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
