import 'dart:developer';
import 'dart:io';

import 'package:chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:chat_flutter/data/database/firestore/firestore_methods.dart';
import 'package:chat_flutter/ui/components/chats_body_component.dart';
import 'package:chat_flutter/ui/pages/authenticated_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import '../../data/database/firestore/firestore_storage_image_download.dart';
import 'conversation_page.dart';

class ChatsPage extends StatefulWidget {
  ChatsPage({Key? key, required this.user}) : super(key: key);
  final UserCredential user;

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late File? newImage;

  FireStoreMethods fireStoreMethods = FireStoreMethods();

  FireStorageDownloadImage uploadImage = FireStorageDownloadImage();

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
                      .showSnackBar(SnackBar(content: Text('Logged Out: ${widget.user.user!.email}'), backgroundColor: const Color(0xFFAC83F0)));
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
        body: ChatsBodyComponent(
          user: widget.user,
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'joinBtn',
              onPressed: () {
                openDialogJoinChat(context);
              },
              backgroundColor: const Color(0xFFAC83F0),
              elevation: 3,
              child: const Icon(Icons.message_rounded),
            ),
            const SizedBox(
              width: kDefaultPadding,
            ),
            FloatingActionButton(
              heroTag: 'createBtn',
              onPressed: () {
                openDialogCreateChat(context);
              },
              backgroundColor: const Color(0xFFAC83F0),
              elevation: 3,
              child: const Icon(Icons.group_add_sharp),
            ),
          ],
        ),
      ),
    );
  }

  void openDialogCreateChat(BuildContext context) {
    var fileName = '';

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: chatNameController,
                    decoration: const InputDecoration(
                      hintText: 'name',
                      labelText: 'chat-name',
                    ),
                    // onSubmitted: (text) {
                    // },
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        newImage = await uploadImage.selectFile();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Image Added')),
                        );
                      },
                      child: const Text('upload image for chat')),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        newImage = null;
                      });
                      chatNameController.clear();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(fontFamily: 'SF', fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF948CF3)),
                    )),
                TextButton(
                    onPressed: () async {
                      try {
                        var destination = '';
                        try {
                          destination = await uploadImage.uploadFile(newImage!);
                        } catch (_) {
                          destination = 'https://siamturakij.com/assets/uploads/img_news/no-images.jpg';
                        }
                        fireStoreMethods.createChatRoom(chatNameController.text, widget.user.user!.uid, destination);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Room: ${chatNameController.text} was created'), backgroundColor: const Color(0xFFAC83F0)));
                        //
                        // chatNameController.clear();
                        // Navigator.of(context).pop();
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

  void openDialogJoinChat(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: TextField(
              controller: chatNameController,
              decoration: const InputDecoration(
                hintText: 'insert chat name to join',
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
                      fireStoreMethods.joinChatRoom(chatNameController.text, widget.user.user!.uid);
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
                    'JOIN',
                    style: TextStyle(fontFamily: 'SF', fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF948CF3)),
                  )),
            ],
          ));
}
