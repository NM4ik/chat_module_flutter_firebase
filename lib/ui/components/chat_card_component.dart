import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_flutter/bloc/conversation/conversation_bloc.dart';
import 'package:chat_flutter/constants.dart';
import 'package:chat_flutter/data/entity/chat_room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/conversation_page.dart';

class ChatCardComponent extends StatefulWidget {
  final ChatRoom chatRoom;
  final UserCredential user;

  const ChatCardComponent({Key? key, required this.chatRoom, required this.user}) : super(key: key);

  @override
  State<ChatCardComponent> createState() => _ChatCardComponentState();
}

class _ChatCardComponentState extends State<ChatCardComponent> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(widget.chatRoom.chatRoomId.toString());

        context.read<ConversationBloc>().add(ConversationCloseEvent());
        setState(() {});

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationPage(
                      chatRoomID: widget.chatRoom.chatRoomId.toString(),
                      user: widget.user,
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
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      imageUrl: widget.chatRoom.chatIcon.toString(),
                      // 'https://sun9-47.userapi.com/impf/c852128/v852128674/193b6e/Uy7BDEgRaLE.jpg?size=2048x1999&quality=96&sign=0c1a3a26d3bf367aa97ed347a0b816d6&type=album',
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/the-chat-module.appspot.com/o/Rectangle%2014.jpg?alt=media&token=5508d866-c3c9-4b6c-9da5-73bdfcf6c06f'),
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
                        widget.chatRoom.name,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, fontFamily: 'SF'),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Opacity(
                          opacity: 0.64,
                          child: Text(
                            '${widget.chatRoom.chatLastMessage}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'SF'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ],
                  ),
                )),
                // Opacity(
                //   opacity: 0.64,
                //   // child: Text('${DateTime.now().hour.toString()} hours'),
                //   child: Text(
                //     widget.chatRoom.lastMessageTime.toString(),
                //     style: const TextStyle(fontFamily: 'SF', fontWeight: FontWeight.w500, fontSize: 15),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
