import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_flutter/bloc/chat/chats_cubit.dart';
import 'package:chat_flutter/data/database/firestore/firestore_methods.dart';
import 'package:chat_flutter/data/entity/message.dart';
import 'package:equatable/equatable.dart';

part 'conversation_event.dart';

part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final FireStoreMethods fireStoreMethods = FireStoreMethods();

  ConversationBloc() : super(ConversationLoadingState()) {
    on<ConversationLoadingEvent>(_onEventStarted);
    on<ConversationCloseEvent>(_onEventClosed);
  }

  Future<void> _onEventStarted(ConversationLoadingEvent event, Emitter<ConversationState> emit) async {
    // emit(ConversationLoadingState());
    List<Message> messages = [];

    try {
      messages = await fireStoreMethods.getConversationMessages(event.chatRoomID);
      if (messages.isEmpty) {
        emit(ConversationEmptyState());
      } else if (messages.isNotEmpty) {
        emit(ConversationLoadedState(messages: messages));
      }
    } catch (e) {
      emit(ConversationErrorState(message: e.toString()));
    }
  }

  Stream<List<Message>> getUpdateMessages(String chatRoomID) => Stream.periodic(const Duration(seconds: 1)).asyncMap((_) => updateMessages(chatRoomID));

  updateMessages(String chatRoomID) async {
    try {
      final List<Message> messages = await fireStoreMethods.getConversationMessages(chatRoomID);
      if (messages.isEmpty) {
        emit(ConversationEmptyState());
      } else if (messages.isNotEmpty) {
        emit(ConversationLoadedState(messages: messages));
        return messages;
      }
    } catch (e) {
      emit(ConversationErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onEventClosed(ConversationCloseEvent event, Emitter<ConversationState> emit) {
    emit(ConversationLoadingState());
  }
}
