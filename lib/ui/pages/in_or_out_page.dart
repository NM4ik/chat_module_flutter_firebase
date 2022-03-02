import 'dart:async';

import 'package:chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:chat_flutter/constants.dart';
import 'package:chat_flutter/data/auth/android_auth_provider.dart';
import 'package:chat_flutter/data/auth/auth_provider.dart';
import 'package:chat_flutter/ui/components/primary_button.dart';
import 'package:chat_flutter/ui/pages/chats_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InOrOutPage extends StatefulWidget {
  const InOrOutPage({Key? key}) : super(key: key);

  @override
  State<InOrOutPage> createState() => _InOrOutPageState();
}

class _InOrOutPageState extends State<InOrOutPage> {

  bool _signedIn = false;

  // void _signIn() async {
  //   try {
  //     final creds = await AndroidAuthProvider().singInWithGoogle();
  //     print('USER : !!! ${creds.user}');
  //     setState(() {
  //       _signedIn = true;
  //     });
  //   } catch (e) {
  //     print('Login failed: $e');
  //   }
  //
  // }

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              const Spacer(
                flex: 2,
              ),
              Image.asset(
                "assets/icons/chat-logo.png",
                width: 146,
                fit: BoxFit.contain,
              ),
              const Spacer(),
              PrimaryButton(
                color: const Color(0xFF6485E6),
                text: 'Login with Google',
                press: () {
                  authBloc.add(AppStarted());
                  // _signIn();
                  const Duration(seconds: 2);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatsPage()));
                },
              ),
              const SizedBox(
                height: kDefaultPadding * 1.5,
              ),
              PrimaryButton(
                color: const Color(0xFFB36AE8),
                text: 'Sign Up',
                press: () {},
              ),
              const Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
