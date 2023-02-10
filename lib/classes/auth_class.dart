import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lesgou/widgets/common_hud.dart';

class AuthClass {
  void toastErrorUser() {
    Fluttertoast.showToast(
      msg: 'Fill the form properly',
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void toastErrorFirebase(FirebaseAuthException e) {
    Fluttertoast.showToast(
      msg: e.message.toString(),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void updateDisplayName(UserCredential userCredential, String name) async {
    if (userCredential.user != null) {
      userCredential.user?.updateDisplayName(name);
    }
  }

  void signIn(BuildContext context, UserCredential user) {
    if (user.user != null) {
      Navigator.pushNamed(context, CommonHUD.route);
    }
  }

  Future<void> signInWithGoogle(BuildContext context, FirebaseAuth auth) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final user = await auth.signInWithCredential(credential);
    if (context.mounted) {
      signIn(context, user);
    }
  }
}
