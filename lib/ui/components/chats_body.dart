import 'package:chat_flutter/constants.dart';
import 'package:chat_flutter/ui/components/filled_outline_button.dart';
import 'package:flutter/material.dart';

import 'chat_card.dart';

class ChatsBody extends StatefulWidget {
  const ChatsBody({Key? key}) : super(key: key);

  @override
  State<ChatsBody> createState() => _ChatsBodyState();
}

class _ChatsBodyState extends State<ChatsBody> {
  @override
  Widget build(BuildContext context) {
    bool isFirstButton = true;
    bool isSecondButton = false;

    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFAC83F0), Color(0xFF948CF3)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
            child: Row(
              children: [
                FillOutlineButton(
                    text: "Recent Message",
                    press: () {},
                    isFilled: isFirstButton),
                const SizedBox(
                  width: kDefaultPadding,
                ),
                FillOutlineButton(
                    text: "Active", press: () {}, isFilled: isSecondButton)
              ],
            ),
          ),
        ),
        Expanded(
            child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) => ChatCard(),
        )),
      ],
    );
  }

}