import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:chat_flutter/bloc/chat/chats_cubit.dart';
import 'package:chat_flutter/constants.dart';
import 'package:chat_flutter/data/database/auth/android_auth_provider.dart';
import 'package:chat_flutter/data/database/firestore/firestore_methods.dart';
import 'package:chat_flutter/data/entity/message.dart';
import 'package:chat_flutter/ui/pages/chats_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../bloc/conversation/conversation_bloc.dart';
import '../components/text_field_component.dart';

class ConversationPage extends StatelessWidget {
  ConversationPage({Key? key, required this.chatRoomID, required this.user}) : super(key: key);
  FireStoreMethods fireStoreMethods = FireStoreMethods();
  final String chatRoomID;
  final UserCredential user;

  @override
  Widget build(BuildContext context) {
    context.read<ConversationBloc>().add(ConversationLoadingEvent(chatRoomID: chatRoomID));
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

          fireStoreMethods.sendMessage(message.toJson(), chatRoomID);
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
                  onPressed: () => context.read<ConversationBloc>().add(ConversationLoadingEvent(chatRoomID: chatRoomID)),
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
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<Message>>(
                  stream: context.read<ConversationBloc>().getUpdateMessages(chatRoomID),
                  builder: (context, snapshot) {
                    return ScrollablePositionedList.builder(
                      initialScrollIndex: messages.length,
                      itemScrollController: itemScrollController,
                      shrinkWrap: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: user.user!.email == messages[index].email ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: (user.user!.email == messages[index].email)
                                    ? kDefaultGradient
                                    : [Colors.white, Colors.white],
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
                              child: Text(messages[index].message.toString()),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ), /// СООБЩЕНИЯ
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFieldComponent(chatRoomID: chatRoomID),
                  ),
                ),
              ),  /// TEXTFIELD
            ],
          ),
        );
      },
    );
  }
}
