import 'package:chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:chat_flutter/ui/components/chats_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return ChatsBody(name: state.displayName.toString());
          }
          if (state is Unauthenticated) {
            return const Text('Unauthenticated');
          }
          if (state is Uninitialized) {
            return const Text('Uninitialized');
          }
          return const Text('not found');
        },
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text("Chats"),
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFAC83F0), Color(0xFF948CF3)],
          ),
        ),
      ),
      elevation: 0,
    );
  }
}
