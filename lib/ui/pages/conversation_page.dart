import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_flutter/constants.dart';
import 'package:chat_flutter/data/database/firestore/firestore_methods.dart';
import 'package:chat_flutter/data/entity/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../bloc/conversation/conversation_bloc.dart';
import '../../data/database/firestore/firestore_storage_image_download.dart';
import '../../data/entity/chat_room.dart';
import '../components/text_field_component.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key? key, required this.chatRoom, required this.user}) : super(key: key);
  final ChatRoom chatRoom;
  final UserCredential user;

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  FireStoreMethods fireStoreMethods = FireStoreMethods();
  FireStorageDownloadImage uploadImage = FireStorageDownloadImage();
  TextEditingController messageController = TextEditingController();
  late File? newImage;
  var messagesIndex = 0;

  @override
  Widget build(BuildContext context) {
    context.read<ConversationBloc>().add(ConversationLoadingEvent(chatRoomID: widget.chatRoom.chatRoomId.toString()));
    FireStoreMethods fireStoreMethods = FireStoreMethods();
    List<Message> messages = [];

    final itemScrollController = ItemScrollController();
    // void scrollIndex(int index) => itemScrollController.scrollTo(index: index, duration: const Duration(milliseconds: 300));

    return BlocBuilder<ConversationBloc, ConversationState>(
      builder: (context, state) {
        if (state is ConversationEmptyState) {
          fireStoreMethods.sendMessageFromChatApp('${widget.user.user!.displayName} created the chat',  widget.chatRoom.chatRoomId.toString());
        }
        if (state is ConversationLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ConversationErrorState) {
          print(state.message);
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load messages, try again....'),
                  SizedBox(
                    width: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 50,
                          )),
                      SizedBox(
                        width: 30,
                      ),
                      IconButton(
                          onPressed: () => context.read<ConversationBloc>().add(ConversationLoadingEvent(chatRoomID: widget.chatRoom.chatRoomId.toString())),
                          icon: const Icon(
                            Icons.update,
                            size: 50,
                          )),
                    ],
                  )
                ],
              ),
            ),
          );
        }
        if (state is ConversationLoadedState) {
          messages = state.messages;
          messagesIndex = messages.length - 1;
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                context.read<ConversationBloc>().add(ConversationCloseEvent());
                Navigator.pop(context);
              }, // emit(ConversationLoadingState());
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10000.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                    imageUrl: widget.chatRoom.chatIcon.toString(),
                    // imageUrl:
                    //     'https://firebasestorage.googleapis.com/v0/b/the-chat-module.appspot.com/o/Rectangle%2014.jpg?alt=media&token=5508d866-c3c9-4b6c-9da5-73bdfcf6c06f',
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    widget.chatRoom.name,
                    style: TextStyle(fontSize: 24, fontFamily: 'SF', fontWeight: FontWeight.w500),
                  ),
                ),
                PopupMenuButton(
                    itemBuilder: (context) => [
                          PopupMenuItem(child: Text('id for join: ${widget.chatRoom.chatRoomId}')),
                          PopupMenuItem(
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.update,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('change icon'),
                                ],
                              ),
                              onTap: () async {
                                newImage = await uploadImage.selectFile();

                                var destination = '';
                                try {
                                  destination = await uploadImage.uploadFile(newImage!);
                                } catch (_) {
                                  destination = 'https://siamturakij.com/assets/uploads/img_news/no-images.jpg';
                                }

                                fireStoreMethods.rooms.doc(widget.chatRoom.chatRoomId).update({'chatIcon': destination});

                                Navigator.of(context).pop();
                              }),

                      PopupMenuItem(
                          child: Row(
                            children: const [
                              Icon(
                                Icons.logout,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text('leave the chat room'),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            fireStoreMethods.leaveFromChatRoom(widget.chatRoom.chatRoomId.toString(), widget.user.user!.uid, widget.user.user!.displayName.toString());
                          }),

                          PopupMenuItem(
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('delete chat'),
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                fireStoreMethods.rooms.doc(widget.chatRoom.chatRoomId).delete();
                              }),
                        ]),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<Message>>(
                  stream: context.read<ConversationBloc>().getUpdateMessages(widget.chatRoom.chatRoomId.toString()),
                  builder: (context, snapshot) {
                    return ScrollablePositionedList.builder(
                    initialScrollIndex: messagesIndex,
                    itemScrollController: itemScrollController,
                    // return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: messages.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Bubble(
                          style: widget.user.user!.email == messages[index].email ? styleMe : styleSomebody,
                          child: Text(
                            messages[index].message.toString(),
                            style: TextStyle(color: widget.user.user!.email == messages[index].email ? Colors.white : Color(0xFFAC83F0),)
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// СООБЩЕНИЯ
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFF948CF3),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 50,
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: TextFieldComponent(
                            messageController: messageController,
                            chatRoomID: widget.chatRoom.chatRoomId.toString(),
                            userCredential: widget.user,
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    child: IconButton(
                        onPressed: () {
                          Message message = Message(
                              sendBy: widget.user.user!.displayName.toString(),
                              time: DateTime.now().millisecondsSinceEpoch.toString(),
                              email: widget.user.user!.email.toString(),
                              message: messageController.text,
                              authorIcon: '');

                          fireStoreMethods.sendMessage(message.toJson(), widget.chatRoom.chatRoomId.toString());


                          FocusManager.instance.primaryFocus?.unfocus();
                          messageController.clear();
                        },
                        icon: const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                        )),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: const LinearGradient(colors: kDefaultGradient),
                    ),
                  )
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
