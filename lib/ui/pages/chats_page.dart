import 'dart:developer';

import 'package:chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:chat_flutter/ui/components/chats_body.dart';
import 'package:chat_flutter/ui/pages/authenticated_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/filled_outline_button.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key, required this.displayName}) : super(key: key);
  final String displayName;

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Chats"),
          actions: [
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  log('request test');
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     backgroundColor: Colors.green,
                  //     content: Text('Success'),
                  //   ),
                  // );
                } else if (state is Unauthenticated) {
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //     content: Text('Logged Out: $displayName'),
                  //     backgroundColor: const Color(0xFFAC83F0)));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthenticatedPage()));
                }
              },
              builder: (context, state) {
                return Row(
                  children: [
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.search)),
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
        body: ChatsBody(name: displayName),
      ),
    );
  }
}
