part of 'conversation_bloc.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

class ConversationEmptyState extends ConversationState {}

class ConversationLoadingState extends ConversationState {
}

class ConversationLoadedState extends ConversationState {
  final List<Message> messages;

  const ConversationLoadedState({required this.messages});

  @override
  List<Object> get props => [messages];
}

class ConversationErrorState extends ConversationState {
  final String message;

  const ConversationErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
