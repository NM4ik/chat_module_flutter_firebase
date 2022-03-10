import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_flutter/data/database/auth/android_auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../ui/pages/authenticated_page.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AndroidAuthProvider androidAuthProvider;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  AuthBloc({required this.androidAuthProvider}) : super(Uninitialized()) {
    on<AuthenticatedStarted>(_onAuthStarted);
    on<AuthenticationLoggedIn>(_onAuthLoggedIn);
    on<AuthenticationLoggedOut>(_onAuthLoggedOut);
  }

  Future<void> _onAuthStarted(AuthenticatedStarted event, Emitter<AuthState> emit) async {
    emit(Uninitialized());
    bool isSignedIn;
    try {
      isSignedIn = await androidAuthProvider.isSignedIn();
    } catch (e) {
      isSignedIn = false;
      log(e.toString(), name: '_onAuthStarted ERROR');
    }
    log('Signed or not:  ${isSignedIn.toString()}');
    if (isSignedIn) {
      final user = await _getUserCredentials();
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  FutureOr<void> _onAuthLoggedIn(AuthenticationLoggedIn event, Emitter<AuthState> emit) async {
    try {
      emit(Uninitialized());
      final user = await _getUserCredentials();

      _addUserToCollection(user.user);
      emit(Authenticated(user));
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  FutureOr<void> _onAuthLoggedOut(AuthenticationLoggedOut event, Emitter<AuthState> emit) async {
    emit(Unauthenticated());
    androidAuthProvider.signOut();
  }

  void _addUserToCollection(User? user) async {
    try {
      final dataExists = await users.doc(user!.uid).get();

      if (dataExists.exists) {
        log('user already added', name: "UserToFireBase");
        return null;
      } else {
        users.doc(user.uid).set({
          "email": user.email,
          "name": user.displayName,
          "phone": user.phoneNumber,
        });
        log('user was added', name: "UserToFireBase");
      }
    } catch (e) {
      print('Error from _addUserToCollection - $e');
    }
  }

  Future<UserCredential> _getUserCredentials() async {
    final credentials = await AndroidAuthProvider().singInWithGoogle();
    return credentials;
  }
}
