import 'package:chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:chat_flutter/data/auth/auth_provider.dart';
import 'package:chat_flutter/data/local_data/shared_preferences.dart';
import 'package:chat_flutter/ui/pages/chats_page.dart';
import 'package:chat_flutter/ui/pages/in_or_out_page.dart';
import 'package:chat_flutter/ui/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/app_bloc_observer.dart';
import 'data/auth/android_auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAuthProvider().initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  GetFirstStatus getFirstStatus = GetFirstStatus();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                AuthBloc(androidAuthProvider: AndroidAuthProvider())
                  ..add(AppStarted())),
      ],
      child: MaterialApp(
          title: 'Flutter Chat Module',
          debugShowCheckedModeBanner: false,
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              print(state.toString());
              if (state is AppStarted) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is Authenticated) {
                return ChatsPage(displayName: state.displayName.toString(),);
              } else if (state is Unauthenticated) {
                // if (getFirstStatus.getStatusFromSharedPreferences()) {
                //   return const InOrOutPage();
                // } else {
                //   return const WelcomePage();
                // }
                return const WelcomePage();
              }
              return const Text('что-то пошло не так..');
            },
          )),
    );
  }
}
