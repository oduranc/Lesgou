import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:lesgou/classes/auth_class.dart';
import 'package:lesgou/util/colors.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../util/constants.dart';
import '../widgets/custom_button.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthClass _authService = AuthClass();
  bool loading = false;
  static late String email, password, name;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      progressIndicator: const CircularProgressIndicator(color: primary),
      child: Padding(
        padding: EdgeInsets.only(
            top: 33,
            left: 41,
            right: 41,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Wrap(
            runSpacing: 15,
            spacing: double.infinity,
            alignment: WrapAlignment.center,
            children: <Widget>[
              const Text('Welcome to Lesgou!', style: titleFormStyle),
              const Text('Your favorite to-do-list app',
                  style: grayDisclaimerStyle),
              SignInButton(
                Buttons.Google,
                text: 'Continue with Google',
                onPressed: () {
                  handleSignUp(_authService.signInWithGoogle(context, _auth));
                },
              ),
              Row(
                children: const <Widget>[
                  Expanded(child: Divider(endIndent: 12)),
                  Text('Or', style: grayDisclaimerStyle),
                  Expanded(child: Divider(indent: 12)),
                ],
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Name or nickname'),
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Password'),
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
              ),
              CustomButton(
                buttonStyle: loginButtonStyle,
                text: 'Sign Up',
                action: () {
                  handleSignUp(createUserWithEmailAndPassword(context));
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Have an account?', style: blackDisclaimerStyle),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Log in', style: textLinkStyle),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void handleSignUp(Future<void> action) async {
    setState(() {
      loading = true;
    });
    try {
      await action;
    } on FirebaseAuthException catch (e) {
      _authService.toastErrorFirebase(e);
    } catch (e) {
      _authService.toastErrorUser();
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> createUserWithEmailAndPassword(BuildContext context) async {
    final user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    _authService.updateDisplayName(user, name);
    if (context.mounted) {
      _authService.signIn(context, user);
    }
  }
}
