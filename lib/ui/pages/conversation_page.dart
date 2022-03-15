import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_flutter/constants.dart';
import 'package:chat_flutter/data/database/firestore/firestore_methods.dart';
import 'package:chat_flutter/data/entity/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../bloc/conversation/conversation_bloc.dart';
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
          Message message = Message(
            sendBy: 'chatApp',
            time: DateTime.now().millisecondsSinceEpoch.toString(),
            email: 'chatApp',
            message: "You're don't have any messages yet",
            authorIcon: '',
          );

          fireStoreMethods.sendMessage(message.toJson(), widget.chatRoom.chatRoomId.toString());
        }
        if (state is ConversationLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ConversationErrorState) {
          return Column(
            children: [
              const Text('НЕ УДАЛОСЬ ЗАГРУЗИТЬ СООБЩЕНИЯ, ПОФИКСИ ИНЕТ МРАЗЬ'),
              IconButton(
                  onPressed: () => context.read<ConversationBloc>().add(ConversationLoadingEvent(chatRoomID: widget.chatRoom.chatRoomId.toString())),
                  icon: const Icon(
                    Icons.update,
                    size: 50,
                  )),
            ],
          );
        }
        if (state is ConversationLoadedState) {
          messages = state.messages;

          final int index = messages.length;
          // WidgetsBinding.instance!.addPostFrameCallback((_) => scrollIndex(index));
          // scrollIndex(5);

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
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10000.0),
                  child: CachedNetworkImage(
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
                Text(
                  widget.chatRoom.name,
                  style: TextStyle(fontSize: 24, fontFamily: 'SF', fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<Message>>(
                  stream: context.read<ConversationBloc>().getUpdateMessages(widget.chatRoom.chatRoomId.toString()),
                  builder: (context, snapshot) {
                    // return ScrollablePositionedList.builder(
                    // initialScrollIndex: messages.length - 1,
                    // itemScrollController: itemScrollController,
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: messages.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: widget.user.user!.email == messages[index].email ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 250, minWidth: 70),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: (widget.user.user!.email == messages[index].email) ? kDefaultGradient : [Colors.white, Colors.white],
                              ),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(1, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(messages[index].email, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'SF'),),
                                  Text(messages[index].message.toString()),
                                ],
                              ),
                            ),
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
                          // log(widget.chatRoomID, name: "CHATROOMID: ");
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
