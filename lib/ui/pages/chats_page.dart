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
  final chatNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Chats",
            style: TextStyle(fontFamily: 'SF', fontWeight: FontWeight.w600, fontSize: 24),
          ),
          actions: [
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Unauthenticated) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Logged Out: ${user.user!.email}'), backgroundColor: const Color(0xFFAC83F0)));
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthenticatedPage()));
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const AuthenticatedPage()), (route) => false);
                }
              },
              builder: (context, state) {
                log('${state.runtimeType}', name: 'state type');
                return Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          // var t = await fireStoreMethods.rooms.where('chatRoomId',  isEqualTo: 'new chat57039').get();
                          // print(t.docs.map((e) => e.data()));
                          ///поиск чата, сделать вход по id
                        },
                        icon: const Icon(Icons.search)),
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
        body: ChatsBody(
          user: user,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openDialog(context);
          },
          backgroundColor: const Color(0xFFAC83F0),
          elevation: 3,
          child: const Icon(Icons.group_add_sharp),
        ),
      ),
    );
  }

  void openDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: TextField(
              controller: chatNameController,
              decoration: const InputDecoration(
                hintText: 'name',
                labelText: 'chat-name',
              ),
              // onSubmitted: (text) {
              // },
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    chatNameController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(fontFamily: 'SF', fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF948CF3)),
                  )),
              TextButton(
                  onPressed: () {
                    try {
                      fireStoreMethods.createChatRoom(chatNameController.text, user.user!.uid);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Room: ${chatNameController.text} was created'), backgroundColor: const Color(0xFFAC83F0)));
                    } catch (_) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Room: ${chatNameController.text} wasn't created"), backgroundColor: Colors.red));
                    }

                    chatNameController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'CREATE',
                    style: TextStyle(fontFamily: 'SF', fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF948CF3)),
                  )),
            ],
          ));
}
