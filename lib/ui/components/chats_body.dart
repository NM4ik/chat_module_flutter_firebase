import 'dart:developer';
import 'package:chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:chat_flutter/bloc/chat/chats_cubit.dart';
import 'package:chat_flutter/constants.dart';
import 'package:chat_flutter/data/entity/chat_room.dart';
import 'package:chat_flutter/ui/components/filled_outline_button.dart';
import 'package:chat_flutter/ui/widgets/chats_body_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_card.dart';

class ChatsBody extends StatefulWidget {
  const ChatsBody({Key? key, required this.userID}) : super(key: key);
  final String userID;

  @override
  State<ChatsBody> createState() => _ChatsBodyState();
}

class _ChatsBodyState extends State<ChatsBody> {
  @override
  Widget build(BuildContext context) {
    bool isFirstButton = true;
    bool isSecondButton = false;
    context.read<ChatsCubit>().loadChats(widget.userID);

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
          return const ChatsBodyHeaderWidget(
            text: "You don't have active chats",
          );
        }

        /// need implement streamBuilder.

        return Column(
          children: [
            const ChatsBodyHeaderWidget(),
            StreamBuilder<List<ChatRoom>>(
                stream: context.read<ChatsCubit>().getStreamChats(widget.userID),
                builder: (context, snapshot) {
                  return Expanded(
                      child: ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) => ChatCard(
                      chatRoom: chats[index],
                    ),
                  ));
                }),
          ],
        );
      },
    );
  }
}
