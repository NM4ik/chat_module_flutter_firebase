import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_flutter/data/auth/android_auth_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AndroidAuthProvider androidAuthProvider;

  AuthBloc({required this.androidAuthProvider}) : super(Uninitialized()) {
    on<AuthEvent>((event, emit) async{
      // if (event is AppStarted) {
      //   _appStarterToState(emit);
      // } else if (event is LoggedIn) {
      //   _appLoggedInToState(emit);
      // } else if (event is LoggedIn) {
      //   _appLoggedOutToState(emit);
      // }

      if(event is AppStarted){
        emit(Uninitialized());

        final isSignedIn = await androidAuthProvider.isSignedIn();
        if(isSignedIn){
          final name = await androidAuthProvider.getUser();
          emit(Authenticated(name!));
        }

      }


    });
  }
  //
  // _appStarterToState(emit) async {
  //   try {
  //     final isSignedIn = await androidAuthProvider.isSignedIn();
  //     if (isSignedIn) {
  //       final name = await androidAuthProvider.getUser();
  //       emit(Authenticated(name!));
  //     } else {
  //       emit(Unauthenticated());
  //     }
  //   } catch (_) {
  //     emit(Unauthenticated());
  //   }
  // }
  //
  // _appLoggedInToState(emit) async {
  //   final String? displayName = await androidAuthProvider.getUser();
  //
  //   emit(Authenticated(displayName!));
  // }
  //
  // _appLoggedOutToState(emit) async {
  //   emit(Unauthenticated());
  //   androidAuthProvider.signOut();
  // }
}
