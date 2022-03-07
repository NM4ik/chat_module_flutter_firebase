import 'package:flutter/material.dart';

import '../../constants.dart';
import '../components/filled_outline_button.dart';

class ChatsBodyHeaderWidget extends StatelessWidget {
  final String? text;

  const ChatsBodyHeaderWidget({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFAC83F0), Color(0xFF948CF3)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FillOutlineButton(text: "Active", press: () {}, isFilled: true),
                const SizedBox(
                  width: kDefaultPadding,
                ),
                FillOutlineButton(text: "Active", press: () {}, isFilled: false),
              ],
            ),
            text == null ? Container() : getTextIfEmpty(),
          ],
        ),
      ),
    );
  }

  Widget getTextIfEmpty() {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Text(
          text.toString(),
          style: const TextStyle(fontSize: 24, color: Colors.white),
        )
      ],
    );
  }
}
