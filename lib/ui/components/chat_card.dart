import 'package:chat_flutter/constants.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            const CircleAvatar(
              // backgroundImage: ,
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Test Chat", style: TextStyle(fontSize: 15,  fontWeight: FontWeight.w500),),
                  SizedBox(height: 8,),
                  Opacity(opacity: 0.64 ,child: Text("Do u have update....Do u have update....Do u", style: TextStyle(fontSize: 12,), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                ],
              ),
            )),

            Opacity(
              opacity: 0.64,
              child: Text(
                '${DateTime.now().hour.toString()} hours'),
            ),
          ],
        ),
      ),
    );
  }
}
