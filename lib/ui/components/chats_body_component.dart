import 'dart:developer';
import 'package:chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:chat_flutter/bloc/chat/chats_cubit.dart';
import 'package:chat_flutter/constants.dart';
import 'package:chat_flutter/data/entity/chat_room.dart';
import 'package:chat_flutter/ui/components/filled_outline_button.dart';
import 'package:chat_flutter/ui/widgets/chats_body_header_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_card_component.dart';

class ChatsBodyComponent extends StatefulWidget {
  const ChatsBodyComponent({Key? key, required this.user}) : super(key: key);
  final UserCredential user;

  @override
  State<ChatsBodyComponent> createState() => _ChatsBodyComponentState();
}

class _ChatsBodyComponentState extends State<ChatsBodyComponent> {
  @override
  Widget build(BuildContext context) {
    bool isFirstButton = true;
    bool isSecondButton = false;
    context.read<ChatsCubit>().loadChats(widget.user.user!.uid.toString());

    return BlocBuilder<ChatsCubit, ChatsState>(
      builder: (context, state) {
        List<ChatRoom> chats = [];

        if (state is ChatsLoadingState) {
          log('loading', name: 'state');
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChatsLoadedState) {
          log('loaded', name: 'state');
          chats = state.chatRooms;
        } else if (state is ChatsErrorState) {
          log('error ${state.message}', name: 'state');
          return Text(
            state.message,
            style: const TextStyle(color: Colors.white, fontSize: 25),
          );
        } else if (state is ChatsEmptyState) {
          log('empty', name: 'state');
          // const ChatsBodyHeaderWidget(text: 'empty',);
          // return const ChatsBodyHeaderWidget(
          //   text: "You don't have active chats",
          // );
        }

        return Column(
          children: [
            const ChatsBodyHeaderWidget(),
            StreamBuilder<List<ChatRoom>>(
                stream: context.read<ChatsCubit>().getStreamChats(widget.user.user!.uid),
                builder: (context, snapshot) {
                  return Expanded(
                      child: ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) => ChatCardComponent(
                      // key: Uniq,
                      chatRoom: chats[index],
                      user: widget.user,
                    ),
                  ));
                }),
          ],
        );
      },
    );
  }
}
