import 'package:chat_flutter/constants.dart';
import 'package:chat_flutter/ui/pages/authenticated_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2,),
            Image.asset("assets/images/hey-chat-illustration_4x.jpg"),
            const Spacer(flex: 3,),
            Text(
              "Welcome to our freedom \nmessaging app",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Text(
              "Send free messages \nConnect your friends \nMake Group Chat",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 3,),
            FittedBox(
              child: TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthenticatedPage())), child: Row(children: [
                Text("Skip", style: Theme
                    .of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 18),),
                const SizedBox(width: kDefaultPadding,),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey,),
              ],),
              ),
            ),
            const SizedBox(height: kDefaultPadding,)
          ],
        ),
      ),
    );
  }
}
