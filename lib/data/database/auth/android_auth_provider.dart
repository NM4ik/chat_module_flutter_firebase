import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_provider.dart';

class AndroidAuthProvider implements AuthProvider {
  @override
  Future<FirebaseApp> initialize() async {
    return await Firebase.initializeApp(
      name: "The Chat Module",
      options: const FirebaseOptions(
          apiKey: "AIzaSyDXikPk8qSc-NIyt1yrEx1yXlGUOmOged0",
          appId: "1:187273692521:android:c4f9a63361a2043876a9f8",
          messagingSenderId: "187273692521",
          projectId: "the-chat-module"),
    );
  }

  @override
  Future<UserCredential> singInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void signOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null;
  }

  Future<String?> getUser() async {
    return (FirebaseAuth.instance.currentUser)?.email;
  }
}
