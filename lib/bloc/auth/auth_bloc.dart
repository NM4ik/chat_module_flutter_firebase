import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_flutter/data/auth/android_auth_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../ui/pages/in_or_out_page.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AndroidAuthProvider androidAuthProvider;

  AuthBloc({required this.androidAuthProvider}) : super(Uninitialized()) {
    on<AuthEvent>((event, emit) async {
      // if (event is AppStarted) {
      //   _appStarterToState(emit);
      // } else if (event is LoggedIn) {
      //   _appLoggedInToState(emit);
      // } else if (event is LoggedIn) {
      //   _appLoggedOutToState(emit);
      // }

      if (event is AppStarted) {
        emit(Uninitialized());

        final isSignedIn = await androidAuthProvider.isSignedIn();
        print(isSignedIn);
        if (isSignedIn) {
          final name = await androidAuthProvider.getUser();
          emit(Authenticated(name!));
        } else {
          emit(Unauthenticated());
        }
      }

      if (event is LoggedOut) {
        emit(Unauthenticated());
        androidAuthProvider.signOut();

        // MaterialPageRoute(builder: (BuildContext context) {
        //   return const InOrOutPage();
        // });
      }

      if (event is LoggedIn) {
        try {
          final credentials = await AndroidAuthProvider().singInWithGoogle();
          print('USER : !!! ${credentials.user}');
          emit(Authenticated(credentials.user?.displayName));
        } catch (_) {
          emit(Unauthenticated());
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
