import 'package:chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:chat_flutter/bloc/chat/chats_cubit.dart';
import 'package:chat_flutter/bloc/conversation/conversation_bloc.dart';
import 'package:chat_flutter/data/database/auth/auth_provider.dart';
import 'package:chat_flutter/data/database/firestore/firestore_methods.dart';
import 'package:chat_flutter/data/database/local_data/shared_preferences.dart';
import 'package:chat_flutter/ui/pages/chats_page.dart';
import 'package:chat_flutter/ui/pages/authenticated_page.dart';
import 'package:chat_flutter/ui/pages/splash_page.dart';
import 'package:chat_flutter/ui/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/app_bloc_observer.dart';
import 'data/database/auth/android_auth_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  initializeDateFormatting('ru', null);
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAuthProvider().initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  GetFirstStatus getFirstStatus = GetFirstStatus();
  FireStoreMethods fireStoreMethods = FireStoreMethods();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(androidAuthProvider: AndroidAuthProvider())..add(AuthenticatedStarted())),
        BlocProvider(create: (context) => ChatsCubit(fireStoreMethods)),
        BlocProvider(create: (context) => ConversationBloc()),
      ],
      child: MaterialApp(
          title: 'Flutter Chat Module',
          debugShowCheckedModeBanner: false,
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              print(state.toString());
              if (state is AuthenticatedStarted) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is Authenticated) {
                return ChatsPage(
                  user: state.user,
                );
              } else if (state is Unauthenticated) {
                // return const AuthenticatedPage();
                return const WelcomePage();
              } else if (state is Uninitialized) {
                return const SplashPage();
              }
              return const Text('что-то пошло не так..');
            },
          )),
    );
  }
}
