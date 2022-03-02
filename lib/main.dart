import 'package:chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:chat_flutter/data/auth/auth_provider.dart';
import 'package:chat_flutter/ui/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/app_bloc_observer.dart';
import 'data/auth/android_auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAuthProvider().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                AuthBloc(androidAuthProvider: AndroidAuthProvider())),
      ],
      child: MaterialApp(
        title: 'Flutter Chat Module',
        debugShowCheckedModeBanner: false,
        home: WelcomePage(),
      ),
    );
  }
}
