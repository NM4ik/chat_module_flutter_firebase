import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_flutter/data/auth/android_auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../ui/pages/authenticated_page.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AndroidAuthProvider androidAuthProvider;

  AuthBloc({required this.androidAuthProvider}) : super(Uninitialized()) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    on<AuthEvent>((event, emit) async {
      if (event is AuthenticatedStarted) {
        emit(Uninitialized());
        bool isSignedIn;
        try {
          isSignedIn = await androidAuthProvider.isSignedIn();
        } catch (e) {
          isSignedIn = false;
        }
        log('Signed or not:  ${isSignedIn.toString()}');
        if (isSignedIn) {
          final name = await androidAuthProvider.getUser();
          emit(Authenticated(name!));
        } else {
          emit(Unauthenticated());
        }
      } else if (event is AuthenticationLoggedOut) {
        emit(Unauthenticated());
        androidAuthProvider.signOut();
      } else if (event is AuthenticationLoggedIn) {
        try {
          emit(Uninitialized());
          final credentials = await AndroidAuthProvider().singInWithGoogle();

          // users
          //     .add({'email': credentials.user?.displayName.toString(), 'name': credentials.user?.email.toString()})
          //     .then((value) => print("User Added"))
          //     .catchError((error) => print("Failed to add user: $error"));
          // добавление пользователя.

          final data = await users.get();
          final allData = data.docs.map((e) => e.data()).toList();
          print(allData);

          log('USER : !!! ${credentials.user?.email}');
          emit(Authenticated(credentials.user?.displayName));
        } catch (_) {
          emit(Unauthenticated());
        }
      }
    });
  }
}
