import 'dart:developer';

import 'package:chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:chat_flutter/data/database/firestore/firestore_methods.dart';
import 'package:chat_flutter/ui/components/chats_body.dart';
import 'package:chat_flutter/ui/pages/authenticated_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsPage extends StatelessWidget {
  ChatsPage({Key? key, required this.user}) : super(key: key);
  final UserCredential user;
  FireStoreMethods fireStoreMethods = FireStoreMethods();

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Chats", style: TextStyle(fontFamily: 'SF', fontWeight: FontWeight.w600, fontSize: 24),),
          actions: [
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Unauthenticated) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Logged Out: ${user.user!.email}'), backgroundColor: const Color(0xFFAC83F0)));
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthenticatedPage()));
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const AuthenticatedPage()), (route) => false);
                }

                /**
                 *  fix this.
                 *  when the state is authenticated this condition isn't triggered
                 *
                 *  if (state is Authenticated) {
                    log('request test');
                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('Success'),
                    ),
                    );
                    }
                 */
              },
              builder: (context, state) {
                log('${state.runtimeType}', name: 'state type');
                return Row(
                  children: [
                    IconButton(onPressed: () async {
                      // fireStoreMethods.getRoomsByUser();
                    }, icon: const Icon(Icons.search)),
                    IconButton(
                        onPressed: () {
                          authBloc.add(AuthenticationLoggedOut());
                        },
                        icon: const Icon(Icons.logout)),
                  ],
                );
              },
            ),
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFAC83F0), Color(0xFF948CF3)],
              ),
            ),
          ),
          elevation: 0,
        ),
        body: ChatsBody(user: user,),
      ),
    );
  }
}
