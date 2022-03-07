part of 'chats_cubit.dart';

abstract class ChatsState extends Equatable {
  const ChatsState();
}

class ChatsEmptyState extends ChatsState {
  @override
  List<Object> get props => [];
}


class ChatsLoadingState extends ChatsState {
  @override
  List<Object> get props => [];
}

class ChatsLoadedState extends ChatsState {
  final List<ChatRoom> chatRooms;

  const ChatsLoadedState(this.chatRooms);

  @override
  List<Object> get props => [chatRooms];
}

class ChatsErrorState extends ChatsState {
  final String message;

  const ChatsErrorState(this.message);

  @override
  List<Object> get props => [message];
}