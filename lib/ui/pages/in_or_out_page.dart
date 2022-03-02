import 'package:chat_flutter/constants.dart';
import 'package:chat_flutter/ui/components/primary_button.dart';
import 'package:chat_flutter/ui/pages/chats_page.dart';
import 'package:flutter/material.dart';

class InOrOutPage extends StatelessWidget {
  const InOrOutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              const Spacer(flex: 2,),
              Image.asset("assets/icons/chat-logo.png", width: 146, fit: BoxFit.contain,),
              const Spacer(),
              PrimaryButton(color: const Color(0xFF6485E6), text: 'Login', press: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ChatsPage()));},),
              const SizedBox(height: kDefaultPadding*1.5,),
              PrimaryButton(color: const Color(0xFFB36AE8),text: 'Sign Up', press: () {},),
              const Spacer(flex: 2,),
            ],
          ),
        ),
      ),
    );
  }
}
