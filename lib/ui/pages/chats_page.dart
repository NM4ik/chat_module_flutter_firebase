import 'package:chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:chat_flutter/ui/components/chats_body.dart';
import 'package:chat_flutter/ui/pages/in_or_out_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/filled_outline_button.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key, required this.displayName}) : super(key: key);
  final String displayName;

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();

    // return BlocBuilder(builder: (context, state){
    //
    // });

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildAppBar(authBloc),
        body: ChatsBody(name: displayName),
        // body: BlocBuilder<AuthBloc, AuthState>(
        //   builder: (context, state) {
        //     if (state is Authenticated) {
        //       return ChatsBody(name: state.displayName.toString());
        //     }
        //     if (state is Unauthenticated) {
        //       return const Text('Unauthenticated');
        //     }
        //     if (state is Uninitialized) {
        //       return const Text('Uninitialized');
        //     }
        //     return const Text('not found');
        //   },
        // ),
      ),
    );
  }

  AppBar buildAppBar(AuthBloc authBloc) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text("Chats"),
      actions: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const InOrOutPage()));
            }
          },
          child: FillOutlineButton(
              text: "LogOut",
              press: () {
                authBloc.add(LoggedOut());
                // authBloc.androidAuthProvider.signOut();
              },
              isFilled: false),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.search))
      ],
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
