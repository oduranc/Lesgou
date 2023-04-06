import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../classes/auth_class.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _auth = FirebaseAuth.instance;
  final _authService = AuthClass();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            _authService.logOut(_auth, context);
          },
          child: Text('Log Out'),
        )
      ],
    );
  }
}
