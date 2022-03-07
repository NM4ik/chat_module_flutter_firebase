import 'package:bloc/bloc.dart';
import 'package:chat_flutter/data/database/firestore/firestore_methods.dart';
import 'package:chat_flutter/data/entity/chat_room.dart';
import 'package:equatable/equatable.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final FireStoreMethods fireStoreMethods;

  ChatsCubit(this.fireStoreMethods) : super(ChatsEmptyState());

  Future<List<ChatRoom>> loadChats(String userID) async {
    List<ChatRoom> chatsRooms = [];
    try {
      emit(ChatsLoadingState());
      chatsRooms = await fireStoreMethods.getRoomsByUser(userID);

      if (chatsRooms.isEmpty) {
        emit(ChatsEmptyState());
      } else if (chatsRooms.isNotEmpty) {
        emit(ChatsLoadedState(chatsRooms));
        return chatsRooms;
      }
    } catch (e) {
      emit(ChatsErrorState(e.toString()));
    }
    return chatsRooms;
  }

  Stream<List<ChatRoom>> getStreamChats(String userID) => Stream.periodic(const Duration(seconds: 3)).asyncMap((_) => updateChats(userID));

  updateChats(String userID) async {
    try {
      final chatsRooms = await fireStoreMethods.getRoomsByUser(userID);
      if (chatsRooms.isEmpty) {
        emit(ChatsEmptyState());
      } else if (chatsRooms.isNotEmpty) {
        emit(ChatsLoadedState(chatsRooms));
        return chatsRooms;
      }
    } catch (e) {
      emit(ChatsErrorState(e.toString()));
    }
  }
}
