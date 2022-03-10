part of 'conversation_bloc.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();
}

class ConversationLoadingEvent extends ConversationEvent {
  final String chatRoomID;

  const ConversationLoadingEvent({required this.chatRoomID});

  @override
  List<Object> get props => [chatRoomID];
}

class ConversationCloseEvent extends ConversationEvent {

  @override
  List<Object> get props => [];
}
