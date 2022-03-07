import 'dart:developer';
import 'package:chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:chat_flutter/bloc/chat/chats_cubit.dart';
import 'package:chat_flutter/constants.dart';
import 'package:chat_flutter/data/entity/chat_room.dart';
import 'package:chat_flutter/ui/components/filled_outline_button.dart';
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
        print(widget.userID);
        List<ChatRoom> chats = [];

        if (state is ChatsLoadingState) {
          log('loading', name: 'state');
          return CircularProgressIndicator();
        } else if (state is ChatsLoadedState) {
          log('loaded', name: 'state');
          chats = state.chatRooms;
        } else if (state is ChatsErrorState) {
          log('error', name: 'state');
          return Text(
            state.message,
            style: const TextStyle(color: Colors.white, fontSize: 25),
          );
        } else if(state is ChatsEmptyState){
          log('empty', name: 'state');
          return const Text("You don't have active chats", style: TextStyle(fontSize: 40),);
        }

        return Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFAC83F0), Color(0xFF948CF3)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
                child: Row(
                  children: [
                    FillOutlineButton(text: "Active", press: () {}, isFilled: isFirstButton),
                    const SizedBox(
                      width: kDefaultPadding,
                    ),
                    FillOutlineButton(text: "Active", press: () {}, isFilled: isSecondButton),
                  ],
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) => const ChatCard(),
            )),
          ],
        );
      },
    );
  }
}
