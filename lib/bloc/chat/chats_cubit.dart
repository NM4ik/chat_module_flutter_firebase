import 'package:bloc/bloc.dart';
import 'package:chat_flutter/data/database/firestore/firestore_methods.dart';
import 'package:chat_flutter/data/entity/chat_room.dart';
import 'package:equatable/equatable.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final FireStoreMethods fireStoreMethods;

  ChatsCubit(this.fireStoreMethods) : super(ChatsEmptyState());

  void loadChats(String userID) async {
    try {
      emit(ChatsLoadingState());
      final chatsRooms = await fireStoreMethods.getRoomsByUser(userID);
      print(chatsRooms.length);
      if (chatsRooms.isEmpty) {
        emit(ChatsEmptyState());
      }else if (chatsRooms.isNotEmpty) {
        emit(ChatsLoadedState(chatsRooms));
      }
    } catch (e) {
      emit(ChatsErrorState(e.toString()));
    }
  }
}
