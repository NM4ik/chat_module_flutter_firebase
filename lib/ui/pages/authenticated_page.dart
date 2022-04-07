import 'dart:async';

import 'package:chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:chat_flutter/constants.dart';
import 'package:chat_flutter/data/database/auth/android_auth_provider.dart';
import 'package:chat_flutter/data/database/auth/auth_provider.dart';
import 'package:chat_flutter/ui/components/primary_button.dart';
import 'package:chat_flutter/ui/pages/chats_page.dart';
import 'package:chat_flutter/ui/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticatedPage extends StatefulWidget {
  const AuthenticatedPage({Key? key}) : super(key: key);

  @override
  State<AuthenticatedPage> createState() => _AuthenticatedPageState();
}

class _AuthenticatedPageState extends State<AuthenticatedPage> {
  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Uninitialized) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SplashPage()),
                );
              } else if (state is Authenticated) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ChatsPage(
                          user: state.user,
                        )));
              }
            },
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
                  color: const Color(0xFFAC83F0),
                  text: 'Login with Google',
                  press: () {
                    authBloc.add(AuthenticationLoggedIn());
                  },
                ),
                const SizedBox(
                  height: kDefaultPadding * 1.5,
                ),
                // PrimaryButton(
                //   color: const Color(0xFFB36AE8),
                //   text: 'Sign Up',
                //   press: () async {
                //     final creds =
                //         await AndroidAuthProvider().singInWithGoogle();
                //     print(creds.user?.displayName);
                //   },
                // ),
                const Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
